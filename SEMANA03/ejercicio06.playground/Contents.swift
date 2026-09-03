// Desarrollado Pablo Isla Arone
// Ejercicio 6: Gestión de Notas con IA
import Foundation

// Diccionario principal: [NombreAlumno: ArrayDe3Notas]
var registroNotas: [String: [Double]] = [:]

print("=== GESTIÓN DE NOTAS ===")
print("¿Cuántos alumnos desea registrar?", terminator: " ")
let cantidadAlumnos = Int(readLine() ?? "") ?? 0

// Registro de alumnos y sus 3 notas
for i in 1...cantidadAlumnos {
    print("\nAlumno \(i) - Nombre:", terminator: " ")
    let nombre = readLine() ?? ""
    var notasAlumno: [Double] = []
    
    for j in 1...3 {
        print("  Nota \(j):", terminator: " ")
        let nota = Double(readLine() ?? "") ?? 0.0
        notasAlumno.append(nota)
    }
    
    registroNotas[nombre] = notasAlumno
}

var listaReporte: [(nombre: String, promedio: Double, estado: String)] = []
var sumaTotalNotas = 0.0
var contadorNotasTotales = 0
var aprobadosCount = 0

print("\n===== REPORTE INDIVIDUAL =====")

// Cálculo de promedios y clasificación por alumno
for (nombre, notas) in registroNotas {
    let sumaNotas = notas.reduce(0, +)
    let promedio = notas.count > 0 ? sumaNotas / Double(notas.count) : 0.0
    
    sumaTotalNotas += sumaNotas
    contadorNotasTotales += notas.count
    
    var clasificacion = ""
    
    // Clasificación según rango de promedio
    switch promedio {
    case 18.0...20.0:
        clasificacion = "Excelente"
    case 15.0..<18.0:
        clasificacion = "Bueno"
    case 13.0..<15.0:
        clasificacion = "Aprobado"
    default:
        clasificacion = "Desaprobado"
    }
    
    if promedio >= 13.0 {
        aprobadosCount += 1
    }
    
    listaReporte.append((nombre: nombre, promedio: promedio, estado: clasificacion))
    print("\(nombre) - Notas: \(notas) | Promedio: \(String(format: "%.2f", promedio)) | Estado: \(clasificacion)")
}

// Estadísticas generales del grupo
let promedioGeneral = contadorNotasTotales > 0 ? sumaTotalNotas / Double(contadorNotasTotales) : 0.0
let porcentajeAprobados = registroNotas.count > 0 ? (Double(aprobadosCount) / Double(registroNotas.count)) * 100.0 : 0.0

print("\n===== ESTADÍSTICAS GENERALES =====")
print("Promedio General de la clase: \(String(format: "%.2f", promedioGeneral))")
print("Porcentaje de Aprobados: \(String(format: "%.1f", porcentajeAprobados))%")

// Ordenamiento de lista de mayor a menor promedio
let listaOrdenada = listaReporte.sorted { $0.promedio > $1.promedio }

if let mejor = listaOrdenada.first {
    print("Nota/Promedio más alto: \(mejor.nombre) (\(String(format: "%.2f", mejor.promedio)))")
}

if let peor = listaOrdenada.last {
    print("Nota/Promedio más bajo: \(peor.nombre) (\(String(format: "%.2f", peor.promedio)))")
}

print("\n===== ALUMNOS ORDENADOS POR PROMEDIO =====")
for alumno in listaOrdenada {
    print("\(alumno.nombre): \(String(format: "%.2f", alumno.promedio)) (\(alumno.estado))")
}
