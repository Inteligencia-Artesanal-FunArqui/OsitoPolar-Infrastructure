#!/bin/bash
# Este script inicia toda la infraestructura de OsitoPolar en el orden correcto.

echo "🚀 Iniciando servicios de infraestructura base (MySQL, RabbitMQ)..."
# Levanta los servicios base en segundo plano (-d)
docker-compose up -d mysql rabbitmq

echo "⏳ Esperando 15 segundos para que la base de datos y el broker se inicialicen..."
# Pausa para asegurar que los servicios base estén listos antes de que otros dependan de ellos.
# En docker-compose.yml se usan 'healthchecks' para una mayor robustez.
sleep 15

echo "🚀 Iniciando todos los microservicios y el API Gateway..."
# Levanta el resto de los servicios definidos en docker-compose.yml
docker-compose up -d

echo "✅ ¡Todo el ecosistema OsitoPolar ha sido iniciado!"
echo "Puedes verificar el estado de los contenedores con: docker-compose ps"

# Muestra el estado final de los contenedores
docker-compose ps
