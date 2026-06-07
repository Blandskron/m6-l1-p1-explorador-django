#!/bin/sh

# Salir inmediatamente si algún comando falla
set -e

echo "===================================================="
echo " Ejecutando Entrypoint de Automatización..."
echo "===================================================="

# 1. Ejecutar migraciones automáticamente
echo "--> Aplicando migraciones de base de datos..."
python manage.py migrate --noinput

# 2. Crear superusuario de forma idempotente y automática
echo "--> Configurando superusuario administrativo..."
if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
    python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
username = '$DJANGO_SUPERUSER_USERNAME'
email = '${DJANGO_SUPERUSER_EMAIL:-admin@example.com}'
password = '$DJANGO_SUPERUSER_PASSWORD'

if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
    print('¡Superusuario ' + username + ' creado exitosamente!')
else:
    print('El superusuario ' + username + ' ya existe. Omitiendo creación.')
"
else:
    echo "Aviso: DJANGO_SUPERUSER_USERNAME o DJANGO_SUPERUSER_PASSWORD no configurados. Omitiendo creación automática."
fi

echo "===================================================="
echo " Inicialización completada. Iniciando comando: $@"
echo "===================================================="

# 3. Continuar con el comando por defecto (ej. runserver)
exec "$@"
