# Guía de Contenedores — Docker y Django en Entornos de Desarrollo

Esta guía didáctica explica cómo se utiliza **Docker** en este proyecto para empaquetar, distribuir y automatizar el despliegue local de la aplicación Django, garantizando que funcione en cualquier computadora exactamente de la misma manera.

---

## 1. ¿Por qué usar Docker en el Desarrollo Web?

El problema clásico en desarrollo es: *"Funciona en mi máquina, pero no en la del compañero o en el servidor"*. Esto ocurre por diferencias en las versiones de Python, dependencias del sistema operativo, o configuraciones locales.

**Docker** resuelve esto empaquetando la aplicación, el intérprete de Python, las librerías necesarias y las configuraciones en una unidad aislada llamada **Contenedor**.

### Beneficios principales:
* **Entornos idénticos:** Todos los desarrolladores y el servidor de producción usan exactamente el mismo entorno.
* **Automatización:** Al iniciar el contenedor, las migraciones de base de datos se ejecutan solas y los administradores se crean automáticamente.
* **Despliegue rápido:** Una sola línea de comandos levanta todo el ecosistema.

---

## 2. Explicación de los Archivos de Configuración Docker

El proyecto incluye cuatro archivos clave en la raíz para habilitar Docker:

### A. [Dockerfile](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/Dockerfile) (Receta de Construcción)
El `Dockerfile` define paso a paso cómo se construye la **imagen** del contenedor:
1. **Imagen base:** `FROM python:3.11-slim` utiliza una versión de Linux ligera optimizada para Python.
2. **Variables de entorno:** Configura Python para que imprima directamente en consola (`PYTHONUNBUFFERED=1`) y no ensucie el contenedor con archivos de caché compilados (`PYTHONDONTWRITEBYTECODE=1`).
3. **Instalación de paquetes:** Descarga las librerías necesarias para compilar ciertas dependencias y luego instala los requisitos con `pip install -r requirements.txt`.
4. **entrypoint.sh:** Copia y configura el script que corre cada vez que el contenedor arranca.
5. **Comando por defecto:** `CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]` le indica al contenedor que levante el servidor web de Django por defecto escuchando en todas las interfaces de red.

### B. [entrypoint.sh](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/entrypoint.sh) (Automatización de Inicio)
Este script de shell se ejecuta **antes** de que el servidor web se inicie. Automatiza dos tareas críticas:
* **Migraciones:** Ejecuta `python manage.py migrate --noinput` para asegurar que las tablas de la base de datos existan y estén al día.
* **Superusuario Idempotente:** Lee las variables de entorno `DJANGO_SUPERUSER_USERNAME` y `DJANGO_SUPERUSER_PASSWORD`. Ejecuta un script interno en Python que verifica si el usuario ya existe en la base de datos; si no existe, lo crea automáticamente. Esto evita que la build falle si el usuario ya fue creado en ejecuciones anteriores.

### C. [docker-compose.yml](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/docker-compose.yml) (Orquestación y Volúmenes)
Permite definir los parámetros de ejecución del contenedor y sus conexiones:
* **Puerto:** Mapea el puerto `8000` de tu máquina real al puerto `8000` del contenedor.
* **Volumen del Código (`.:/app`):** Permite el **Hot-Reloading** (recarga en vivo). Cuando modificas un archivo en tu editor de código favorito en tu máquina real, el cambio se refleja inmediatamente dentro del contenedor y el servidor se reinicia solo.
* **Volumen de Persistencia (`sqlite_data:/data`):** Dado que los contenedores son efímeros (si los destruyes, pierdes lo que escribiste en su disco duro), este volumen guarda la base de datos SQLite de forma segura fuera del contenedor. Además, al montarlo en una ruta nativa, evita problemas de bloqueo de archivos que a veces ocurren con SQLite en sistemas Windows.

### D. [.dockerignore](file:///c:/Users/BlandskronNotebook/Documents/updatesGitHubs/Django/M6/M6-L1-D1-ExploradorDjango/.dockerignore) (Exclusiones)
Funciona igual que `.gitignore`. Evita que archivos temporales de tu máquina local (como tu base de datos local `db.sqlite3` o tu entorno virtual `venv/`) se suban al contenedor, previniendo conflictos de dependencias o datos viejos.

---

## 3. Comandos Útiles para Clase

Para trabajar con Docker en clase, enseña a tus alumnos los siguientes comandos clave en su terminal (en el directorio del proyecto):

### Levantar y Construir el Proyecto
Construye la imagen por primera vez o ante cambios en dependencias, y levanta el servidor:
```bash
docker compose up --build
```
> Una vez levantado, la aplicación y su panel de administración estarán disponibles en: `http://127.0.0.1:8000/`

### Detener los Contenedores
Apaga el servidor y detiene la ejecución de los contenedores sin borrar los datos guardados:
```bash
docker compose down
```

### Ejecutar Pruebas Unitarias dentro de Docker
Ejecuta la suite de pruebas unitarias usando la base de datos temporal del contenedor:
```bash
docker compose exec web python manage.py test
```

### Entrar al Shell del Contenedor
Si necesitas ejecutar comandos manuales de Django dentro del entorno de Docker (como `python manage.py shell` o inspeccionar archivos):
```bash
docker compose exec web bash
```
*(Para salir de esa terminal del contenedor, escribe `exit`).*

### Limpiar Volúmenes y Datos (Reset Completo)
Si los alumnos cometen un error con los datos y quieren limpiar la base de datos de Docker por completo para iniciar de cero:
```bash
docker compose down -v
```
*(El modificador `-v` elimina los volúmenes asociados, borrando la base de datos SQLite interna para que en la próxima ejecución se cree limpia).*
