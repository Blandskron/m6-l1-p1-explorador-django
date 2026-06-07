# Explorador de Arquitectura y Flujo de Django

Proyecto didáctico **mínimo** para observar de manera práctica y visual cómo funciona Django internamente desde que llega una URL (HTTP Request) hasta que se renderiza un template y se genera el HTML de respuesta (HTTP Response).

---

## 📂 Estructura del Proyecto

Este proyecto está organizado bajo una arquitectura monolítica clásica:

* `explorador_django/`: Directorio raíz del proyecto Django (configuraciones, enrutador global `urls.py`, `settings.py`).
* `arquitectura/`: Aplicación modular de Django que maneja el enrutamiento interno, vistas (`views.py`), modelos (`models.py`) y pruebas (`tests.py`).
* `templates/`: Plantillas HTML organizadas con herencia de componentes (`base.html` y plantillas de vista).
* `Dockerfile` & `docker-compose.yml`: Configuración de dockerización para automatizar el desarrollo.
* `introduccion_django.md`: Guía de estudio teórica sobre conceptos clave de Django, arquitectura MTV y entornos virtuales.
* `docker_guide.md`: Guía didáctica específica sobre el uso y configuración de Docker para estudiantes.

---

## ⚡ Opción A: Ejecución Rápida con Docker (Recomendado)

La vía más rápida e independiente del sistema operativo. No requiere instalar Python o Django en tu máquina real, solo tener instalado [Docker Desktop](https://www.docker.com/products/docker-desktop/).

### 1. Iniciar el contenedor
Abre la terminal en la carpeta raíz del proyecto y ejecuta:
```bash
docker compose up --build
```
*Este comando compilará la imagen de Python, instalará las librerías, aplicará las migraciones y configurará un superusuario administrador automáticamente.*

### 2. Acceder a la aplicación
* **Sitio Web:** [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
* **Panel de Administración:** [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/)
  * **Usuario:** `admin`
  * **Contraseña:** `adminpass123`

### 3. Detener la ejecución
Para detener los contenedores y liberar los puertos, presiona `CTRL + C` en tu terminal, o ejecuta:
```bash
docker compose down
```

---

## 🛠️ Opción B: Ejecución en Entorno Local (Tradicional)

Si prefieres ejecutar el proyecto utilizando un entorno virtual local (`venv`):

### Requisitos previos
* Python 3.10 o superior instalado.
* Gestor de paquetes `pip` actualizado.

### Paso 1: Crear y activar el entorno virtual
En la raíz del proyecto, ejecuta:

* **Windows (PowerShell):**
  ```powershell
  python -m venv venv
  .\venv\Scripts\Activate.ps1
  ```
* **Windows (CMD):**
  ```cmd
  python -m venv venv
  venv\Scripts\activate.bat
  ```
* **Linux / macOS:**
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

### Paso 2: Instalar dependencias
```bash
pip install -r requirements.txt
```

### Paso 3: Aplicar migraciones iniciales
```bash
python manage.py migrate
```

### Paso 4: Crear superusuario (Opcional)
Para acceder al panel de administración `/admin/` localmente:
```bash
python manage.py createsuperuser
```
*(Ingresa el usuario, correo electrónico y contraseña que prefieras).*

### Paso 5: Levantar el servidor de desarrollo
```bash
python manage.py runserver
```
* Abre tu navegador en [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
* Para apagar el servidor local, presiona `CTRL + C`.
* Para desactivar el entorno virtual, escribe `deactivate`.

---

## 🧪 Pruebas Unitarias Automatizadas

El proyecto incluye pruebas automatizadas para validar el correcto funcionamiento de las URLs y la visualización de datos:

* **Ejecutar pruebas localmente:**
  ```bash
  python manage.py test
  ```
* **Ejecutar pruebas dentro de Docker:**
  ```bash
  docker compose exec web python manage.py test
  ```

---

## 📝 Taller Práctico: Construcción del Proyecto desde Cero

Si deseas replicar este proyecto paso a paso en clase con tus estudiantes para enseñar la fase de inicialización, sigue esta guía:

1. **Crear carpeta del proyecto y entrar:**
   ```bash
   mkdir explorador_django
   cd explorador_django
   ```
2. **Crear y activar el entorno virtual (`venv`):**
   *(Ver los comandos de activación según el sistema operativo en la Sección Opción B).*
3. **Instalar Django:**
   ```bash
   pip install django
   ```
4. **Inicializar el proyecto Django:**
   ```bash
   django-admin startproject explorador_django .
   ```
   *(El punto `.` al final es crucial para crear el proyecto en el directorio actual).*
5. **Crear la aplicación modular:**
   ```bash
   python manage.py startapp arquitectura
   ```
6. **Registrar la aplicación y configurar plantillas:**
   * En `explorador_django/settings.py`, agrega `'arquitectura'` en `INSTALLED_APPS`.
   * En la misma sección `settings.py`, configura `'DIRS': [BASE_DIR / 'templates']` dentro de la lista `TEMPLATES`.
7. **Configurar el enrutador global y local:**
   * En `explorador_django/urls.py`, incluye las URLs de la aplicación usando `include("arquitectura.urls")`.
   * Crea el archivo `arquitectura/urls.py` y define las rutas (`home`, `flujo`, `mvc`) mapeándolas a `views.py`.
8. **Crear carpetas de templates:**
   * Crea un directorio `templates/` en la raíz.
   * Crea un subdirectorio `templates/arquitectura/` para organizar los templates de la app.
9. **Implementar Vistas, Modelos y Plantillas:**
   * Desarrolla la clase del modelo en `models.py`.
   * Genera y aplica los archivos de migración:
     ```bash
     python manage.py makemigrations arquitectura
     python manage.py migrate
     ```
   * Registra el modelo en `admin.py` para habilitar su edición desde el panel.
   * Define la lógica de respuesta en `views.py` e implementa los templates HTML correspondientes.

---

## 📚 Documentación Complementaria de Estudio

* 📖 **Guía Teórica de Django y MTV:** Consulta [introduccion_django.md](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/introduccion_django.md) para estudiar a fondo el ciclo Request-Response, el patrón MTV, el principio DRY y el manejo de entornos virtuales.
* 🐳 **Guía Didáctica de Docker:** Consulta [docker_guide.md](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/docker_guide.md) para aprender detalladamente cómo Docker encapsula y automatiza la ejecución del servidor de Django.

---

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**. Siéntete libre de utilizarlo, modificarlo y distribuirlo de forma gratuita en tus lecciones y cursos. Consulta el archivo [LICENSE](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/LICENSE) para más detalles.
