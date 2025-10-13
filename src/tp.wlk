import src.brujo.*
import wollok.game.*
import src.world_objects.*
import src.enemigos.*
import movimiento.*

object color {
    const property verde = "00FF00FF"
    const property rojo = "FF0000FF"
}

object texto_victoria{
    const posicion = new Position(x = brujosYdiablos.ancho() / 2, y = 4)
    method text() = "Ganaste! Derrotaste a " + brujo.enemigosEliminados() + " enemigos"
    method textColor() = color.verde()
    method position() = posicion
}
object texto_derrota{
    const posicion = new Position(x = brujosYdiablos.ancho() / 2, y = 4)
    method text() = "Perdiste"
    method textColor() = color.rojo()
    method position() = posicion
}

const brujo = new Brujo(posicion = game.center())

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16

    var enemigos = [
        generarEnemigos.diablillo(),
        generarEnemigos.diablillo()
    ]
    var paredes = []

    method configurar(){
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        game.ground("pasto.png")

        
        // new Range(start = 0, end = 15).forEach { n => 
		// 	paredes.add(new Pared(posicion = new Position(x=n,y=0)))
        // }

        enemigos.forEach { enemigo => game.addVisual(enemigo) }
        // paredes.forEach { pared => game.addVisual(pared) }
        game.addVisual(brujo)

        
        
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
        game.onTick(200, "movimiento_proyectiles", { brujo.proyectiles().forEach { proyectil => proyectil.moverHacia(enemigos, brujo) } } )
        game.onTick(1500, "disparo", { brujo.disparar(enemigos) })
        game.onTick(3000, "generacion_enemigos", { generarEnemigos.aleatorio(enemigos) })
    }

    method finalizar(){
        brujo.position(game.center())
        game.allVisuals().forEach { cosa => game.removeVisual(cosa) }
        enemigos = []
        paredes = []
        game.removeTickEvent("generacion_enemigos")
        game.removeTickEvent("movimiento_enemigos")
        game.removeTickEvent("disparo")
        game.removeTickEvent("movimiento_proyectiles")
        game.addVisual(brujo)
    }
    method perder(){
        game.ground("fondo_perder.png")
        self.finalizar()
        game.addVisual(texto_derrota)
    }

    method ganar(){
        self.finalizar()
        game.addVisual(texto_victoria)
    }

    method iniciar(){
        self.configurar()

        game.start()
    }
}