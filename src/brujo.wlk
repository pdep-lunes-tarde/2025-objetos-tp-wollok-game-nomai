import tp.*
import movimiento.*

class Brujo{
    var posicion
    var direccionImagen = derecha

    var vida = 100
    var enemigosEliminados = 0
    var danio_realizado = 0
    var proyectiles = []
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
        const nuevaPosicion = direccion.siguientePosicion(posicion)

        posicion = self.posicionCorregida(nuevaPosicion)
    }

    method posicionCorregida(posicionACorregir) {
        const nuevaX = movimiento.limitar(posicionACorregir.x(), 0, brujosYdiablos.ancho())
        const nuevaY = movimiento.limitar(posicionACorregir.y(), 0, brujosYdiablos.alto())

        return new Position(x=nuevaX, y=nuevaY)
    }

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
        var enemigo_mas_cercano = enemigos.get(0)
        enemigos.forEach {
            unEnemigo =>
            if(unEnemigo.position().distance(self.position()) < enemigo_mas_cercano.position().distance(self.position())){
                enemigo_mas_cercano = unEnemigo
            }
        }
        const disparo = new DisparoCercano ( posicion = self.position() , enemigo_fijado = enemigo_mas_cercano )
        proyectiles.add(disparo)
        game.addVisual(disparo)
        return null
    }

    method aumentarDanioRealizado(danio){
        danio_realizado += danio
    }

    method enemigosEliminados() = enemigosEliminados
    method aumentarEnemigosEliminados(enemigo){
        if(! enemigo.estaVivo())
            enemigosEliminados += 1
        if(enemigosEliminados >= 10)
            brujosYdiablos.ganar()
    }

    method proyectiles() = proyectiles
    method removerDisparo(disparo) { 
        disparo.matar()
        proyectiles.remove(disparo)
        game.removeVisual(disparo)
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
    }

    method golpeasteAEnemigo(enemigo, enemigos, brujo){
        if(enemigo != self.objetivo())
            return null
        enemigo.restarVida(self.danio_inflijido(), enemigos)
        brujo.aumentarDanioRealizado(self.danio_inflijido())
        brujo.aumentarEnemigosEliminados(enemigo)
        brujo.removerDisparo(self)
        return null
    }
    method golpeasteABrujo(_brujo) {}

    method moverHacia(enemigos, brujo){
        movimiento.moverHacia(self, enemigo_fijado)
        game.onCollideDo(self, {
            objetivo => 
            self.golpeasteAEnemigo(objetivo, enemigos, brujo)
            }
        )
        if(! enemigo_fijado.estaVivo())
            brujo.removerDisparo(self)
    }
}