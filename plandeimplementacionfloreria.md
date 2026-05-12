# 🌸 Plan de Implementación: Florería - Aura

Este documento describe el procedimiento paso a paso para desarrollar la aplicación multiplataforma **Florería - Aura** con Flutter, Dart y Firebase. No contiene código fuente; su objetivo es servir como hoja de ruta estructurada para guiar el desarrollo de forma ordenada, escalable y profesional.

---

## 1. 🛠️ Preparación del Entorno de Desarrollo
1. **Instalar y verificar herramientas base**
   - Flutter SDK (última versión estable)
   - Dart SDK (incluido con Flutter)
   - Android Studio (solo para SDKs y emuladores) o Xcode (para iOS en macOS)
   - VS Code como IDE principal
2. **Configurar VS Code para Flutter**
   - Instalar extensiones oficiales: `Flutter`, `Dart`, `Error Lens`, `Pubspec Assist`, `Firebase`, `GitLens`
   - Habilitar formato automático al guardar (`dart.formatOnSave`)
   - Configurar `flutter doctor` hasta obtener ✅ en todas las plataformas objetivo
3. **Nota sobre "Antigravity"**
   - No existe un IDE oficial llamado "Antigravity" en el ecosistema Flutter. Si te referías a **Android Studio**, **IntelliJ** o un editor personalizado, confirma el nombre para ajustar recomendaciones. Por ahora, el plan se basa en **VS Code**.

---

## 2. 🏗️ Arquitectura y Estructura del Proyecto
1. **Patrón recomendado**: MVVM (Model-View-ViewModel) adaptado con `provider` para separación clara entre UI, lógica de presentación y datos.
2. **Estructura de carpetas propuesta**
   ```
   lib/
   ├── core/          (constantes, temas, utilidades, errores, rutas)
   ├── data/          (repositorios, modelos, servicios Firebase)
   ├── presentation/  (widgets, screens, providers, controllers)
   └── main.dart      (entry point, inicialización de Firebase y Provider)
   ```
3. **Flujo de datos**
   - Firebase → Repositorios → Notifiers (Provider) → UI
   - Todas las mutaciones de estado pasan por `ChangeNotifier` o `Provider`

---

## 3. 🎨 Diseño UI/UX
1. **Identidad visual de "Aura"**
   - Paleta: tonos pastel, verdes suaves, blancos, acentos dorados o terracota
   - Tipografía: una serif elegante para títulos, sans-serif legible para cuerpo
   - Iconografía: lineal, minimalista, temática floral/natural
2. **Fases de diseño**
   - Low-fidelity wireframes (flujo de navegación, mapas de pantallas)
   - High-fidelity mockups (Figma o Adobe XD)
   - Diseño de componentes reutilizables: botones, cards, inputs, banners, estados de carga/vacío/error
3. **Principios UX aplicados**
   - Accesibilidad (contraste, tamaños de texto dinámicos, etiquetas semánticas)
   - Navegación intuitiva (≤3 clics para llegar a checkout)
   - Feedback visual inmediato (transiciones, skeletons, toasts)

---

## 4. 🔥 Configuración de Firebase
1. Crear proyecto en Firebase Console con nombre `floreria-aura`
2. Registrar aplicaciones: Android, iOS y Web (si aplica)
3. Descargar y colocar archivos de configuración:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
4. Habilitar servicios:
   - Authentication (Email/Password)
   - Firestore Database (modo prueba inicial, luego reglas estrictas)
   - Cloud Storage (para imágenes de flores)
   - Crashlytics & Analytics (monitoreo)
5. Ejecutar `flutterfire configure` para generar `firebase_options.dart`

---

## 5. 🔐 Autenticación (Email & Contraseña)
1. **Flujo definido**
   - Registro → Verificación de correo → Inicio de sesión → Recuperación de contraseña → Cierre de sesión
2. **Validaciones y seguridad**
   - Validación en tiempo real de formato de email y fortaleza de contraseña
   - Manejo de errores específicos de Firebase (usuario existente, contraseña incorrecta, red no disponible)
   - Persistencia de sesión automática (Firebase Auth lo maneja nativamente)
3. **Integración con Provider**
   - `AuthProvider` escuchará `FirebaseAuth.instance.authStateChanges()`
   - Exponer estados: `loading`, `authenticated`, `unauthenticated`, `error`
   - Router condicional según estado de autenticación

---

## 6. 🗄️ Estructura de Base de Datos (Firestore)
1. **Colecciones principales**
   - `users`: `{ uid, name, email, phone, address, createdAt, role }`
   - `products`: `{ id, name, description, price, category, stock, imageUrl, isActive, createdAt }`
   - `orders`: `{ id, userId, items[], total, status, paymentMethod, createdAt, deliveryDate }`
   - `categories`: `{ id, name, icon, displayOrder }`
2. **Reglas de seguridad iniciales**
   - Solo usuarios autenticados pueden leer productos
   - Cada usuario solo puede leer/escribir sus propios pedidos y perfil
   - Admins (rol definido en `users.role`) pueden gestionar productos
3. **Optimización**
   - Indexar campos frecuentemente consultados (`category`, `isActive`, `userId`)
   - Usar subcolecciones solo cuando la relación sea 1:N claro y el acceso sea independiente

---

## 7. 📦 Dependencias (`pubspec.yaml`)
*(Listado conceptual por categoría. Las versiones se ajustarán al momento de la implementación)*

