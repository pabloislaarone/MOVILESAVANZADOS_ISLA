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

// --- 2. ESTRUCTURA DEL PRÉSTAMO Y LÓGICA DE NEGOCIO ---
struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucion: Date

    var fechaLimite: Date {
        return Calendar.current.date(byAdding: .day, value: tipoUsuario.diasPermitidos, to: fechaPrestamo)!
    }

    var diasAtraso: Int {
        let calendario = Calendar.current
        let limiteInicio = calendario.startOfDay(for: fechaLimite)
        let devolucionInicio = calendario.startOfDay(for: fechaDevolucion)
        let componentes = calendario.dateComponents([.day], from: limiteInicio, to: devolucionInicio)
        return max(0, componentes.day ?? 0)
    }

    func procesarYMostrarReporte() {
        let calendario = Calendar.current
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"

        print("\n==========================================")
        print("         INFORMACIÓN DEL PRÉSTAMO         ")
        print("==========================================")
        print("📘 Título del libro: \(tituloLibro)")
        print("👤 Tipo de usuario: \(tipoUsuario)")
        print("📅 Fecha de préstamo: \(df.string(from: fechaPrestamo))")
        print("⏰ Fecha límite (Automática): \(df.string(from: fechaLimite))")
        print("📥 Fecha real de devolución: \(df.string(from: fechaDevolucion))")

        let retraso = diasAtraso
        var multaTotal = 0.0

        if retraso > 0 {
            print("\n--- CALENDARIO DE MULTAS DIARIAS ---")
            print("DIA\tFECHA\t\tMULTA DIAS\tACUMULA")

            let limiteInicio = calendario.startOfDay(for: fechaLimite)

            for dia in 1...retraso {
                var tarifaDia = tipoUsuario.tarifaBase

                if dia >= 4 && dia <= 6 {
                    tarifaDia *= 1.50 // Base + 50%
                } else if dia >= 7 {
                    tarifaDia *= 2.00 // Base + 100%
                }

                multaTotal += tarifaDia
                let fechaDiaMulta = calendario.date(byAdding: .day, value: dia, to: limiteInicio)!

                print("\(dia)\t\(df.string(from: fechaDiaMulta))\tS/ \(String(format: "%.2f", tarifaDia))\t\tS/ \(String(format: "%.2f", multaTotal))")
            }
        }

        let estado = retraso == 0 ? "Devuelto sin atraso" : "Devuelto con atraso (\(retraso) días)"
        let situacion = retraso > 10 ? "Usuario suspendido para futuros préstamos" : "Usuario habilitado"

        print("\n==========================================")
        print("            RESULTADOS FINALES            ")
        print("==========================================")
        print("💰 Multa Total: S/ \(String(format: "%.2f", multaTotal))")
        print("📋 Estado: \(estado)")
        print("⚠️  Situación: \(situacion)")
        print("==========================================")
    }
}

// --- 3. FUNCIONES DE VALIDACIÓN Y RESTRICCIONES REALISTAS ---

// Lee exclusivamente números enteros dentro de un rango
func leerNumeroValidado(mensaje: String, min: Int, max: Int) -> Int {
    while true {
        print(mensaje, terminator: " ")
        if let entrada = readLine(), let numero = Int(entrada), numero >= min && numero <= max {
            return numero
        }
        print("❌ Entrada inválida. Ingrese únicamente un número entero entre \(min) y \(max).")
    }
}

// Garatiza que el texto no se envíe vacío
func leerTextoValidado(mensaje: String) -> String {
    while true {
        print(mensaje)
        if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !entrada.isEmpty {
            return entrada
        }
        print("❌ El título no puede estar vacío.")
    }
}

// Garantiza la existencia real de la fecha en el calendario
func leerFechaValidada(mensajeHeader: String) -> Date {
    let calendario = Calendar.current
    while true {
        print("\n--- \(mensajeHeader) ---")
        let dia = leerNumeroValidado(mensaje: "Día (1-31):", min: 1, max: 31)
        let mes = leerNumeroValidado(mensaje: "Mes (1-12):", min: 1, max: 12)
        let año = leerNumeroValidado(mensaje: "Año (ej. 2026):", min: 2026, max: 2100)

        var componentes = DateComponents()
        componentes.day = dia
        componentes.month = mes
        componentes.year = año

        if let fecha = calendario.date(from: componentes),
           calendario.component(.day, from: fecha) == dia {
            return fecha
        }
        print("❌ Fecha inexistente en el calendario (ej. 30 de febrero). Intente de nuevo.")
    }
}

// --- 4. EJECUCIÓN INTERACTIVA ---

print("=== SISTEMA REALISTA DE PRÉSTAMOS DE BIBLIOTECA ===")

let tituloInput = leerTextoValidado(mensaje: "Ingrese el título del libro:")

print("\nSeleccione Tipo de Usuario:")
print("1. Alumno (+7 días límite | Tarifa: S/ 1.50)")
print("2. Docente (+15 días límite | Tarifa: S/ 2.00)")
print("3. Administrador (+10 días límite | Tarifa: S/ 3.00)")
let opcionUsuario = leerNumeroValidado(mensaje: "Opción (1-3):", min: 1, max: 3)

let usuario: TipoUsuario
switch opcionUsuario {
case 2: usuario = .docente
case 3: usuario = .administrador
default: usuario = .alumno
}

// Captura de Fecha de Préstamo
let fechaPrestamo = leerFechaValidada(mensajeHeader: "FECHA DE PRÉSTAMO")

// Captura de Fecha de Devolución con restricción cronológica
var fechaDevolucion: Date
while true {
    fechaDevolucion = leerFechaValidada(mensajeHeader: "FECHA DE DEVOLUCIÓN REAL")
    if fechaDevolucion >= fechaPrestamo {
        break
    }
    print("❌ Restricción: La fecha de devolución no puede ser anterior a la fecha de préstamo.")
}

let miPrestamo = Prestamo(
    tituloLibro: tituloInput,
    tipoUsuario: usuario,
    fechaPrestamo: fechaPrestamo,
    fechaDevolucion: fechaDevolucion
)

miPrestamo.procesarYMostrarReporte()
