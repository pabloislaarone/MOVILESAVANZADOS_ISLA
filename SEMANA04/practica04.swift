import Foundation

// ==========================================
// 0. EXTENSIÓN DE UTILIDAD CON LIMPIEZA DE SÍMBOLOS
// ==========================================
extension String {
    var normalizado: String {
        let soloAlfanumerico = self.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) || $0 == " " }
        return String(soloAlfanumerico)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// ==========================================
// 1. ESTRUCTURAS DE DATOS Y BILLETERA
// ==========================================
enum EstadoLinea: String {
    case enOperacion = "En operación"
    case enConstruccion = "En construcción"
    case enProyecto = "En proyecto"
}

struct Estacion {
    var clave: String
    var nombre: String
    var linea: String
    var estado: EstadoLinea
    var tieneAscensor: Bool
    var conexionesDirectas: [String]
    var advertencia: String
}

struct Linea {
    var nombre: String
    var color: String
    var tarifa: Double
    var tarjetaRequerida: String
    var estaciones: [String]
}

struct BilleteraTarjetas {
    var saldoLinea1: Double = 10.0
    var saldoLinea2: Double = 10.0
    var saldoMetropolitano: Double = 10.0
    var efectivo: Double = 20.0
    
    mutating func recargar(sistema: String, monto: Double) {
        guard monto > 0 else { return }
        switch sistema {
        case "1":
            saldoLinea1 += monto
            print("✅ Recarga exitosa. Saldo Tarjeta Línea 1: S/.\(String(format: "%.2f", saldoLinea1))")
        case "2":
            saldoLinea2 += monto
            print("✅ Recarga exitosa. Saldo Tarjeta Línea 2 / TIT: S/.\(String(format: "%.2f", saldoLinea2))")
        case "3":
            saldoMetropolitano += monto
            print("✅ Recarga exitosa. Saldo Tarjeta Metropolitano: S/.\(String(format: "%.2f", saldoMetropolitano))")
        default:
            print("❌ Opción no válida.")
        }
    }
}

// ==========================================
// 2. BASE DE DATOS GLOBAL
// ==========================================
var diccionarioEstaciones: [String: Estacion] = [:]
var redLineas: [String: Linea] = [:]
var destinosPopulares: [String: String] = [:]
var billetera = BilleteraTarjetas()

