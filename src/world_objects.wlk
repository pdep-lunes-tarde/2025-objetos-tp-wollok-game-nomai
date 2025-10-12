import wollok.game.*

class Pared {
    const posicion
    method image() = "pared.png"
    method position() = posicion
    method golpeasteABrujo(brujo){
        const posicionNuevaBrujo = brujo.position().up(1)
        brujo.position(posicionNuevaBrujo)
    }
}