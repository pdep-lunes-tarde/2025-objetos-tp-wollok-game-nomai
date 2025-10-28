import src.tp.*
import src.brujo.*
import movimiento.*
import wollok.game.*
import textos.*


class Enemigo{
    var vida
    const danio
    const chanceDeAparecer
    const velocidad
    var imagen
    var posicion = new Position(x=0,y=0)
    
    method text() = vida.toString()
    method textColor() = color.verde()
    method vida() = vida
    method restarVida(danioRecibido){ 
        if(self.estaVivo()){
            if(vida <= danioRecibido){
                self.morir()
            } else {
                vida -= danioRecibido
            }
        }
    }
    method morir(){
        vida = 0
        imagen = "muerte.png"
        game.schedule(500, { => brujosYdiablos.removerEnemigo(self) })
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
    method chanceDeAparecer() = chanceDeAparecer
    method velocidad() = velocidad
}

object generarEnemigo {
    method hombreLobo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(30, 20),
            danio = randomizador.generarEstadistica(5, 2),
            chanceDeAparecer = 10,
            velocidad = 800,
            imagen = "hombre_lobo.png"
        )
        return enemigoGenerado
    }
    method diablillo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(15, 5),
            danio = randomizador.generarEstadistica(10, 3),
            chanceDeAparecer = 4,
            velocidad = 300,
            imagen = "diablillo.png"
        )
        return enemigoGenerado
    }
    method vampiro(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(100, 25),
            danio = randomizador.generarEstadistica(20, 15),
            chanceDeAparecer = 3,
            velocidad = 600,
            imagen = "vampiro.png"
        )
        return enemigoGenerado
    }
    method diablo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(500, 0), 
            danio = randomizador.generarEstadistica(80, 10),
            chanceDeAparecer = 1,
            velocidad = 1500,
            imagen = "diablo.png"
        )
        return enemigoGenerado
    }
    method enemigo_aleatorio(){
        var enemigosAElegir = []
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {self.hombreLobo()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {self.diablillo()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {self.vampiro()})
        enemigosAElegir = randomizador.aplicarChanceDeAparecer(enemigosAElegir, {self.diablo()})
        enemigosAElegir.randomize()
        return enemigosAElegir.first().apply()
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