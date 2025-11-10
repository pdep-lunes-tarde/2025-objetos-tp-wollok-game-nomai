import textos.color
class Mejora{
    const property cantidadMejorada
    const property tipo
    const property colorTexto
}
class MejoraDanio inherits Mejora(
        cantidadMejorada = (1).randomUpTo(5).truncate(1),
        tipo = "daño",
        colorTexto = color.rojo()
        ){
    method mejorar(magia){
        magia.mejorarDanio(cantidadMejorada)
    }
}
class MejoraVelocidad inherits Mejora(
            cantidadMejorada = (3).randomUpTo(10).floor(), 
            tipo = "velocidad",
            colorTexto = color.azul()
        ){
    method mejorar(magia){
        magia.mejorarVelocidad(cantidadMejorada)
    }
}

object generadorMejoras{
    method mejoraDanio(){
        return new MejoraDanio()
    }
    method mejoraVelocidad(){
        return new MejoraVelocidad()
    }
    // method mejoraCantidad(){
    //     return new Mejora(
    //         cantidadMejorada = (0.1).randomUpTo(1).truncate(1),
    //         tipo = "cantidad",
    //         color = color.amarillo()
    //     )
    // }
    method generarMejoraAleatoria(){
        const mejorasPosibles = [self.mejoraDanio(), self.mejoraVelocidad()]
        return mejorasPosibles.anyOne()    
    }
}