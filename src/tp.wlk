import src.brujo.*
import wollok.game.*
import src.world_objects.*
import src.enemigos.*
import movimiento.*

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

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16
    method scoreParaGanar() = 10

    const proyectiles = []
    const enemigos = []
    // const paredes = []

    method configurarPantalla(){
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        game.ground("pasto.png")
    }

    method configurarMovimientoJugador(){
        keyboard.w().onPressDo {
            brujo.mover(arriba)
        }
        keyboard.a().onPressDo {
            brujo.mover(izquierda)
        }
        keyboard.s().onPressDo {
            brujo.mover(abajo)
        }
        keyboard.d().onPressDo {
            brujo.mover(derecha)
        }
    }
    

    method iniciarMenu(){
        game.addVisual(brujo)

        self.configurarMovimientoJugador()

        textoJugar.iniciarMenu()
        game.addVisual(textoJugar)

        keyboard.space().onPressDo({ self.reiniciar() })
    }

    method configurarJuego(){
        enemigos.add(generarEnemigo.diablillo())
        enemigos.add(generarEnemigo.diablillo())
        game.addVisual(brujo)
        
        self.configurarMovimientoJugador()

        game.onCollideDo(brujo, { cosa => cosa.golpeasteABrujo(brujo) })
        game.onTick(200, "movimiento_proyectiles", { proyectiles.forEach { proyectil => proyectil.moverHacia(enemigos, brujo) } } )
        game.onTick(1500, "disparo", { proyectiles.add(brujo.disparar(enemigos)) })
        game.onTick(3000, "generacion_enemigos", { enemigos.add(generarEnemigo.enemigo_aleatorio()) })
        game.onTick(3000, "eliminacion_enemigos_muertos", { enemigos.forEach { enemigo => if(!enemigo.estaVivo()) enemigos.remove(enemigo) } })
    }

    method finalizar(resultado){
        brujo.position(game.center())
        game.clear()
        enemigos.clear()
        // paredes.clear()
        game.addVisual(brujo)
        resultado.apply(textoResultadoFinal)
        game.addVisual(textoResultadoFinal)
        textoJugar.reiniciarJuego()
        game.addVisual(textoJugar)
        keyboard.space().onPressDo({ self.reiniciar() })
    }
    method perder(){
        self.finalizar({texto => texto.derrota()})
    }

    method ganar(){
        self.finalizar({texto => texto.victoria()})
    }

    method reiniciar(){
        game.clear()
        brujo.reiniciar()
        self.configurarJuego()
    }

    method iniciar(){
        self.configurarPantalla()
        self.iniciarMenu()

        game.start()
    }
}