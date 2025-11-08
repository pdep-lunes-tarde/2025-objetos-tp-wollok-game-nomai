import tp.*
import movimiento.*

object brujo{
    var posicion = game.center()
    var direccionImagen = derecha

    var vida = 100
    var score = 0
    var danio_realizado = 0

    var magia = magiaCercana

    method image() = "brujo_" + direccionImagen.toString() + ".png"
    method position() = posicion
    method position(nuevaPosicion) {
        posicion = nuevaPosicion
    }

    method rotarHechizo(){
        magia = magia.magiaProxima()
    }
    method mover(direccion) {
        if(direccion.horizontal())
            direccionImagen = direccion
        const posicionEsperada = direccion.siguientePosicion(posicion)
        if(self.esMovimientoValido(posicionEsperada))
            posicion = posicionEsperada
    }

    method esMovimientoValido(unaPosicion) = movimiento.estaEnPantalla(unaPosicion)

    method vida() = vida
    method vida(nuevaVida) = nuevaVida
    method perderVida(danioRecibido){
        if(vida - danioRecibido > 0)
            vida = vida - danioRecibido
        else{
            brujosYdiablos.perder()
        }
    }

    method disparar(enemigos) = magia.lanzarHechizo(enemigos)

    method aumentarDanioRealizado(danio){
        danio_realizado += danio
    }

    method danio_realizado() = danio_realizado
    method score() = score
    method aumentarScore(enemigo){
        if(! enemigo.estaVivo())
            score += enemigo.scorePorMuerte()
        if(score >= brujosYdiablos.scoreParaGanar())
            brujosYdiablos.ganar()
    }

    method reiniciar(){
        vida = 100
        score = 0
        danio_realizado = 0
        posicion = game.center()
        direccionImagen = derecha
        magia = magiaCercana
    }
}

// magias
class Magia{
    method objetivo(enemigos)
    method image()
    method position() = new Position(x = 5, y = 5)
    method magiaProxima()
    method danio()

    method lanzarHechizo(enemigos){
        if(enemigos.size() == 0){
            return null
        }
        const disparo = new Hechizo(
            enemigo_fijado = self.objetivo(enemigos),
            imagen = self.image(),
            danio_inflijido = self.danio()
        )
        brujosYdiablos.agregarDisparo(disparo)
        return disparo
    }
}
object magiaCercana inherits Magia{
    override method objetivo(enemigos) = enemigos.min { unEnemigo => unEnemigo.position().distance(brujo.position()) }
    override method danio() = 20
    
    override method image() = "magia_cercana.png"

    override method magiaProxima() = magiaLejana
}
object magiaLejana inherits Magia{
    override method objetivo(enemigos) = enemigos.max { unEnemigo => unEnemigo.position().distance(brujo.position()) }
    override method danio() = 10
    
    override method image() = "magia_lejana.png"
    
    override method magiaProxima() = magiaAleatoria
}
object magiaAleatoria inherits Magia{
    override method objetivo(enemigos) = enemigos.anyOne()
    override method danio() = 100
    
    override method image() = "magia_aleatoria.png"
    
    override method magiaProxima() = magiaCercana
}

class Hechizo {
    var posicion = brujo.position()
    const imagen
    var estaVivo = true
    const danio_inflijido
    const enemigo_fijado
    const seed = 0.randomUpTo(10).toString()

    method position() = posicion
    method position(nuevaPosicion){ 
        posicion = nuevaPosicion 
    }
    method image() = imagen
    method objetivo() = enemigo_fijado
    method danio_inflijido() = danio_inflijido
    method estaVivo() = estaVivo
    method seed() = seed

    method matar() {
        estaVivo = false
        brujosYdiablos.removerDisparo(self)
    }

    method golpeasteABrujo(){
        // no debería hacer nada
    }

    method golpeasteA(enemigo){
        if(enemigo == self.objetivo()){
            enemigo.restarVida(self.danio_inflijido())
            brujo.aumentarScore(enemigo)
            brujo.aumentarDanioRealizado(self.danio_inflijido())
            self.matar()
        }
    }

    method mover(){
        if(! enemigo_fijado.estaVivo())
            self.matar()
        movimiento.moverHacia(self, enemigo_fijado)
    }
}