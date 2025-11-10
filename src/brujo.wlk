import src.mejoras.*
import tp.*
import movimiento.*

object brujo{
    var posicion = game.center()
    var direccionImagen = derecha

    var vida = 100
    var danioRealizado = 0

    var magia = magiaCercana

    method image() = "brujo_" + direccionImagen.toString() + ".png"
    method position() = posicion
    method position(nuevaPosicion) {
        posicion = nuevaPosicion
    }

    method rotarHechizo(){
        magia = magia.magiaProxima()
    }
    method elegirHechizo(magiaElegida){
        magia = magiaElegida
    }
    method magia() = magia
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

    method danioRealizado() = danioRealizado
    method aumentarDanioRealizado(danio){
        danioRealizado += danio
    }

    method subirDeNivel(){
        const mejora = generadorMejoras.generarMejoraAleatoria()
        magia.mejorar(mejora)
        brujosYdiablos.mostrarMejora(mejora)
    }

    method reiniciar(){
        vida = 100
        danioRealizado = 0
        posicion = game.center()
        direccionImagen = derecha
        magia = magiaCercana
    }
}

// magias
class Magia{
    var danio
    var velocidad = 200
    method objetivo(enemigos)
    method image()
    method magiaProxima()
    method danio() = danio
    method velocidad() = velocidad
    const potenciadorDeMejora

    method mejorar(mejora){
        mejora.mejorar(self)
    }
    method mejorarDanio(cantidadMejorada){
        danio += cantidadMejorada * potenciadorDeMejora
    }
    method mejorarVelocidad(cantidadMejorada){
        velocidad = (velocidad - cantidadMejorada * potenciadorDeMejora).max(10)
    }

    method lanzarHechizo(enemigos){
        if(enemigos.size() == 0){
            return null
        }
        const disparo = new Hechizo(
            enemigo_fijado = self.objetivo(enemigos),
            imagen = self.image(),
            danioInflijido = self.danio(),
            velocidad = self.velocidad()
        )
        brujosYdiablos.agregarDisparo(disparo)
        return disparo
    }
}
object magiaCercana inherits Magia(danio = 20, velocidad = 250, potenciadorDeMejora = 2.5){
    override method objetivo(enemigos) = enemigos.min { unEnemigo => unEnemigo.position().distance(brujo.position()) }
    override method image() = "magia_cercana.png"
    override method magiaProxima() = magiaLejana
}
object magiaLejana inherits Magia(danio = 40, velocidad = 150, potenciadorDeMejora = 1){
    override method objetivo(enemigos) = enemigos.max { unEnemigo => unEnemigo.position().distance(brujo.position()) }
    override method image() = "magia_lejana.png"
    override method magiaProxima() = magiaAleatoria
}
object magiaAleatoria inherits Magia(danio = 10, velocidad = 500, potenciadorDeMejora = 5){
    override method objetivo(enemigos) = enemigos.anyOne()
    override method image() = "magia_aleatoria.png"
    override method magiaProxima() = magiaCercana    
}

class Hechizo {
    var posicion = brujo.position()
    const imagen
    var estaVivo = true
    const property danioInflijido
    const property velocidad
    const enemigo_fijado
    const property seed = 0.randomUpTo(10).toString()

    method position() = posicion
    method position(nuevaPosicion){ 
        posicion = nuevaPosicion 
    }
    method image() = imagen
    method objetivo() = enemigo_fijado
    method estaVivo() = estaVivo

    method matar() {
        estaVivo = false
        brujosYdiablos.removerDisparo(self)
    }

    method golpeasteABrujo(){
        // no debería hacer nada
    }

    method golpeasteA(enemigo){
        if(enemigo == enemigo_fijado){
            enemigo.restarVida(self.danioInflijido())
            brujosYdiablos.aumentarScore(enemigo)
            brujo.aumentarDanioRealizado(self.danioInflijido())
            self.matar()
        }
    }

    method mover(){
        if(! enemigo_fijado.estaVivo())
            self.matar()
        movimiento.moverHacia(self, enemigo_fijado)
    }
}