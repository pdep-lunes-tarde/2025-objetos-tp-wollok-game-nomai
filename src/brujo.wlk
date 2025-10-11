import tp.*
import movimiento.*

class Brujo{
    var posicion
    var direccionImagen = derecha

    var vida = 100
    var enemigos_eliminados = 0
    var danio_realizado = 0
    var disparos = []
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
        const nuevaY = wraparound.limitar(posicionACorregir.y(), 0, brujosYdiablos.alto())
        const nuevaX = wraparound.limitar(posicionACorregir.x(), 0, brujosYdiablos.ancho())

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
        disparos.add(disparo)
        game.addVisual(disparo)
        return null
    }

    method aumentarDanioRealizado(danio){
        danio_realizado += danio
    }

    method disparos() = disparos
    method removerDisparo(disparo) = disparos.remove(disparo)
}

// magias
object randomizador{
    method danio(danioPromedio, variacion){
        var danioReal = danioPromedio
        if(1.randomUpTo(2).odd())
            danioReal = (danioReal - variacion).max(1)
        return danioReal.randomUpTo(variacion)
    }
    method mejorar(maximo){
        return 1.randomUpTo(maximo).floor()
    }
}

// magias
class DisparoCercano {
    var posicion
    const danio_inflijido = 10
    const enemigo_fijado

    method position() = posicion
    method image() = "disparo_2.png"
    method objetivo() = enemigo_fijado
    method danio_inflijido() = danio_inflijido

    method chocasteConEnemigo(enemigo, enemigos, brujo){
        enemigo.restarVida(self.danio_inflijido(), enemigos)
        game.removeVisual(self)
        brujo.removerDisparo(self)
        brujo.aumentarDanioRealizado(self.danio_inflijido())
    }
    method chocasteConBrujo(brujo) {}

    method movimiento(direccion) = direccion.siguientePosicion(posicion)
    method mover(){
        const direccionesPosibles = [arriba,abajo,izquierda,derecha]
        // hace un map para conseguir todas las posiciones a las que se puede mover el enemigo
        const posicionesPosibles = direccionesPosibles.map{ unaDireccion => self.movimiento(unaDireccion) }
        // "contador" para conseguir la mejor posicion a la que se puede mover
        var mejorPosicion = posicionesPosibles.get(0)
        // "contador" para conseguir la menor distancia entre la posible posicion del enemigo y el brujo
        var menorDistancia = mejorPosicion.distance(enemigo_fijado.position())

        // itera por todas las posiciones para conseguir la mejor

        posicionesPosibles.forEach { 
            unaPosicion => 
            if(unaPosicion.distance(enemigo_fijado.position()) < menorDistancia){
                mejorPosicion = unaPosicion
                menorDistancia = unaPosicion.distance(enemigo_fijado.position())
            }
        }
        posicion = mejorPosicion
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