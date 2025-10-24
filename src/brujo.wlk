import tp.*
import movimiento.*

object brujo{
    var posicion = game.center()
    var direccionImagen = derecha

    var vida = 100
    var enemigosEliminados = 0
    var danio_realizado = 0
    // const magia
    // const mejoras = []

    method image() = "brujo_" + direccionImagen.toString() + ".png"
    method position() = posicion
    method position(nuevaPosicion) {
        posicion = nuevaPosicion
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

    method disparar(enemigos){
        if(enemigos.size() == 0)
            return null
        const enemigo_mas_cercano = enemigos.min {
            unEnemigo => unEnemigo.position().distance(self.position())
        }
        const disparo = new DisparoCercano ( posicion = self.position() , enemigo_fijado = enemigo_mas_cercano )
        game.onCollideDo(disparo, {
            objetivo => 
            disparo.golpeasteAEnemigo(objetivo, enemigos, self)
            }
        )
        game.addVisual(disparo)
        return disparo
    }

    method aumentarDanioRealizado(danio){
        danio_realizado += danio
    }

    method enemigosEliminados() = enemigosEliminados
    method aumentarEnemigosEliminados(enemigo){
        if(! enemigo.estaVivo())
            enemigosEliminados += 1
        if(enemigosEliminados >= brujosYdiablos.scoreParaGanar())
            brujosYdiablos.ganar()
    }

    method reiniciar(){
        vida = 100
        enemigosEliminados = 0
        danio_realizado = 0
        posicion = game.center()
        direccionImagen = derecha
    }
}

// magias
class DisparoCercano {
    var posicion
    var estaVivo = true
    const danio_inflijido = 20
    const enemigo_fijado

    method position() = posicion
    method position(nuevaPosicion){ 
        posicion = nuevaPosicion 
    }
    method image() = "disparo.png"
    method objetivo() = enemigo_fijado
    method danio_inflijido() = danio_inflijido
    method estaVivo() = estaVivo
    method matar() {
        estaVivo = false
        game.removeVisual(self)
    }

    method golpeasteAEnemigo(enemigo, enemigos, brujo){
        if(enemigo != self.objetivo())
            return null
        enemigo.restarVida(self.danio_inflijido(), enemigos)
        brujo.aumentarDanioRealizado(self.danio_inflijido())
        brujo.aumentarEnemigosEliminados(enemigo)
        self.matar()
        return null
    }
    method golpeasteABrujo(_brujo) {}

    method moverHacia(enemigos, brujo){
        movimiento.moverHacia(self, enemigo_fijado)
        if(! enemigo_fijado.estaVivo())
            self.matar()
    }
}