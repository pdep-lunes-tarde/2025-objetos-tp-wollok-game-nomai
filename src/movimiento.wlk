object movimiento{
    method movimiento(objetoAMoverse, direccion) = direccion.siguientePosicion(objetoAMoverse.position())
    method limitar(numero, limiteInferior, limiteSuperior) {
        if(numero <= limiteInferior)
            return limiteInferior
        if(numero >= limiteSuperior)
            return limiteSuperior - 1
        return numero
    }
    method moverHacia(objetoAMoverse, objetivo){
        if(! objetoAMoverse.estaVivo())
            return null
        const direccionesPosibles = [arriba,abajo,izquierda,derecha]
        // hace un map para conseguir todas las posiciones a las que se puede mover el enemigo
        const posicionesPosibles = direccionesPosibles.map{ unaDireccion => self.movimiento(objetoAMoverse,unaDireccion) }
        // "contador" para conseguir la mejor posicion a la que se puede mover
        var mejorPosicion = posicionesPosibles.get(0)
        // "contador" para conseguir la menor distancia entre la posible posicion del enemigo y el brujo
        var menorDistancia = mejorPosicion.distance(objetivo.position())

        // itera por todas las posiciones para conseguir la mejor

        posicionesPosibles.forEach { 
            unaPosicion => 
            if(unaPosicion.distance(objetivo.position()) < menorDistancia){
                mejorPosicion = unaPosicion
                menorDistancia = unaPosicion.distance(objetivo.position())
            }
        }
        objetoAMoverse.position(mejorPosicion)
        return null
    }
    // method moverHacia()
}


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