struct Curso {
    let nombre: String
    let cantidad: Int
    let precioTotal: Double
}

func emitirFactura(estudiante: String, dni: String, esAlumnoTecsup: Bool, cursos: [Curso]) {
    print("🎓 FACTURA DE CURSOS")
    print("Estudiante: \(estudiante)")
    print("DNI: \(dni)")
    print("Alumno de Tecsup: \(esAlumnoTecsup ? "Sí ✅" : "No ❌")")
    print("---------------------------------")
    
    var subtotal = 0.0
    var cantidadTotalCursos = 0
    
    for curso in cursos {
        print("\(curso.nombre) x\(curso.cantidad) - S/ \(String(format: "%.2f", curso.precioTotal))")
        subtotal += curso.precioTotal
        cantidadTotalCursos += curso.cantidad
    }
    print("---------------------------------")
    
    let igv = subtotal * 0.18
    let totalConIgv = subtotal + igv
    
    print("Subtotal: S/ \(String(format: "%.2f", subtotal))")
    print("IGV (18%): S/ \(String(format: "%.2f", igv))")
    print("Total con IGV: S/ \(String(format: "%.2f", totalConIgv))")
    
    var descuentoCantidad = 0.0
    if cantidadTotalCursos >= 3 {
        descuentoCantidad = totalConIgv * 0.10
        print("Descuento 10% por cantidad: -S/ \(String(format: "%.2f", descuentoCantidad)) ✅")
    }
    
    var descuentoTecsup = 0.0
    if esAlumnoTecsup && cantidadTotalCursos >= 3 {
        descuentoTecsup = 400.0
        print("Descuento especial Tecsup: -S/ \(String(format: "%.2f", descuentoTecsup)) ✅")
    }
    print("---------------------------------")
    
    let totalPagar = totalConIgv - descuentoCantidad - descuentoTecsup
    print("💰 TOTAL FINAL A PAGAR: S/ \(String(format: "%.2f", totalPagar))")
}

let misCursos = [
    Curso(nombre: "Swift Avanzado", cantidad: 1, precioTotal: 450.0),
    Curso(nombre: "IA con Python", cantidad: 2, precioTotal: 1300.0),
    Curso(nombre: "Diseño UX/UI", cantidad: 1, precioTotal: 500.0)
]

emitirFactura(estudiante: "Juan León", dni: "78965412", esAlumnoTecsup: true, cursos: misCursos)