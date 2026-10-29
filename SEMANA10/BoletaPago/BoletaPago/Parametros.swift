//
//  Parametros.swift
//  BoletaPago
//
//  Todos los parámetros legales viven aquí y en ningún otro lugar.
//  Las fórmulas de Boleta.swift solo los leen; nunca escriben números sueltos.
//

import Foundation

enum Parametros {

    // MARK: - Remuneración

    /// RMV vigente desde el 01/10/2026 (D.S. N.º 015-2026-TR).
    static let rmv: Decimal = 1230

    /// Asignación familiar: 10% de la RMV (Ley 25129). No se prorratea por días.
    static let porcentajeAsignacionFamiliar: Decimal = Decimal(string: "0.10")!

    /// Días del mes y horas de la jornada diaria para el valor hora.
    static let diasDelMes: Decimal = 30
    static let horasPorDia: Decimal = 8

    /// Recargos de sobretiempo (normas de jornada y sobretiempo).
    static let factorHorasExtras25: Decimal = Decimal(string: "1.25")!
    static let factorHorasExtras35: Decimal = Decimal(string: "1.35")!

    // MARK: - Pensiones y salud

    /// ONP: 13% del total de remuneraciones (D.L. 19990).
    static let porcentajeONP: Decimal = Decimal(string: "0.13")!

    /// EsSalud: 9% a cargo del empleador (Ley 26790).
    static let porcentajeEsSalud: Decimal = Decimal(string: "0.09")!

    // MARK: - AFP

    /// Diccionario con las tasas de cada AFP.
    /// "AFP Ejemplo" es la del enunciado (solo para los casos de prueba).
    /// Las demás son las publicadas por la SBS, devengue octubre 2026 (consulta 28/10/2026).
    static let tasasAFP: [String: TasaAFP] = [
        "AFP Ejemplo": TasaAFP(fondo: "0.1000", comision: "0.0160", seguro: "0.0135"),
        "Habitat":     TasaAFP(fondo: "0.1000", comision: "0.0147", seguro: "0.0137"),
        "Integra":     TasaAFP(fondo: "0.1000", comision: "0.0155", seguro: "0.0137"),
        "Prima":       TasaAFP(fondo: "0.1000", comision: "0.0160", seguro: "0.0137"),
        "Profuturo":   TasaAFP(fondo: "0.1000", comision: "0.0169", seguro: "0.0137")
    ]

    /// Orden en que aparecen las AFP en el Picker (un diccionario no guarda orden).
    static let nombresAFP: [String] = ["AFP Ejemplo", "Habitat", "Integra", "Prima", "Profuturo"]

    // MARK: - Renta de 5.ª categoría (nivel 3, reto)

    /// UIT 2026: S/ 5,500 (D.S. N.º 301-2025-EF).
    static let uit: Decimal = 5500

    /// Deducción anual de 7 UIT (art. 46 de la Ley del Impuesto a la Renta).
    static let uitDeducibles: Decimal = 7

    /// Meses del año que se proyectan (versión simplificada: sueldo igual todo el año).
    static let mesesDelAnio: Decimal = 12

    /// Gratificaciones al año (julio y diciembre, Ley 27735) y bonificación extraordinaria del 9% (Ley 30334).
    static let gratificacionesPorAnio: Decimal = 2
    static let porcentajeBonificacion: Decimal = Decimal(string: "0.09")!

    /// Tramos del impuesto (art. 53 LIR). "hasta" en UIT; el último tramo no tiene tope.
    static let tramosRenta: [TramoRenta] = [
        TramoRenta(hastaUIT: 5,   tasa: "0.08"),
        TramoRenta(hastaUIT: 20,  tasa: "0.14"),
        TramoRenta(hastaUIT: 35,  tasa: "0.17"),
        TramoRenta(hastaUIT: 45,  tasa: "0.20"),
        TramoRenta(hastaUIT: nil, tasa: "0.30")
    ]

    // MARK: - Datos ficticios de la boleta (nivel 3)

    static let razonSocial = "Comercial Andina Ejemplo S.A.C."
    static let ruc = "RUC 20000000000 (ficticio)"
}
