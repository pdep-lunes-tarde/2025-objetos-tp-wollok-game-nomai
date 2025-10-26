import src.brujo.*
import wollok.game.*
import src.enemigos.*
import movimiento.*
import textos.*

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16
    method scoreParaGanar() = 10

    const proyectiles = []
    const enemigos = []

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
        game.addVisual(textoVidaDelBrujo)
        
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