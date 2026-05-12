# 🌸 Documento de Planificación Maestro: Proyecto Aura

Bienvenido al proceso de arquitectura de **Aura**. Como tu mentor, he estructurado esta hoja de ruta para que cada capa del proyecto tenga una responsabilidad clara, la curva de aprendizaje sea suave y la base técnica sea lo suficientemente sólida para escalar sin dolores de cabeza futuros. Este documento es tu brújula: léelo con calma, internaliza la separación de responsabilidades y no avances a la codificación hasta dominar la lógica descrita.

---

## 1. Estructura de Carpetas y Documentos

La organización es el primer pilar de un software mantenible. En Flutter, la separación física entre **datos**, **lógica** y **presentación** evita que un proyecto se convierta en un laberinto. A continuación se presenta una arquitectura limpia y modular, diseñada específicamente para evitar dependencias externas de estado y fomentar la comprensión nativa.

### Representación Visual de la Jerarquía
```
lib/
├── config/                 # Configuraciones globales inmutables
├── models/                 # Definición de entidades (clases de datos)
├── services/               # Lógica de negocio, comunicación con Firestore y Firebase
├── controllers/            # Gestión de estado nativa (ValueNotifier, ChangeNotifier)
├── views/                  # Pantallas completas (rutas navegables)
│   ├── auth/
│   ├── dashboard/
│   ├── inventory/
│   ├── sales/
│   └── clients/
├── widgets/                # Componentes reutilizables (no son pantallas)
│   ├── cards/
│   ├── forms/
│   ├── dialogs/
│   └── common/
├── utils/                  # Funciones auxiliares, validaciones, formateadores
└── main.dart               # Punto de entrada e inicialización de Firebase
```

### Propósito de Cada Carpeta
- **`config/`**: Centraliza rutas de navegación, temas globales (colores, tipografías, espaciados) y constantes de la aplicación. Un desarrollador junior solo debe modificar un archivo aquí para cambiar el color principal o agregar una nueva ruta.
- **`models/`**: Define la estructura de los datos que viajan por la app. Cada archivo representa una entidad (ej. `articulo_model.dart`). Aquí se implementan métodos simples para convertir documentos de Firestore a objetos Dart (`fromJson`) y viceversa (`toJson`).
- **`services/`**: El cerebro de la aplicación. Contiene clases estáticas o con instancias únicas que interactúan con Firebase, realizan cálculos, validan reglas de negocio y orquestan transacciones. **No tocan la UI directamente**.
- **`controllers/`**: Reemplaza a `provider`. Utiliza `ValueNotifier` y `ChangeNotifier` de Flutter puro. Su única responsabilidad es observar cambios en los servicios y notificar a la interfaz. Mantén la lógica compleja fuera de ellos; solo deben exponer variables reactivas.
- **`views/`**: Aquí viven las pantallas. Cada carpeta agrupa pantallas relacionadas con un módulo. Las vistas consumen `controllers` mediante `ValueListenableBuilder` o `StreamBuilder` nativos. Nunca contienen lógica de negocio.
- **`widgets/`**: Bloques de construcción reutilizables. Ejemplo: una tarjeta de producto, un campo de texto con validación, un botón estilizado. Si un componente se repite en más de dos pantallas, extraelo aquí.
- **`utils/`**: Herramientas transversales: formateo de fechas, validación de RFC/correo, conversiones de moneda, manejo de errores genéricos.
- **`main.dart`**: Inicializa Firebase, configura el tema global y lanza el primer `MaterialApp`. Debe permanecer minimalista.

---

## 2. Identidad Visual (Paleta Lila/Morada) y UX

La experiencia de usuario en una floristería debe transmitir elegancia, calma y profesionalismo. El uso estratégico del lila y morado evita la saturación visual y guía la atención del usuario hacia las acciones importantes.

### Paleta de Colores Propuesta
- **Primario (Fondo Oscuro/Encabezados)**: Morado Profundo (`#4A235A`). Transmite solidez y se usa en barras de navegación, pies de página y modales.
- **Secundario (Acentos/Selección)**: Lavanda Suave (`#C39BD3`). Para bordes activos, estados de hover, chips de categorías y resaltados sutiles.
- **Fondo Base**: Lila Muy Claro (`#F4ECF7`) o Blanco Puro (`#FFFFFF`). Garantiza legibilidad y reduce fatiga visual en entornos de trabajo prolongados.
- **Texto Claro sobre Fondo Oscuro**: Blanco Neutro (`#FFFFFF`).
- **Texto Oscuro sobre Fondo Claro**: Carbón Suave (`#2C3E50`). Nunca negro puro (`#000000`) para evitar contraste excesivo y fatiga.

