// Desarrollado por: Pablo Isla Arone
// Ejercicio 5: Carrito de Compras 2.0
import Foundation

print("=== EJERCICIO 5: CARRITO DE COMPRAS 2.0 ===")

var nombres: [String] = []
var precios: [Double] = []
var cantidades: [Int] = []

// TODO 11: Pedir productos
print("¿Cuántos productos va a comprar?", terminator: " ")
let totalProductos = Int(readLine() ?? "") ?? 0

for i in 1...totalProductos {
    print("\nProducto \(i) - Nombre:", terminator: " ")
    nombres.append(readLine() ?? "")
    print("Precio unitario:", terminator: " ")
    precios.append(Double(readLine() ?? "") ?? 0)
    print("Cantidad:", terminator: " ")
    cantidades.append(Int(readLine() ?? "") ?? 0)
}

// TODO 12: Calcular subtotales
var subtotales: [Double] = []
for i in 0..<nombres.count {
    let sub = precios[i] * Double(cantidades[i])
    subtotales.append(sub)
}

// TODO 13: Total del carrito
var totalCarrito = 0.0
for sub in subtotales {
    totalCarrito += sub
}

// TODO 14: Nombre del cliente
print("\nNombre del cliente:", terminator: " ")
let cliente = readLine() ?? ""

// TODO 15: Descuento
var descPct = 0.0
if totalCarrito >= 5000 { descPct = 0.15 }
else if totalCarrito >= 2000 { descPct = 0.10 }
else if totalCarrito >= 500 { descPct = 0.05 }

let descuento = totalCarrito * descPct
let totalConDesc = totalCarrito - descuento

// TODO 16: IGV y total
let igv = totalConDesc * 0.18
let totalFinal = totalConDesc + igv

// TODO 17: Categoría
var categoria = ""
switch Int(totalCarrito) {
case 0..<500: categoria = "Regular"
case 500..<2000: categoria = "Frecuente"
case 2000..<5000: categoria = "VIP"
default: categoria = "Premium"
}

// TODO 18: Ticket
let sep = String(repeating: "=", count: 45)
print("\n\(sep)")
print("           TICKET DE COMPRA 2.0")
print(" Cliente: \(cliente) (\(categoria))")
print(sep)
for i in 0..<nombres.count {
    print("\(nombres[i]) x\(cantidades[i]) - S/. \(String(format: "%.2f", subtotales[i]))")
}
print(sep)
print("Subtotal:            S/. \(String(format: "%.2f", totalCarrito))")
if descPct > 0 {
    print("Descuento (\(Int(descPct * 100))%):   -S/. \(String(format: "%.2f", descuento))")
}
print("IGV (18%):           S/. \(String(format: "%.2f", igv))")
print(sep)
print("TOTAL:               S/. \(String(format: "%.2f", totalFinal))")
print(sep)
print("¡Gracias por su compra, \(cliente)!\n")
