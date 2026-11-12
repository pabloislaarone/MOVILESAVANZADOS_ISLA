import UIKit
import CoreData

// A3 · Productos
// Vendedor: solo consultar y buscar. Supervisor: crear, editar y borrar.
class ProductosViewController: UITableViewController, UISearchResultsUpdating {

    private var productos: [Producto] = []
    private var categorias: [String] = ["Todos"]
    private let chips = ChipsView()
    private let buscador = UISearchController(searchResultsController: nil)

    init() { super.init(style: .insetGrouped) }
    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        tableView.register(ProductoCelda.self, forCellReuseIdentifier: "producto")

        // ① Botón + solo para el supervisor
        if Sesion.shared.esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(nuevoProducto))
        }

        // ② Búsqueda
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        // ③ Chips de categoría
        chips.alCambiar = { [weak self] _ in self?.cargar() }
        let cabecera = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        chips.translatesAutoresizingMaskIntoConstraints = false
        cabecera.addSubview(chips)
        NSLayoutConstraint.activate([
            chips.leadingAnchor.constraint(equalTo: cabecera.leadingAnchor),
            chips.trailingAnchor.constraint(equalTo: cabecera.trailingAnchor),
            chips.centerYAnchor.constraint(equalTo: cabecera.centerYAnchor)
        ])
        tableView.tableHeaderView = cabecera

        if !Sesion.shared.esSupervisor {
            tableView.tableFooterView = notaPie("Vista del vendedor: solo consulta y búsqueda.")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarCategorias()
        cargar()
    }

    // Lista de categorías existentes para los chips
    private func actualizarCategorias() {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        let nombres = Set(BaseDeDatos.buscar(request).compactMap { $0.categoria })
        let anterior = categorias[safe: chips.seleccionado] ?? "Todos"
        categorias = ["Todos"] + nombres.sorted()
        chips.configurar(opciones: categorias, seleccionado: categorias.firstIndex(of: anterior) ?? 0)
    }

    // READ con NSPredicate: categoría (chip) + texto de búsqueda
    private func cargar() {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        var filtros: [NSPredicate] = []

        let categoria = categorias[safe: chips.seleccionado] ?? "Todos"
        if categoria != "Todos" {
            filtros.append(NSPredicate(format: "categoria == %@", categoria))
        }
        let texto = buscador.searchBar.text ?? ""
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]

        productos = BaseDeDatos.buscar(request)
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "producto", for: indexPath) as! ProductoCelda
        celda.configurar(productos[indexPath.row])
        celda.selectionStyle = Sesion.shared.esSupervisor ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard Sesion.shared.esSupervisor else { return }
        formulario(productos[indexPath.row])
    }

    // ⑤ Deslizar para borrar (solo supervisor; bloqueado si tiene ventas)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return nil }
        let producto = productos[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminado in
            self?.borrar(producto)
            terminado(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ producto: Producto) {
        if producto.cantidadVentas > 0 {
            mostrarAlerta("No se puede borrar", "\(producto.nombre ?? "El producto") tiene \(producto.cantidadVentas) venta(s) registradas.")
            return
        }
        BaseDeDatos.contexto.delete(producto)
        if BaseDeDatos.guardar() {
            actualizarCategorias()
            cargar()
        } else {
            mostrarAlerta("No se puede borrar", "El producto tiene ventas registradas.")
        }
    }

    // MARK: - Crear y editar (solo supervisor)

    @objc private func nuevoProducto() {
        formulario(nil)
    }

    private func formulario(_ producto: Producto?) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = producto?.nombre }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = producto?.categoria }
        alerta.addTextField {
            $0.placeholder = "Precio"
            $0.keyboardType = .decimalPad
            if let p = producto { $0.text = String(format: "%.2f", p.precio) }
        }
        alerta.addTextField {
            $0.placeholder = "Stock"
            $0.keyboardType = .numberPad
            if let p = producto { $0.text = "\(p.stock)" }
        }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            let campos = alerta.textFields ?? []
            let nombre = (campos[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let categoria = (campos[1].text ?? "").trimmingCharacters(in: .whitespaces)
            let precio = Double((campos[2].text ?? "").replacingOccurrences(of: ",", with: ".")) ?? -1
            let stock = Int64(campos[3].text ?? "") ?? -1

            guard !nombre.isEmpty, !categoria.isEmpty, precio > 0, stock >= 0 else {
                self?.mostrarAlerta("Datos incompletos", "Escribe nombre, categoría, un precio mayor a 0 y un stock de 0 o más.")
                return
            }
            let p = producto ?? Producto(context: BaseDeDatos.contexto)
            p.nombre = nombre
            p.categoria = categoria
            p.precio = redondear(precio)
            p.stock = stock
            BaseDeDatos.guardar()
            self?.actualizarCategorias()
            self?.cargar()
        })
        present(alerta, animated: true)
    }
}

// ④ Fila con iniciales, nombre, categoría, precio y stock en color
final class ProductoCelda: UITableViewCell {
    private let avatar = AvatarView(tamano: 36)
    private let nombre = Estilo.texto("", tamano: 15, peso: .semibold)
    private let categoria = Estilo.texto("", tamano: 12, color: .secondaryLabel)
    private let precio = Estilo.texto("", tamano: 15, peso: .semibold)
    private let stock = EtiquetaColor()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nombre.numberOfLines = 1
        let textos = UIStackView(arrangedSubviews: [nombre, categoria])
        textos.axis = .vertical
        textos.spacing = 2
        let fila = UIStackView(arrangedSubviews: [avatar, textos, precio, stock])
        fila.spacing = 10
        fila.alignment = .center
        textos.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textos.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        precio.setContentCompressionResistancePriority(.required, for: .horizontal)
        stock.setContentCompressionResistancePriority(.required, for: .horizontal)
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

    func configurar(_ producto: Producto) {
        avatar.configurar(nombre: producto.nombre ?? "")
        nombre.text = producto.nombre
        categoria.text = producto.categoria
        precio.text = Formato.soles(producto.precio)
        stock.configurar(texto: "\(producto.stock) u.", color: Estilo.colorStock(producto.stock))
    }
}

extension Array {
    subscript(safe indice: Int) -> Element? {
        return indices.contains(indice) ? self[indice] : nil
    }
}
