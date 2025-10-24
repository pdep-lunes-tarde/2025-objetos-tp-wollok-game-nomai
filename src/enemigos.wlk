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
    var posicion

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

object generarEnemigos {
    method hombreLobo(){
        const vidaHombreLobo = randomizador.generarEstadistica(15, 5)
        const danioHombreLobo = randomizador.generarEstadistica(5, 2)
        const posicionHombreLobo = randomizador.posicion()
        return new Enemigo(
            vida = vidaHombreLobo,
            danio = danioHombreLobo,
            imagen = "hombre_lobo.png",
            posicion = posicionHombreLobo)
    }
    method diablillo(){
        const vidaDiablillo = randomizador.generarEstadistica(50, 5)
        const danioDiablillo = randomizador.generarEstadistica(10, 3)
        const posicionDiablillo = randomizador.posicion()
        return new Enemigo(
            vida = vidaDiablillo,
            danio = danioDiablillo,
            imagen = "diablillo.png",
            posicion = posicionDiablillo)
    }
    method vampiro(){
        const vidaVampiro = randomizador.generarEstadistica(200, 25)
        const danioVampiro = randomizador.generarEstadistica(20, 15)
        const posicionVampiro = randomizador.posicion()
        return new Enemigo(
            vida = vidaVampiro,
            danio = danioVampiro,
            imagen = "vampiro.png",
            posicion = posicionVampiro)
    }
    method diablo(){
        const vidaDiablo = randomizador.generarEstadistica(500, 0)
        const danioDiablo = randomizador.generarEstadistica(80, 10)
        const posicionDiablo = randomizador.posicion()
        return new Enemigo(
            vida = vidaDiablo,
            danio = danioDiablo,
            imagen = "diablo.png",
            posicion = posicionDiablo)
    }
    method aleatorio(enemigos){
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
        enemigos.add(enemigo)
        game.addVisual(enemigo)
    }
}

object randomizador{
    var isTesting = false
    method habilitarTesteo() {
        isTesting = true
    }
    method generarEstadistica(estadisticaBase, variacion){
        if(isTesting or variacion > estadisticaBase)
            return estadisticaBase
        return (estadisticaBase - variacion).randomUpTo(estadisticaBase + variacion).floor()
    }
    method posicion(){
        
        const posicionX = 0.randomUpTo(game.width() - 1).floor()
        const posicionY = 0.randomUpTo(game.height() - 1).floor()
        const posicionGenerada = new Position(x = posicionX , y = posicionY)
        game.getObjectsIn(posicionGenerada)
        // game.allVisuals().forEach{ 
        //     cosa =>
        //     if(game.onSameCell(cosa.position(), posicionGenerada)) 
        //         posicionGenerada = posicionGenerada.up(3)
        // }
        return posicionGenerada
    }
    method mejorar(maximo){
        return 1.randomUpTo(maximo).floor()
    }
}