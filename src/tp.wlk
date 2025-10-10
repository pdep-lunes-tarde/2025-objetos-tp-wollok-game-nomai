import src.brujo.*
import wollok.game.*
import src.world_objects.*
import src.enemigos.*

object brujosYdiablos {
    method alto() = 16
    method ancho() = 16

    const brujo = new Brujo(posicion = new Position(x=0,y=1))

    method configurar(){
        game.width(self.alto())
        game.height(self.ancho())
        game.cellSize(32)
        game.ground("pasto.png")

        const enemigos = [new Enemigo(posicion = new Position(x=12,y=12), vida = 30), new Enemigo(posicion = new Position(x=8,y=13), vida = 50)]
        const paredes = []
        new Range(start = 0, end = 15).forEach { n => 
			paredes.add(new Pared(posicion = new Position(x=n,y=0)))
        }

        enemigos.forEach { enemigo => game.addVisual(enemigo) }
        paredes.forEach { pared => game.addVisual(pared) }
        game.addVisual(brujo)

        game.onCollideDo(brujo, { cosa => cosa.chocasteConBrujo(brujo) })
        
        
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

        game.onTick(1000, "movimiento_enemigos", { enemigos.forEach { enemigo => enemigo.moverHacia(brujo) } })
        game.onTick(200, "movimiento_hechizo", { brujo.disparos().forEach { disparo => disparo.mover() } } )
        game.schedule(5, { game.onTick(200, "checkear_balas", { 
            brujo.disparos().forEach { 
                disparo => 
                game.onCollideDo(disparo, { 
                    objetivo =>
                    disparo.chocasteConEnemigo(objetivo, brujo)
                }) 
            } 
        } ) })
        game.onTick(2001, "disparo", { brujo.disparar(enemigos) })
    }

    method perder(unBrujo){
        game.ground("fondo_perder.png")

        unBrujo.position(game.center())
        const todosLosElementos = game.allVisuals()
        todosLosElementos.forEach { cosa => game.removeVisual(cosa) }
        game.addVisual(unBrujo)
    }

    method iniciar(){
        self.configurar()

        game.start()
    }
}