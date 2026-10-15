import UIKit

class CulturaTableViewCell: UITableViewCell {

    @IBOutlet weak var celdaImagen: UIImageView!
    @IBOutlet weak var celdaNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
