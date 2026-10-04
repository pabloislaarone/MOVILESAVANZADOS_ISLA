//
//  NuevaVentaViewController.swift
//  Calculadora de Venta a Plazos de Electrodoméstico
//
//  Pantalla "Nueva Venta". El botón "Calcular" tiene un segue Show
//  hacia "Resultado" con identifier "showResultado".
//  El cálculo se hace en prepare(for:sender:) y se envía un VentaModel.
//

import UIKit

class NuevaVentaViewController: UIViewController {

    //    controles de entrada
    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecioUnitario: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfInteresMensual: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nueva Venta"
    }

    //    aplica las formulas y devuelve un VentaModel con los resultados
    func calcularVenta() -> VentaModel {
        //    si un campo esta vacio o no es numero, se toma como 0
        let precioUnitario = Double(tfPrecioUnitario.text!) ?? 0
        let cantidad = Double(tfCantidad.text!) ?? 0
        let meses = Double(tfMeses.text!) ?? 0
        let tasaInteresMensual = Double(tfInteresMensual.text!) ?? 0

        let subtotal = precioUnitario * cantidad
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (tasaInteresMensual / 100) * meses
        let total = base + intereses

        //    evitar dividir entre 0 si no se ingresaron meses
        var cuota: Double = 0
        if meses > 0 {
            cuota = total / meses
        }

        return VentaModel(pSubtotal: subtotal, pIgv: igv, pBase: base,
                          pIntereses: intereses, pTotal: total, pCuota: cuota)
    }

    //    se ejecuta justo antes de navegar a "Resultado"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            let oResultado = segue.destination as! ResultadoViewController
            oResultado.pVenta = calcularVenta()
            oResultado.pElectrodomestico = tfElectrodomestico.text!
        }
    }
}
