import UIKit

// Pantalla 1: lista de culturas
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas del Perú"
    }

    // Cantidad de filas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCulturas.count
    }

    // Contenido de cada celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "culturaCell") as? CulturaTableViewCell
        cell?.celdaNombre.text = listaCulturas[indexPath.row].nombre
        cell?.celdaImagen.image = listaCulturas[indexPath.row].imagen
        return cell!
    }

    // Al seleccionar una cultura, ir a la lista de lo que ofrece
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showElementos", sender: indexPath)
    }

    // Pasar la cultura seleccionada a la pantalla 2
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showElementos",
           let destino = segue.destination as? ElementosViewController,
           let indexPath = sender as? IndexPath {
            destino.cultura = listaCulturas[indexPath.row]
        }
    }
}
