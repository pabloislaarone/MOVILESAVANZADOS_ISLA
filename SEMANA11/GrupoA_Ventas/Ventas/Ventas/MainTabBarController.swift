import UIKit

// Pestañas según el rol:
// Vendedor   -> Productos, Clientes, Venta, Mis ventas, Cuenta
// Supervisor -> Resumen, Ventas, Productos, Clientes, Cuenta
class MainTabBarController: UITabBarController {

    init(usuario: Usuario) {
        super.init(nibName: nil, bundle: nil)

        if usuario.esSupervisor {
            viewControllers = [
                pestana(UIViewController(), "Resumen", "chart.bar.fill"),
                pestana(UIViewController(), "Ventas", "list.bullet.rectangle.fill"),
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(UIViewController(), "Clientes", "person.2.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        } else {
            viewControllers = [
                pestana(ProductosViewController(), "Productos", "shippingbox.fill"),
                pestana(UIViewController(), "Clientes", "person.2.fill"),
                pestana(UIViewController(), "Venta", "cart.fill.badge.plus"),
                pestana(UIViewController(), "Mis ventas", "list.bullet.rectangle.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    private func pestana(_ vc: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return nav
    }
}

// Pestaña Cuenta: nombre, usuario, rol y Cerrar sesión
class CuentaViewController: UITableViewController {

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    private var filas: [(String, String)] {
        let u = Sesion.shared.usuario
        return [("Nombre", u?.nombre ?? ""), ("Usuario", u?.usuario ?? ""), ("Rol", u?.rol ?? "")]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"

        let avatar = AvatarView(tamano: 72)
        avatar.configurar(nombre: Sesion.shared.usuario?.nombre ?? "")
        let cabecera = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 110))
        cabecera.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: cabecera.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: cabecera.centerYAnchor)
        ])
        tableView.tableHeaderView = cabecera
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? filas.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = UITableViewCell(style: .value1, reuseIdentifier: nil)
        if indexPath.section == 0 {
            celda.textLabel?.text = filas[indexPath.row].0
            celda.detailTextLabel?.text = filas[indexPath.row].1
            celda.selectionStyle = .none
        } else {
            celda.textLabel?.text = "Cerrar sesión"
            celda.textLabel?.textColor = .systemRed
        }
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            Sesion.shared.cerrar() // la variable vuelve a nil y se muestra el login
        }
    }
}
