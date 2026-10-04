//
//  ViewController.swift
//  Semana06_02 - Ventanas modales
//
//  Pantalla "DATOS DEL CLIENTE": lee los datos y abre la pantalla
//  de confirmación de forma modal, pasándole un ClienteModel.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDni: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnContinuar(_ sender: Any) {
        let oCliente: ClienteModel = ClienteModel(pCodigo: 0,
                                                  pApellido: self.tfApellido.text!,
                                                  pNombre: self.tfNombre.text!,
                                                  pDni: self.tfDni.text!)
        //        crear el Storyboard con el nombre Main, se asocia a la pantalla 2
        //        le pasamos los datos del cliente
        let osb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let oPantalla2 = osb.instantiateViewController(identifier: "ViewControllerConfirmacion") as! ViewControllerConfirmacion
        oPantalla2.pCliente = oCliente
        self.present(oPantalla2, animated: true, completion: nil)
    }
}
