import XCTest

final class CapturasUITests: XCTestCase {

    @MainActor
    func captura(_ app: XCUIApplication, _ nombre: String) {
        sleep(1)
        let adjunto = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        adjunto.name = nombre
        adjunto.lifetime = .keepAlways
        add(adjunto)
    }

    @MainActor
    func fila(_ app: XCUIApplication, _ texto: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label CONTAINS %@", texto)).firstMatch
    }

    @MainActor
    func escribir(_ app: XCUIApplication, _ campo: String, _ texto: String) {
        let tf = app.textFields[campo]
        XCTAssertTrue(tf.waitForExistence(timeout: 5), "No aparece el campo \(campo)")
        tf.tap()
        tf.typeText(texto)
    }

    @MainActor
    func agregar(_ app: XCUIApplication, _ apellido: String, _ nombre: String, _ dni: String, capturar: Bool = false) {
        app.buttons["Nuevo Alumno"].firstMatch.tap()
        escribir(app, "Apellido", apellido)
        escribir(app, "Nombre", nombre)
        escribir(app, "DNI", dni)
        app.navigationBars["Nuevo Alumno"].staticTexts["Nuevo Alumno"].firstMatch.tap() // baja el teclado
        if capturar { captura(app, "02_formulario_nuevo_alumno") }
        app.buttons["Guardar Alumno"].tap()
        XCTAssertTrue(fila(app, "\(apellido), \(nombre)").waitForExistence(timeout: 5))
    }

    @MainActor
    func volver(_ app: XCUIApplication) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
    }

    @MainActor
    func testCapturasLab11() throws {
        continueAfterFailure = true
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["Nuevo Alumno"].firstMatch.waitForExistence(timeout: 15))

        // READ: lista vacía
        captura(app, "01_lista_vacia")

        // CREATE
        agregar(app, "Isla Arone", "Pablo", "72345678", capturar: true)
        agregar(app, "García", "Lucía", "45678912")
        agregar(app, "Gargurevich", "Diego", "41234567")
        agregar(app, "Quispe", "Ana", "70123456")
        captura(app, "03_lista_alumnos")

        // Detalle
        fila(app, "Quispe, Ana").tap()
        XCTAssertTrue(app.buttons["Editar"].waitForExistence(timeout: 5))
        captura(app, "04_detalle_alumno")

        // UPDATE
        app.buttons["Editar"].tap()
        let ape = app.textFields["Apellido"]
        XCTAssertTrue(ape.waitForExistence(timeout: 5))
        ape.tap()
        ape.typeText(" Mamani")
        app.navigationBars["Editar Alumno"].staticTexts["Editar Alumno"].firstMatch.tap()
        captura(app, "05_editar_alumno")
        app.buttons["Listo"].tap()
        sleep(1)
        captura(app, "06_detalle_actualizado")
        volver(app)

        // Persistencia: se cierra y se vuelve a abrir la app
        app.terminate()
        app.launch()
        XCTAssertTrue(fila(app, "Quispe Mamani, Ana").waitForExistence(timeout: 15))
        captura(app, "07_persistencia_al_reabrir")

        // Búsqueda
        var buscador = app.searchFields["Buscar por apellido"]
        if !buscador.waitForExistence(timeout: 3) {
            app.collectionViews.firstMatch.swipeDown()
            buscador = app.searchFields["Buscar por apellido"]
        }
        if buscador.waitForExistence(timeout: 5) {
            buscador.tap()
            buscador.typeText("gar")
            sleep(1)
            captura(app, "08_buscar_gar")
        }
        app.terminate()
        app.launch()
        XCTAssertTrue(fila(app, "Isla Arone, Pablo").waitForExistence(timeout: 15))

        // DELETE
        fila(app, "Gargurevich, Diego").swipeLeft()
        sleep(1)
        captura(app, "09_eliminar_swipe")
        app.buttons["Delete"].firstMatch.tap()
        sleep(1)
        captura(app, "10_lista_tras_eliminar")

        // Relación Curso - Alumno
        let libro = app.buttons["Curso demo"].firstMatch
        if libro.waitForExistence(timeout: 5) {
            libro.tap()
            sleep(1)
            fila(app, "Isla Arone, Pablo").tap()
            XCTAssertTrue(app.staticTexts["Curso: Programación en Móviles"].waitForExistence(timeout: 5))
            captura(app, "11_curso_asignado")
        }
    }
}
