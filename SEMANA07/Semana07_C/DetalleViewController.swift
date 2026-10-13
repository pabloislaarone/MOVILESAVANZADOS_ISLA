import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!

    // Cultura que llega desde la lista
    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"

        if let cultura = cultura {
            imgCultura.image = cultura.imagen
            lblNombre.text = cultura.nombre
            lblRegion.text = "Región: \(cultura.region)"
            lblDescripcion.text = cultura.descripcion
        }
    }
}
