**Requerimientos Funcionales (RF)**

* **Campo: Gestión de Red y Transporte Multimodal**
  * **RF-01 (Cobertura de Red):** Registro de las líneas de tren elevado y subterráneo (Línea 1, Línea 2, Línea 3, Línea 4) y la línea BRT (Metropolitano).
  * **RF-02 (Estado Operativo):** Clasificación del estado de servicio de cada estación (*En operación*, *En construcción*, *En proyecto*).
  * **RF-03 (Transbordos e Intersecciones):** Registro explícito de puntos de intercambio entre líneas (ej. *Estación Central*, *La Cultura*, *Carmen de la Legua*, *28 de Julio*).

* **Campo: Búsqueda y Navegación**
  * **RF-04 (Búsqueda de Estaciones):** Localización por coincidencia parcial de texto con insensibilidad a tildes, mayúsculas y espacios.
  * **RF-05 (Mapeo de Destinos):** Resolución de alias urbanos y puntos de interés clave hacia su estación correspondiente.
  * **RF-06 (Cálculo de Adyacencia):** Determinación dinámica de la estación inmediata anterior y siguiente según el sentido de la ruta.

* **Campo: Visualización y Presentación**
  * **RF-07 (Modos de Despliegue):** Opción para listar estaciones en orden de recorrido real (terminal a terminal) o en orden alfabético (A-Z).
  * **RF-08 (Ficha Informativa):** Visualización de metadatos de la estación (línea, color, accesibilidad de ascensor, información/advertencia y conexiones disponibles).

---

**Requerimientos No Funcionales (RNF)**

* **Campo: Arquitectura y Entorno**
  * **RNF-01 (Lenguaje de Desarrollo):** Código fuente nativo implementado en Swift 5+.
  * **RNF-02 (Interfaz de Usuario):** Interfaz de línea de comandos (CLI) síncrona interactiva.

* **Campo: Rendimiento y Calidad**
  * **RNF-03 (Procesamiento en Memoria):** Búsquedas, filtrados y cálculos inmediatos sin latencia de red.
  * **RNF-04 (Sanitización de Cadenas):** Normalización de entradas para garantizar tolerancia a errores de tipeo o formato.

---

**Nuevos Requerimientos Agregados (Última Actualización)**

* **Integración del Metropolitano (BRT):** Incorporación del sistema de buses con sus paraderos clave y nodos de enlace subterráneos.
* **Ordenamiento Dual por Línea:** Selección entre vista por recorrido de trenes/buses o vista alfabética A-Z.
* **Mapeo de Estaciones Adyacentes:** Mapeo automático de paradas vecinas (anterior/siguiente) en las fichas de consulta.
* **Atajos de Destinos Populares:** Reconocimiento de consultas como "Aeropuerto", "Gamarra", "Naranjal" o "Ate" para dirigir al usuario a la estación correcta.
