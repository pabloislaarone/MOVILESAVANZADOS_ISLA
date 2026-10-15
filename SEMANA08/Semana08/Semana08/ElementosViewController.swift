import UIKit

// Pantalla 2: lo que ofrece la cultura seleccionada
class ElementosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Cultura que llega desde la pantalla 1
    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura?.nombre
    }

    // Cantidad de filas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura?.elementos.count ?? 0
    }

    // Contenido de cada celda (estilo Subtitle: nombre y tipo)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "elementoCell")!
        if let cultura = cultura {
            let elemento = cultura.elementos[indexPath.row]
            cell.textLabel?.text = elemento.nombre
            cell.detailTextLabel?.text = elemento.tipo
            cell.imageView?.image = cultura.imagenDe(elemento)
        }
        
        return cell
    }
    // Al seleccionar un elemento, ir al detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetalle", sender: indexPath)
    }

    // Pasar la cultura y el elemento seleccionado a la pantalla 3
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetalle",
           let destino = segue.destination as? DetalleViewController,
           let indexPath = sender as? IndexPath,
           let cultura = cultura {
            destino.cultura = cultura
            destino.elemento = cultura.elementos[indexPath.row]
        }
    }
}
