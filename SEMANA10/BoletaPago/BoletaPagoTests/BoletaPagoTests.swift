//
//  BoletaPagoTests.swift
//  BoletaPagoTests
//
//  Los 4 casos del enunciado. Los casos 1-3 traen respuesta; el 4 se contrasta con el Excel.
//

import XCTest
@testable import BoletaPago

final class BoletaPagoTests: XCTestCase {

    private func boleta(sueldo: String, dias: Int, hijos: Bool, sistema: SistemaPension,
                        afp: String = "AFP Ejemplo", h25: String = "0", h35: String = "0",
                        adelantos: String = "0") -> Boleta {
        let datos = DatosTrabajador(nombre: "Prueba",
                                    sueldoBasico: Decimal(string: sueldo)!,
                                    diasLaborados: dias,
                                    tieneHijos: hijos,
                                    sistema: sistema,
                                    nombreAFP: afp,
                                    horasExtras25: Decimal(string: h25)!,
                                    horasExtras35: Decimal(string: h35)!,
                                    adelantos: Decimal(string: adelantos)!)
        return Boleta(datos: datos)
    }

    private func d(_ s: String) -> Decimal { Decimal(string: s)! }

    func testCaso1_SinHijosONPMesCompleto() {
        let b = boleta(sueldo: "2500", dias: 30, hijos: false, sistema: .onp)
        XCTAssertEqual(b.totalRemuneraciones, d("2500.00"))
        XCTAssertEqual(b.onp, d("325.00"))
        XCTAssertEqual(b.netoAPagar, d("2175.00"))
        XCTAssertEqual(b.essalud, d("225.00"))
    }

    func testCaso2_ConHijosDiasIncompletos() {
        let b = boleta(sueldo: "1800", dias: 27, hijos: true, sistema: .onp)
        XCTAssertEqual(b.sueldoComputable, d("1620.00"))
        XCTAssertEqual(b.asignacionFamiliar, d("123.00"))
        XCTAssertEqual(b.totalRemuneraciones, d("1743.00"))
        XCTAssertEqual(b.onp, d("226.59"))
        XCTAssertEqual(b.netoAPagar, d("1516.41"))
        XCTAssertEqual(b.essalud, d("156.87"))
    }

    func testCaso3_AFPHorasExtrasAdelanto() {
        let b = boleta(sueldo: "3000", dias: 30, hijos: true, sistema: .afp,
                       h25: "4", h35: "4", adelantos: "200")
        XCTAssertEqual(b.horasExtras25, d("62.50"))
        XCTAssertEqual(b.horasExtras35, d("67.50"))
        XCTAssertEqual(b.totalRemuneraciones, d("3253.00"))
        XCTAssertEqual(b.afpFondo, d("325.30"))
        XCTAssertEqual(b.afpComision, d("52.05"))
        XCTAssertEqual(b.afpSeguro, d("43.92"))
        XCTAssertEqual(b.totalDescuentos, d("621.27"))
        XCTAssertEqual(b.netoAPagar, d("2631.73"))
        XCTAssertEqual(b.essalud, d("292.77"))
    }

    func testCaso4_Evaluacion() {
        // Mismo resultado que la hoja "Casos" del Excel.
        let b = boleta(sueldo: "4200", dias: 24, hijos: true, sistema: .afp,
                       h25: "2", h35: "2", adelantos: "100")
        XCTAssertEqual(b.sueldoComputable, d("3360.00"))
        XCTAssertEqual(b.totalRemuneraciones, d("3574.00"))
        XCTAssertEqual(b.totalDescuentos, d("562.83"))
        XCTAssertEqual(b.netoAPagar, d("3011.17"))
        XCTAssertEqual(b.essalud, d("321.66"))
    }

    // MARK: - Nivel 3

    func testReto_ComparacionONPvsAFP_Caso3() {
        let b = boleta(sueldo: "3000", dias: 30, hijos: true, sistema: .afp,
                       h25: "4", h35: "4", adelantos: "200")
        XCTAssertEqual(b.con(sistema: .onp).netoAPagar, d("2630.11"))
        XCTAssertEqual(b.con(sistema: .afp).netoAPagar, d("2631.73"))
    }

    func testReto_RentaQuinta_Caso3() {
        var datos = boleta(sueldo: "3000", dias: 30, hijos: true, sistema: .afp,
                           h25: "4", h35: "4", adelantos: "200").datos
        datos.calcularRenta = true
        let b = Boleta(datos: datos)
        XCTAssertEqual(b.rentaBrutaAnual, d("45844.14"))
        XCTAssertEqual(b.impuestoAnual, d("587.53"))
        XCTAssertEqual(b.rentaQuinta, d("48.96"))
        XCTAssertEqual(b.netoAPagar, d("2582.77"))
    }

    func testReto_RentaQuinta_VariosTramos() {
        var datos = boleta(sueldo: "12000", dias: 30, hijos: false, sistema: .onp).datos
        datos.calcularRenta = true
        let b = Boleta(datos: datos)
        XCTAssertEqual(b.impuestoAnual, d("17432.20"))
        XCTAssertEqual(b.rentaQuinta, d("1452.68"))
    }

    func testValidacionRechazaDias() {
        XCTAssertThrowsError(try Validador.validar(nombre: "", sueldoTexto: "1500", diasTexto: "31",
                                                   tieneHijos: false, sistema: .onp, nombreAFP: "",
                                                   horas25Texto: "", horas35Texto: "", adelantosTexto: ""))
    }

    func testValidacionRechazaSueldoCero() {
        XCTAssertThrowsError(try Validador.validar(nombre: "", sueldoTexto: "0", diasTexto: "30",
                                                   tieneHijos: false, sistema: .onp, nombreAFP: "",
                                                   horas25Texto: "", horas35Texto: "", adelantosTexto: ""))
    }
}
