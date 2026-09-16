class Cliente {
    var codigo: String
    var direccion: String
    var fechaDeRegistro: String
    var numeroCuenta: String
    var montoMinimoApertura: Double
    
    init(codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.codigo = codigo
        self.direccion = direccion
        self.fechaDeRegistro = fechaDeRegistro
        self.numeroCuenta = numeroCuenta
        self.montoMinimoApertura = montoMinimoApertura
    }
    
    func MostrarDatos() {
        print("📄 Código: \(codigo)")
        print("📍 Dirección: \(direccion)")
        print("📅 Fecha de registro: \(fechaDeRegistro)")
        print("💳 Nº Cuenta: \(numeroCuenta)")
        print("💰 Monto mínimo de apertura: S/ \(String(format: "%.2f", montoMinimoApertura))")
    }
}

class ClienteNatural: Cliente {
    var nombreCompleto: String
    var dni: String
    
    init(nombreCompleto: String, dni: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.nombreCompleto = nombreCompleto
        self.dni = dni
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func MostrarDatos() {
        print("👤 Cliente Natural:")
        print("Nombre: \(nombreCompleto)")
        print("DNI: \(dni)")
        super.MostrarDatos()
        print("------------------------------")
    }
}

class ClienteJuridico: Cliente {
    var razonSocial: String
    var ruc: String
    var representanteLegal: String
    
    init(razonSocial: String, ruc: String, representanteLegal: String, codigo: String, direccion: String, fechaDeRegistro: String, numeroCuenta: String, montoMinimoApertura: Double) {
        self.razonSocial = razonSocial
        self.ruc = ruc
        self.representanteLegal = representanteLegal
        super.init(codigo: codigo, direccion: direccion, fechaDeRegistro: fechaDeRegistro, numeroCuenta: numeroCuenta, montoMinimoApertura: montoMinimoApertura)
    }
    
    override func MostrarDatos() {
        print("🏢 Cliente Jurídico:")
        print("Razón Social: \(razonSocial)")
        print("RUC: \(ruc)")
        print("Representante Legal: \(representanteLegal)")
        super.MostrarDatos()
    }
}

let cNatural = ClienteNatural(nombreCompleto: "Juan Pérez", dni: "12345678", codigo: "C001", direccion: "Av. Lima 123", fechaDeRegistro: "2025-04-03", numeroCuenta: "001-2025-000123", montoMinimoApertura: 500.0)
let cJuridico = ClienteJuridico(razonSocial: "Soluciones SAC", ruc: "20123456789", representanteLegal: "María León", codigo: "C002", direccion: "Jr. Empresas 456", fechaDeRegistro: "2025-04-01", numeroCuenta: "001-2025-000456", montoMinimoApertura: 3000.0)

cNatural.MostrarDatos()
cJuridico.MostrarDatos()