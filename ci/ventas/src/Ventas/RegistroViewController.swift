import UIKit
import CoreData

// A2 · Crear cuenta
class RegistroViewController: UIViewController {

    private let campoNombre: UITextField
    private let campoUsuario: UITextField
    private let campoClave: UITextField
    private let campoConfirmar: UITextField
    private let tarjetas: [UIView]
    private let avisoUsuario = UILabel()
    private let selectorRol = UISegmentedControl(items: [Rol.vendedor, Rol.supervisor])
    private let etiquetaError = UILabel()

    init() {
        let (t1, c1) = Estilo.campoTarjeta(titulo: "Nombre completo", placeholder: "Ej. Lucía Paredes", id: "regNombre")
        let (t2, c2) = Estilo.campoTarjeta(titulo: "Usuario", placeholder: "Ej. lparedes", id: "regUsuario")
        let (t3, c3) = Estilo.campoTarjeta(titulo: "Clave (mínimo 6 caracteres)", placeholder: "••••••", id: "regClave", seguro: true)
        let (t4, c4) = Estilo.campoTarjeta(titulo: "Confirmar clave", placeholder: "••••••", id: "regConfirmar", seguro: true)
        campoNombre = c1; campoUsuario = c2; campoClave = c3; campoConfirmar = c4
        tarjetas = [t1, t2, t3, t4]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = .systemGroupedBackground
        campoNombre.autocapitalizationType = .words
        construirPantalla()
    }

    private func construirPantalla() {
        // ③ Aviso de usuario único (se actualiza mientras se escribe)
        avisoUsuario.font = .systemFont(ofSize: 12, weight: .medium)
        avisoUsuario.textAlignment = .right
        avisoUsuario.accessibilityIdentifier = "avisoUsuario"
        avisoUsuario.translatesAutoresizingMaskIntoConstraints = false
        tarjetas[1].addSubview(avisoUsuario)
        NSLayoutConstraint.activate([
            avisoUsuario.trailingAnchor.constraint(equalTo: tarjetas[1].trailingAnchor, constant: -14),
            avisoUsuario.bottomAnchor.constraint(equalTo: tarjetas[1].bottomAnchor, constant: -12)
        ])
        campoUsuario.addTarget(self, action: #selector(revisarUsuario), for: .editingChanged)

        // ⑤ Rol
        let tituloRol = Estilo.texto("TU ROL", tamano: 11, peso: .medium, color: .secondaryLabel)
        selectorRol.selectedSegmentIndex = 0

        etiquetaError.font = .systemFont(ofSize: 13)
        etiquetaError.textColor = .systemRed
        etiquetaError.numberOfLines = 0
        etiquetaError.isHidden = true
        etiquetaError.accessibilityIdentifier = "errorRegistro"

        // ⑥ Registrarme
        let boton = Estilo.botonPrincipal("Registrarme")
        boton.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let nota = Estilo.texto("Al registrarte entrarás directamente a la app con las pestañas de tu rol.", tamano: 12, color: .secondaryLabel)
        nota.textAlignment = .center

        let pila = UIStackView(arrangedSubviews: tarjetas + [tituloRol, selectorRol, etiquetaError, boton, nota])
        pila.axis = .vertical
        pila.spacing = 12
        pila.setCustomSpacing(20, after: tarjetas[3])
        pila.setCustomSpacing(6, after: tituloRol)
        pila.setCustomSpacing(20, after: selectorRol)

        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(pila)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -16)
        ])

        let toque = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        view.addGestureRecognizer(toque)
    }

    @objc private func revisarUsuario() {
        let usuario = (campoUsuario.text ?? "").trimmingCharacters(in: .whitespaces)
        if usuario.isEmpty {
            avisoUsuario.text = ""
        } else if Usuario.existe(usuario) {
            avisoUsuario.text = "✗ Ya existe"
            avisoUsuario.textColor = .systemRed
        } else {
            avisoUsuario.text = "✓ Disponible"
            avisoUsuario.textColor = .systemGreen
        }
    }

    private func mostrarError(_ mensaje: String) {
        etiquetaError.text = mensaje
        etiquetaError.isHidden = false
    }

    @objc private func registrar() {
        view.endEditing(true)
        let nombre = (campoNombre.text ?? "").trimmingCharacters(in: .whitespaces)
        let usuario = (campoUsuario.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = campoClave.text ?? ""
        let confirmar = campoConfirmar.text ?? ""

        // Validaciones del registro
        if nombre.isEmpty || usuario.isEmpty {
            mostrarError("Completa tu nombre y tu usuario.")
            return
        }
        if Usuario.existe(usuario) {
            mostrarError("El usuario \"\(usuario)\" ya existe. Elige otro.")
            return
        }
        if clave.count < 6 {
            mostrarError("La clave debe tener mínimo 6 caracteres.")
            return
        }
        if clave != confirmar {
            mostrarError("Las claves no coinciden.")
            return
        }

        // Se crea el usuario y entra directo a la app
        let nuevo = Usuario(context: BaseDeDatos.contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = selectorRol.selectedSegmentIndex == 1 ? Rol.supervisor : Rol.vendedor

        if BaseDeDatos.guardar() {
            Sesion.shared.iniciar(nuevo)
        } else {
            mostrarError("No se pudo crear la cuenta. Intenta de nuevo.")
        }
    }
}
