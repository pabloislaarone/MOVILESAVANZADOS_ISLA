//
//  ResultadoViewController.swift
//  Calculadora de Venta a Plazos de Electrodoméstico
//
//  Pantalla "Resultado": muestra los 6 valores formateados en soles.
//

import UIKit

class ResultadoViewController: UIViewController {

    //    datos recibidos desde "Nueva Venta"
    var pVenta: VentaModel = VentaModel()
    var pElectrodomestico: String = ""

    //    controles de salida
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblIgv: UILabel!
    @IBOutlet weak var lblBase: UILabel!
    @IBOutlet weak var lblIntereses: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCuota: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Resultado"
        if pElectrodomestico != "" {
            self.title = "Resultado - " + pElectrodomestico
        }

        self.lblSubtotal.text = String(format: "S/. %.2f", pVenta.subtotal)
        self.lblIgv.text = String(format: "S/. %.2f", pVenta.igv)
        self.lblBase.text = String(format: "S/. %.2f", pVenta.base)
        self.lblIntereses.text = String(format: "S/. %.2f", pVenta.intereses)
        self.lblTotal.text = String(format: "S/. %.2f", pVenta.total)
        self.lblCuota.text = String(format: "S/. %.2f", pVenta.cuota)
    }
}
