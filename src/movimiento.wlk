import src.tp.*
object movimiento{
    method movimiento(objetoAMoverse, direccion) = direccion.siguientePosicion(objetoAMoverse.position())
    method estaEnPantalla(posicion) {
        return 
            (posicion.x() >= 0 and posicion.y() >= 0) and 
            (posicion.x() < brujosYdiablos.ancho() and posicion.y() < brujosYdiablos.alto())
    }
    method moverHacia(objetoAMoverse, objetivo){
        if(! objetoAMoverse.estaVivo())
            return null
        const direccionesPosibles = [arriba,abajo,izquierda,derecha]
        // hace un map para conseguir todas las posiciones a las que se puede mover el enemigo
        const posicionesPosibles = direccionesPosibles.map{ unaDireccion => self.movimiento(objetoAMoverse,unaDireccion) }
        // consigue la posicion que menor distancia tiene hacia el objetivo
        const mejorPosicion = posicionesPosibles.min { unaPosicion => unaPosicion.distance(objetivo.position()) }
        objetoAMoverse.position(mejorPosicion)
        return null
    }
}


// direcciones
object izquierda {
    method horizontal() = true
    method siguientePosicion(posicion) {
        return posicion.left(1)
    }
}
object abajo {
    method horizontal() = false
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }
}
object arriba {
    method horizontal() = false
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }
}
object derecha {
    method horizontal() = true
    method siguientePosicion(posicion) {
        return posicion.right(1)
    }
}