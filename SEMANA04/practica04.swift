import Foundation

// ==========================================
// 0. EXTENSIÓN DE UTILIDAD
// ==========================================
extension String {
    var normalizado: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
                   .lowercased()
                   .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// ==========================================
// 1. ESTRUCTURAS DE DATOS
// ==========================================
enum EstadoLinea: String {
    case enOperacion = "En operación"
    case enConstruccion = "En construcción"
    case enProyecto = "En proyecto"
}

struct Conexion {
    var lineaDestino: String
    var estacionDestino: String
    var detalle: String
}

struct Estacion {
    var clave: String
    var nombre: String
    var linea: String
    var estado: EstadoLinea
    var tieneAscensor: Bool
    var conexiones: [Conexion]
    var advertencia: String
}

struct Linea {
    var nombre: String
    var color: String
    var estadoGeneral: EstadoLinea
    var estaciones: [String] // Lista en orden geográfico real
}

// ==========================================
// 2. BASE DE DATOS GLOBAL
// ==========================================
var diccionarioEstaciones: [String: Estacion] = [:]
var redLineas: [String: Linea] = [:]
var destinosPopulares: [String: String] = [:]

// ==========================================
// 3. CARGA COMPLETA (METRO LIMA SVG + METROPOLITANO)
// ==========================================
func cargarTodaLaRed() {
    diccionarioEstaciones.removeAll()
    redLineas.removeAll()
    destinosPopulares.removeAll()

    // ------------------------------------------
    // LÍNEA 1 (VERDE) - Operativa (Bayóvar <-> Villa El Salvador)
    // ------------------------------------------
    let l1Secuencia = [
        "Bayóvar", "Santa Rosa", "San Martín", "San Carlos", "Los Postes",
        "Los Jardines", "Pirámide del Sol", "Caja de Agua", "Presbítero Maestro",
        "El Ángel", "Miguel Grau", "Gamarra", "Arriola", "La Cultura",
        "San Borja Sur", "Angamos", "Cabitos", "Ayacucho", "Jorge Chávez",
        "Atocongo", "San Juan", "María Auxiliadora", "Villa María",
        "Pumacahua", "Parque Industrial", "Villa El Salvador"
    ]

    for nombre in l1Secuencia {
        var info = "Línea en operación continua."
        if nombre == "Miguel Grau" {
            info = "Punto de conexión cercano con el centro histórico y futura L2."
        }
        
        diccionarioEstaciones[nombre] = Estacion(
            clave: nombre,
            nombre: nombre,
            linea: "Línea 1",
            estado: .enOperacion,
            tieneAscensor: true,
            conexiones: [],
            advertencia: info
        )
    }
    redLineas["Línea 1"] = Linea(nombre: "Línea 1", color: "Verde 🟢", estadoGeneral: .enOperacion, estaciones: l1Secuencia)

    // ------------------------------------------
    // LÍNEA 2 (AMARILLA) - Puerto del Callao <-> Municipalidad de Ate
    // ------------------------------------------
    let l2SecuenciaNombres = [
        "Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
        "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio",
        "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi",
        "Estación Central", "Manco Cápac", "Cangallo", "28 de Julio",
        "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento",
        "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán",
        "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado",
        "Municipalidad de Ate"
    ]

    let operativasL2 = ["Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán", "Mercado Santa Anita"]
    var l2Claves: [String] = []

    for nombre in l2SecuenciaNombres {
        let clave = "\(nombre) (L2)"
        l2Claves.append(clave)
        let estaEnServicio = operativasL2.contains(nombre)
        
        diccionarioEstaciones[clave] = Estacion(
            clave: clave,
            nombre: clave,
            linea: "Línea 2",
            estado: estaEnServicio ? .enOperacion : .enConstruccion,
            tieneAscensor: true,
            conexiones: [],
            advertencia: estaEnServicio ? "Tramo 1A en operación." : "Tramo subterráneo en construcción."
        )
    }
    redLineas["Línea 2"] = Linea(nombre: "Línea 2", color: "Amarillo 🟡", estadoGeneral: .enConstruccion, estaciones: l2Claves)

    // ------------------------------------------
    // LÍNEA 3 (CELESTE) - El Álamo <-> Pedro Miotta (Proyecto)
    // ------------------------------------------
    let l3SecuenciaNombres = [
        "El Álamo", "Huandoy", "2 de Octubre", "Villa Sol", "Naranjal (L3)",
        "Carlos Izaguirre", "Tomás Valle", "Bartolomé de las Casas", "José Granda",
        "Caquetá (L3)", "Tacna", "Garcilaso de la Vega", "Central (L3)",
        "Parque Universitario", "Alejandro Tirado", "Manzanilla", "Pardo de Zela",
        "Conde de Lemos", "Andrés Avelino Cáceres", "Angamos (L3)", "Benavides (L3)",
        "Cabitos (L3)", "Ayacucho (L3)", "Pedro Miotta"
    ]

    var l3Claves: [String] = []
    for nombre in l3SecuenciaNombres {
        let clave = nombre.contains("(L3)") ? nombre : "\(nombre) (L3)"
        l3Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(
            clave: clave,
            nombre: clave,
            linea: "Línea 3",
            estado: .enProyecto,
            tieneAscensor: true,
            conexiones: [],
            advertencia: "Línea proyectada subterránea Norte-Sur."
        )
    }
    redLineas["Línea 3"] = Linea(nombre: "Línea 3", color: "Celeste 🔵", estadoGeneral: .enProyecto, estaciones: l3Claves)

    // ------------------------------------------
    // LÍNEA 4 (ROJA) - Gambetta <-> Mercado Santa Anita (Obras / Proyecto)
    // ------------------------------------------
    let l4SecuenciaNombres = [
        "Gambetta", "Canta Callao", "Bocanegra", "El Olivar", "Quilca",
        "Morales Duárez", "Carmen de la Legua (L4)", "Óscar R. Benavides (L4)",
        "Venezuela", "Arica", "Salaverry", "Canevaro", "Arriola (L4)",
        "La Cultura (L4)", "Canadá", "Circunvalación (L4)", "Los Frutales",
        "La Molina", "Santa Patricia", "Mercado Santa Anita (L4)"
    ]

    var l4Claves: [String] = []
    for nombre in l4SecuenciaNombres {
        let clave = nombre.contains("(L4)") ? nombre : "\(nombre) (L4)"
        l4Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(
            clave: clave,
            nombre: clave,
            linea: "Línea 4",
            estado: .enConstruccion,
            tieneAscensor: true,
            conexiones: [],
            advertencia: "Ramal Faucett en obras de construcción."
        )
    }
    redLineas["Línea 4"] = Linea(nombre: "Línea 4", color: "Rojo 🔴", estadoGeneral: .enConstruccion, estaciones: l4Claves)

    // ------------------------------------------
    // METROPOLITANO (GRIS / BRT) - Naranjal <-> Matellini
    // ------------------------------------------
    let metSecuenciaNombres = [
        "Terminal Naranjal", "Izaguirre (MET)", "Pacífico (MET)", "UNI (MET)",
        "Caquetá (MET)", "España (MET)", "Central (MET)", "Estadio Nacional (MET)",
        "Javier Prado (MET)", "Canaval y Moreyra (MET)", "Angamos (MET)",
        "Benavides (MET)", "Terminal Matellini"
    ]

    var metClaves: [String] = []
    for nombre in metSecuenciaNombres {
        metClaves.append(nombre)
        diccionarioEstaciones[nombre] = Estacion(
            clave: nombre,
            nombre: nombre,
            linea: "Metropolitano",
            estado: .enOperacion,
            tieneAscensor: true,
            conexiones: [],
            advertencia: "Sistema BRT de buses en vía exclusiva."
        )
    }
    redLineas["Metropolitano"] = Linea(nombre: "Metropolitano", color: "Gris ⚪", estadoGeneral: .enOperacion, estaciones: metClaves)

    // ------------------------------------------
    // REGISTRO DE TRANSBORDOS E INTERCONEXIONES
    // ------------------------------------------
    // Estación Central (Hub L2, L3 y Metropolitano)
    diccionarioEstaciones["Estación Central (L2)"]?.conexiones.append(
        Conexion(lineaDestino: "Metropolitano", estacionDestino: "Central (MET)", detalle: "Túnel peatonal subterráneo directismo")
    )
    diccionarioEstaciones["Central (MET)"]?.conexiones.append(
        Conexion(lineaDestino: "Línea 2", estacionDestino: "Estación Central (L2)", detalle: "Interconexión L2 ↔ Metropolitano")
    )
    
    // Intersección L1 - L2 (28 de Julio / Grau)
    diccionarioEstaciones["28 de Julio (L2)"]?.conexiones.append(
        Conexion(lineaDestino: "Línea 1", estacionDestino: "Miguel Grau", detalle: "Futura estación de transbordo L1 ↔ L2")
    )
    
    // Intersección L1 - L4 (La Cultura)
    diccionarioEstaciones["La Cultura"]?.conexiones.append(
        Conexion(lineaDestino: "Línea 4", estacionDestino: "La Cultura (L4)", detalle: "Transbordo L1 ↔ L4 (Av. Javier Prado)")
    )
    
    // Intersección L2 - L4 (Carmen de la Legua)
    diccionarioEstaciones["Carmen de la Legua (L2)"]?.conexiones.append(
        Conexion(lineaDestino: "Línea 4", estacionDestino: "Carmen de la Legua (L4)", detalle: "Intercambio L2 ↔ L4")
    )

    // ------------------------------------------
    // DESTINOS POPULARES Y ALIAS
    // ------------------------------------------
    destinosPopulares["bayobar".normalizado] = "Bayóvar"
    destinosPopulares["bayovar".normalizado] = "Bayóvar"
    destinosPopulares["callao".normalizado] = "Puerto del Callao (L2)"
    destinosPopulares["ate".normalizado] = "Municipalidad de Ate (L2)"
    destinosPopulares["gamarra".normalizado] = "Gamarra"
    destinosPopulares["santa anita".normalizado] = "Óvalo Santa Anita (L2)"
    destinosPopulares["aeropuerto".normalizado] = "El Olivar (L4)"
    destinosPopulares["estadio nacional".normalizado] = "Estadio Nacional (MET)"
    destinosPopulares["centro de lima".normalizado] = "Central (MET)"
    destinosPopulares["naranjal".normalizado] = "Terminal Naranjal"
    destinosPopulares["matellini".normalizado] = "Terminal Matellini"
}

// ==========================================
// 4. LÓGICA DE BÚSQUEDA Y NAVEGACIÓN
// ==========================================
func obtenerVecinos(estacion: Estacion) -> (anterior: String?, siguiente: String?) {
    guard let lineaObj = redLineas[estacion.linea],
          let idx = lineaObj.estaciones.firstIndex(of: estacion.clave) else {
        return (nil, nil)
    }
    
    let anterior = idx > 0 ? lineaObj.estaciones[idx - 1] : nil
    let siguiente = idx < lineaObj.estaciones.count - 1 ? lineaObj.estaciones[idx + 1] : nil
    
    return (anterior, siguiente)
}

func imprimirDetalleEstacion(_ estacion: Estacion) {
    print("\n========================================")
    print("🚇 ESTACIÓN: \(estacion.nombre)")
    print("📍 Línea: \(estacion.linea)")
    print("🚦 Estado: \(estacion.estado.rawValue)")
    print("🛗 Ascensor: \(estacion.tieneAscensor ? "Sí" : "No")")
    print("⚠️ Información: \(estacion.advertencia)")
    
    let (anterior, siguiente) = obtenerVecinos(estacion: estacion)
    print("↔️ ESTACIONES ADYACENTES (RECORRIDO):")
    print("   ⬅️ Anterior: \(anterior ?? "Terminal de inicio")")
    print("   ➡️ Siguiente: \(siguiente ?? "Terminal de fin")")
    
    if !estacion.conexiones.isEmpty {
        print("🔗 TRANSBORDOS DISPONIBLES:")
        for conexion in estacion.conexiones {
            print("   - Conecta con \(conexion.lineaDestino) en '\(conexion.estacionDestino)' [\(conexion.detalle)]")
        }
    }
    print("========================================")
}

func buscarEstacion(nombre: String) {
    let busqueda = nombre.normalizado
    if busqueda.isEmpty {
        print("\n⚠️ Por favor, ingresa un término de búsqueda.")
        return
    }
    
    let resultados = diccionarioEstaciones.filter { $0.key.normalizado.contains(busqueda) }
    if resultados.isEmpty {
        print("\n❌ No se encontró ninguna estación con '\(nombre)'.")
        return
    }
    
    for (_, estacion) in resultados {
        imprimirDetalleEstacion(estacion)
    }
}

func consultarDestino(lugar: String) {
    let lugarLimpio = lugar.normalizado
    if lugarLimpio.isEmpty {
        print("\n⚠️ Por favor, ingresa un destino.")
        return
    }
    
    if let claveEstacion = destinosPopulares[lugarLimpio], let est = diccionarioEstaciones[claveEstacion] {
        print("\n🎯 Para ir a '\(lugar.trimmingCharacters(in: .whitespacesAndNewlines))', dirígete a:")
        imprimirDetalleEstacion(est)
        return
    }
    
    let coincidencias = diccionarioEstaciones.filter { $0.key.normalizado.contains(lugarLimpio) }
    if !coincidencias.isEmpty {
        print("\n🎯 Coincidencias encontradas para tu destino:")
        for (_, estacion) in coincidencias {
            imprimirDetalleEstacion(estacion)
        }
        return
    }
    
    print("\n❌ Destino o estación '\(lugar.trimmingCharacters(in: .whitespacesAndNewlines))' no registrado.")
}

func listarPorLinea(lineaBuscada: String) {
    var busq = lineaBuscada.normalizado
    if busq.isEmpty {
        print("\n⚠️ Entrada vacía.")
        return
    }
    
    if busq == "1" || busq == "l1" { busq = "linea 1" }
    if busq == "2" || busq == "l2" { busq = "linea 2" }
    if busq == "3" || busq == "l3" { busq = "linea 3" }
    if busq == "4" || busq == "l4" { busq = "linea 4" }
    if busq == "met" { busq = "metropolitano" }
    
    guard let claveLinea = redLineas.keys.first(where: { $0.normalizado.contains(busq) }),
          let lineaObj = redLineas[claveLinea] else {
        print("\n❌ No se encontró la línea '\(lineaBuscada.trimmingCharacters(in: .whitespacesAndNewlines))'.")
        return
    }
    
    print("\n📋 LÍNEA SELECCIONADA: \(lineaObj.nombre) (\(lineaObj.color))")
    print("   Estado Global: \(lineaObj.estadoGeneral.rawValue)")
    print("1. Ver en Orden de Recorrido Real (Terminal a Terminal)")
    print("2. Ver en Orden Alfabético (A-Z)")
    print("Elige una opción de orden [1/2]: ", terminator: "")
    
    let modo = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "1"
    print("\n--- ESTACIONES DE \(lineaObj.nombre.uppercased()) ---")
    
    if modo == "2" {
        let ordenadas = lineaObj.estaciones.sorted { $0 < $1 }
        for clave in ordenadas {
            if let est = diccionarioEstaciones[clave] {
                print("- \(est.nombre) [\(est.estado.rawValue)]")
            }
        }
    } else {
        for (idx, clave) in lineaObj.estaciones.enumerated() {
            if let est = diccionarioEstaciones[clave] {
                var etiqueta = ""
                if idx == 0 { etiqueta = " 🟢 [Terminal Inicio]" }
                else if idx == lineaObj.estaciones.count - 1 { etiqueta = " 🔴 [Terminal Fin]" }
                
                print("\(idx + 1). \(est.nombre) [\(est.estado.rawValue)]\(etiqueta)")
            }
        }
    }
}

// ==========================================
// 5. MENÚ INTERACTIVO BASE
// ==========================================
cargarTodaLaRed()
var salir = false

while !salir {
    print("""
    
    === SISTEMA DE METRO Y METROPOLITANO LIMA (CÓDIGO BASE) ===
    1. Buscar una estación
    2. Consultar cómo llegar a un destino
    3. Ver estaciones por línea (Ruta real o A-Z)
    4. Salir
    Elige una opción: 
    """, terminator: "")
    
    if let input = readLine() {
        let opcion = input.trimmingCharacters(in: .whitespacesAndNewlines)
        switch opcion {
        case "1":
            print("Ingresa el nombre de la estación: ", terminator: "")
            if let nombre = readLine() { buscarEstacion(nombre: nombre) }
        case "2":
            print("Ingresa tu destino: ", terminator: "")
            if let destino = readLine() { consultarDestino(lugar: destino) }
        case "3":
            print("Ingresa la línea (1, 2, 3, 4, Metropolitano): ", terminator: "")
            if let linea = readLine() { listarPorLinea(lineaBuscada: linea) }
        case "4":
            salir = true
            print("\n👋 ¡Gracias por usar el Sistema de Transporte de Lima!")
        default:
            print("\n❌ Opción inválida.")
        }
    }
}
