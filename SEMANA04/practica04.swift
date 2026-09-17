import Foundation

// ==========================================
// 1. EXTENSIÓN Y ESTRUCTURAS PRINCIPALES
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
    var lugaresCercanos: [String]
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
// 2. BASE DE DATOS GLOBAL Y CARGA DE LA RED
// ==========================================

var diccionarioEstaciones: [String: Estacion] = [:]
var redLineas: [String: Linea] = [:]
var destinosPopulares: [String: String] = [:]
var billetera = BilleteraTarjetas()

func cargarTodaLaRed() {
    diccionarioEstaciones.removeAll()
    redLineas.removeAll()
    destinosPopulares.removeAll()

    // --- LÍNEA 1 (OPERATIVA) ---
    let l1Secuencia = ["Bayóvar", "Santa Rosa", "San Martín", "San Carlos", "Los Postes", "Los Jardines", "Pirámide del Sol", "Caja de Agua", "Presbítero Maestro", "El Ángel", "Miguel Grau", "Gamarra", "Arriola", "La Cultura", "San Borja Sur", "Angamos", "Cabitos", "Ayacucho", "Jorge Chávez", "Atocongo", "San Juan", "María Auxiliadora", "Villa María", "Pumacahua", "Parque Industrial", "Villa El Salvador"]
    for nombre in l1Secuencia {
        diccionarioEstaciones[nombre] = Estacion(
            clave: nombre,
            nombre: nombre,
            linea: "Línea 1",
            estado: .enOperacion,
            tieneAscensor: true,
            conexionesDirectas: [],
            lugaresCercanos: [],
            advertencia: "Línea de tren elevado en operación."
        )
    }
    redLineas["Línea 1"] = Linea(nombre: "Línea 1", color: "Verde 🟢", tarifa: 1.50, tarjetaRequerida: "Tarjeta Línea 1", estaciones: l1Secuencia)

    // --- LÍNEA 2 (TRAMO 1A OPERATIVO) ---
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
            lugaresCercanos: [],
            advertencia: estaEnServicio ? "Tramo 1A en servicio." : "⚠️ Estación en construcción (Sin servicio)."
        )
    }
    redLineas["Línea 2"] = Linea(nombre: "Línea 2", color: "Amarillo 🟡", tarifa: 1.40, tarjetaRequerida: "Tarjeta Línea 2 / TIT", estaciones: l2Claves)

    // --- LÍNEA 3 (EN PROYECTO) ---
    let l3SecuenciaNombres = ["El Álamo", "Naranjal (L3)", "Caquetá (L3)", "Central (L3)", "Angamos (L3)", "Pedro Miotta"]
    var l3Claves: [String] = []
    for nombre in l3SecuenciaNombres {
        let clave = "\(nombre) (L3)"
        l3Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(
            clave: clave,
            nombre: clave,
            linea: "Línea 3",
            estado: .enProyecto,
            tieneAscensor: true,
            conexionesDirectas: [],
            lugaresCercanos: [],
            advertencia: "Línea en proyecto futuro."
        )
    }
    redLineas["Línea 3"] = Linea(nombre: "Línea 3", color: "Celeste 🔵", tarifa: 1.50, tarjetaRequerida: "TIT", estaciones: l3Claves)

    // --- LÍNEA 4 (EN CONSTRUCCIÓN) ---
    let l4SecuenciaNombres = ["Gambetta", "El Olivar", "Carmen de la Legua (L4)", "La Cultura (L4)", "Mercado Santa Anita (L4)"]
    var l4Claves: [String] = []
    for nombre in l4SecuenciaNombres {
        let clave = "\(nombre) (L4)"
        l4Claves.append(clave)
        diccionarioEstaciones[clave] = Estacion(
            clave: clave,
            nombre: clave,
            linea: "Línea 4",
            estado: .enConstruccion,
            tieneAscensor: true,
            conexionesDirectas: [],
            lugaresCercanos: [],
            advertencia: "Línea en construcción."
        )
    }
    redLineas["Línea 4"] = Linea(nombre: "Línea 4", color: "Rojo 🔴", tarifa: 1.50, tarjetaRequerida: "TIT", estaciones: l4Claves)

    // --- METROPOLITANO (OPERATIVO) ---
    let metSecuenciaNombres = ["Terminal Naranjal", "Izaguirre (MET)", "UNI (MET)", "Caquetá (MET)", "Central (MET)", "Estadio Nacional (MET)", "Javier Prado (MET)", "Angamos (MET)", "Terminal Matellini"]
    redLineas["Metropolitano"] = Linea(nombre: "Metropolitano", color: "Gris ⚪", tarifa: 3.20, tarjetaRequerida: "Tarjeta Metropolitano / Lima Pass", estaciones: metSecuenciaNombres)
    for nombre in metSecuenciaNombres {
        diccionarioEstaciones[nombre] = Estacion(
            clave: nombre,
            nombre: nombre,
            linea: "Metropolitano",
            estado: .enOperacion,
            tieneAscensor: true,
            conexionesDirectas: [],
            lugaresCercanos: [],
            advertencia: "Buses BRT operativos."
        )
    }

    // --- ENLACES REALES DE SUPERFICIE ---
    redLineas["Bus Urbano (Evitamiento)"] = Linea(nombre: "Bus Urbano (Evitamiento)", color: "Naranja 🟠", tarifa: 2.00, tarjetaRequerida: "Efectivo", estaciones: ["Bus Evitamiento / Av. Grau"])
    redLineas["Corredor Rojo / Bus"] = Linea(nombre: "Corredor Rojo / Bus", color: "Rojo 🔴", tarifa: 2.35, tarjetaRequerida: "Lima Pass / Efectivo", estaciones: ["Bus Javier Prado"])

    diccionarioEstaciones["Bus Evitamiento / Av. Grau"] = Estacion(
        clave: "Bus Evitamiento / Av. Grau",
        nombre: "Bus Urbano (Enlace Evitamiento ↔ L1)",
        linea: "Bus Urbano (Evitamiento)",
        estado: .enOperacion,
        tieneAscensor: false,
        conexionesDirectas: ["Evitamiento (L2)", "El Ángel"],
        lugaresCercanos: [],
        advertencia: "Traslado en bus por Vía Evitamiento."
    )
    
    diccionarioEstaciones["Bus Javier Prado"] = Estacion(
        clave: "Bus Javier Prado",
        nombre: "Corredor Rojo (Enlace L1 ↔ Metropolitano)",
        linea: "Corredor Rojo / Bus",
        estado: .enOperacion,
        tieneAscensor: false,
        conexionesDirectas: ["La Cultura", "Javier Prado (MET)"],
        lugaresCercanos: [],
        advertencia: "Traslado en corredor por Av. Javier Prado."
    )

    // ENLACES NODALES
    let conexionesNodales = [
        ("Evitamiento (L2)", "Bus Evitamiento / Av. Grau"),
        ("El Ángel", "Bus Evitamiento / Av. Grau"),
        ("La Cultura", "Bus Javier Prado"),
        ("Javier Prado (MET)", "Bus Javier Prado")
    ]

    for (estacionKey, conexion) in conexionesNodales {
        if var est = diccionarioEstaciones[estacionKey] {
            est.conexionesDirectas.append(conexion)
            diccionarioEstaciones[estacionKey] = est
        }
    }

    // ALIAS DE BÚSQUEDA
    destinosPopulares["bayobar".normalizado] = "Bayóvar"
    destinosPopulares["evitamiento".normalizado] = "Evitamiento (L2)"
    destinosPopulares["gamarra".normalizado] = "Gamarra"
    destinosPopulares["naranjal".normalizado] = "Terminal Naranjal"
    destinosPopulares["matellini".normalizado] = "Terminal Matellini"
}
// ==========================================
// 3. LÓGICA DE RUTAS Y GRAFOS (BFS)
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
            if let estV = diccionarioEstaciones[v], estV.estado == .enOperacion { vecinos.append(v) }
        }
        for c in est.conexionesDirectas {
            if let estC = diccionarioEstaciones[c], estC.estado == .enOperacion { vecinos.append(c) }
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
// 4. FUNCIONES DEL USUARIO DE TRANSPORTE
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
        print("⬅️ Anterior: \(vecinos.first ?? "Cabecera") | ➡️ Siguiente: \(vecinos.last ?? "Terminal")")
        if !est.conexionesDirectas.isEmpty {
            print("🔄 Conexiones directas: \(est.conexionesDirectas.joined(separator: ", "))")
        }
        print("========================================")
    }
}

