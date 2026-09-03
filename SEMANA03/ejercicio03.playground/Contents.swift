// Desarrollado por: Pablo Isla Arone
// Ejercicio 3: Sets
import Foundation

// ==========================================
// TODO 8: Eliminar duplicados
// ==========================================
print("=== TODO 8: ELIMINAR DUPLICADOS ===")
var numeros: [Int] = []
for i in 1...8 {
    print("Número \(i):", terminator: " ")
    let n = Int(readLine() ?? "") ?? 0
    numeros.append(n)
}
print("Con duplicados: \(numeros)")
let sinDuplicados = Array(Set(numeros)).sorted()
print("Sin duplicados (ordenados): \(sinDuplicados)\n")

// ==========================================
// TODO 9: Comparar asistencia
// ==========================================
print("=== TODO 9: COMPARAR ASISTENCIA ===")
var asistenciaLunes: Set<String> = []
print("--- Asistencia Lunes ---")
for i in 1...4 {
    print("Nombre \(i):", terminator: " ")
    let nombre = readLine() ?? ""
    asistenciaLunes.insert(nombre)
}

var asistenciaMartes: Set<String> = []
print("--- Asistencia Martes ---")
for i in 1...4 {
    print("Nombre \(i):", terminator: " ")
    let nombre = readLine() ?? ""
    asistenciaMartes.insert(nombre)
}

print("\n=== REPORTE DE ASISTENCIA ===")
print("Asistieron ambos días: \(asistenciaLunes.intersection(asistenciaMartes))")
print("Asistieron solo el lunes: \(asistenciaLunes.subtracting(asistenciaMartes))")
print("Asistieron solo el martes: \(asistenciaMartes.subtracting(asistenciaLunes))\n")

// ==========================================
// PREDICT: Análisis de operaciones con Sets
// ==========================================
/*
 CÓDIGO:
 let a: Set = [1, 2, 3, 4, 5]
 let b: Set = [4, 5, 6, 7, 8]

 RESPUESTAS:
 PREDICT 5 (a.intersection(b)): [4, 5]
 PREDICT 6 (a.union(b).count): 8 (Elementos únicos combinados del 1 al 8)
 PREDICT 7 (a.subtracting(b)): [1, 2, 3]

 CÓDIGO ANALIZADO 2:
 var repetidos: Set = ["A", "B", "A", "C", "B"]

 RESPUESTAS:
 PREDICT 8 (repetidos.count): 3 (Un Set descarta los duplicados dejando "A", "B", "C")
 */