// ==========================================
// 3. CARGA COMPLETA DE LA RED
// ==========================================
func cargarTodaLaRed() {
    diccionarioEstaciones.removeAll()
    redLineas.removeAll()
    destinosPopulares.removeAll()

    // LÍNEA 1 (OPERATIVA)
    let l1Secuencia = ["Bayóvar", "Santa Rosa", "San Martín", "San Carlos", "Los Postes", "Los Jardines", "Pirámide del Sol", "Caja de Agua", "Presbítero Maestro", "El Ángel", "Miguel Grau", "Gamarra", "Arriola", "La Cultura", "San Borja Sur", "Angamos", "Cabitos", "Ayacucho", "Jorge Chávez", "Atocongo", "San Juan", "María Auxiliadora", "Villa María", "Pumacahua", "Parque Industrial", "Villa El Salvador"]
    for nombre in l1Secuencia {
        diccionarioEstaciones[nombre] = Estacion(clave: nombre, nombre: nombre, linea: "Línea 1", estado: .enOperacion, tieneAscensor: true, conexionesDirectas: [], advertencia: "Línea de tren elevado en operación.")
    }
    redLineas["Línea 1"] = Linea(nombre: "Línea 1", color: "Verde 🟢", tarifa: 1.50, tarjetaRequerida: "Tarjeta Línea 1", estaciones: l1Secuencia)

    // LÍNEA 2 (PARCIALMENTE OPERATIVA - TRAMO 1A)
    let l2SecuenciaNombres = ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes", "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio", "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi", "Estación Central", "Manco Cápac", "Cangallo", "28 de Julio", "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán", "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado", "Municipalidad de Ate"]
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
            conexionesDirectas: [],
            advertencia: estaEnServicio ? "Tramo 1A en servicio." : "⚠️ Estación en construcción (Sin servicio)."
        )
    }
    redLineas["Línea 2"] = Linea(nombre: "Línea 2", color: "Amarillo 🟡", tarifa: 1.40, tarjetaRequerida: "Tarjeta Línea 2 / TIT", estaciones: l2Claves)

    // LÍNEA 3 Y LÍNEA 4 (PROYECTOS / EN CONSTRUCCIÓN)
    let l3SecuenciaNombres = ["El Álamo", "Naranjal (L3)", "Caquetá (L3)", "Central (L3)", "Angamos (L3)", "Pedro Miotta"]
    var l3Claves: [String] = []
    for nombre in l3SecuenciaNombres {
        let clave = "\(nombre) (L3)"
        l3Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(clave: clave, nombre: clave, linea: "Línea 3", estado: .enProyecto, tieneAscensor: true, conexionesDirectas: [], advertencia: "Línea en proyecto.")
    }
    redLineas["Línea 3"] = Linea(nombre: "Línea 3", color: "Celeste 🔵", tarifa: 1.50, tarjetaRequerida: "TIT", estaciones: l3Claves)

    let l4SecuenciaNombres = ["Gambetta", "El Olivar", "Carmen de la Legua (L4)", "La Cultura (L4)", "Mercado Santa Anita (L4)"]
    var l4Claves: [String] = []
    for nombre in l4SecuenciaNombres {
        let clave = "\(nombre) (L4)"
        l4Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(clave: clave, nombre: clave, linea: "Línea 4", estado: .enConstruccion, tieneAscensor: true, conexionesDirectas: [], advertencia: "En obras.")
    }
    redLineas["Línea 4"] = Linea(nombre: "Línea 4", color: "Rojo 🔴", tarifa: 1.50, tarjetaRequerida: "TIT", estaciones: l4Claves)

    // METROPOLITANO (OPERATIVO)
    let metSecuenciaNombres = ["Terminal Naranjal", "Izaguirre (MET)", "UNI (MET)", "Caquetá (MET)", "Central (MET)", "Estadio Nacional (MET)", "Javier Prado (MET)", "Angamos (MET)", "Terminal Matellini"]
    var metClaves: [String] = []
    for nombre in metSecuenciaNombres {
        metClaves.append(nombre)
        diccionarioEstaciones[nombre] = Estacion(clave: nombre, nombre: nombre, linea: "Metropolitano", estado: .enOperacion, tieneAscensor: true, conexionesDirectas: [], advertencia: "Buses BRT operativos.")
    }
    redLineas["Metropolitano"] = Linea(nombre: "Metropolitano", color: "Gris ⚪", tarifa: 3.20, tarjetaRequerida: "Tarjeta Metropolitano / Lima Pass", estaciones: metClaves)

    // LÍNEAS DE ENLACE DE SUPERFICIE
    redLineas["Bus Urbano (Evitamiento)"] = Linea(nombre: "Bus Urbano (Evitamiento)", color: "Naranja 🟠", tarifa: 2.00, tarjetaRequerida: "Efectivo / Pasaje Urbano", estaciones: ["Bus Evitamiento / Av. Grau"])
    redLineas["Corredor Rojo / Bus"] = Linea(nombre: "Corredor Rojo / Bus", color: "Rojo 🔴", tarifa: 2.35, tarjetaRequerida: "Lima Pass / Efectivo", estaciones: ["Bus Javier Prado"])

    // NODOS DE ENLACE REAL DE SUPERFICIE
    diccionarioEstaciones["Bus Evitamiento / Av. Grau"] = Estacion(
        clave: "Bus Evitamiento / Av. Grau",
        nombre: "Bus Urbano (Enlace Evitamiento ↔ L1)",
        linea: "Bus Urbano (Evitamiento)",
        estado: .enOperacion,
        tieneAscensor: false,
        conexionesDirectas: ["Evitamiento (L2)", "El Ángel"],
        advertencia: "Traslado en bus de servicio público por Vía Evitamiento."
    )
    
    diccionarioEstaciones["Bus Javier Prado"] = Estacion(
        clave: "Bus Javier Prado",
        nombre: "Corredor Rojo (Enlace L1 ↔ Metropolitano)",
        linea: "Corredor Rojo / Bus",
        estado: .enOperacion,
        tieneAscensor: false,
        conexionesDirectas: ["La Cultura", "Javier Prado (MET)"],
        advertencia: "Traslado en bus por Av. Javier Prado."
    )

    diccionarioEstaciones["Evitamiento (L2)"]?.conexionesDirectas.append("Bus Evitamiento / Av. Grau")
    diccionarioEstaciones["El Ángel"]?.conexionesDirectas.append("Bus Evitamiento / Av. Grau")
    diccionarioEstaciones["La Cultura"]?.conexionesDirectas.append("Bus Javier Prado")
    diccionarioEstaciones["Javier Prado (MET)"]?.conexionesDirectas.append("Bus Javier Prado")

    // ALIAS POPULARES
    destinosPopulares["bayobar".normalizado] = "Bayóvar"
    destinosPopulares["evitamiento".normalizado] = "Evitamiento (L2)"
    destinosPopulares["gamarra".normalizado] = "Gamarra"
    destinosPopulares["naranjal".normalizado] = "Terminal Naranjal"
    destinosPopulares["matellini".normalizado] = "Terminal Matellini"
}