func planificarYEjecutarViaje() {
    print("\n🗺️ --- PLANIFICADOR DE VIAJE ---")
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
        print("\n❌ No existe ruta disponible en transporte operativo (Las estaciones en construcción o proyecto están inhabilitadas).")
        return
    }
    
    print("\n🧩 RUTA CALCULADA (\(ruta.count - 1) tramos):")
    var lineasUsadas: [String] = []
    var lineaActual = ""
    
    for (index, clave) in ruta.enumerated() {
        if let est = diccionarioEstaciones[clave] {
            if est.linea != lineaActual {
                if !lineasUsadas.contains(est.linea) { lineasUsadas.append(est.linea) }
                if index > 0 { print("\n 🚌 [TRANSBORDO] Cambiar a: \(est.linea)") }
                lineaActual = est.linea
            }
            print("   \(index + 1). \(est.nombre) (\(est.linea)) - [\(est.estado.rawValue)]")
        }
    }
    
    print("\n💵 --- DESGLOSE DE PASAJES ---")
    var costoTotal: Double = 0.0
    for nombreLinea in lineasUsadas {
        if let infoLinea = redLineas[nombreLinea] {
            costoTotal += infoLinea.tarifa
            print("• \(infoLinea.nombre): S/.\(String(format: "%.2f", infoLinea.tarifa)) [\(infoLinea.tarjetaRequerida)]")
        }
    }
    print("💰 TOTAL A PAGAR: S/.\(String(format: "%.2f", costoTotal))")
    
    var saldoSuficiente = true
    if lineasUsadas.contains("Línea 1") && billetera.saldoLinea1 < 1.50 { saldoSuficiente = false }
    if lineasUsadas.contains("Línea 2") && billetera.saldoLinea2 < 1.40 { saldoSuficiente = false }
    if lineasUsadas.contains("Metropolitano") && billetera.saldoMetropolitano < 3.20 { saldoSuficiente = false }
    if lineasUsadas.contains("Bus Urbano (Evitamiento)") && billetera.efectivo < 2.00 { saldoSuficiente = false }
    if lineasUsadas.contains("Corredor Rojo / Bus") && billetera.efectivo < 2.35 { saldoSuficiente = false }

    if !saldoSuficiente {
        print("\n❌ SALDO INSUFICIENTE en una de tus tarjetas o efectivo. Recarga antes de viajar.")
        return
    }

    print("\n¿Desea realizar el viaje y descontar el saldo? [S/N]: ", terminator: "")
    let confirm = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
    if confirm == "s" || confirm == "si" {
        if lineasUsadas.contains("Línea 1") { billetera.saldoLinea1 -= 1.50 }
        if lineasUsadas.contains("Línea 2") { billetera.saldoLinea2 -= 1.40 }
        if lineasUsadas.contains("Metropolitano") { billetera.saldoMetropolitano -= 3.20 }
        if lineasUsadas.contains("Bus Urbano (Evitamiento)") { billetera.efectivo -= 2.00 }
        if lineasUsadas.contains("Corredor Rojo / Bus") { billetera.efectivo -= 2.35 }
        print("✅ Pasajes descontados correctamente. ¡Buen viaje!")
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
    
    print("\n¿En qué orden deseas ver las estaciones?")
    print("1. Orden Secuencial (Recorrido de la línea)")
    print("2. Orden Alfabético (A - Z)")
    print("Selecciona [1/2]: ", terminator: "")
    let modo = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "1"
    
    print("\n📋 LÍNEA: \(lineaObj.nombre) (\(lineaObj.color)) | Tarifa: S/.\(String(format: "%.2f", lineaObj.tarifa))")
    
    if modo == "2" {
        let ordenadas = lineaObj.estaciones.compactMap { diccionarioEstaciones[$0] }.sorted { $0.nombre < $1.nombre }
        for est in ordenadas {
            print("• \(est.nombre) [\(est.estado.rawValue)]")
        }
    } else {
        for (idx, clave) in lineaObj.estaciones.enumerated() {
            if let est = diccionarioEstaciones[clave] {
                print("\(idx + 1). \(est.nombre) [\(est.estado.rawValue)]")
            }
        }
    }
}

