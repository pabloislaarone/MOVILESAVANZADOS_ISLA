//
//  ContentView.swift
//  BoletaPago
//
//  Una sola pantalla: formulario arriba y, al pulsar Calcular, la boleta debajo
//  y la comparación ONP vs AFP (nivel 3).
//  Controles usados: solo Text, VStack, HStack, @State, TextField, Picker, Button y ScrollView.
//  La pantalla no calcula nada: valida con Validador y le pide todo a la clase Boleta.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Estado del formulario

    @State private var nombre = ""
    @State private var sueldoTexto = ""
    @State private var diasTexto = "30"
    @State private var tieneHijos = false
    @State private var sistema: SistemaPension = .onp
    @State private var nombreAFP = Parametros.nombresAFP[0]
    @State private var horas25Texto = ""
    @State private var horas35Texto = ""
    @State private var adelantosTexto = ""
    @State private var calcularRenta = false

    // MARK: - Resultado

    @State private var boleta: Boleta? = nil
    @State private var mensajeError = ""

    // MARK: - Vista

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Boleta de pago")
                    .font(.largeTitle)
                    .bold()
                Text("Boleta de ejemplo · datos ficticios")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                formulario

                Button(action: calcular) {
                    Text("Calcular")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                if !mensajeError.isEmpty {
                    Text(mensajeError)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }

                if let boleta = boleta {
                    vistaBoleta(boleta)
                    vistaComparacion(boleta)
                }
            }
            .padding()
        }
    }

    // MARK: - Formulario

    private var formulario: some View {
        VStack(alignment: .leading, spacing: 12) {
            campo("Nombre del trabajador (ficticio)", texto: $nombre, teclado: .default)
            campo("Sueldo básico (S/)", texto: $sueldoTexto, teclado: .decimalPad)
            campo("Días laborados (1 a 30)", texto: $diasTexto, teclado: .numberPad)

            HStack {
                Text("¿Tiene hijos?")
                Picker("¿Tiene hijos?", selection: $tieneHijos) {
                    Text("No").tag(false)
                    Text("Sí").tag(true)
                }
                .pickerStyle(.segmented)
            }

            HStack {
                Text("Sistema de pensiones")
                Picker("Sistema", selection: $sistema) {
                    Text("ONP").tag(SistemaPension.onp)
                    Text("AFP").tag(SistemaPension.afp)
                }
                .pickerStyle(.segmented)
            }

            // Solo aparece si eligió AFP
            if sistema == .afp {
                HStack {
                    Text("AFP")
                    Picker("AFP", selection: $nombreAFP) {
                        Text(Parametros.nombresAFP[0]).tag(Parametros.nombresAFP[0])
                        Text(Parametros.nombresAFP[1]).tag(Parametros.nombresAFP[1])
                        Text(Parametros.nombresAFP[2]).tag(Parametros.nombresAFP[2])
                        Text(Parametros.nombresAFP[3]).tag(Parametros.nombresAFP[3])
                        Text(Parametros.nombresAFP[4]).tag(Parametros.nombresAFP[4])
                    }
                }
            }

            campo("Horas extras al 25%", texto: $horas25Texto, teclado: .decimalPad)
            campo("Horas extras al 35%", texto: $horas35Texto, teclado: .decimalPad)
            campo("Adelantos (S/)", texto: $adelantosTexto, teclado: .decimalPad)

            HStack {
                Text("Renta 5.ª (reto)")
                Picker("Renta 5.ª", selection: $calcularRenta) {
                    Text("No").tag(false)
                    Text("Sí").tag(true)
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private func campo(_ titulo: String, texto: Binding<String>, teclado: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField(titulo, text: texto)
                .keyboardType(teclado)
                .textFieldStyle(.roundedBorder)
        }
    }

    // MARK: - Acción

    private func calcular() {
        do {
            let datos = try Validador.validar(nombre: nombre,
                                              sueldoTexto: sueldoTexto,
                                              diasTexto: diasTexto,
                                              tieneHijos: tieneHijos,
                                              sistema: sistema,
                                              nombreAFP: nombreAFP,
                                              horas25Texto: horas25Texto,
                                              horas35Texto: horas35Texto,
                                              adelantosTexto: adelantosTexto,
                                              calcularRenta: calcularRenta)
            boleta = Boleta(datos: datos)
            mensajeError = ""
        } catch let error as ErrorValidacion {
            boleta = nil            // si los datos no son válidos, no se calcula
            mensajeError = error.mensaje
        } catch {
            boleta = nil
            mensajeError = "Revisa los datos ingresados."
        }
    }

    // MARK: - Filas

    /// Una línea de la boleta: nombre a la izquierda y monto a la derecha.
    private func fila(_ concepto: Concepto, negrita: Bool = false) -> some View {
        HStack {
            Text(concepto.nombre)
                .fontWeight(negrita ? .bold : .regular)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(Boleta.formato(concepto.monto))
                .fontWeight(negrita ? .bold : .regular)
                .monospacedDigit()
        }
    }

    // MARK: - Boleta (tres bloques uno debajo del otro + neto)

    private func vistaBoleta(_ boleta: Boleta) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text(Parametros.razonSocial).bold()
                Text(Parametros.ruc).font(.caption)
                Text("Trabajador: \(boleta.datos.nombre.isEmpty ? "Trabajador de ejemplo" : boleta.datos.nombre)")
                    .font(.caption)
                Text("Sistema: \(boleta.datos.sistema == .onp ? "ONP" : boleta.datos.nombreAFP) · Días: \(boleta.datos.diasLaborados)")
                    .font(.caption)
            }

            // Bloque 1: remuneraciones (se recorre el array por posición)
            VStack(alignment: .leading, spacing: 6) {
                Text("REMUNERACIONES").font(.headline)
                fila(boleta.remuneraciones[0])
                fila(boleta.remuneraciones[1])
                fila(boleta.remuneraciones[2])
                fila(boleta.remuneraciones[3])
                fila(Concepto(nombre: "Total remuneraciones", monto: boleta.totalRemuneraciones), negrita: true)
            }

            // Bloque 2: retenciones / descuentos
            VStack(alignment: .leading, spacing: 6) {
                Text("RETENCIONES / DESCUENTOS").font(.headline)
                fila(boleta.descuentos[0])
                fila(boleta.descuentos[1])
                fila(boleta.descuentos[2])
                fila(boleta.descuentos[3])
                fila(boleta.descuentos[4])
                fila(boleta.descuentos[5])
                fila(Concepto(nombre: "Total descuentos", monto: boleta.totalDescuentos), negrita: true)
            }

            // Bloque 3: aportaciones del empleador
            VStack(alignment: .leading, spacing: 6) {
                Text("APORTACIONES DEL EMPLEADOR").font(.headline)
                fila(boleta.aportaciones[0])
            }

            HStack {
                Text("NETO A PAGAR")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("S/ \(Boleta.formato(boleta.netoAPagar))")
                    .font(.title3)
                    .bold()
            }
            .padding()
            .background(Color.green.opacity(0.15))
            .cornerRadius(10)
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }

    // MARK: - Comparación ONP vs AFP lado a lado (nivel 3)

    private func vistaComparacion(_ boleta: Boleta) -> some View {
        let conONP = boleta.con(sistema: .onp)
        let conAFP = boleta.con(sistema: .afp)
        let diferencia = conAFP.netoAPagar - conONP.netoAPagar
        let conviene = diferencia > 0 ? boleta.datos.nombreAFP : (diferencia < 0 ? "ONP" : "ninguno")
        let monto = diferencia < 0 ? -diferencia : diferencia

        return VStack(alignment: .leading, spacing: 10) {
            Text("ONP vs AFP con los mismos datos").font(.headline)
            HStack(alignment: .top, spacing: 12) {
                columnaSistema(titulo: "ONP", boleta: conONP)
                columnaSistema(titulo: boleta.datos.nombreAFP, boleta: conAFP)
            }
            Text(diferencia == 0
                 ? "Este mes los dos sistemas dejan el mismo neto."
                 : "Este mes \(conviene) deja S/ \(Boleta.formato(monto)) más de neto.")
                .font(.subheadline)
        }
        .padding()
        .background(Color.orange.opacity(0.08))
        .cornerRadius(12)
    }

    private func columnaSistema(titulo: String, boleta: Boleta) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).bold()
            Text("Pensión").font(.caption).foregroundColor(.secondary)
            Text(Boleta.formato(boleta.totalPension)).monospacedDigit()
            Text("Total descuentos").font(.caption).foregroundColor(.secondary)
            Text(Boleta.formato(boleta.totalDescuentos)).monospacedDigit()
            Text("Neto").font(.caption).foregroundColor(.secondary)
            Text("S/ \(Boleta.formato(boleta.netoAPagar))").bold().monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.white.opacity(0.6))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
}
