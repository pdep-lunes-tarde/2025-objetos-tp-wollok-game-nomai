import src.brujo.*
import wollok.game.*
import src.enemigos.*
import movimiento.*
import textos.*

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16
    method scoreParaGanar() = 10

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
        self.agregarEnemigo(generarEnemigo.diablillo())
        self.agregarEnemigo(generarEnemigo.diablillo())
        game.addVisual(brujo)
        game.addVisual(textoVidaDelBrujo)
        
        self.configurarMovimientoJugador()

        game.onCollideDo(brujo, { cosa => cosa.golpeasteABrujo(brujo) })
        game.onTick(1500, "disparo", { brujo.disparar(enemigos) })
        game.onTick(3000, "generacion_enemigos", { self.agregarEnemigo(generarEnemigo.enemigo_aleatorio()) })
    }

    method agregarDisparo(disparo){
        game.onCollideDo(disparo, {
            unEnemigo => 
            disparo.golpeasteA(unEnemigo)
            }
        )
        game.addVisual(disparo)
        game.onTick(200, "movimiento_proyectiles", { disparo.mover() })
    }
    method removerDisparo(disparo){
        game.removeVisual(disparo)
    }

    method removerEnemigo(enemigo){
        enemigos.remove(enemigo) 
        game.removeVisual(enemigo)
    }
    method agregarEnemigo(enemigo){
        enemigo.position(randomizador.generarPosicion())
        enemigos.add(enemigo)
        game.addVisual(enemigo)
        game.onTick(enemigo.velocidad(), "movimiento_enemigo", { enemigo.moverHacia(brujo) })
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