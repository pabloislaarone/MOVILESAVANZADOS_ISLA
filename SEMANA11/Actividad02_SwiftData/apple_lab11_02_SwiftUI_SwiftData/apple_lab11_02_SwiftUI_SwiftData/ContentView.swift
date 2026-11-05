import SwiftUI
import SwiftData // Para consultar y manipular datos persistentes

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // Contexto: insertar, borrar, guardar

    // READ: consulta automática de todos los alumnos ordenados por apellido
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]

    @State private var alumnoSeleccionado: Alumno? // Alumno seleccionado en la lista
    @State private var mostrarFormulario = false   // Muestra el formulario de nuevo alumno

    var body: some View {
        NavigationSplitView { // Lista a la izquierda, detalle a la derecha
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnos) { alumno in
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
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                VStack(alignment: .leading, spacing: 10) {
                    Text("👤 Detalles del Alumno")
                        .font(.title2)
                    Text("Nombre: \(alumno.nombre)")
                    Text("Apellido: \(alumno.apellido)")
                    Text("DNI: \(alumno.dni)")
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
    }

    // DELETE: eliminar uno o más alumnos desde la lista
    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let alumno = alumnos[index]
                if alumnoSeleccionado == alumno { alumnoSeleccionado = nil }
                modelContext.delete(alumno)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Alumno.self], inMemory: true)
}