func gestionarTarjetasMenu() {
    print("\n💳 --- BILLETERA Y TARJETAS ---")
    print("1. Consultar saldos")
    print("2. Recargar tarjeta")
    print("Elige opción [1/2]: ", terminator: "")
    
    let op = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if op == "1" {
        print("\n💰 SALDOS ACTUALES:")
        print("• Tarjeta Línea 1: S/.\(String(format: "%.2f", billetera.saldoLinea1))")
        print("• Tarjeta Línea 2 / TIT: S/.\(String(format: "%.2f", billetera.saldoLinea2))")
        print("• Tarjeta Metropolitano: S/.\(String(format: "%.2f", billetera.saldoMetropolitano))")
        print("• Efectivo en mano: S/.\(String(format: "%.2f", billetera.efectivo))")
    } else if op == "2" {
        print("\n¿Qué tarjeta deseas recargar? [1: L1, 2: L2, 3: Metropolitano]: ", terminator: "")
        let tSelec = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print("Monto a recargar (S/.): ", terminator: "")
        if let input = readLine(), let monto = Double(input) {
            billetera.recargar(sistema: tSelec, monto: monto)
        } else {
            print("❌ Monto inválido.")
        }
    }
}
// ==========================================
// 5. MÓDULO DE ADMINISTRACIÓN PROTEGIDO
// ==========================================