### Reglas de Contraste y Aplicación UX
1. **Botones de Acción Primaria**: Fondo Morado Profundo, texto blanco, bordes redondeados (8-12px). Al presionar, cambia a un tono ligeramente más claro o agrega una sombra interna sutil.
2. **Botones Secundarios/Cancelación**: Fondo transparente, borde Lavanda, texto Morado Profundo. Mantienen la jerarquía sin competir con la acción principal.
3. **Encabezados**: Barra superior fija en Morado Profundo con título en blanco. Incluye indicador de progreso o estado del módulo actual en color Lavanda para contexto visual.
4. **Estados de Selección**: Campos activos reciben un borde Lavanda de 2px y un fondo ligeramente más claro (`#F9F1FA`). Campos con error usan un tono coral suave (`#E74C3C`) para alertas no intrusivas.
5. **Espaciado y Jerarquía**: Aplica el sistema 8pt (múltiplos de 8). Márgenes generosos entre tarjetas de productos, líneas de división sutiles en listas, y tipografía clara: títulos grandes y oscuros, descripciones en gris medio.
6. **Accesibilidad**: Verifica siempre el ratio de contraste mínimo (4.5:1 para texto normal). Los iconos deben tener etiquetas semánticas. Evita depender solo del color para transmitir información (ej. añadir un icono de check junto al color de estado "vendido").

---

## 3. Arquitectura de Datos en Firestore (Tablas y Campos)

Firestore es una base de datos documental. En lugar de "tablas relacionales", trabajamos con **colecciones** que contienen **documentos JSON**. Cada documento es independiente, pero se vincula mediante identificadores de referencia. A continuación, la estructura exhaustiva para Aura.

### Colección: `articulos`
| Campo             | Tipo     | Descripción                                                                 |
|-------------------|----------|-----------------------------------------------------------------------------|
| `id`              | String   | Identificador único generado por la app.                                    |
| `nombre`          | String   | Nombre comercial (ej. "Rosa Blanca Premium").                               |
| `descripcion`     | String   | Detalles de cuidado, origen o temporada.                                    |
| `precio`          | Number   | Precio unitario con dos decimales.                                          |
| `stock`           | Number   | Cantidad disponible en inventario.                                          |
| `categoria_id`    | String   | Referencia al documento correspondiente en `categorias`.                    |
| `imagen_url`      | String   | URL directa a la imagen alojada en GitHub (raw).                            |

### Colección: `categorias`
| Campo               | Tipo     | Descripción                                      |
|---------------------|----------|--------------------------------------------------|
| `id`                | String   | ID único.                                        |
| `nombre_categoria`  | String   | Ej. "Interior", "Exterior", "Bodas", "Suculentas"|
| `descripcion`       | String   | Breve explicación del uso o características.     |
| `color_identificador`| String  | Código HEX asociado para filtrado visual en UI.  |

### Colección: `clientes`
| Campo             | Tipo     | Descripción                          |
|-------------------|----------|--------------------------------------|
| `id`              | String   | ID único.                            |
| `nombre_completo` | String   | Nombre legal o comercial.            |
| `telefono`        | String   | Formato internacional preferido.     |
| `correo`          | String   | Contacto principal.                  |
| `fecha_registro`  | DateTime | Marca de tiempo automática.          |

### Colección: `empleados`
| Campo           | Tipo     | Descripción                                      |
|-----------------|----------|--------------------------------------------------|
| `id`            | String   | ID único.                                        |
| `nombre`        | String   | Nombre completo.                                 |
| `puesto`        | String   | Cajero, Vendedor, Administrador, Jardinería.     |
| `correo`        | String   | Email corporativo o personal vinculado.          |
| `nivel_acceso`  | String   | `admin`, `vendedor`, `cajero`, `solo_lectura`.   |

