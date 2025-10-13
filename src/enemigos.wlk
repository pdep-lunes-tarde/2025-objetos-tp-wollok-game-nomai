import src.brujo.*
import movimiento.*
import wollok.game.*
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
    var vida = 500
    const danio = 80
    var imagen = "diablo.png"
    var posicion
    var estaVivo = true
    method vida() = vida
    method restarVida(danioRecibido, enemigos){ 
        if(! estaVivo)
            return null
        if(vida > danioRecibido)
            vida -= danioRecibido
        else
            self.morir(enemigos)
        return null
    }
    method morir(enemigos){
        estaVivo = false
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
    method estaVivo() = estaVivo
    method golpeasteABrujo(brujo){
        brujo.perderVida(self.danio())
    }
    method moverHacia(brujo){
        movimiento.moverHacia(self, brujo)
    }
}

object generarEnemigos {
    method hombreLobo(){
        const vidaHombreLobo = randomizador.estadistica(15, 5)
        const danioHombreLobo = randomizador.estadistica(5, 2)
        const posicionHombreLobo = randomizador.posicion()
        return new Enemigo(
            vida = vidaHombreLobo,
            danio = danioHombreLobo,
            imagen = "hombre_lobo.png",
            posicion = posicionHombreLobo)
    }
    method diablillo(){
        const vidaDiablillo = randomizador.estadistica(50, 5)
        const danioDiablillo = randomizador.estadistica(10, 3)
        const posicionDiablillo = randomizador.posicion()
        return new Enemigo(
            vida = vidaDiablillo,
            danio = danioDiablillo,
            imagen = "diablillo.png",
            posicion = posicionDiablillo)
    }
    method vampiro(){
        const vidaVampiro = randomizador.estadistica(200, 25)
        const danioVampiro = randomizador.estadistica(20, 15)
        const posicionVampiro = randomizador.posicion()
        return new Enemigo(
            vida = vidaVampiro,
            danio = danioVampiro,
            imagen = "vampiro.png",
            posicion = posicionVampiro)
    }
    method diablo(){
        const vidaDiablo = randomizador.estadistica(500, 0)
        const danioDiablo = randomizador.estadistica(80, 10)
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
    method estadistica(estadisticaBase, variacion){
        if(isTesting)
            return estadisticaBase
        var estadisticaReal = estadisticaBase
        if(1.randomUpTo(2).odd())
            estadisticaReal = (estadisticaReal - variacion).max(1)
        return estadisticaReal.randomUpTo(variacion)
    }
    method posicion(){
        const posicionX = 0.randomUpTo(game.width() - 1).floor()
        const posicionY = 0.randomUpTo(game.height() - 1).floor()
        const posicionGenerada = new Position(x = posicionX , y = posicionY)
        game.allVisuals().forEach{ 
            cosa => 
            if(game.onSameCell(cosa.position(), posicionGenerada)) 
                posicionGenerada.up(3)
        }
        return posicionGenerada
    }
    method mejorar(maximo){
        return 1.randomUpTo(maximo).floor()
    }
}