func menuAdministrador() {
    let claveCorrecta = "admin123"
    print("\n🔒 --- MÓDULO DE ADMINISTRACIÓN ---")
    print("Ingrese la clave de administrador: ", terminator: "")
    
    guard let claveIngresada = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
          claveIngresada == claveCorrecta else {
        print("❌ Clave incorrecta. Acceso denegado.")
        return
    }
    
    var volver = false
    while !volver {
        print("""
        
        ⚙️ === PANEL DE ADMINISTRACIÓN ===
        1. Cambiar estado de una estación (Operación / Construcción / Proyecto)
        2. Modificar tarifa de una línea
        3. Cambiar/Agregar advertencia a una estación
        4. Ver reporte general del sistema
        5. Volver al menú principal
        Elige una opción: 
        """, terminator: "")
        
        guard let op = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
        
        switch op {
        case "1":
            print("\nIngrese el nombre de la estación: ", terminator: "")
            if let input = readLine(), let claveEst = resolverClaveEstacion(entrada: input), var est = diccionarioEstaciones[claveEst] {
                print("Estado actual: \(est.estado.rawValue)")
                print("Seleccione nuevo estado [1: En operación, 2: En construcción, 3: En proyecto]: ", terminator: "")
                if let opcionEstado = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    switch opcionEstado {
                    case "1": est.estado = .enOperacion
                    case "2": est.estado = .enConstruccion
                    case "3": est.estado = .enProyecto
                    default: print("❌ Opción inválida.")
                    }
                    diccionarioEstaciones[claveEst] = est
                    print("✅ Estado actualizado a: \(est.estado.rawValue)")
                }
            } else {
                print("❌ Estación no encontrada.")
            }
            
        case "2":
            print("\nLíneas disponibles: \(redLineas.keys.joined(separator: ", "))")
            print("Ingrese el nombre de la línea: ", terminator: "")
            if let busq = readLine(), let claveLinea = redLineas.keys.first(where: { $0.normalizado.contains(busq.normalizado) }), var linea = redLineas[claveLinea] {
                print("Tarifa actual de \(linea.nombre): S/.\(String(format: "%.2f", linea.tarifa))")
                print("Ingrese nueva tarifa (S/.): ", terminator: "")
                if let inputT = readLine(), let nuevaTarifa = Double(inputT), nuevaTarifa >= 0 {
                    linea.tarifa = nuevaTarifa
                    redLineas[claveLinea] = linea
                    print("✅ Tarifa de \(linea.nombre) actualizada a S/.\(String(format: "%.2f", nuevaTarifa))")
                } else {
                    print("❌ Monto inválido.")
                }
            } else {
                print("❌ Línea no encontrada.")
            }
            
        case "3":
            print("\nIngrese el nombre de la estación: ", terminator: "")
            if let input = readLine(), let claveEst = resolverClaveEstacion(entrada: input), var est = diccionarioEstaciones[claveEst] {
                print("Advertencia actual: \(est.advertencia)")
                print("Ingrese la nueva advertencia/alerta: ", terminator: "")
                if let nuevaAdv = readLine() {
                    est.advertencia = nuevaAdv
                    diccionarioEstaciones[claveEst] = est
                    print("✅ Advertencia actualizada.")
                }
            } else {
                print("❌ Estación no encontrada.")
            }
            
        case "4":
            print("\n📊 --- REPORTE DEL SISTEMA ---")
            print("• Total de estaciones registradas: \(diccionarioEstaciones.count)")
            let enOp = diccionarioEstaciones.values.filter { $0.estado == .enOperacion }.count
            let enCons = diccionarioEstaciones.values.filter { $0.estado == .enConstruccion }.count
            let enProy = diccionarioEstaciones.values.filter { $0.estado == .enProyecto }.count
            print("  - En operación: \(enOp)")
            print("  - En construcción: \(enCons)")
            print("  - En proyecto: \(enProy)")
            print("• Total de líneas/redes: \(redLineas.count)")
            for (_, l) in redLineas {
                print("  - \(l.nombre): S/.\(String(format: "%.2f", l.tarifa)) | \(l.estaciones.count) estaciones")
            }
            
        case "5":
            volver = true
            
        default:
            print("❌ Opción inválida.")
        }
    }
}
// ==========================================
// 6. MENÚ PRINCIPAL E INICIALIZACIÓN
// ==========================================

func iniciarPrograma() {
    cargarTodaLaRed()
    var salir = false

    while !salir {
        print("""
        
        === METRO Y TRANSPORTE DE LIMA ===
        1. Buscar una estación
        2. Planificar viaje (Cálculo de ruta y cobro)
        3. Ver estaciones por línea (Secuencial / Alfabético)
        4. Gestión de Billetera y Tarjetas
        5. Modo Administrador (Gestión de red, tarifas y estados)
        6. Salir
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
                menuAdministrador()
            case "6":
                salir = true
                print("\n👋 ¡Gracias por usar el sistema!")
            default:
                print("\n❌ Opción inválida.")
            }
        }
    }
}

// Iniciar ejecutable
iniciarPrograma()
