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

object wraparound {
    method limitar(numero, limiteInferior, limiteSuperior) {
        if(numero <= limiteInferior)
            return limiteInferior
        if(numero >= limiteSuperior)
            return limiteSuperior - 1
        return numero
    }
}