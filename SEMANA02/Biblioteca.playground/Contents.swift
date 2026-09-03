import Foundation

// --- 1. DATOS DE LOS USUARIOS ---
enum TipoUsuario {
    case alumno
    case docente
    case administrador

    var diasPermitidos: Int {
        switch self {
        case .alumno: return 7
        case .docente: return 15
        case .administrador: return 10
        }
    }

    var tarifaBase: Double {
        switch self {
        case .alumno: return 1.50
        case .docente: return 2.00
        case .administrador: return 3.00
        }
    }
}

// --- 2. ESTRUCTURA DEL PRÉSTAMO ---
struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucion: Date

    var fechaLimite: Date {
        return Calendar.current.date(byAdding: .day, value: tipoUsuario.diasPermitidos, to: fechaPrestamo)!
    }

    // ETAPA 2: Lógica del calendario de multas
    func generarCalendarioMultas() {
        let calendario = Calendar.current
        let limiteInicio = calendario.startOfDay(for: fechaLimite)
        let devolucionInicio = calendario.startOfDay(for: fechaDevolucion)

        let componentes = calendario.dateComponents([.day], from: limiteInicio, to: devolucionInicio)
        let diasAtraso = componentes.day ?? 0

        if diasAtraso <= 0 {
            print("\n✅ Entregado a tiempo. No hay multas.")
            return
        }

        print("\n--- CALENDARIO DE MULTAS ---")
        print("DIA\tFECHA\t\tMULTA DIAS\tACUMULA")

        var acumulado = 0.0

        for dia in 1...diasAtraso {
            var tarifaDia = tipoUsuario.tarifaBase

            // Recargos según el rango de días de atraso
            if dia >= 4 && dia <= 6 {
                tarifaDia *= 1.50 // Base + 50%
            } else if dia >= 7 {
                tarifaDia *= 2.00 // Base + 100%
            }

            acumulado += tarifaDia
            let fechaDiaMulta = calendario.date(byAdding: .day, value: dia, to: limiteInicio)!

            print("\(dia)\t\(fechaDiaMulta.formateada)\t\(String(format: "%.2f", tarifaDia))\t\t\(String(format: "%.2f", acumulado))")
        }
    }
}

// --- 3. AYUDANTES DE FECHAS ---
extension Date {
    static func crear(dia: Int, mes: Int, año: Int) -> Date? {
        var componentes = DateComponents()
        componentes.day = dia
        componentes.month = mes
        componentes.year = año
        return Calendar.current.date(from: componentes)
    }

    var formateada: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df.string(from: self)
    }
}

// --- 4. ENTRADA INTERACTIVA POR CONSOLA ---
print("=== REGISTRO DE PRÉSTAMO DE LIBROS ===")

print("Ingrese el título del libro:")
let tituloInput = readLine() ?? "Libro sin título"

print("\nSeleccione Tipo de Usuario (1: Alumno, 2: Docente, 3: Administrador):")
let opcionUsuario = readLine() ?? "1"
let usuario: TipoUsuario
switch opcionUsuario {
case "2": usuario = .docente
case "3": usuario = .administrador
default: usuario = .alumno
}

print("\n--- FECHA DE PRÉSTAMO ---")
print("Día:")
let diaP = Int(readLine() ?? "10") ?? 10
print("Mes:")
let mesP = Int(readLine() ?? "10") ?? 10
print("Año:")
let añoP = Int(readLine() ?? "2026") ?? 2026

print("\n--- FECHA DE DEVOLUCIÓN ---")
print("Día:")
let diaD = Int(readLine() ?? "21") ?? 21
print("Mes:")
let mesD = Int(readLine() ?? "10") ?? 10
print("Año:")
let añoD = Int(readLine() ?? "2026") ?? 2026

guard let fechaInicio = Date.crear(dia: diaP, mes: mesP, año: añoP),
      let fechaFin = Date.crear(dia: diaD, mes: mesD, año: añoD) else {
    print("❌ Error en formato de fechas.")
    exit(1)
}

let prestamo = Prestamo(
    tituloLibro: tituloInput,
    tipoUsuario: usuario,
    fechaPrestamo: fechaInicio,
    fechaDevolucion: fechaFin
)

print("\n--- RESUMEN DEL PRÉSTAMO ---")
print("Libro: \(prestamo.tituloLibro)")
print("Usuario: \(prestamo.tipoUsuario)")
print("Fecha de préstamo: \(prestamo.fechaPrestamo.formateada)")
print("Fecha LÍMITE permitida: \(prestamo.fechaLimite.formateada)")
print("Fecha en que devolvió: \(prestamo.fechaDevolucion.formateada)")

// Muestra el desglose del calendario
prestamo.generarCalendarioMultas()