// ==========================================
// 4. LÓGICA DE NAVEGACIÓN Y FILTRADO REALISTA
// ==========================================
func obtenerVecinosTren(estacion: Estacion) -> [String] {
    guard let lineaObj = redLineas[estacion.linea],
          let idx = lineaObj.estaciones.firstIndex(of: estacion.clave) else { return [] }
    var vecinos: [String] = []
    if idx > 0 { vecinos.append(lineaObj.estaciones[idx - 1]) }
    if idx < lineaObj.estaciones.count - 1 { vecinos.append(lineaObj.estaciones[idx + 1]) }
    return vecinos
}

func construirGrafoAdyacencia() -> [String: [String]] {
    var grafo: [String: [String]] = [:]
    for (clave, est) in diccionarioEstaciones {
        guard est.estado == .enOperacion else { continue }
        
        var vecinos: [String] = []
        for v in obtenerVecinosTren(estacion: est) {
            if let estV = diccionarioEstaciones[v], estV.estado == .enOperacion {
                vecinos.append(v)
            }
        }
        for c in est.conexionesDirectas {
            if let estC = diccionarioEstaciones[c], estC.estado == .enOperacion {
                vecinos.append(c)
            }
        }
        grafo[clave] = vecinos
    }
    return grafo
}

func calcularRutaBFS(origen: String, destino: String) -> [String]? {
    let grafo = construirGrafoAdyacencia()
    guard grafo[origen] != nil, grafo[destino] != nil else { return nil }
    
    var visitados: Set<String> = [origen]
    var cola: [String] = [origen]
    var padre: [String: String] = [:]
    
    while !cola.isEmpty {
        let actual = cola.removeFirst()
        if actual == destino {
            var ruta: [String] = []
            var paso: String? = destino
            while let p = paso {
                ruta.append(p)
                paso = padre[p]
            }
            return ruta.reversed()
        }
        
        if let vecinos = grafo[actual] {
            for vecino in vecinos {
                if !visitados.contains(vecino) {
                    visitados.insert(vecino)
                    padre[vecino] = actual
                    cola.append(vecino)
                }
            }
        }
    }
    return nil
}

func resolverClaveEstacion(entrada: String) -> String? {
    let limpia = entrada.normalizado
    if let alias = destinosPopulares[limpia] { return alias }
    return diccionarioEstaciones.keys.first { $0.normalizado == limpia || $0.normalizado.contains(limpia) }
}

