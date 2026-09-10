import Foundation

// ==========================================
// 1. ESTRUCTURAS DE DATOS
// ==========================================
struct Conexion {
    var lineaDestino: String
    var estacionDestino: String
    var detalle: String
}

struct Estacion {
    var nombre: String
    var linea: String
    var operativa: Bool
    var tieneAscensor: Bool
    var conexiones: [Conexion]
    var advertencia: String
}

// ==========================================
// 2. DICCIONARIO PRINCIPAL
// ==========================================
var diccionarioEstaciones: [String: Estacion] = [:]
var destinosPopulares: [String: String] = [:]

// ==========================================
// 3. DATOS DE ESTACIONES Y METROPOLITANO
// ==========================================
func cargarTodaLaRed() {
    // --- LÍNEA 1 ---
    let linea1Nombres = ["Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María", "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho", "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra", "Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua", "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos", "San Martín", "Santa Rosa", "Bayóvar"]
    
    for nombre in linea1Nombres {
        var info = "Estación operativa."
        if nombre == "Grau" {
            info = "Grau NO tiene conexión directa con L2. La futura interconexión L1-L2 será en 28 de Julio."
        }
        diccionarioEstaciones[nombre] = Estacion(nombre: nombre, linea: "Línea 1", operativa: true, tieneAscensor: true, conexiones: [], advertencia: info)
    }
    
    // --- LÍNEA 2 ---
    let linea2Nombres = ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes", "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio", "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi", "Estación Central", "Manco Cápac", "Cangallo", "28 de Julio", "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán", "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado", "Municipalidad de Ate"]
    
    let operativasL2 = ["Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán", "Mercado Santa Anita"]
    
    for nombre in linea2Nombres {
        let clave = "\(nombre) (L2)"
        let estaOperativa = operativasL2.contains(nombre)
        diccionarioEstaciones[clave] = Estacion(nombre: clave, linea: "Línea 2", operativa: estaOperativa, tieneAscensor: true, conexiones: [], advertencia: estaOperativa ? "Tramo 1A en funcionamiento." : "Estación en construcción.")
    }
    
    // --- METROPOLITANO ---
    diccionarioEstaciones["Estadio Nacional (MET)"] = Estacion(nombre: "Estadio Nacional (MET)", linea: "Metropolitano", operativa: true, tieneAscensor: true, conexiones: [], advertencia: "Estación principal para ir al Estadio Nacional del Perú.")
    diccionarioEstaciones["Central (MET)"] = Estacion(nombre: "Central (MET)", linea: "Metropolitano", operativa: true, tieneAscensor: true, conexiones: [], advertencia: "Conectará mediante túnel con L2.")
    
    // --- REGISTRO DE CONEXIONES Y DESTINOS ---
    diccionarioEstaciones["28 de Julio (L2)"]?.conexiones.append(Conexion(lineaDestino: "Línea 1", estacionDestino: "28 de Julio (L1 Futura)", detalle: "Futuro intercambio"))
    
    diccionarioEstaciones["Estación Central (L2)"]?.conexiones.append(Conexion(lineaDestino: "Metropolitano", estacionDestino: "Central (MET)", detalle: "Intercambio subterráneo en construcción"))
    
    destinosPopulares["estadio nacional del peru"] = "Estadio Nacional (MET)"
    destinosPopulares["estadio nacional"] = "Estadio Nacional (MET)"
}

// ==========================================
// 4. LÓGICA DE BÚSQUEDA
// ==========================================
func buscarEstacion(nombre: String) {
    let busqueda = nombre.lowercased()
    let resultados = diccionarioEstaciones.filter { $0.key.lowercased().contains(busqueda) }
    
    if resultados.isEmpty {
        print("\n❌ No se encontró ninguna estación con el nombre ingresado.")
        return
    }
    
    for (_, estacion) in resultados {
        print("\n========================================")
        print("🚇 ESTACIÓN: \(estacion.nombre)")
        print("📍 Línea: \(estacion.linea)")
        print("🛠️ Estado: \(estacion.operativa ? "Operativa" : "En construcción")")
        print("🛗 Ascensor: \(estacion.tieneAscensor ? "Sí" : "No")")
        print("⚠️ Info: \(estacion.advertencia)")
        
        if !estacion.conexiones.isEmpty {
            print("🔗 Conexiones Especiales:")
            for conexion in estacion.conexiones {
                print("   - Conecta con \(conexion.lineaDestino) en \(conexion.estacionDestino) (\(conexion.detalle))")
            }
        }
        print("========================================")
    }
}

func consultarDestino(lugar: String) {
    if let estacionRecomendada = destinosPopulares[lugar.lowercased()] {
        print("\n🎯 Para ir a este destino, debes dirigirte a la estación:")
        buscarEstacion(nombre: estacionRecomendada)
    } else {
        print("\n❌ Destino no registrado.")
    }
}

func listarPorLinea(lineaBuscada: String) {
    print("\n📋 ESTACIONES DE \(lineaBuscada.uppercased()):")
    let estacionesLinea = diccionarioEstaciones.values.filter { $0.linea.lowercased() == lineaBuscada.lowercased() }
    
    if estacionesLinea.isEmpty {
        print("No se encontraron estaciones para esta línea.")
        return
    }
    
    for estacion in estacionesLinea.sorted(by: { $0.nombre < $1.nombre }) {
        print("- \(estacion.nombre) [\(estacion.operativa ? "Operativa" : "En obras")]")
    }
}

// ==========================================
// 5. INTERFAZ DE CONSOLA
// ==========================================
cargarTodaLaRed()
var salir = false

while !salir {
    print("""
    
    === SISTEMA DE METRO LIMA ===
    1. Buscar una estación
    2. Consultar cómo llegar a un destino
    3. Ver estaciones por línea
    4. Salir
    Elige una opción: 
    """, terminator: "")
    
    if let opcion = readLine() {
        switch opcion {
        case "1":
            print("Ingresa el nombre de la estación: ", terminator: "")
            if let nombre = readLine() { buscarEstacion(nombre: nombre) }
        case "2":
            print("Ingresa tu destino: ", terminator: "")
            if let destino = readLine() { consultarDestino(lugar: destino) }
        case "3":
            print("Ingresa la línea: ", terminator: "")
            if let linea = readLine() { listarPorLinea(lineaBuscada: linea) }
        case "4":
            salir = true
        default:
            print("Opción inválida.")
        }
    }
}