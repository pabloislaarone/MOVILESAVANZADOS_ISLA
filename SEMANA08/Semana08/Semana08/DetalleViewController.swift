import UIKit

// Pantalla 3: detalle del elemento seleccionado
class DetalleViewController: UIViewController {

    @IBOutlet weak var imgElemento: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblCultura: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!

    // Datos que llegan desde la pantalla 2
    var cultura: Cultura?
    var elemento: Elemento?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"

        if let cultura = cultura, let elemento = elemento {
            imgElemento.image = cultura.imagenDe(elemento)
            lblNombre.text = elemento.nombre
            lblTipo.text = elemento.tipo
            lblCultura.text = "Cultura \(cultura.nombre) – \(cultura.region)"
            lblDescripcion.text = elemento.descripcion
        }
    }
}
