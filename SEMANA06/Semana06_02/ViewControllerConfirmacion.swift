//
//  ViewControllerConfirmacion.swift
//  Semana06_02 - Ventanas modales
//
//  Pantalla "DATOS INGRESADOS": muestra el cliente recibido.
//  Storyboard ID: ViewControllerConfirmacion
//

import UIKit

class ViewControllerConfirmacion: UIViewController {

    //instanciar la clase ClienteModel
    var pCliente: ClienteModel = ClienteModel()

    //    definir los controles
    @IBOutlet weak var tfApellido: UILabel!
    @IBOutlet weak var tfNombre: UILabel!
    @IBOutlet weak var tfDni: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //        mostrar los datos del cliente
        self.tfApellido.text = pCliente.Apellido
        self.tfNombre.text = pCliente.Nombre
        self.tfDni.text = pCliente.Dni
    }

    //    boton Volver: cierra la ventana modal y regresa a la pantalla anterior
    @IBAction func btnVolver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
