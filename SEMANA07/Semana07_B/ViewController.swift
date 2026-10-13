import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Definir los arreglos que cargan los nombres e imágenes
    var personasArreglo = ["Jaime Gomez", "Juan León", "Silvia Montoya", "Theo Diaz", "Elliot Garamendi"]
    var personasImagenarreglo = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personasArreglo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCell") as? PersonasTableViewCell
        cell?.personaNombre.text = "\(personasArreglo[indexPath.row])"
        cell?.PersonaImagen.image = UIImage(named: "\(personasImagenarreglo[indexPath.row])")
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "El Docente que Selecciono es : ",
                                       message: "\(personasArreglo[indexPath.row])",
                                       preferredStyle: UIAlertController.Style.alert)
        // Activar el botón OK
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
        }))
        self.present(alerta, animated: true, completion: nil)
    }
}
