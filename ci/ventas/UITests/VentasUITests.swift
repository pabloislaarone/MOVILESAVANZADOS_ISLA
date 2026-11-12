import XCTest

final class VentasUITests: XCTestCase {

    var app: XCUIApplication!

    @MainActor
    func captura(_ nombre: String) {
        sleep(1)
        let adjunto = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        adjunto.name = nombre
        adjunto.lifetime = .keepAlways
        add(adjunto)
    }

    @MainActor
    func escribir(_ campo: XCUIElement, _ texto: String, limpiar: Bool = false) {
        XCTAssertTrue(campo.waitForExistence(timeout: 5), "No aparece el campo \(campo)")
        campo.tap()
        if limpiar, let actual = campo.value as? String, !actual.isEmpty {
            campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: actual.count + 2))
        }
        campo.typeText(texto)
    }

    @MainActor
    func ocultarTeclado() {
        if app.keyboards.count > 0 {
            app.navigationBars.firstMatch.tap()
        }
    }

    @MainActor
    func fila(_ texto: String) -> XCUIElement {
        app.cells.containing(NSPredicate(format: "label == %@", texto)).firstMatch
    }

    @MainActor
    func pestana(_ nombre: String) {
        let boton = app.tabBars.buttons[nombre]
        XCTAssertTrue(boton.waitForExistence(timeout: 8), "No aparece la pestaña \(nombre)")
        boton.tap()
        sleep(1)
    }

    @MainActor
    func login(_ usuario: String, _ clave: String) {
        escribir(app.textFields["loginUsuario"], usuario, limpiar: true)
        escribir(app.secureTextFields["loginClave"], clave, limpiar: true)
        app.buttons["Ingresar"].tap()
    }

    @MainActor
    func cerrarSesion() {
        pestana("Cuenta")
        app.cells.staticTexts["Cerrar sesión"].tap()
        XCTAssertTrue(app.buttons["Ingresar"].waitForExistence(timeout: 5))
    }

    @MainActor
    func aceptarAlerta() {
        let ok = app.alerts.buttons["OK"]
        if ok.waitForExistence(timeout: 3) { ok.tap() }
        sleep(1)
    }

    @MainActor
    func elegir(_ fila: String, _ opcion: String) {
        app.cells.staticTexts[fila].firstMatch.tap()
        let celda = app.cells.staticTexts[opcion].firstMatch
        XCTAssertTrue(celda.waitForExistence(timeout: 5), "No aparece \(opcion)")
        celda.tap()
        sleep(1)
    }

    @MainActor
    func cantidad(_ n: String) {
        escribir(app.textFields["cantidad"], n, limpiar: true)
        ocultarTeclado()
    }

    @MainActor
    func testNueveCasos() throws {
        continueAfterFailure = true
        app = XCUIApplication()
        app.launchArguments = ["-reiniciar", "-datosDemo"]
        addUIInterruptionMonitor(withDescription: "alertas del sistema") { alerta in
            for b in ["Not Now", "Ahora no", "OK"] where alerta.buttons[b].exists {
                alerta.buttons[b].tap(); return true
            }
            return false
        }
        app.launch()
        XCTAssertTrue(app.buttons["Ingresar"].waitForExistence(timeout: 20))

        // A1 · Login
        captura("01_A1_login")

        // Caso 3: clave incorrecta
        login("cruiz", "999999")
        XCTAssertTrue(app.staticTexts["⚠︎ Usuario o clave incorrectos"].waitForExistence(timeout: 3))
        captura("02_caso3_clave_incorrecta")

        // Caso 1 (primera parte): registrar a lparedes como Supervisor
        app.buttons["Crear cuenta"].tap()
        escribir(app.textFields["regNombre"], "Lucía Paredes")
        escribir(app.textFields["regUsuario"], "lparedes")
        escribir(app.secureTextFields["regClave"], "123456")
        escribir(app.secureTextFields["regConfirmar"], "123456")
        ocultarTeclado()
        app.segmentedControls.buttons["Supervisor"].tap()
        XCTAssertTrue(app.staticTexts["✓ Disponible"].exists)
        captura("03_A2_registro_lparedes")
        app.buttons["Registrarme"].tap()
        XCTAssertTrue(app.tabBars.buttons["Resumen"].waitForExistence(timeout: 8), "El supervisor no entró a la app")
        captura("04_caso1_entra_supervisor")

        pestana("Cuenta")
        captura("05_cuenta_supervisor")
        cerrarSesion()

        // Caso 1 (segunda parte): LPAREDES repetido
        app.buttons["Crear cuenta"].tap()
        escribir(app.textFields["regNombre"], "Luis Paredes")
        escribir(app.textFields["regUsuario"], "LPAREDES")
        escribir(app.secureTextFields["regClave"], "123456")
        escribir(app.secureTextFields["regConfirmar"], "123456")
        ocultarTeclado()
        app.buttons["Registrarme"].tap()
        XCTAssertTrue(app.staticTexts["✗ Ya existe"].exists)
        XCTAssertFalse(app.tabBars.firstMatch.exists)
        captura("06_caso1_usuario_repetido")

        // Caso 2: clave de 4 caracteres y claves distintas
        escribir(app.textFields["regUsuario"], "jperez", limpiar: true)
        escribir(app.secureTextFields["regClave"], "1234", limpiar: true)
        escribir(app.secureTextFields["regConfirmar"], "1234", limpiar: true)
        ocultarTeclado()
        app.buttons["Registrarme"].tap()
        XCTAssertTrue(app.staticTexts["La clave debe tener mínimo 6 caracteres."].exists)
        captura("07_caso2_clave_corta")
        escribir(app.secureTextFields["regClave"], "123456", limpiar: true)
        escribir(app.secureTextFields["regConfirmar"], "654321", limpiar: true)
        ocultarTeclado()
        app.buttons["Registrarme"].tap()
        XCTAssertTrue(app.staticTexts["Las claves no coinciden."].exists)
        captura("08_caso2_claves_distintas")
        app.navigationBars.buttons["Ingresar"].tap()

        // Vendedor
        login("cruiz", "123456")
        XCTAssertTrue(app.tabBars.buttons["Venta"].waitForExistence(timeout: 8))
        captura("09_A3_productos_vendedor")
        pestana("Clientes")
        captura("10_A4_clientes")

        // Caso 6: 50 unidades con stock 40
        pestana("Venta")
        elegir("Cliente", "Comercial Andina SAC")
        elegir("Producto", "Laptop Pro 14")
        cantidad("50")
        app.buttons["Registrar venta"].tap()
        XCTAssertTrue(app.alerts["Stock insuficiente"].waitForExistence(timeout: 3))
        captura("11_caso6_stock_insuficiente")
        aceptarAlerta()

        // Caso 4: 2 Laptop a S/ 200 a cliente VIP
        cantidad("2")
        XCTAssertTrue(app.staticTexts["S/ 424.80"].exists)
        captura("12_A5_caso4_resumen")
        app.buttons["Registrar venta"].tap()
        XCTAssertTrue(app.alerts["Venta registrada"].waitForExistence(timeout: 3))
        captura("13_caso4_registrada_stock_38")
        aceptarAlerta()

        // Caso 5: 3 Mouse a S/ 35 a cliente Regular
        elegir("Cliente", "Luis Rojas")
        elegir("Producto", "Mouse inalámbrico")
        cantidad("3")
        XCTAssertTrue(app.staticTexts["S/ 123.90"].exists)
        captura("14_caso5_resumen")
        app.buttons["Registrar venta"].tap()
        aceptarAlerta()

        // Caso 7: Mis ventas, solo las suyas y sin Anular
        pestana("Mis ventas")
        captura("15_A6_caso7_mis_ventas")
        fila("Comercial Andina SAC").swipeLeft()
        XCTAssertFalse(app.buttons["Anular"].exists)
        captura("16_caso7_sin_anular")

        pestana("Productos")
        captura("17_caso4_stock_38")
        cerrarSesion()

        // Supervisor
        login("lparedes", "123456")
        XCTAssertTrue(app.tabBars.buttons["Resumen"].waitForExistence(timeout: 8))
        captura("18_A9_resumen")

        // Caso 8: anular la venta del caso 4
        pestana("Ventas")
        captura("19_A7_ventas_equipo")
        fila("Comercial Andina SAC").swipeLeft()
        XCTAssertTrue(app.buttons["Anular"].waitForExistence(timeout: 3))
        captura("20_A7_deslizar_anular")
        app.buttons["Anular"].tap()
        let alerta = app.alerts["Anular venta"]
        XCTAssertTrue(alerta.waitForExistence(timeout: 3))
        XCTAssertFalse(alerta.buttons["Anular"].isEnabled, "Anular debe estar deshabilitado sin motivo")
        captura("21_A8_caso8_sin_motivo")
        alerta.textFields["motivo"].typeText("Producto defectuoso")
        XCTAssertTrue(alerta.buttons["Anular"].isEnabled)
        captura("22_A8_caso8_con_motivo")
        alerta.buttons["Anular"].tap()
        sleep(1)
        captura("23_caso8_venta_anulada")

        pestana("Productos")
        captura("24_caso8_stock_vuelve_40")
        fila("Laptop Pro 14").swipeLeft()
        app.buttons["Borrar"].tap()
        XCTAssertTrue(app.alerts["No se puede borrar"].waitForExistence(timeout: 3))
        captura("25_borrar_producto_con_ventas")
        aceptarAlerta()

        // Caso 9: borrar un cliente que tiene ventas
        pestana("Clientes")
        fila("Comercial Andina SAC").swipeLeft()
        app.buttons["Borrar"].tap()
        XCTAssertTrue(app.alerts["No se puede borrar"].waitForExistence(timeout: 3))
        captura("26_caso9_borrar_cliente_con_ventas")
        aceptarAlerta()

        pestana("Resumen")
        captura("27_caso8_resumen_baja")
        cerrarSesion()

        // Venta anulada vista por el vendedor
        login("cruiz", "123456")
        pestana("Mis ventas")
        captura("28_A6_anulada_tachada")

        // Ícono en la pantalla de inicio
        XCUIDevice.shared.press(.home)
        sleep(2)
        captura("29_icono_inicio")
    }
}
