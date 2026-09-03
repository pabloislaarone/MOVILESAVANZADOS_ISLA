// Desarrollado por: Pablo Isla Arone
// Ejercicio 4: Combinación de Colecciones
import Foundation

// ==========================================
// TODO 10: Inventario de productos
// ==========================================
print("=== TODO 10: INVENTARIO DE PRODUCTOS ===")
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos va a registrar?", terminator: " ")
let n = Int(readLine() ?? "") ?? 0

for i in 1...n {
    print("\nProducto \(i) - Nombre:", terminator: " ")
    let nombre = readLine() ?? ""
    print("Precio:", terminator: " ")
    let precio = Double(readLine() ?? "") ?? 0
    print("Stock:", terminator: " ")
    let stock = Int(readLine() ?? "") ?? 0
    
    precios[nombre] = precio
    stocks[nombre] = stock
}

print("\n===== REPORTE DE INVENTARIO =====")
var valorTotalInventario = 0.0

for (nombre, precio) in precios {
    if let stock = stocks[nombre] {
        let valorProducto = precio * Double(stock)
        valorTotalInventario += valorProducto
        print("\(nombre) -> Precio: S/. \(precio) | Stock: \(stock) | Valor Subtotal: S/. \(valorProducto)")
    }
}

print("\nValor total del inventario: S/. \(valorTotalInventario)")

print("\n===== PRODUCTOS CON STOCK BAJO (< 5) =====")
var hayStockBajo = false
for (nombre, stock) in stocks {
    if stock < 5 {
        print("- \(nombre): Quedan \(stock) unidades")
        hayStockBajo = true
    }
}

if !hayStockBajo {
    print("No hay productos con stock bajo.")
}
print("")
