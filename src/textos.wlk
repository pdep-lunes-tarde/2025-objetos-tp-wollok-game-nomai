import src.enemigos.*
import tp.*
import brujo.*
object color {
    const property blanco =  "FFFFFFFF"
    const property rojo =  "FF7777FF"
    const property verde = "00FF00FF"
    const property azul =  "0088FF7FF"
    const property amarillo =  "FFFF00FF"
}

object textoResultadoFinal{
    var texto = ""
    var colorTexto = color.blanco()
    method victoria(){
        texto = "¡GANASTE!\n\nTu score fue " + brujosYdiablos.score() + ".\n Realizaste " + brujo.danioRealizado() + " puntos de daño.\nSobreviviste por " + brujosYdiablos.tiempoJugado() + " segundos."
        colorTexto = color.verde()
    }
    method derrota(){
        texto = "Perdiste :("
        colorTexto = color.rojo()
    }
    method text() = texto
    method textColor() = colorTexto
    method position() = new Position(x = brujosYdiablos.ancho() / 2, y = brujosYdiablos.alto() - 4)
}

object textoJugar{
    var texto = ""
    method text() = "Para " + texto + " presiona la tecla 'Espacio'!"
    method textColor() = color.blanco()
    method position() = new Position(x = brujosYdiablos.ancho() / 2, y = 3)

    method menuIniciar(){
        texto = "iniciar el juego"
    }
    method menuReiniciar(){
        texto = "volver a jugar"
    }
}

object titulo{
    method position() = new Position(x = brujosYdiablos.ancho() / 2 - 5, y = brujosYdiablos.alto() - 8)
    method image() = "titulo.png"
}

object textoVidaDelBrujoYScore{
    method text() = "Vida: " + brujo.vida() + "\nScore:" + brujosYdiablos.score()
    method textColor() = color.blanco()
    method position() = new Position(x = 1, y = brujosYdiablos.alto() - 1)
}

object textoDificultad {
    method text() = "Seleccione la dificultad presionando un numero del 1 al 5\nDificultad: " + brujosYdiablos.dificultad()
    method textColor() = color.blanco()
    method position() = new Position(x = brujosYdiablos.ancho() / 2, y = 5)
}
class TextoMejora {
    const mejora
    method text() = "¡Aumentar " + mejora.tipo() + " por " + mejora.cantidadMejorada() + "!"
    method textColor() = mejora.color()
    method position() = brujo.position().up(1)
}