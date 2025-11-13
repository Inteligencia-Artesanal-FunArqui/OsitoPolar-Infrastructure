#!/bin/bash
# Este script detiene y elimina todos los contenedores, redes y volúmenes anónimos
# definidos en el archivo docker-compose.yml.

echo "🛑 Deteniendo y eliminando todos los servicios del ecosistema OsitoPolar..."

# El comando 'down' detiene los contenedores y los elimina.
# También elimina las redes creadas por 'up'.
# Los volúmenes nombrados (como 'mysql-data') no se eliminan por defecto,
# lo cual previene la pérdida de datos de la base de datos.
docker-compose down

echo "✅ Ecosistema detenido y limpiado."
echo "Para eliminar también los volúmenes (¡CUIDADO, borra datos!), usa: docker-compose down -v"