| Categoría | Paquetes | Propósito |
|-----------|----------|-----------|
| **Firebase** | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_crashlytics`, `firebase_analytics` | Backend y servicios cloud |
| **Estado** | `provider`, `flutter_riverpod` (opcional) o `freezed` + `json_serializable` | Gestión de estado y modelos inmutables |
| **UI/UX** | `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `lottie`, `flutter_slidable` | Tipografía, imágenes, animaciones, componentes |
| **Formularios/Validación** | `flutter_form_builder`, `form_builder_validators`, `intl` | UX de inputs y manejo de fechas/moneda |
| **Navegación/Rutas** | `go_router` o `auto_route` | Enrutamiento declarativo y protegido |
| **Utilidades** | `uuid`, `connectivity_plus`, `shared_preferences`, `url_launcher` | Offline, IDs, preferencias locales, enlaces externos |
| **Dev/Testing** | `mockito`, `bloc_test` (si aplica), `flutter_lints` | Pruebas y linting estricto |

**Procedimiento de instalación**:
1. Ejecutar `flutter create floreria_aura`
2. Abrir `pubspec.yaml` y agregar dependencias agrupadas por sección
3. Ejecutar `flutter pub get`
4. Verificar compatibilidad con `flutter analyze`

---

## 8. 📱 Desarrollo de Pantallas y Funcionalidades (Orden Secuencial)
1. **Pantalla de Bienvenida / Onboarding** (opcional, 1-3 slides)
2. **Autenticación**
   - Login
   - Registro
   - Recuperación de contraseña
3. **Navegación principal**
   - BottomNavigationBar: Inicio, Catálogo, Carrito, Perfil
4. **Catálogo**
   - Lista/Grid de productos con filtros por categoría
   - Búsqueda y ordenamiento (precio, novedad)
5. **Detalle de Producto**
   - Galería de imágenes, descripción, selector de cantidad, botón "Agregar"
6. **Carrito**
   - Lista editable, cálculo de total, cupones (futuro), proceder a checkout
7. **Checkout**
   - Dirección de entrega, fecha/hora, resumen, confirmación
8. **Perfil de Usuario**
   - Datos personales, historial de pedidos, cerrar sesión
9. **Panel Admin** (fase 2)
   - CRUD de productos, gestión de pedidos, métricas básicas

---

## 9. 🔌 Integración con Provider
1. Crear `AppProvider` como contenedor raíz (`MultiProvider`)
2. Definir providers especializados:
   - `AuthProvider` (estado de sesión)
   - `ProductProvider` (catálogo, filtros, carrito)
   - `OrderProvider` (creación, seguimiento)
   - `ThemeProvider` (modo claro/oscuro, fuentes)
3. **Patrones de uso**
   - `Consumer` o `Provider.of(context, listen: false)` según necesidad
   - `Selector` para evitar rebuilds innecesarios
   - Notificar cambios solo cuando el estado relevante muté
4. **Ciclo de vida**
   - Inicializar providers en `main()` o en un `AppInitializer`
   - Disponer recursos en `dispose()` cuando aplique

---

## 10. 🧪 Pruebas y Calidad
1. **Entorno de desarrollo local**
   - Usar Firebase Emulator Suite para Auth, Firestore y Storage
   - Simular estados de red (offline, latencia) con herramientas nativas
2. **Tipos de pruebas**
   - Unit: lógica de negocio, validaciones, transformación de modelos
   - Widget: renders de componentes, estados de carga/error, interacciones táctiles
   - Integration: flujos completos (login → agregar al carrito → checkout simulado)
3. **Herramientas**
   - `flutter test`, `flutter drive`
   - `mockito` para repositorios ficticios
   - Firebase Test Lab para dispositivos reales en la nube

---

## 11. 🚀 Despliegue y Publicación
1. **Preparación de builds**
   - Configurar `android/app/build.gradle` y `ios/Runner` para versiones y signing
   - Optimizar imágenes y assets con `flutter pub run flutter_launcher_icons` y compresión
2. **Publicación**
   - Google Play Console: crear app, subir `app-release.aab`, completar ficha
   - App Store Connect: generar certificados, perfiles, subir vía `xcrun altool` o Xcode
3. **CI/CD básico**
   - GitHub Actions o Codemagic para build automático en pushes a `main`
   - Ejecutar `flutter analyze` y `flutter test` en pipeline
   - Generar artefactos listos para distribución interna (TestFlight / Play Internal Testing)

---

## 12. 📈 Mantenimiento y Escalabilidad
1. **Monitoreo en producción**
   - Crashlytics para reportes de fallos
   - Analytics para métricas de retención, conversión de carrito, uso de categorías
2. **Seguridad continua**
   - Rotar claves API si se exponen accidentalmente
   - Revisar reglas de Firestore mensualmente
   - Validar entradas en backend mediante Cloud Functions (futuro)
3. **Actualizaciones**
   - Mantener `pubspec.yaml` actualizado con `flutter pub upgrade`
   - Planificar releases cada 3-4 semanas con changelog público
4. **Escalabilidad**
   - Implementar Cloud Functions para pagos, notificaciones push y validación de stock
   - Migrar a `Riverpod` o `BLoC` si la complejidad del estado crece significativamente

---

## ✅ Próximos Pasos
1. Validar y ajustar este plan según alcance inicial (MVP vs. versión completa)
2. Definir wireframes en Figma y aprobar paleta/typografía
3. Configurar proyecto Flutter + Firebase en tu máquina
4. Confirmar versión de Flutter/Dart y sistema operativo para afinar dependencias
5. Cuando estés listo, solicitaré el código base estructurado por fases (auth → catálogo → carrito → checkout), comenzando por `pubspec.yaml`, `main.dart`, y la arquitectura de providers.

¿Deseas que ajustemos el alcance del MVP, agreguemos un flujo de pagos específico, o prefieres avanzar a la generación del código de la **Fase 1: Configuración + Autenticación**?
