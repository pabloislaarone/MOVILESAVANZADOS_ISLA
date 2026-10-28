//
//  ContentView.swift
//  BoletaPago
//
//  Una sola pantalla: formulario arriba y, al pulsar Calcular, la boleta debajo.
//  Controles usados: Text, VStack, HStack, @State, TextField, Picker, Button y ScrollView.
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
                    ForEach(SistemaPension.allCases, id: \.self) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Solo aparece si eligió AFP
            if sistema == .afp {
                HStack {
                    Text("AFP")
                    Picker("AFP", selection: $nombreAFP) {
                        ForEach(Parametros.nombresAFP, id: \.self) { nombre in
                            Text(nombre).tag(nombre)
                        }
                    }
                }
            }

            campo("Horas extras al 25%", texto: $horas25Texto, teclado: .decimalPad)
            campo("Horas extras al 35%", texto: $horas35Texto, teclado: .decimalPad)
            campo("Adelantos (S/)", texto: $adelantosTexto, teclado: .decimalPad)
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
                                              adelantosTexto: adelantosTexto)
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

            bloque(titulo: "REMUNERACIONES",
                   conceptos: boleta.remuneraciones,
                   tituloTotal: "Total remuneraciones",
                   total: boleta.totalRemuneraciones)

            bloque(titulo: "RETENCIONES / DESCUENTOS",
                   conceptos: boleta.descuentos,
                   tituloTotal: "Total descuentos",
                   total: boleta.totalDescuentos)

            bloque(titulo: "APORTACIONES DEL EMPLEADOR",
                   conceptos: boleta.aportaciones,
                   tituloTotal: nil,
                   total: nil)

            HStack {
                Text("NETO A PAGAR")
                    .font(.title3)
                    .bold()
                Spacer()
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

    private func bloque(titulo: String, conceptos: [Concepto], tituloTotal: String?, total: Decimal?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.headline)
            ForEach(conceptos) { concepto in
                HStack {
                    Text(concepto.nombre)
                    Spacer()
                    Text(Boleta.formato(concepto.monto))
                        .monospacedDigit()
                }
            }
            if let tituloTotal = tituloTotal, let total = total {
                HStack {
                    Text(tituloTotal).bold()
                    Spacer()
                    Text(Boleta.formato(total))
                        .bold()
                        .monospacedDigit()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
