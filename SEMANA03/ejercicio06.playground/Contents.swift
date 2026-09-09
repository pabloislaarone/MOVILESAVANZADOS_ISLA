import UIKit // Importación de la librería UIKit para ejecutar el entorno del Playground.

let prod1 = "Laptop" // Define el nombre del primer producto en el carrito.
let precio1 = 3500.0 // Define el precio unitario del primer producto.
let cant1 = 1 // Define la cantidad a llevar del primer producto.

let prod2 = "Mouse" // Define el nombre del segundo producto en el carrito.
let precio2 = 45.50 // Define el precio unitario del segundo producto.
let cant2 = 2 // Define la cantidad a llevar del segundo producto.

let prod3 = "Teclado" // Define el nombre del tercer producto en el carrito.
let precio3 = 120.00 // Define el precio unitario del tercer producto.
let cant3 = 1 // Define la cantidad a llevar del tercer producto.

let prod4 = "Monitor" // Define el nombre del cuarto producto en el carrito.
let precio4 = 890.00 // Define el precio unitario del cuarto producto.
let cant4 = 1 // Define la cantidad a llevar del cuarto producto.

let prod5 = "USB Cable" // Define el nombre del quinto producto en el carrito.
let precio5 = 15.00 // Define el precio unitario del quinto producto.
let cant5 = 3 // Define la cantidad a llevar del quinto producto.

let datosValidos = precio1 >= 0 && cant1 > 0 && precio2 >= 0 && cant2 > 0 && precio3 >= 0 && cant3 > 0 && precio4 >= 0 && cant4 > 0 && precio5 >= 0 && cant5 > 0 // Valida que ningún precio sea negativo ni cantidad sea cero o menor.

if !datosValidos { // Evalúa si existe un error en los datos de entrada.
    print("Error: Existen precios negativos o cantidades iguales a cero.") // Muestra mensaje de error si la validación falla.
} else { // Ejecuta el proceso de cobro si los datos son válidos.

    let descVol1 = cant1 >= 3 ? 0.05 : 0.0 // Aplica 5% de descuento en prod1 si lleva 3 o más unidades.
    let sub1 = (precio1 * Double(cant1)) * (1.0 - descVol1) // Calcula el subtotal descontado para el producto 1.

    let descVol2 = cant2 >= 3 ? 0.05 : 0.0 // Aplica 5% de descuento en prod2 si lleva 3 o más unidades.
    let sub2 = (precio2 * Double(cant2)) * (1.0 - descVol2) // Calcula el subtotal descontado para el producto 2.

    let descVol3 = cant3 >= 3 ? 0.05 : 0.0 // Aplica 5% de descuento en prod3 si lleva 3 o más unidades.
    let sub3 = (precio3 * Double(cant3)) * (1.0 - descVol3) // Calcula el subtotal descontado para el producto 3.

    let descVol4 = cant4 >= 3 ? 0.05 : 0.0 // Aplica 5% de descuento en prod4 si lleva 3 o más unidades.
    let sub4 = (precio4 * Double(cant4)) * (1.0 - descVol4) // Calcula el subtotal descontado para el producto 4.

    let descVol5 = cant5 >= 3 ? 0.05 : 0.0 // Aplica 5% de descuento en prod5 si lleva 3 o más unidades.
    let sub5 = (precio5 * Double(cant5)) * (1.0 - descVol5) // Calcula el subtotal descontado para el producto 5.

    let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5 // Calcula la suma total de los subtotales de los productos.

    let cupon = "DESCUENTO20" // Variable con el código del cupón ingresado.
    var descCupon = 0.0 // Variable que almacenará el porcentaje de descuento por cupón.
    if cupon == "DESCUENTO20" { // Condicional que verifica si el cupón ingresado es correcto.
        descCupon = 0.20 // Asigna 20% de descuento adicional al total.
    } // Cierra la verificación del cupón.

    let subtotalConCupon = subtotalGeneral * (1.0 - descCupon) // Aplica el descuento del cupón al subtotal acumulado.
    let igv = subtotalConCupon * 0.18 // Calcula el 18% del IGV sobre el subtotal con cupón.
    let totalParcial = subtotalConCupon + igv // Calcula el costo parcial sumando el impuesto.

    var costoEnvio = 0.0 // Inicializa la variable correspondiente al costo de delivery.
    if totalParcial > 3000 { // Condicional para validar si el monto califica para envío gratis.
        costoEnvio = 0.0 // Determina envío gratis si supera los S/. 3000.
    } else { // Se ejecuta si la compra no alcanza los S/. 3000.
        costoEnvio = 25.00 // Asigna el costo fijo de envío de S/. 25.00.
    } // Cierra la evaluación del costo de envío.

    let totalFinal = totalParcial + costoEnvio // Calcula el importe total sumando el costo de envío.
    let puntosGanados = Int(totalFinal / 100) // Calcula 1 punto acumulado por cada S/. 100 de compra total.

    print("========================================") // Imprime línea divisoria del ticket.
    print("         CARRITO MEJORADO CON IA") // Muestra el título del comprobante.
    print("========================================") // Imprime línea divisoria del ticket.
    print("\(prod1) x\(cant1) = S/. \(sub1)") // Muestra detalle e importe del producto 1.
    print("\(prod2) x\(cant2) = S/. \(sub2)") // Muestra detalle e importe del producto 2.
    print("\(prod3) x\(cant3) = S/. \(sub3)") // Muestra detalle e importe del producto 3.
    print("\(prod4) x\(cant4) = S/. \(sub4)") // Muestra detalle e importe del producto 4.
    print("\(prod5) x\(cant5) = S/. \(sub5)") // Muestra detalle e importe del producto 5.
    print("----------------------------------------") // Imprime línea de separación secundaria.
    print("Subtotal General: S/. \(subtotalGeneral)") // Imprime la suma de los subtotales.
    print("Subtotal con Cupón: S/. \(subtotalConCupon)") // Imprime el valor con cupón aplicado.
    print("IGV (18%): S/. \(igv)") // Imprime la cuota por IGV.
    print("Costo de Envío: S/. \(costoEnvio)") // Imprime el costo de delivery abonado.
    print("TOTAL FINAL: S/. \(totalFinal)") // Imprime la suma final a cancelar.
    print("Puntos de fidelidad ganados: \(puntosGanados) pts") // Imprime los puntos ganados por la compra.
    print("========================================") // Imprime línea divisoria final.
} // Cierra el bloque condicional principal de validación de datos.
