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
    let fechaDevolucion: Date // La fecha en que REALMENTE trae el libro
    
    // Propiedad calculada: Cuándo DEBÍA entregarlo según su tipo
    var fechaLimite: Date {
        return Calendar.current.date(byAdding: .day, value: tipoUsuario.diasPermitidos, to: fechaPrestamo)!
    }
}

// --- 3. AYUDANTES (Encapsulados para evitar el bug del Playground) ---
extension Date {
    // Función estática para crear fechas
    static func crear(dia: Int, mes: Int, año: Int) -> Date {
        var componentes = DateComponents()
        componentes.day = dia
        componentes.month = mes
        componentes.year = año
        return Calendar.current.date(from: componentes) ?? Date()
    }
    
    // Propiedad calculada para imprimir la fecha bonita automáticamente
    var formateada: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df.string(from: self)
    }
}

// --- PRUEBA DE LA ETAPA 1 ---
// Ingresas el día 10 (préstamo) y el día 20 (devolución real)
let fechaInicio = Date.crear(dia: 10, mes: 10, año: 2026)
let fechaFin = Date.crear(dia: 20, mes: 10, año: 2026)

let prestamo = Prestamo(
    tituloLibro: "Estructuras de Datos",
    tipoUsuario: .alumno,
    fechaPrestamo: fechaInicio,
    fechaDevolucion: fechaFin
)

print("--- DATOS INICIALES DEL PRÉSTAMO ---")
print("Libro: \(prestamo.tituloLibro)")
print("Usuario: \(prestamo.tipoUsuario)")
print("Fecha de préstamo: \(prestamo.fechaPrestamo.formateada)")
print("Fecha en que entregó el libro: \(prestamo.fechaDevolucion.formateada)")
print("Fecha LÍMITE permitida: \(prestamo.fechaLimite.formateada)")