// ==========================================
// 5. FUNCIONES DEL MENÚ
// ==========================================
func buscarEstacion(nombre: String) {
    let busqueda = nombre.normalizado
    let resultados = diccionarioEstaciones.filter { $0.key.normalizado.contains(busqueda) }
    if resultados.isEmpty {
        print("\n❌ No se encontró ninguna estación con '\(nombre)'.")
        return
    }
    for (_, est) in resultados {
        let vecinos = obtenerVecinosTren(estacion: est)
        print("\n========================================")
        print("🚇 ESTACIÓN: \(est.nombre) | Línea: \(est.linea)")
        print("🚦 Estado: \(est.estado.rawValue)")
        print("🛗 Ascensor: \(est.tieneAscensor ? "Sí" : "No")")
        print("⚠️ Info: \(est.advertencia)")
        print("⬅️ Anterior: \(vecinos.first ?? "Terminal") | ➡️ Siguiente: \(vecinos.last ?? "Terminal")")
        print("========================================")
    }
}

func planificarYEjecutarViaje() {
    print("\n🗺️ --- PLANIFICADOR DE VIAJE REALISTA ---")
    print("Ingrese origen: ", terminator: "")
    guard let inOrigen = readLine(), let origenClave = resolverClaveEstacion(entrada: inOrigen) else {
        print("❌ Origen no encontrado.")
        return
    }
    
    print("Ingrese destino: ", terminator: "")
    guard let inDestino = readLine(), let destinoClave = resolverClaveEstacion(entrada: inDestino) else {
        print("❌ Destino no encontrado.")
        return
    }
    
    if origenClave == destinoClave {
        print("⚠️ Ya te encuentras en el destino.")
        return
    }
    
    guard let ruta = calcularRutaBFS(origen: origenClave, destino: destinoClave) else {
        print("\n❌ No existe un camino habilitado en transporte público operativo entre estas estaciones.")
        return
    }
    
    print("\n🧩 RUTA CALCULADA (\(ruta.count - 1) tramos en servicio):")
    var lineasUsadas: [String] = []
    var lineaActual = ""
    
    for (index, clave) in ruta.enumerated() {
        if let est = diccionarioEstaciones[clave] {
            if est.linea != lineaActual {
                if !lineasUsadas.contains(est.linea) { lineasUsadas.append(est.linea) }
                if index > 0 {
                    print("\n   🚌 [TRANSBORDO] Cambiar a: \(est.linea)")
                }
                lineaActual = est.linea
            }
            print("   \(index + 1). \(est.nombre) (\(est.linea)) - [\(est.estado.rawValue)]")
        }
    }
    
    print("\n💵 --- DESGLOSE DE PASAJES Y MEDIOS DE PAGO ---")
    var costoTotal: Double = 0.0
    for nombreLinea in lineasUsadas {
        if let infoLinea = redLineas[nombreLinea] {
            costoTotal += infoLinea.tarifa
            print("• \(infoLinea.nombre): S/.\(String(format: "%.2f", infoLinea.tarifa)) -> Pago con: [\(infoLinea.tarjetaRequerida)]")
        }
    }
    
    print("----------------------------------------")
    print("💰 GASTO TOTAL DEL VIAJE: S/.\(String(format: "%.2f", costoTotal))")
    print("----------------------------------------")
    
    print("\n💳 TU DISPONIBILIDAD:")
    print("1. Tarjeta Línea 1: S/.\(String(format: "%.2f", billetera.saldoLinea1))")
    print("2. Tarjeta Línea 2 / TIT: S/.\(String(format: "%.2f", billetera.saldoLinea2))")
    print("3. Tarjeta Metropolitano: S/.\(String(format: "%.2f", billetera.saldoMetropolitano))")
    print("4. Efectivo en mano: S/.\(String(format: "%.2f", billetera.efectivo))")
    
    print("\n¿Desea realizar el viaje y descontar los saldos? [S/N]: ", terminator: "")
    let confirm = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
    
    if confirm == "s" || confirm == "si" {
        if lineasUsadas.contains("Línea 1") { billetera.saldoLinea1 -= 1.50 }
        if lineasUsadas.contains("Línea 2") { billetera.saldoLinea2 -= 1.40 }
        if lineasUsadas.contains("Metropolitano") { billetera.saldoMetropolitano -= 3.20 }
        if lineasUsadas.contains("Bus Urbano (Evitamiento)") { billetera.efectivo -= 2.00 }
        print("✅ Pasajes cobrados de tus tarjetas/efectivo. ¡Buen viaje!")
    }
}

