import UIKit
import CoreData

// A4 · Clientes
// Vendedor: crear, editar y consultar. Supervisor: además borrar.
class ClientesViewController: UITableViewController, UISearchResultsUpdating {

    private var clientes: [Cliente] = []
    private let buscador = UISearchController(searchResultsController: nil)

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        tableView.register(ClienteCelda.self, forCellReuseIdentifier: "cliente")

        // ① Botón + (ambos roles)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nuevoCliente))

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        // ③ Nota: categoría y total se calculan, no se guardan
        tableView.tableFooterView = notaPie("Categoría y \"comprado\" se calculan con las ventas no anuladas; no se guardan.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let request: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", texto, texto)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        clientes = BaseDeDatos.buscar(request)
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "cliente", for: indexPath) as! ClienteCelda
        celda.configurar(clientes[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        formulario(clientes[indexPath.row])
    }

    // Borrar: solo supervisor y bloqueado si el cliente tiene ventas (delete rule Deny)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let cliente = clientes[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminado in
            self?.borrar(cliente)
            terminado(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ cliente: Cliente) {
        if cliente.cantidadVentas > 0 {
            mostrarAlerta("No se puede borrar", "\(cliente.nombre ?? "El cliente") tiene \(cliente.cantidadVentas) venta(s) registradas.")
            return
        }
        BaseDeDatos.contexto.delete(cliente)
        if !BaseDeDatos.guardar() {
            mostrarAlerta("No se puede borrar", "El cliente tiene ventas registradas.")
        }
        cargar()
    }

    // MARK: - Crear y editar

    @objc private func nuevoCliente() {
        formulario(nil)
    }

    private func formulario(_ cliente: Cliente?) {
        let alerta = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre o razón social"; $0.text = cliente?.nombre; $0.autocapitalizationType = .words }
        alerta.addTextField { $0.placeholder = "DNI o RUC"; $0.text = cliente?.documento; $0.keyboardType = .numberPad }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let nombre = (alerta.textFields?[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let documento = (alerta.textFields?[1].text ?? "").trimmingCharacters(in: .whitespaces)
            guard !nombre.isEmpty, !documento.isEmpty else {
                self?.mostrarAlerta("Datos incompletos", "Escribe el nombre y el documento.")
                return
            }
            let c = cliente ?? Cliente(context: BaseDeDatos.contexto)
            c.nombre = nombre
            c.documento = documento
            BaseDeDatos.guardar()
            self?.cargar()
        })
        present(alerta, animated: true)
    }
}

// ② Fila con iniciales, nombre, documento y total comprado + categoría
final class ClienteCelda: UITableViewCell {
    private let avatar = AvatarView(tamano: 36)
    private let nombre = Estilo.texto("", tamano: 15, peso: .semibold)
    private let documento = Estilo.texto("", tamano: 12, color: .secondaryLabel)
    private let total = Estilo.texto("", tamano: 15, peso: .semibold)
    private let comprado = Estilo.texto("comprado", tamano: 11, color: .secondaryLabel)
    private let categoria = EtiquetaColor()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nombre.numberOfLines = 1
        total.textAlignment = .right
        comprado.textAlignment = .right
        let textos = UIStackView(arrangedSubviews: [nombre, documento])
        textos.axis = .vertical
        textos.spacing = 2
        let montos = UIStackView(arrangedSubviews: [total, comprado])
        montos.axis = .vertical
        montos.alignment = .trailing
        let fila = UIStackView(arrangedSubviews: [avatar, textos, montos, categoria])
        fila.spacing = 10
        fila.alignment = .center
        textos.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        montos.setContentCompressionResistancePriority(.required, for: .horizontal)
        categoria.setContentCompressionResistancePriority(.required, for: .horizontal)
        fila.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            fila.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func configurar(_ cliente: Cliente) {
        avatar.configurar(nombre: cliente.nombre ?? "")
        nombre.text = cliente.nombre
        documento.text = cliente.documento
        total.text = Formato.solesCorto(cliente.totalComprado)
        let cat = cliente.categoria
        categoria.configurar(texto: cat.rawValue, color: cat.color)
    }
}