### Colección: `ventas`
| Campo                 | Tipo     | Descripción                                                                 |
|-----------------------|----------|-----------------------------------------------------------------------------|
| `id`                  | String   | ID único de transacción.                                                    |
| `cliente_id`          | String   | Referencia a `clientes`. Puede ser "publico_general".                       |
| `empleado_id`         | String   | Responsable de la venta.                                                    |
| `fecha`               | DateTime | Fecha y hora exacta de confirmación.                                        |
| `total`               | Number   | Sumatoria calculada de todos los artículos.                                 |
| `estado`              | String   | `pendiente`, `completada`, `cancelada`, `devolucion`.                       |
| `articulos_vendidos`  | Array    | Lista de mapas. Cada mapa contiene: `articulo_id`, `nombre`, `cantidad`, `precio_unitario`, `subtotal`. |

### Colección: `proveedores`
| Campo             | Tipo     | Descripción                              |
|-------------------|----------|------------------------------------------|
| `id`              | String   | ID único.                                |
| `nombre_empresa`  | String   | Razón social del proveedor.              |
| `contacto`        | String   | Persona asignada.                        |
| `telefono`        | String   | Línea directa o celular.                 |
| `rfc`             | String   | Registro Fiscal (si aplica facturación). |

### Colección: `facturas`
| Campo           | Tipo     | Descripción                          |
|-----------------|----------|--------------------------------------|
| `id`            | String   | ID único.                            |
| `venta_id`      | String   | Vinculación con la transacción.      |
| `numero_factura`| String   | Folio fiscal o interno.              |
| `fecha_emision` | DateTime | Fecha de generación del comprobante. |
| `estado_pago`   | String   | `pagada`, `pendiente`, `cancelada`.  |

**Nota Arquitectónica**: Los campos `fecha` y `total` en ventas deben calcularse en el cliente antes de enviar, pero validarse en el servicio antes de confirmar. El array `articulos_vendidos` se usa en lugar de subcolecciones para evitar lecturas adicionales innecesarias en una floristería con transacciones de tamaño medio. Si la escala crece a miles de ítems por venta, se migraría a subcolección.

---

## 4. Integración con Firebase y Gestión de Imágenes desde GitHub

### Conexión con Firebase para Principiantes
1. **Consola Firebase**: Crea un nuevo proyecto y habilita Firestore Database, Authentication y Cloud Functions (si se requieren en el futuro). Configura las reglas de seguridad para que solo usuarios autenticados puedan leer/escribir colecciones.
2. **CLI y Configuración**: Instala Firebase CLI en tu sistema. Ejecuta el comando de configuración de Flutter que detecta automáticamente las plataformas activadas (Android, iOS, Web). Este paso genera archivos de configuración nativos (`google-services.json`, `GoogleService-Info.plist`, `firebase.json`) que se colocan en las rutas correctas de cada plataforma.
3. **Inicialización en Código**: En `main.dart`, se invoca la inicialización de Firebase antes de ejecutar cualquier widget. Se asegura que la app falle con un mensaje claro si la configuración no se carga, evitando pantallas en blanco.
4. **Autenticación**: Se habilita el método correo/contraseña y, opcionalmente, inicio de sesión con Google para empleados. Los tokens se manejan automáticamente por el SDK.

### Método para Imágenes desde GitHub
Guardar imágenes en Firebase Storage genera costos por lectura/almacenamiento y complejidad de reglas. Una alternativa viable para un catálogo estático o de actualización controlada es alojarlas en un repositorio de GitHub público.

**Proceso Técnico**:
1. Crea un repositorio dedicado (ej. `aura-floreria-assets`) con carpetas organizadas (`/flores/`, `/plantas/`, `/macetas/`).
2. Sube las imágenes en formato optimizado (JPG/WebP, máximo 500KB).
3. Genera la URL directa usando el dominio `raw.githubusercontent.com/usuario/repositorio/rama/ruta/imagen.jpg`. Esta URL es servida por la CDN de GitHub, es pública, cacheable y no requiere autenticación.
4. En Firestore, guarda esa URL exacta como un string en el campo `imagen_url` del documento correspondiente.
5. En la app, el widget de imagen lee el string y lo descarga dinámicamente. Al actualizar un producto, solo cambias la URL en Firestore; si subes una nueva imagen al mismo nombre en GitHub, la CDN puede cacheear la vieja, por lo que se recomienda usar nombres únicos con versión (ej. `rosa_v2.jpg`) o invalidar caché manualmente en la app si es crítico.

**Ventaja**: Cero costo de almacenamiento, velocidad de CDN global, fácil versionado con Git.
**Precaución**: GitHub impone límites de ancho de banda para uso comercial masivo. Para una floristería local o mediana, es más que suficiente. Si el tráfico escala exponencialmente, se migra a un servicio de imágenes dedicado.

