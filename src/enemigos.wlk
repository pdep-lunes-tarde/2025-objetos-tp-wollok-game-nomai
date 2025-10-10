import src.brujo.*
// const diablo = new Enemigo ( vida = 500, danio = 80, imagen = "diablo.png", posicion = new Position(x=6,y=6))
// const diablillo = new Enemigo ( vida = 50, danio = 10, imagen = "diablillo.png", posicion = new Position(x=10,y=10))

class Enemigo{
    var vida = 500
    const danio = 80
    var imagen = "diablo.png"
    var posicion
    var esta_vivo = true
    method vida() = vida
    method restarVida(danioRecibido){ 
        if(vida > danioRecibido)
            vida -= danioRecibido
        else
            self.morir()
    }
    method morir(){
        esta_vivo = false
        imagen = "pared.png"
        game.schedule(500, game.removeVisual(self))
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