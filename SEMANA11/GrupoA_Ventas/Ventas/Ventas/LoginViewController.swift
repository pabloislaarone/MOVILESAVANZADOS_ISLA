import UIKit

// A1 · Inicio de sesión
class LoginViewController: UIViewController {

    private let campoUsuario: UITextField
    private let campoClave: UITextField
    private let tarjetaUsuario: UIView
    private let tarjetaClave: UIView
    private let etiquetaError = UILabel()

    init() {
        (tarjetaUsuario, campoUsuario) = Estilo.campoTarjeta(titulo: "Usuario", placeholder: "Tu usuario", id: "loginUsuario")
        (tarjetaClave, campoClave) = Estilo.campoTarjeta(titulo: "Clave", placeholder: "Tu clave", id: "loginClave", seguro: true)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.backButtonTitle = "Ingresar"
        construirPantalla()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func construirPantalla() {
        // ① Logo y nombre
        let logo = UIImageView(image: UIImage(systemName: "cart.fill"))
        logo.tintColor = .white
        logo.contentMode = .center
        logo.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 34, weight: .semibold)
        logo.backgroundColor = .systemBlue
        logo.layer.cornerRadius = 20
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let titulo = Estilo.texto("Ventas Tecsup", tamano: 26, peso: .bold)
        let subtitulo = Estilo.texto("Inicia sesión para continuar", tamano: 15, color: .secondaryLabel)

        let cabecera = UIStackView(arrangedSubviews: [logo, titulo, subtitulo])
        cabecera.axis = .vertical
        cabecera.alignment = .center
        cabecera.spacing = 8
        cabecera.setCustomSpacing(16, after: logo)

        // ④ Mensaje de error genérico (no dice si falló el usuario o la clave)
        etiquetaError.text = "⚠︎ Usuario o clave incorrectos"
        etiquetaError.font = .systemFont(ofSize: 13)
        etiquetaError.textColor = .systemRed
        etiquetaError.isHidden = true

        // ⑤ Ingresar
        let botonIngresar = Estilo.botonPrincipal("Ingresar")
        botonIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        // ⑥ Ir a Crear cuenta
        let pregunta = Estilo.texto("¿Primera vez?", tamano: 14, color: .secondaryLabel)
        let botonCrear = UIButton(type: .system)
        botonCrear.setTitle("Crear cuenta", for: .normal)
        botonCrear.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        botonCrear.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)
        let filaCrear = UIStackView(arrangedSubviews: [pregunta, botonCrear])
        filaCrear.spacing = 4

        let formulario = UIStackView(arrangedSubviews: [tarjetaUsuario, tarjetaClave, etiquetaError, botonIngresar])
        formulario.axis = .vertical
        formulario.spacing = 12

        let contenedorCrear = UIStackView(arrangedSubviews: [filaCrear])
        contenedorCrear.axis = .vertical
        contenedorCrear.alignment = .center

        let pila = UIStackView(arrangedSubviews: [cabecera, formulario, contenedorCrear])
        pila.axis = .vertical
        pila.spacing = 32
        pila.setCustomSpacing(12, after: formulario)

        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8),
            pila.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            pila.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])

        ocultarTecladoAlTocarFuera()
    }

    @objc private func ingresar() {
        let usuario = (campoUsuario.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = campoClave.text ?? ""

        guard let encontrado = Usuario.login(usuario: usuario, clave: clave) else {
            etiquetaError.isHidden = false
            return
        }
        etiquetaError.isHidden = true
        view.endEditing(true)
        Sesion.shared.iniciar(encontrado)
    }

    @objc private func irARegistro() {
        etiquetaError.isHidden = true
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
