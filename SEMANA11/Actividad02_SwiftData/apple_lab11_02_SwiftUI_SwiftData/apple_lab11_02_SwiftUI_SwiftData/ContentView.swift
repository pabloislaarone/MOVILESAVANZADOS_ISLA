import SwiftUI
import SwiftData // Para consultar y manipular datos persistentes

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // Contexto: insertar, borrar, guardar

    // READ: consulta automática de todos los alumnos ordenados por apellido
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]

    @State private var alumnoSeleccionado: Alumno? // Alumno seleccionado en la lista
    @State private var mostrarFormulario = false   // Muestra el formulario de nuevo alumno
    @State private var alumnoAEditar: Alumno?      // Alumno que se está editando
    @State private var busqueda = ""               // Texto de búsqueda

    // Alumnos que coinciden con la búsqueda por apellido
    private var alumnosFiltrados: [Alumno] {
        if busqueda.isEmpty { return alumnos }
        return alumnos.filter { $0.apellido.localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        NavigationSplitView { // Lista a la izquierda, detalle a la derecha
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnosFiltrados) { alumno in
                    NavigationLink(value: alumno) {
                        VStack(alignment: .leading) {
                            Text("\(alumno.apellido), \(alumno.nombre)")
                                .font(.headline)
                            Text("DNI: \(alumno.dni)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteAlumnos) // Eliminar con swipe o modo edición
            }
            .searchable(text: $busqueda, prompt: "Buscar por apellido")
            .navigationTitle("📋 Alumnos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button {
                        asignarCursoDemo()
                    } label: {
                        Label("Curso demo", systemImage: "book")
                    }
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 10) {
                    Text("👤 Detalles del Alumno")
                        .font(.title2)
                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
                    Text("Curso: \(alumno.curso?.nombre ?? "Sin curso")")
                    Button("Editar") {
                        alumnoAEditar = alumno
                    }
                }
                .padding()
            } else {
                Text("Selecciona un alumno")
            }
        }
        // Formulario de nuevo alumno como hoja flotante
        .sheet(isPresented: $mostrarFormulario) {
            NuevoAlumnoView()
        }
        // Formulario de edición
        .sheet(item: $alumnoAEditar) { alumno in
            EditarAlumnoView(alumno: alumno)
        }
    }

    // DELETE: eliminar uno o más alumnos desde la lista
    // Se usan los índices de alumnosFiltrados porque son los que se ven en pantalla
    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let alumno = alumnosFiltrados[index]
                if alumnoSeleccionado == alumno { alumnoSeleccionado = nil }
                modelContext.delete(alumno)
            }
        }
    }

    // DEMOSTRACIÓN de relación: crea un curso y se lo asigna a todos los alumnos
    private func asignarCursoDemo() {
        let curso = Curso(nombre: "Programación en Móviles")
        modelContext.insert(curso)
        for alumno in alumnos {
            alumno.curso = curso
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
