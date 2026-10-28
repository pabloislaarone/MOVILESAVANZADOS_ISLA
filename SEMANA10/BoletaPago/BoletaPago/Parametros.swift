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

    // MARK: - Datos ficticios de la boleta (nivel 3)

    static let razonSocial = "Comercial Andina Ejemplo S.A.C."
    static let ruc = "RUC 20000000000 (ficticio)"
}
