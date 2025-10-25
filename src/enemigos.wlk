import src.brujo.*
import movimiento.*
import wollok.game.*
import tp.*
// Tipos de Enemigos:
// hombre lobo:
// - rareza = comun ; vida = 15 ; daño = 5 ; velocidad = 6
// diablillo:
// - rareza = poco-comun ; vida = 50 ; daño = 10 ; velocidad = 10 
// vampiro:
// - rareza = mini-jefe ; vida = 200 ; daño = 20 ; velocidad = 5 
// diablo:
// - rareza = jefe ; vida = 500 ; daño = 80 ; velocidad = 1


class Enemigo{
    var vida
    const danio
    var imagen
    var posicion = new Position(x=0,y=0)

    method text() = vida.toString()
    method textColor() = color.verde()
    method vida() = vida
    method restarVida(danioRecibido, enemigos){ 
        if(! self.estaVivo())
            return null
        if(vida < danioRecibido){
            self.morir(enemigos)
        } else {
            vida -= danioRecibido
        }
        return null
    }
    method morir(enemigos){
        vida = 0
        imagen = "muerte.png"
        game.schedule(500, { => game.removeVisual(self) })
        game.schedule(501, { => enemigos.remove(self) })
    }
    method añadirAlJuego(){
        posicion = randomizador.generarPosicion()
        game.addVisual(self)
        return self
    }
    method danio() = danio
    method image() = imagen
    method position() = posicion
    method position(nuevaPosicion){ 
        posicion = nuevaPosicion 
    }
    method estaVivo() = vida > 0
    method golpeasteABrujo(brujo){
        brujo.perderVida(self.danio())
    }
    method moverHacia(brujo){
        movimiento.moverHacia(self, brujo)
    }
}

class HombreLobo inherits Enemigo(
    vida = randomizador.generarEstadistica(15, 5), 
    danio = randomizador.generarEstadistica(5, 2),
    imagen = "hombre_lobo.png"){}
class Diablillo inherits Enemigo(
    vida = randomizador.generarEstadistica(50, 5), 
    danio = randomizador.generarEstadistica(10, 3),
    imagen = "diablillo.png"){}
class Vampiro inherits Enemigo(
    vida = randomizador.generarEstadistica(200, 25), 
    danio = randomizador.generarEstadistica(20, 15),
    imagen = "vampiro.png"){}
class Diablo inherits Enemigo(
    vida = randomizador.generarEstadistica(500, 0), 
    danio = randomizador.generarEstadistica(80, 10),
    imagen = "diablo.png"){}

object generarEnemigo {
    method hombreLobo(){
        return new HombreLobo().añadirAlJuego()
    }
    method diablillo(){
        return new Diablillo().añadirAlJuego()
    }
    method vampiro(){
        return new Vampiro().añadirAlJuego()
    }
    method diablo(){
        return new Diablo().añadirAlJuego()
    }
    method enemigo_aleatorio(){
        const seed = 1.randomUpTo(10).floor()
        var enemigo
        if(seed % 4 == 0)
            enemigo = self.hombreLobo()
        if(seed % 4 == 1)
            enemigo = self.diablillo()
        if(seed % 4 == 2)
            enemigo = self.vampiro()
        if(seed % 4 == 3)
            enemigo = self.diablo()
        return enemigo
        
        // const enemigosAElegir = [
        //     {self.hombreLobo()},
        //     {self.diablillo()},
        //     {self.vampiro()},
        //     {self.diablo()}]
        // const enemigo = enemigosAElegir.apply()
        // return enemigo
    }
}

object randomizador{
    var isTesting = false
    method habilitarTesteo() {
        isTesting = true
    }
    method deshabilitarTesteo() {
        isTesting = false
    }
    method generarEstadistica(estadisticaBase, variacion){
        if(isTesting or variacion > estadisticaBase)
            return estadisticaBase
        return (estadisticaBase - variacion).randomUpTo(estadisticaBase + variacion).floor()
    }
    method generarPosicion(){
        const posicionX = 0.randomUpTo(game.width() - 1).floor()
        const posicionY = 0.randomUpTo(game.height() - 1).floor()
        var posicionGenerada = new Position(x = posicionX , y = posicionY)

        if((!isTesting) and (game.getObjectsIn(posicionGenerada).size() > 0 or brujo.position().distance(posicionGenerada) < 4)){
            posicionGenerada = self.generarPosicion()
        }
        return posicionGenerada
    }
}