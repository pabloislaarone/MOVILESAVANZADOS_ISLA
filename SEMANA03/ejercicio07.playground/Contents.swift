import UIKit // Importación del marco de trabajo UIKit para Swift.

let numeroSecreto = 42 // Establece el número secreto fijo a adivinar.

let intento1 = 20 // Simula el valor ingresado en el primer intento.
let intento2 = 50 // Simula el valor ingresado en el segundo intento.
let intento3 = 35 // Simula el valor ingresado en el tercer intento.
let intento4 = 42 // Simula el valor ingresado en el cuarto intento.
let intento5 = 10 // Simula el valor ingresado en el quinto intento.

var numIntentoActual = 1 // Inicializa el contador de intentos desde el primer intento.
var adivino = false // Controla el estado de victoria del juego.

while numIntentoActual <= 5 && !adivino { // Permite iterar mientras los intentos sean <= 5 y no haya acertado.
    var intentoEvaluar = 0 // Variable auxiliar para almacenar el intento correspondiente a la vuelta.

    if numIntentoActual == 1 { // Evalúa si se encuentra en el primer intento.
        intentoEvaluar = intento1 // Asigna la variable intento1.
    } else if numIntentoActual == 2 { // Evalúa si se encuentra en el segundo intento.
        intentoEvaluar = intento2 // Asigna la variable intento2.
    } else if numIntentoActual == 3 { // Evalúa si se encuentra en el tercer intento.
        intentoEvaluar = intento3 // Asigna la variable intento3.
    } else if numIntentoActual == 4 { // Evalúa si se encuentra en el cuarto intento.
        intentoEvaluar = intento4 // Asigna la variable intento4.
    } else if numIntentoActual == 5 { // Evalúa si se encuentra en el quinto intento.
        intentoEvaluar = intento5 // Asigna la variable intento5.
    } // Cierra la estructura condicional de asignación de variables.

    print("Intento \(numIntentoActual): Se ingresó el número \(intentoEvaluar)") // Muestra la jugada actual.

    if intentoEvaluar == numeroSecreto { // Compara si la suposición coincide exactamente con el secreto.
        print("¡Correcto!") // Imprime la notificación de acierto.
        adivino = true // Actualiza el booleano para salir del bucle.
    } else if intentoEvaluar > numeroSecreto { // Evalúa si el intento ingresado supera el objetivo.
        print("Muy alto") // Le indica al usuario que ingrese un valor inferior.
    } else { // Se ejecuta si el número es menor que el objetivo.
        print("Muy bajo") // Le indica al usuario que ingrese un valor superior.
    } // Cierra las comparaciones de adivinanza.

    if !adivino { // Incrementa el contador sólo si no ha adivinado en esta vuelta.
        numIntentoActual += 1 // Suma 1 a la cantidad de intentos efectuados.
    } // Cierra la condición de incremento.
} // Cierra el bucle principal while.

if adivino { // Revisa si el jugador concluyó victorioso.
    print("¡Felicidades! Adivinaste el número en \(numIntentoActual) intentos.") // Muestra el mensaje de victoria.
} else { // Caso en el que agotó los 5 intentos sin acertar.
    print("Perdiste. El número era: \(numeroSecreto)") // Muestra el mensaje de derrota y revela el número.
} // Cierra la verificación de victoria final.