---

## 5. Dependencias Críticas (pubspec.yaml)

La siguiente lista contiene únicamente las librerías esenciales para mantener el proyecto ligero, estable y sin sobrecarga de dependencias externas.

- **`firebase_core`**: Inicializa el ecosistema Firebase en todas las plataformas. Es el cimiento obligatorio antes de usar cualquier otro servicio.
- **`cloud_firestore`**: SDK oficial para interactuar con la base de datos NoSQL. Permite consultas, escucha en tiempo real, transacciones y paginación.
- **`firebase_auth`**: Maneja el registro, inicio de sesión, recuperación de contraseña y gestión de sesiones de empleados y cajeros.
- **`cached_network_image`**: Descarga imágenes desde URLs externas (como las de GitHub), las almacena en el disco del dispositivo y las reutiliza. Reduce consumo de datos y mejora drásticamente el rendimiento en listas.
- **`intl`**: Formato de fechas, números y monedas. Esencial para presentar precios en formato local (ej. `$150.00 MXN`) y fechas legibles (`13 de mayo de 2026`).
- **`go_router`**: Enrutamiento declarativo y tipado. Simplifica la navegación entre vistas, manejo de parámetros en la URL y protección de rutas según nivel de acceso.
- **`uuid`**: Generación de identificadores únicos del lado del cliente para artículos, ventas y clientes antes de enviarlos a Firestore, evitando colisiones.
- **`flutter_native_splash`**: Configura la pantalla de carga inicial con el logo de Aura y colores de la paleta. Mejora la percepción de rendimiento.
- **`http`**: Utilitario para peticiones REST si se requiere integrar APIs externas de logística o proveedores en el futuro. No es crítico en la fase 1, pero se mantiene por escalabilidad.

---

## 6. Plan de Desarrollo Paso a Paso (Fases Detalladas)

### 🔹 Fase 1: Preparación y Configuración Inicial
**Base de Datos**: Crea las colecciones en Firestore. Define índices compuestos para búsquedas frecuentes (ej. `categoria_id + precio`, `nombre`). Establece reglas de seguridad básicas: lectura pública para catálogo, escritura solo autenticada.
**UI**: Diseña el esqueleto de navegación con `go_router`. Crea un `Scaffold` maestro que contenga la barra superior lila, el área de contenido y un menú lateral o inferior según la plataforma. Implementa el tema global con la paleta definida.
**Servicios**: Configura un servicio de inicialización que verifique la conexión a Firebase antes de mostrar el dashboard. Prepara un utilitario de manejo de errores que capture excepciones de red y muestre mensajes amigables.

### 🔹 Fase 2: Autenticación y Control de Acceso
**Base de Datos**: Vincula el documento de `empleados` con el `uid` de Firebase Auth. Agrega un campo `activo: true/false` para revocar accesos sin eliminar el registro.
**UI**: Construye la vista de login con validación en tiempo real. Usa `ValueListenableBuilder` nativo para reaccionar al estado de carga del botón "Ingresar". Incluye una pantalla de registro exclusivo para administradores.
**Servicios**: Crea `AuthService`. Maneja el flujo de sesión, guarda el `nivel_acceso` localmente tras el login, y implementa un interceptor de rutas que redirija a usuarios no autenticados al login. Añade cierre de sesión seguro y limpieza de caché local sensible.

### 🔹 Fase 3: Gestión de Inventario (Artículos, Categorías, Proveedores)
**Base de Datos**: Mapea cada formulario a la estructura JSON definida. Usa IDs generados por `uuid`. Para categorías, implementa un sistema de color que guarde el HEX y lo reutilice en la UI.
**UI**: Jerarquía de widgets:
  - `ProductCard`: Muestra imagen (desde GitHub), nombre, stock y precio. Usa `Stack` para un badge de "Bajo Stock" si es menor a 5.
  - `InventoryForm`: Formulario reutilizable para crear/editar. Campos con validación nativa. Selector de categoría que carga dinámicamente desde Firestore.
  - `CategoryFilter`: Barra horizontal con chips coloreados según `color_identificador`.
**Servicios**: `InventoryService` maneja CRUD completo. Implementa paginación con `limit` y `startAfter` para listas largas. Crea funciones de búsqueda que filtren por nombre, categoría o proveedor. Centraliza la lógica de carga de imágenes con fallback a un placeholder lila si la URL falla.

