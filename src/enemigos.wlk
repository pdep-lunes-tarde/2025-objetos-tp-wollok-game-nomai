import src.tp.*
import src.brujo.*
import movimiento.*
import wollok.game.*
import textos.*


class Enemigo{
    var vida
    const danio
    const property chanceDeAparecer
    const velocidad
    const property scorePorMuerte
    var imagen
    var posicion = new Position(x=0,y=0)
    const seed = 0.randomUpTo(10).toString()
    
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
    method danio() = danio * brujosYdiablos.dificultad()
    method velocidad() = velocidad / (0.4 * brujosYdiablos.dificultad())
    method morir(){
        vida = 0
        imagen = "muerte.png"
        game.schedule(500, { => brujosYdiablos.removerEnemigo(self) })
    }
    method image() = imagen
    method position() = posicion
    method position(nuevaPosicion){ 
        posicion = nuevaPosicion 
    }
    method seed() = seed
    method estaVivo() = vida > 0
    method golpeasteABrujo(){
        brujo.perderVida(self.danio())
    }
    method moverHacia(brujo){
        movimiento.moverHacia(self,brujo)
    }
}

object generarEnemigo {
    method hombreLobo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(30, 20),
            danio = randomizador.generarEstadistica(5, 2),
            chanceDeAparecer = 50,
            velocidad = 800,
            scorePorMuerte = 10,
            imagen = "hombre_lobo.png"
        )
        return enemigoGenerado
    }
    method diablillo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(15, 5),
            danio = randomizador.generarEstadistica(10, 3),
            chanceDeAparecer = 30,
            velocidad = 300,
            scorePorMuerte = 5,
            imagen = "diablillo.png"
        )
        return enemigoGenerado
    }
    method vampiro(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(100, 25),
            danio = randomizador.generarEstadistica(20, 15),
            chanceDeAparecer = 15,
            velocidad = 600,
            scorePorMuerte = 30,
            imagen = "vampiro.png"
        )
        return enemigoGenerado
    }
    method diablo(){
        const enemigoGenerado = new Enemigo(
            vida = randomizador.generarEstadistica(500, 0), 
            danio = randomizador.generarEstadistica(80, 10),
            chanceDeAparecer = 5,
            velocidad = 1500,
            scorePorMuerte = 250,
            imagen = "diablo.png"
        )
        return enemigoGenerado
    }
    method enemigo_aleatorio(){
        const enemigosAElegir = [self.hombreLobo(), self.diablillo(), self.vampiro(), self.diablo()]
        return randomizador.aplicarChanceDeAparecer(enemigosAElegir)
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
    method aplicarChanceDeAparecer(listaDeEnemigos){
        const probabilidadTotal = listaDeEnemigos.sum { enemigo => enemigo.chanceDeAparecer() }
        var random = 0.randomUpTo(probabilidadTotal).floor()
        listaDeEnemigos.removeAllSuchThat(
            {
                enemigo =>
                const randomActual = random
                random = random - enemigo.chanceDeAparecer()
                return randomActual > enemigo.chanceDeAparecer()
            }
        )
        return listaDeEnemigos.first()
    }
    method generarCartas(){
        // genera 3 cartas

        return [1,2,3]
    }
}