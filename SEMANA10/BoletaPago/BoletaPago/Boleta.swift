//
//  Boleta.swift
//  BoletaPago
//
//  La clase que calcula. No sabe nada de la pantalla: recibe DatosTrabajador
//  y expone cada concepto ya redondeado a 2 decimales.
//
//  Convención del enunciado: cada concepto se redondea a 2 decimales y LUEGO se suman.
//  El valor hora es un paso intermedio: no se redondea (igual que en el Excel).
//

import Foundation

class Boleta {

    let datos: DatosTrabajador

    init(datos: DatosTrabajador) {
        self.datos = datos
    }

    // MARK: - Redondeo (medio hacia arriba, como ROUND de Excel)

    static func redondear(_ valor: Decimal) -> Decimal {
        var entrada = valor
        var salida = Decimal()
        NSDecimalRound(&salida, &entrada, 2, .plain)
        return salida
    }

    // MARK: - Remuneraciones

    /// Sueldo básico ÷ 30 × días laborados
    /// (se multiplica primero para no arrastrar decimales periódicos; el resultado es el mismo)
    var sueldoComputable: Decimal {
        Boleta.redondear(datos.sueldoBasico * Decimal(datos.diasLaborados) / Parametros.diasDelMes)
    }

    /// 10% de la RMV si tiene hijos. No se prorratea.
    var asignacionFamiliar: Decimal {
        datos.tieneHijos ? Boleta.redondear(Parametros.rmv * Parametros.porcentajeAsignacionFamiliar) : 0
    }

    /// Sueldo básico ÷ 30 ÷ 8 (sin redondear: es un paso intermedio)
    var valorHora: Decimal {
        datos.sueldoBasico / Parametros.diasDelMes / Parametros.horasPorDia
    }

    var horasExtras25: Decimal {
        Boleta.redondear(valorHora * Parametros.factorHorasExtras25 * datos.horasExtras25)
    }

    var horasExtras35: Decimal {
        Boleta.redondear(valorHora * Parametros.factorHorasExtras35 * datos.horasExtras35)
    }

    /// Array con los conceptos de remuneraciones (en el orden de la boleta).
    var remuneraciones: [Concepto] {
        [
            Concepto(nombre: "Sueldo computable", monto: sueldoComputable),
            Concepto(nombre: "Asignación familiar", monto: asignacionFamiliar),
            Concepto(nombre: "Horas extras 25%", monto: horasExtras25),
            Concepto(nombre: "Horas extras 35%", monto: horasExtras35)
        ]
    }

    var totalRemuneraciones: Decimal {
        remuneraciones.reduce(0) { $0 + $1.monto }
    }

    // MARK: - Descuentos

    var tasaAFP: TasaAFP? {
        datos.sistema == .afp ? Parametros.tasasAFP[datos.nombreAFP] : nil
    }

    var onp: Decimal {
        datos.sistema == .onp ? Boleta.redondear(totalRemuneraciones * Parametros.porcentajeONP) : 0
    }

    var afpFondo: Decimal {
        guard let tasa = tasaAFP else { return 0 }
        return Boleta.redondear(totalRemuneraciones * tasa.fondo)
    }

    var afpComision: Decimal {
        guard let tasa = tasaAFP else { return 0 }
        return Boleta.redondear(totalRemuneraciones * tasa.comision)
    }

    var afpSeguro: Decimal {
        guard let tasa = tasaAFP else { return 0 }
        return Boleta.redondear(totalRemuneraciones * tasa.seguro)
    }

    var adelantos: Decimal {
        Boleta.redondear(datos.adelantos)
    }

    /// Array con los conceptos de descuentos (los que no aplican salen en 0.00).
    var descuentos: [Concepto] {
        [
            Concepto(nombre: "ONP (13%)", monto: onp),
            Concepto(nombre: "AFP fondo", monto: afpFondo),
            Concepto(nombre: "AFP comisión", monto: afpComision),
            Concepto(nombre: "AFP seguro", monto: afpSeguro),
            Concepto(nombre: "Adelantos", monto: adelantos)
        ]
    }

    var totalDescuentos: Decimal {
        descuentos.reduce(0) { $0 + $1.monto }
    }

    // MARK: - Resultado

    var netoAPagar: Decimal {
        totalRemuneraciones - totalDescuentos
    }

    /// Aporte del empleador: no se descuenta al trabajador.
    var essalud: Decimal {
        Boleta.redondear(totalRemuneraciones * Parametros.porcentajeEsSalud)
    }

    var aportaciones: [Concepto] {
        [Concepto(nombre: "EsSalud (9%)", monto: essalud)]
    }

    // MARK: - Formato

    /// 2500 -> "2,500.00"
    static func formato(_ monto: Decimal) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: monto as NSDecimalNumber) ?? "0.00"
    }
}
