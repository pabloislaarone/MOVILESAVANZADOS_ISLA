//
//  Modelos.swift
//  BoletaPago
//
//  Structs con los datos de entrada, las tasas y cada línea de la boleta.
//  Aquí también vive la validación del formulario.
//

import Foundation

// MARK: - Sistema de pensiones

enum SistemaPension: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

// MARK: - Tasas de una AFP

struct TasaAFP {
    let fondo: Decimal
    let comision: Decimal
    let seguro: Decimal

    /// Se reciben como texto para que Decimal no arrastre errores de Double.
    init(fondo: String, comision: String, seguro: String) {
        self.fondo = Decimal(string: fondo)!
        self.comision = Decimal(string: comision)!
        self.seguro = Decimal(string: seguro)!
    }
}

// MARK: - Un tramo del impuesto a la renta

struct TramoRenta {
    let hastaUIT: Decimal?      // nil = sin tope (último tramo)
    let tasa: Decimal

    init(hastaUIT: Decimal?, tasa: String) {
        self.hastaUIT = hastaUIT
        self.tasa = Decimal(string: tasa)!
    }
}

// MARK: - Datos que ingresa el usuario

struct DatosTrabajador {
    let nombre: String
    let sueldoBasico: Decimal
    let diasLaborados: Int
    let tieneHijos: Bool
    var sistema: SistemaPension          // var: la comparación ONP vs AFP hace una copia cambiando el sistema
    let nombreAFP: String
    let horasExtras25: Decimal
    let horasExtras35: Decimal
    let adelantos: Decimal
    var calcularRenta: Bool = false      // reto: retención de renta de 5.ª (por defecto no, como en los casos)
}

// MARK: - Una línea de la boleta (nombre + monto)

struct Concepto {
    let nombre: String
    let monto: Decimal
}

// MARK: - Validación

enum ErrorValidacion: Error {
    case sueldoInvalido
    case diasInvalidos
    case horas25Invalidas
    case horas35Invalidas
    case adelantosInvalidos
    case afpNoSeleccionada

    var mensaje: String {
        switch self {
        case .sueldoInvalido:     return "El sueldo básico debe ser un número mayor que cero."
        case .diasInvalidos:      return "Los días laborados deben ser un número entero entre 1 y 30."
        case .horas25Invalidas:   return "Las horas extras al 25% deben ser un número mayor o igual a cero."
        case .horas35Invalidas:   return "Las horas extras al 35% deben ser un número mayor o igual a cero."
        case .adelantosInvalidos: return "Los adelantos deben ser un monto mayor o igual a cero."
        case .afpNoSeleccionada:  return "Elige una AFP de la lista."
        }
    }
}

enum Validador {

    /// Convierte texto a Decimal. Acepta coma o punto y deja vacío = 0 en los campos opcionales.
    static func numero(_ texto: String, vacioEsCero: Bool) -> Decimal? {
        let limpio = texto
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        if limpio.isEmpty { return vacioEsCero ? 0 : nil }
        return Decimal(string: limpio, locale: Locale(identifier: "en_US_POSIX"))
    }

    /// Revisa cada campo y devuelve los datos listos para calcular, o lanza el primer error.
    static func validar(nombre: String,
                        sueldoTexto: String,
                        diasTexto: String,
                        tieneHijos: Bool,
                        sistema: SistemaPension,
                        nombreAFP: String,
                        horas25Texto: String,
                        horas35Texto: String,
                        adelantosTexto: String,
                        calcularRenta: Bool = false) throws -> DatosTrabajador {

        guard let sueldo = numero(sueldoTexto, vacioEsCero: false), sueldo > 0 else {
            throw ErrorValidacion.sueldoInvalido
        }

        let diasLimpio = diasTexto.trimmingCharacters(in: .whitespaces)
        guard let dias = Int(diasLimpio), dias >= 1, dias <= 30 else {
            throw ErrorValidacion.diasInvalidos
        }

        // En ONP las horas extras y adelantos también se aceptan (son de nivel 2, pero no dependen del sistema).
        guard let h25 = numero(horas25Texto, vacioEsCero: true), h25 >= 0 else {
            throw ErrorValidacion.horas25Invalidas
        }
        guard let h35 = numero(horas35Texto, vacioEsCero: true), h35 >= 0 else {
            throw ErrorValidacion.horas35Invalidas
        }
        guard let adelantos = numero(adelantosTexto, vacioEsCero: true), adelantos >= 0 else {
            throw ErrorValidacion.adelantosInvalidos
        }

        if sistema == .afp && Parametros.tasasAFP[nombreAFP] == nil {
            throw ErrorValidacion.afpNoSeleccionada
        }

        return DatosTrabajador(nombre: nombre.trimmingCharacters(in: .whitespaces),
                               sueldoBasico: sueldo,
                               diasLaborados: dias,
                               tieneHijos: tieneHijos,
                               sistema: sistema,
                               nombreAFP: nombreAFP,
                               horasExtras25: h25,
                               horasExtras35: h35,
                               adelantos: adelantos,
                               calcularRenta: calcularRenta)
    }
}
