import tp.*
import movimiento.*

class Brujo{
    var posicion
    var direccionImagen = derecha

    var vida = 100
    var enemigos_eliminados = 0
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

    method proyectiles() = proyectiles
    method removerDisparo(disparo) = proyectiles.remove(disparo)
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

    method golpeasteAEnemigo(enemigo, enemigos, brujo){
        if(enemigo != self.objetivo())
            return null
        enemigo.restarVida(self.danio_inflijido(), enemigos)
        estaVivo = false
        game.removeVisual(self)
        brujo.removerDisparo(self)
        brujo.aumentarDanioRealizado(self.danio_inflijido())
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
    }
}

// mejoras
// class Danio_explosivo {
//     var area
//     method mejorar(maximo) {
//         area += randomizador.mejorar(maximo * 1)
//     }
// }
// class Penetracion {
//     var penetraciones
//     method mejorar(maximo) {
//         penetraciones += randomizador.mejorar(maximo * 1)
//     }
// }
// class VelocidadDeAtaque{
//     var velocidad
//     method mejorar(maximo) {
//         velocidad += randomizador.mejorar(maximo * 5)
//     }
// }
// class Danio {
//     var danio_aumentado
//     method mejorar(maximo) {
//         danio_aumentado += randomizador.mejorar(maximo * 2)
//     }
// }