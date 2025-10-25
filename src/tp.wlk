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

object textoFinal{
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

object textoVolverAJugar{
    const posicion = new Position(x = brujosYdiablos.ancho() / 2, y = 4)
    method text() = "Para volver a jugar presiona la tecla 'Espacio'!"
    method textColor() = color.blanco()
    method position() = posicion
}

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16
    method scoreParaGanar() = 10

    const proyectiles = []
    const enemigos = []
    const paredes = []

    method configurar(){
        game.ground("pasto.png")

        enemigos.add(generarEnemigo.diablillo())
        enemigos.add(generarEnemigo.diablillo())
        game.addVisual(brujo)
        // paredes.forEach { pared => game.addVisual(pared) }

        
        
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

        game.onCollideDo(brujo, { cosa => cosa.golpeasteABrujo(brujo) })
        game.onTick(500, "movimiento_enemigos", { enemigos.forEach { enemigo => enemigo.moverHacia(brujo) } })
        game.onTick(200, "movimiento_proyectiles", { proyectiles.forEach { proyectil => proyectil.moverHacia(enemigos, brujo) } } )
        game.onTick(1500, "disparo", { proyectiles.add(brujo.disparar(enemigos)) })
        game.onTick(3000, "generacion_enemigos", { enemigos.add(generarEnemigo.enemigo_aleatorio()) })
    }

    method finalizar(resultado){
        brujo.position(game.center())
        game.clear()
        enemigos.clear()
        paredes.clear()
        game.addVisual(brujo)
        resultado.apply(textoFinal)
        game.addVisual(textoFinal)
        game.addVisual(textoVolverAJugar)
        keyboard.space().onPressDo({ self.reiniciar() })
    }
    method perder(){
        game.ground("fondo_perder.png")
        self.finalizar({t => t.derrota()})
    }

    method ganar(){
        self.finalizar({t => t.victoria()})
    }

    method reiniciar(){
        game.clear()
        brujo.reiniciar()
        self.configurar()
    }

    method iniciar(){
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)

        self.configurar()

        game.start()
    }
}