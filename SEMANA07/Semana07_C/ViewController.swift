import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Lista de culturas peruanas
    var listaCulturas = [
        Cultura(nombre: "Caral",
                region: "Lima (valle de Supe, Barranca)",
                descripcion: "Es la civilización más antigua de América, con cerca de 5000 años. Destacan sus pirámides y su ciudad sagrada, construida sin murallas defensivas.",
                imagen: UIImage(named: "caral")),
        Cultura(nombre: "Chavín",
                region: "Áncash (Chavín de Huántar)",
                descripcion: "Cultura religiosa de la sierra norte. Su templo tiene galerías subterráneas, el Lanzón monolítico y las famosas cabezas clavas.",
                imagen: UIImage(named: "chavin")),
        Cultura(nombre: "Paracas",
                region: "Ica (península de Paracas)",
                descripcion: "Conocida por sus mantos textiles de gran colorido y por las trepanaciones craneanas, una de las primeras prácticas quirúrgicas.",
                imagen: UIImage(named: "paracas")),
        Cultura(nombre: "Nazca",
                region: "Ica (valles de Nazca)",
                descripcion: "Famosa por las Líneas de Nazca, figuras gigantes trazadas en el desierto, su cerámica polícroma y sus acueductos subterráneos.",
                imagen: UIImage(named: "nazca")),
        Cultura(nombre: "Moche",
                region: "La Libertad y Lambayeque",
                descripcion: "Grandes ceramistas y constructores: levantaron las Huacas del Sol y de la Luna. A esta cultura pertenece la tumba del Señor de Sipán.",
                imagen: UIImage(named: "moche")),
        Cultura(nombre: "Inca",
                region: "Cusco",
                descripcion: "Formaron el Tahuantinsuyo, el imperio más grande de América precolombina. Su obra más conocida es Machu Picchu y su red de caminos, el Qhapaq Ñan.",
                imagen: UIImage(named: "inca"))
    ]

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

    // Al seleccionar una cultura, ir al detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetalle", sender: indexPath)
    }

    // Pasar la cultura seleccionada a la pantalla de detalle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetalle",
           let destino = segue.destination as? DetalleViewController,
           let indexPath = sender as? IndexPath {
            destino.cultura = listaCulturas[indexPath.row]
        }
    }
}
