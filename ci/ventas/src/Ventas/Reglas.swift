import UIKit

// MARK: - Reglas de negocio

enum Reglas {
    static let tasaIGV = 0.18
    static let descuentoVIP = 0.10
    static let montoFrecuente = 1_000.0
    static let montoVIP = 5_000.0
    static let stockBajo: Int64 = 5
}

// Redondeo a 2 decimales (céntimos)
func redondear(_ valor: Double) -> Double {
    return (valor * 100).rounded() / 100
}

// Categoría del cliente: se calcula con lo comprado (ventas no anuladas), no se guarda
enum Categoria: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"

    static func para(totalComprado: Double) -> Categoria {
        if totalComprado >= Reglas.montoVIP { return .vip }
        if totalComprado >= Reglas.montoFrecuente { return .frecuente }
        return .regular
    }

    var porcentajeDescuento: Double { self == .vip ? Reglas.descuentoVIP : 0 }

    var color: UIColor {
        switch self {
        case .regular: return .systemGray
        case .frecuente: return .systemBlue
        case .vip: return .systemPurple
        }
    }
}

// Cálculo de una venta:
// subtotal = precio × cantidad; descuento = VIP 10 %; IGV = 18 % de (subtotal − descuento);
// total = subtotal − descuento + IGV
struct CalculoVenta {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double

    init(precio: Double, cantidad: Int, categoria: Categoria) {
        subtotal = redondear(precio * Double(cantidad))
        descuento = redondear(subtotal * categoria.porcentajeDescuento)
        igv = redondear((subtotal - descuento) * Reglas.tasaIGV)
        total = redondear(subtotal - descuento + igv)
    }
}

extension Cliente {
    var ventasValidas: [Venta] {
        let todas = (ventas as? Set<Venta>) ?? []
        return todas.filter { !$0.anulada }
    }

    var totalComprado: Double {
        return redondear(ventasValidas.reduce(0) { $0 + $1.total })
    }

    var categoria: Categoria { Categoria.para(totalComprado: totalComprado) }
}

// MARK: - Formatos

enum Formato {
    private static let numero: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    private static let entero: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f
    }()

    // S/ 1,234.50
    static func soles(_ valor: Double) -> String {
        return "S/ " + (numero.string(from: NSNumber(value: valor)) ?? "0.00")
    }

    // S/ 1,235 (sin decimales, para filas compactas)
    static func solesCorto(_ valor: Double) -> String {
        return "S/ " + (entero.string(from: NSNumber(value: valor)) ?? "0")
    }

    static func diaMes(_ fecha: Date?) -> String {
        guard let fecha = fecha else { return "" }
        let f = DateFormatter()
        f.dateFormat = "dd/MM"
        return f.string(from: fecha)
    }

    static func fechaLarga(_ fecha: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_PE")
        f.dateFormat = "EEEE d 'de' MMMM"
        let texto = f.string(from: fecha)
        return texto.prefix(1).uppercased() + texto.dropFirst()
    }
}

// MARK: - Fechas para los filtros (NSPredicate con fechas)

enum Periodo: Int {
    case todas = 0, hoy, mes

    var desde: Date? {
        let cal = Calendar.current
        switch self {
        case .todas: return nil
        case .hoy: return cal.startOfDay(for: Date())
        case .mes: return cal.date(from: cal.dateComponents([.year, .month], from: Date()))
        }
    }
}
