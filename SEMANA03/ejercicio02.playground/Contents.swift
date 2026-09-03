// Desarrollado por: Pablo Isla Arone
// Ejercicio 2: Diccionarios
import Foundation

// ==========================================
// TODO 4-7: Catálogo de productos
// ==========================================
print("=== TODO 4-7: CATÁLOGO DE PRODUCTOS ===")
var productos: [String: Double] = [:]

// TODO 4: Ingreso de 4 productos
for i in 1...4 {
    print("Producto \(i) - Nombre:", terminator: " ")
    let nombre = readLine() ?? ""
    print("Precio:", terminator: " ")
    let precio = Double(readLine() ?? "") ?? 0
    productos[nombre] = precio
}

// TODO 5: Mostrar catálogo
print("\n===== CATÁLOGO =====")
for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// TODO 6: Calcular valor total
var valorTotal = 0.0
for (_, precio) in productos {
    valorTotal += precio
}
print("\nValor total del catálogo: S/. \(valorTotal)")

// TODO 7: Buscar producto
print("\nBuscar producto:", terminator: " ")
let buscarProd = readLine() ?? ""
if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)\n")
} else {
    print("Producto no encontrado\n")
}

// ==========================================
// 3. ANALYZE: Análisis de código
// ==========================================
/*
 CÓDIGO ANALIZADO:
 var edades: [String: Int] = ["Ana": 20, "Luis": 22, "María": 19]
 var mayores: [String] = []
 for (nombre, edad) in edades {
     if edad >= 21 {
         mayores.append(nombre)
     }
 }
 print("Mayores de 21: \(mayores)")

 ANALYZE 1:
 - ¿Qué hace?: Recorre el diccionario 'edades' evaluando cada pareja (nombre, edad). Si la edad es mayor o igual a 21, agrega el nombre al array 'mayores'.
 - ¿Qué imprime?: Mayores de 21: ["Luis"]
 */
