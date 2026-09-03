import Foundation

// --- 1. DATOS DE LOS USUARIOS ---
enum TipoUsuario {
    case alumno
    case docente
    case administrador
    case coordinador

    var diasPermitidos: Int {
        switch self {
        case .alumno: return 7
        case .docente: return 15
        case .administrador: return 10
        case .coordinador: return 15
        }
    }

    var tarifaBase: Double {
        switch self {
        case .alumno: return 1.50
        case .docente: return 2.00
        case .administrador: return 3.00
        case .coordinador: return 4.00
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
        df.dateFormat = "dd/MM/yyyy"

        print("\n==================================================")
        print("            INFORMACIÓN DEL PRÉSTAMO              ")
        print("==================================================")
        print("Título del libro            : \(tituloLibro)")
        print("Tipo de usuario             : \(tipoUsuario)")
        print("Fecha de préstamo           : \(df.string(from: fechaPrestamo))")
        print("Fecha límite (Automática)   : \(df.string(from: fechaLimite))")
        print("Fecha real de devolución    : \(df.string(from: fechaDevolucion))")
        print("--------------------------------------------------")

        let retraso = diasAtraso
        var multaTotal = 0.0

        if retraso > 0 {
            print("\n--------------------------------------------------")
            print("           CALENDARIO DE MULTAS DIARIAS           ")
            print("--------------------------------------------------")
            print("DÍA\tFECHA\t\tMULTA DÍA\tACUMULADO")
            print("--------------------------------------------------")

            let limiteInicio = calendario.startOfDay(for: fechaLimite)

            for dia in 1...retraso {
                var tarifaDia = tipoUsuario.tarifaBase

                if dia >= 4 && dia <= 6 {
                    tarifaDia *= 1.20
                } else if dia >= 7 && dia <= 10 {
                    tarifaDia *= 1.50
                } else if dia >= 11 {
                    tarifaDia *= 2.00
                }

                multaTotal += tarifaDia
                let fechaDiaMulta = calendario.date(byAdding: .day, value: dia, to: limiteInicio)!

                print("\(dia)\t\(df.string(from: fechaDiaMulta))\tS/ \(String(format: "%.2f", tarifaDia))\t\tS/ \(String(format: "%.2f", multaTotal))")
            }
        }

        let estado = retraso == 0 ? "Devuelto sin atraso" : "Devuelto con atraso (\(retraso) días)"
        let situacion = retraso > 20 ? "Usuario suspendido para futuros préstamos" : "Usuario habilitado"

        print("\n==================================================")
        print("                RESULTADOS FINALES                ")
        print("==================================================")
        print("Multa Total                 : S/ \(String(format: "%.2f", multaTotal))")
        print("Estado                      : \(estado)")
        print("Situación                   : \(situacion)")
        print("==================================================\n")
    }
}

// --- 3. FUNCIONES DE VALIDACIÓN CON FORMATO DD/MM/YYYY Y FECHA ACTUAL ---

func leerTextoValidado(mensaje: String) -> String {
    while true {
        print(mensaje, terminator: " ")
        if let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !entrada.isEmpty {
            return entrada
        }
        print("--------------------------------------------------")
        print("Error: El título del libro no puede quedar vacío.")
        print("--------------------------------------------------")
    }
}

func leerOpcionUsuario() -> TipoUsuario {
    while true {
        print("Seleccione Tipo de Usuario:")
        print("1. Alumno        (+7 días límite  | S/ 1.50 tarifa base)")
        print("2. Docente       (+15 días límite | S/ 2.00 tarifa base)")
        print("3. Administrador (+10 días límite | S/ 3.00 tarifa base)")
        print("4. Coordinador   (+15 días límite | S/ 4.00 tarifa base)")
        print("Opción (1-4):", terminator: " ")
        if let entrada = readLine(), let opcion = Int(entrada) {
            switch opcion {
            case 1: return .alumno
            case 2: return .docente
            case 3: return .administrador
            case 4: return .coordinador
            default: break
            }
        }
        print("--------------------------------------------------")
        print("Error: Ingrese únicamente 1, 2, 3 o 4.")
        print("--------------------------------------------------")
    }
}

func leerFechaConBarras(etiqueta: String) -> Date {
    let calendario = Calendar.current
    while true {
        print("Ingrese \(etiqueta) (Formato DD/MM/YYYY):", terminator: " ")
        guard let entrada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
        
        let partes = entrada.split(separator: "/")
        
        guard partes.count == 3,
              let dia = Int(partes[0]),
              let mes = Int(partes[1]),
              let año = Int(partes[2]),
              partes[2].count == 4 else {
            print("--------------------------------------------------")
            print("Error: Use el formato exacto DD/MM/YYYY (ej. 26/04/2026).")
            print("--------------------------------------------------")
            continue
        }

        var componentes = DateComponents()
        componentes.day = dia
        componentes.month = mes
        componentes.year = año

        if let fecha = calendario.date(from: componentes),
           calendario.component(.day, from: fecha) == dia,
           calendario.component(.month, from: fecha) == mes {
            return fecha
        } else {
            print("--------------------------------------------------")
            print("Error: Fecha inexistente en el calendario real.")
            print("--------------------------------------------------")
        }
    }
}

// --- 4. EJECUCIÓN PRINCIPAL ---

let calendario = Calendar.current
let dfHoy = DateFormatter()
dfHoy.dateFormat = "dd/MM/yyyy"
let hoyInicio = calendario.startOfDay(for: Date())

print("==================================================")
print("     SISTEMA DE GESTIÓN DE PRÉSTAMOS DE LIBROS    ")
print("==================================================")

let tituloInput = leerTextoValidado(mensaje: "Ingrese el título del libro:")
print("--------------------------------------------------")

let usuario = leerOpcionUsuario()
print("--------------------------------------------------")

// Validación de Fecha de Préstamo (Igual o posterior al día de hoy)
var fechaPrestamo: Date
while true {
    fechaPrestamo = leerFechaConBarras(etiqueta: "Fecha de Préstamo")
    let prestamoInicio = calendario.startOfDay(for: fechaPrestamo)

    if prestamoInicio >= hoyInicio {
        break
    }
    print("--------------------------------------------------")
    print("Error: La fecha de préstamo no puede ser anterior a hoy (\(dfHoy.string(from: Date()))).")
    print("--------------------------------------------------")
}
print("--------------------------------------------------")

// Validación de Fecha de Devolución (Igual o posterior a la fecha de préstamo)
var fechaDevolucion: Date
while true {
    fechaDevolucion = leerFechaConBarras(etiqueta: "Fecha de Devolución Real")
    let devolucionInicio = calendario.startOfDay(for: fechaDevolucion)
    let prestamoInicio = calendario.startOfDay(for: fechaPrestamo)

    if devolucionInicio >= prestamoInicio {
        break
    }
    print("--------------------------------------------------")
    print("Error: La fecha de devolución no puede ser anterior a la fecha de préstamo.")
    print("--------------------------------------------------")
}

let miPrestamo = Prestamo(
    tituloLibro: tituloInput,
    tipoUsuario: usuario,
    fechaPrestamo: fechaPrestamo,
    fechaDevolucion: fechaDevolucion
)

miPrestamo.procesarYMostrarReporte()
