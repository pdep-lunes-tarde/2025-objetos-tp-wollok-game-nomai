import src.brujo.*
import wollok.game.*
import src.enemigos.*
import movimiento.*
import textos.*

object brujosYdiablos {
    method alto() = 20
    method ancho() = 20
    method scoreParaGanar() = 1000


    method configurarPantalla(){
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        game.ground("pasto.png")
    }

    method configurarJugador(){
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
        keyboard.space().onPressDo{
            brujo.rotarHechizo()
        }
    }
    

    method iniciarMenu(){
        game.addVisual(brujo)

        textoJugar.iniciarMenu()
        game.addVisual(textoJugar)
        game.addVisual(titulo)

        keyboard.space().onPressDo({ self.reiniciar() })
    }

    const enemigos = []
    var tiempoJugado = 0
    method tiempoJugado() = tiempoJugado

    method configurarJuego(){
        self.agregarEnemigo(generarEnemigo.diablillo())
        self.agregarEnemigo(generarEnemigo.diablillo())
        game.addVisual(brujo)
        game.addVisual(textoVidaDelBrujoYScore)
        
        self.configurarJugador()

        game.onCollideDo(brujo, { cosa => cosa.golpeasteABrujo() })
        game.onTick(1500, "disparo", { brujo.disparar(enemigos) })
        game.onTick(3000, "generacion_enemigos", { self.agregarEnemigo(generarEnemigo.enemigo_aleatorio()) })
        
        game.onTick(1000, "tiempo_jugando", { tiempoJugado += 1 })
    }

    method agregarDisparo(disparo){
        game.onCollideDo(disparo, {
            unEnemigo => 
            disparo.golpeasteA(unEnemigo)
            }
        )
        game.addVisual(disparo)
        game.onTick(200, "movimiento_proyectiles" + disparo.seed(), { disparo.mover() })
    }
    method removerDisparo(disparo){
        game.removeTickEvent("movimiento_proyectiles" + disparo.seed())
        game.removeVisual(disparo)
    }

    method removerEnemigo(enemigo){
        enemigos.remove(enemigo) 
        game.removeTickEvent("movimiento_enemigo" + enemigo.seed())
        game.removeVisual(enemigo)
    }
    method agregarEnemigo(enemigo){
        enemigo.position(randomizador.generarPosicion())
        game.addVisual(enemigo)
        enemigos.add(enemigo)
        game.onTick(enemigo.velocidad(), "movimiento_enemigo" + enemigo.seed(), { enemigo.moverHacia(brujo) })
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