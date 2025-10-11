import src.brujo.*
import movimiento.*
// Tipos de Enemigos:
// hombre lobo:
// - rareza = comun ; vida = 15 ; daño = 5 ; velocidad = 6
// diablillo:
// - rareza = poco-comun ; vida = 50 ; daño = 10 ; velocidad = 10 
// vampiro:
// - rareza = mini-jefe ; vida = 200 ; daño = 20 ; velocidad = 5 
// diablo:
// - rareza = jefe ; vida = 500 ; daño = 80 ; velocidad = 1 
// const diablillo = new Enemigo ( vida = 50, danio = 10, imagen = "diablillo.png", posicion = new Position(x=10,y=10))
// const diablo = new Enemigo ( vida = 500, danio = 80, imagen = "diablo.png", posicion = new Position(x=6,y=6))


class Enemigo{
    var vida = 500
    const danio = 80
    var imagen = "diablo.png"
    var posicion
    var esta_vivo = true
    method vida() = vida
    method restarVida(danioRecibido, enemigos){ 
        if(esta_vivo){
            if(vida > danioRecibido)
                vida -= danioRecibido
            else
                self.morir(enemigos)
        }
    }
    method morir(enemigos){
        esta_vivo = false
        imagen = "muerte_2.png"
        game.schedule(500, { => game.removeVisual(self) })
        game.schedule(501, { => enemigos.remove(self) })
    }
    method danio() = danio
    method image() = imagen
    method position() = posicion
    method chocasteConBrujo(brujo){
        brujo.perderVida(self.danio())
    }
    method movimiento(direccion) = direccion.siguientePosicion(posicion)
    method moverHacia(brujo){
        const direccionesPosibles = [arriba,abajo,izquierda,derecha]
        // hace un map para conseguir todas las posiciones a las que se puede mover el enemigo
        const posicionesPosibles = direccionesPosibles.map{ unaDireccion => self.movimiento(unaDireccion) }
        // "contador" para conseguir la mejor posicion a la que se puede mover
        var mejorPosicion = posicionesPosibles.get(0)
        // "contador" para conseguir la menor distancia entre la posible posicion del enemigo y el brujo
        var menorDistancia = mejorPosicion.distance(brujo.position())

        // itera por todas las posiciones para conseguir la mejor

        posicionesPosibles.forEach { 
            unaPosicion => 
            if(unaPosicion.distance(brujo.position()) < menorDistancia){
                mejorPosicion = unaPosicion
                menorDistancia = unaPosicion.distance(brujo.position())
            }
        }
        posicion = mejorPosicion
    }
}