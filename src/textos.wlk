import src.enemigos.*
import tp.*
import brujo.*
object color {
    const property blanco =  "FFFFFFFF"
    const property verde = "00FF00FF"
    const property rojo =  "FF8888FF"
}

object textoResultadoFinal{
    const posicion = new Position(x = brujosYdiablos.ancho() / 2, y = brujosYdiablos.alto() - 4)
    var texto = ""
    var colorTexto = color.verde()
    method victoria(){
        texto = "Ganaste! Derrotaste a " + brujo.enemigosEliminados() + " enemigos"
        colorTexto = color.verde()
    }
    method derrota(){
        texto = "Perdiste"
        colorTexto = color.rojo()
    }
    method text() = texto
    method textColor() = colorTexto
    method position() = posicion
}

object textoJugar{
    var texto = ""
    const posicion = new Position(x = brujosYdiablos.ancho() / 2, y = 4)
    method text() = "Para " + texto + " presiona la tecla 'Espacio'!"
    method textColor() = color.blanco()
    method position() = posicion

    method iniciarMenu(){
        texto = "iniciar el juego"
    }
    method reiniciarJuego(){
        texto = "volver a jugar"
    }
}

object textoVidaDelBrujo{
    const posicion = new Position(x = 1, y = brujosYdiablos.alto() - 1)
    method text() = "Vida: " + brujo.vida()
    method textColor() = color.blanco()
    method position() = posicion
}