### 🔹 Fase 4: Ventas y Facturación
**Base de Datos**: La colección `ventas` se popula mediante un documento maestro y un array de ítems. `facturas` se crea tras el pago, vinculando `venta_id`. Los estados se actualizan en cascada.
**UI**: 
  - `CartView`: Lista de productos agregados. Permite ajustar cantidades, mostrar subtotal por ítem y total general. Usa `SliverList` para rendimiento en pantallas grandes (Windows/Web).
  - `CheckoutDialog`: Modal con selección de cliente, método de pago y confirmación. Botón principal deshabilitado hasta que todo sea válido.
  - `SalesHistory`: Tabla adaptable con filtros por fecha, empleado y estado.
**Servicios**: `SalesService` es el núcleo crítico. Al confirmar la venta, **usa una transacción de Firestore** para:
  1. Leer el stock actual de cada artículo.
  2. Validar que la cantidad solicitada no exceda el disponible.
  3. Restar el stock de forma atómica.
  4. Crear el documento de `venta` con el array de ítems.
  5. (Opcional) Generar documento preliminar de `factura`.
  La transacción garantiza que dos cajeros no vendan el mismo ramo simultáneamente, evitando stock negativo.

---

## 7. Recomendaciones de Nivel Senior

### Optimización de Imágenes Externas
- **Formato y Peso**: Convierte todas las fotos a WebP. Mantén un ancho máximo de 800px y comprime con herramientas antes de subir a GitHub. La CDN de GitHub no redimensiona dinámicamente, por lo que subir la versión final optimizada es crucial.
- **Caché Inteligente**: `cached_network_image` permite configurar tamaño de caché y política de revalidación. Úsalo para evitar descargas repetidas. Implementa un placeholder de color lavanda con un icono de flor que desaparezca suavemente al cargar la imagen real.
- **Gestión de Versiones**: Si una imagen cambia frecuentemente, añade un parámetro query dummy a la URL (ej. `?v=1`) para forzar actualización en caché sin romper el enlace.

### Manejo de Errores y Resiliencia
- **Reintentos con Backoff**: En operaciones de red (consultar Firestore, cargar imagen), implementa un sistema de reintentos con espera exponencial. Firestore ya lo hace internamente, pero para imágenes externas necesitas tu propia lógica.
- **Persistencia Offline**: Activa la caché local de Firestore. Esto permite que la app siga leyendo inventario y vendiendo (con transacciones locales) si se cae el Wi-Fi. Sincroniza automáticamente al recuperar conexión.
- **Feedback al Usuario**: Nunca dejes un botón en estado "cargando" sin texto o indicador visual. Usa `SnackBar` para éxito, `AlertDialog` para errores críticos y validaciones en tiempo real en formularios. Los mensajes deben ser accionables: "No se pudo conectar. Verifica tu red y toca Reintentar".

### Trucos de Arquitectura para Escalabilidad
- **Inyección de Dependencias Simple**: En lugar de pasar servicios manualmente por cada constructor, crea un archivo `locator.dart` que instancie una vez cada servicio (usando `late final` o un patrón singleton controlado). Esto facilita pruebas unitarias y evita acoplamiento.
- **Separación Estricta de Capas**: Un `view` nunca debe importar `cloud_firestore` directamente. Solo interactúa con `controllers`, que llaman a `services`. Si rompes esta regla, el proyecto se volverá imposible de mantener en 6 meses.
- **Uso de `ValueNotifier` Nativo**: Reemplaza la mentalidad de "gestores globales". Cada pantalla o widget complejo puede tener su propio `ValueNotifier` para estado local. Para estado compartido, usa un servicio que exponga un `Stream` o un `ValueNotifier` público. Esto es más predecible que paquetes mágicos y enseña cómo funciona Flutter por dentro.
- **Índices y Consultas**: Firestore cobra por lecturas. Nunca uses `get()` para traer una colección entera y filtrar en el cliente. Usa `where()`, `orderBy()` y `limit()`. Planifica los índices compuestos con anticipación; la consola de Firebase te avisará si falta uno con un enlace directo para crearlo.
- **Pruebas y Documentación**: Documenta cada servicio con comentarios que expliquen el "porqué", no el "qué". Escribe pruebas unitarias para `SalesService` (especialmente la transacción de stock) y `InventoryService`. Un junior que lea estas pruebas entenderá la lógica de negocio sin tocar la UI.

---

## Lizet Alejandra Silva Martinez 6J
