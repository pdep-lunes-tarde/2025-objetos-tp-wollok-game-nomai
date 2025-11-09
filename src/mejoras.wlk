import textos.color
class Mejora{
    const property cantidadMejorada
    const property tipo
    const property color
}

object generadorMejoras{
    method mejoraDanio(){
        return new Mejora(
            cantidadMejorada = (0.1).randomUpTo(3).truncate(1), 
            tipo = "daño",
            color = color.rojo()
        )
    }
    method mejoraVelocidad(){
        return new Mejora(
            cantidadMejorada = (0.1).randomUpTo(10).truncate(1), 
            tipo = "velocidad",
            color = color.azul()
        )
    }
    method mejoraCantidad(){
        return new Mejora(
            cantidadMejorada = (0.1).randomUpTo(1).truncate(1),
            tipo = "cantidad",
            color = color.amarillo()
        )
    }
    method generarMejoraAleatoria(){
        const mejorasPosibles = [self.mejoraDanio(), self.mejoraVelocidad(), self.mejoraCantidad()]
        return mejorasPosibles.anyOne()    
    }
}