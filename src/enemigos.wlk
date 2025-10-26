import src.brujo.*
import movimiento.*
import wollok.game.*
import textos.*


class Enemigo{
    var vida
    const danio
    var imagen
    var posicion = new Position(x=0,y=0)
    
    method text() = vida.toString()
    method textColor() = color.verde()
    method vida() = vida
    method restarVida(danioRecibido){ 
        if(! self.estaVivo())
            return null
        if(vida <= danioRecibido){
            self.morir()
        } else {
            vida -= danioRecibido
        }
        return null
    }
    method morir(){
        vida = 0
        imagen = "muerte.png"
        game.schedule(500, { => game.removeVisual(self) })
    }
    method añadirAlJuego(){
        posicion = randomizador.generarPosicion()
        game.addVisual(self)
        game.onTick(self.velocidad(), "movimiento_enemigo", { self.moverHacia(brujo) })
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
        movimiento.moverHacia(self,brujo)
    }
    method chanceDeAparecer()
    method velocidad()
}

class HombreLobo inherits Enemigo(
    vida = randomizador.generarEstadistica(30, 20),
    danio = randomizador.generarEstadistica(5, 2),
    imagen = "hombre_lobo.png"){
        override method chanceDeAparecer() = 10
        override method velocidad() = 800
    }
class Diablillo inherits Enemigo(
    vida = randomizador.generarEstadistica(15, 5),
    danio = randomizador.generarEstadistica(10, 3),
    imagen = "diablillo.png"){
        override method chanceDeAparecer() = 4
        override method velocidad() = 300
    }
class Vampiro inherits Enemigo(
    vida = randomizador.generarEstadistica(100, 25),
    danio = randomizador.generarEstadistica(20, 15),
    imagen = "vampiro.png"){
        override method chanceDeAparecer() = 3
        override method velocidad() = 600
    }
class Diablo inherits Enemigo(
    vida = randomizador.generarEstadistica(500, 0), 
    danio = randomizador.generarEstadistica(80, 10),
    imagen = "diablo.png"){
        override method chanceDeAparecer() = 1
        override method velocidad() = 1500
    }

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
        var enemigosAElegir = []
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {new HombreLobo()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {new Diablillo()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {new Vampiro()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {new Diablo()})
        enemigosAElegir.randomize()
        return enemigosAElegir.first().apply().añadirAlJuego()
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

        if((!isTesting) and (brujo.position().distance(posicionGenerada) < 1)){
            posicionGenerada = self.generarPosicion()
        }
        return posicionGenerada
    }
    method aplicarChanceDeAparecer(listaDeEnemigos, generadorEnemigo){
        const lista = listaDeEnemigos
        const enemigo = generadorEnemigo.apply()
        enemigo.chanceDeAparecer().times({ i => lista.add ( generadorEnemigo ) })
        return lista
    }
}