func listarPorLinea(lineaBuscada: String) {
    var busq = lineaBuscada.normalizado
    if busq == "1" { busq = "linea 1" }
    if busq == "2" { busq = "linea 2" }
    if busq == "3" { busq = "linea 3" }
    if busq == "4" { busq = "linea 4" }
    if busq == "met" { busq = "metropolitano" }
    
    guard let claveLinea = redLineas.keys.first(where: { $0.normalizado.contains(busq) }),
          let lineaObj = redLineas[claveLinea] else {
        print("\n❌ Línea no encontrada.")
        return
    }
    
    print("\n📋 LÍNEA: \(lineaObj.nombre) (\(lineaObj.color)) | Tarifa: S/.\(String(format: "%.2f", lineaObj.tarifa))")
    for (idx, clave) in lineaObj.estaciones.enumerated() {
        if let est = diccionarioEstaciones[clave] {
            print("\(idx + 1). \(est.nombre) [\(est.estado.rawValue)]")
        }
    }
}

func gestionarTarjetasMenu() {
    print("\n💳 --- BILLETERA Y TARJETAS DE TRANSPORTE ---")
    print("1. Consultar saldos")
    print("2. Recargar tarjeta")
    print("Elige una opción [1/2]: ", terminator: "")
    
    let op = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if op == "1" {
        print("\n💰 SALDOS ACTUALES:")
        print("• Tarjeta Línea 1: S/.\(String(format: "%.2f", billetera.saldoLinea1))")
        print("• Tarjeta Línea 2 / TIT: S/.\(String(format: "%.2f", billetera.saldoLinea2))")
        print("• Tarjeta Metropolitano: S/.\(String(format: "%.2f", billetera.saldoMetropolitano))")
        print("• Efectivo en mano: S/.\(String(format: "%.2f", billetera.efectivo))")
    } else if op == "2" {
        print("\n¿Qué tarjeta deseas recargar?")
        print("1. Tarjeta Línea 1")
        print("2. Tarjeta Línea 2 / TIT")
        print("3. Tarjeta Metropolitano")
        print("Selecciona [1-3]: ", terminator: "")
        let tSelec = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        print("Ingresa el monto a recargar (S/.): ", terminator: "")
        if let input = readLine(), let monto = Double(input) {
            billetera.recargar(sistema: tSelec, monto: monto)
        } else {
            print("❌ Monto inválido.")
        }
    }
}

// ==========================================
// 6. MENÚ PRINCIPAL INTERACTIVO
// ==========================================
cargarTodaLaRed()
var salir = false

while !salir {
    print("""
    
    === METRO Y TRANSPORTE DE LIMA ===
    1. Buscar una estación
    2. Planificar viaje (Calculador de ruta óptima)
    3. Ver estaciones por línea
    4. Gestión de Billetera / Tarjetas
    5. Salir
    Elige una opción: 
    """, terminator: "")
    
    if let input = readLine() {
        let opcion = input.trimmingCharacters(in: .whitespacesAndNewlines)
        switch opcion {
        case "1":
            print("Nombre de estación: ", terminator: "")
            if let n = readLine() { buscarEstacion(nombre: n) }
        case "2":
            planificarYEjecutarViaje()
        case "3":
            print("Ingresa línea (1, 2, 3, 4, Metropolitano): ", terminator: "")
            if let l = readLine() { listarPorLinea(lineaBuscada: l) }
        case "4":
            gestionarTarjetasMenu()
        case "5":
            salir = true
            print("\n👋 ¡Gracias por usar el sistema!")
        default:
            print("\n❌ Opción inválida.")
        }
    }
}
