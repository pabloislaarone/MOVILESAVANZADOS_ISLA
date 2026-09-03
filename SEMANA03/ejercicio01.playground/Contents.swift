// Desarrollado por: Pablo Isla Arone
// Ejercicio 1: Arrays
import Foundation

// ==========================================
// TODO 1: Registro de 5 alumnos
// ==========================================
print("=== TODO 1: REGISTRO DE ALUMNOS ===")
var alumnos: [String] = []
for i in 1...5 {
    print("Nombre del alumno \(i):", terminator: " ")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}
print("Alumnos registrados: \(alumnos)\n")

// ==========================================
// TODO 2: Buscar un alumno
// ==========================================
print("=== TODO 2: BUSCAR ALUMNO ===")
print("Buscar alumno:", terminator: " ")
let buscar = readLine() ?? ""
if alumnos.contains(buscar) {
    print("\(buscar) está en la lista.\n")
} else {
    print("\(buscar) NO está en la lista.\n")
}

// ==========================================
// TODO 3: Notas con clasificación
// ==========================================
print("=== TODO 3: NOTAS CON CLASIFICACIÓN ===")
var notasClase: [Double] = []
for i in 1...5 {
    print("Nota del alumno \(i):", terminator: " ")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)\n")

// ==========================================
// FIX: Corrección de 3 errores
// ==========================================
// FIX 1: Se intentaba agregar un Int (7) a un array de String. Se corrige pasando un String.
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva")

// FIX 2: La variable 'colores' fue declarada con 'let'. Se cambia a 'var' para ser mutable.
var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")

// FIX 3: Acceso fuera de rango (índice 5 no existe en un array de 5 elementos). Se cambia a índice 4.
let numeros = [10, 20, 30, 40, 50]
print("Elemento en índice 4: \(numeros[4])\n")

// ==========================================
// PREDICT: Análisis de ejecución
// ==========================================
/*
 PREDICT 1: [2, 3, 4, 5, 6]  -> remove(at: 0) elimina el 1 y append(6) lo agrega al final.
 PREDICT 2: 5                -> La cantidad de elementos final es 5.
 PREDICT 3: ["Ana", "Beto", "Carlos"] -> sorted() devuelve una nueva lista ordenada alfabéticamente.
 PREDICT 4: ["Ana", "Carlos", "Beto"] -> El array original 'nombres' se mantiene sin cambios.
 */
