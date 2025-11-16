# 🐻 OsitoPolar - Microservices Architecture

Plataforma de gestión de equipamiento de refrigeración industrial basada en microservicios.

## 📋 Tabla de Contenidos

- [Arquitectura](#-arquitectura)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación Rápida](#-instalación-rápida)
- [Instalación Manual](#-instalación-manual)
- [Servicios Disponibles](#-servicios-disponibles)
- [Comandos Útiles](#-comandos-útiles)
- [Tecnologías](#-tecnologías)

---

## 🏗 Arquitectura

Esta aplicación está dividida en **9 microservicios**:

```
┌─────────────────────────────────────────────────────────────┐
│                      API Gateway (Ocelot)                    │
│                     http://localhost:8080                    │
└──────────────────────────┬──────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ IAM Service  │   │   Profiles   │   │  Equipment   │
│   :5001      │   │    :5002     │   │    :5003     │
└──────────────┘   └──────────────┘   └──────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ WorkOrders   │   │ ServiceReq   │   │Subscriptions │
│   :5004      │   │    :5005     │   │    :5006     │
└──────────────┘   └──────────────┘   └──────────────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
┌──────────────┐                     ┌──────────────┐
│Notifications │                     │  Analytics   │
│   :5007      │                     │    :5008     │
└──────────────┘                     └──────────────┘
        │
        └────────────────┐
                         ▼
                 ┌──────────────┐
                 │  RabbitMQ    │
                 │   :5672      │
                 │   :15672     │
                 └──────────────┘
```

**Comunicación:**
- **Síncrona**: HTTP/REST entre servicios
- **Asíncrona**: RabbitMQ + MassTransit para eventos

---

## 🔧 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- ✅ **Git** - [Descargar](https://git-scm.com/)
- ✅ **Docker Desktop** - [Descargar](https://www.docker.com/products/docker-desktop/)
- ✅ **MySQL 8.0** - [Descargar](https://dev.mysql.com/downloads/installer/)
- ✅ **Acceso a la organización** `Inteligencia-Artesanal-FunArqui` en GitHub

### Configuración de MySQL

Asegúrate de que MySQL esté corriendo en:
- **Host**: `localhost`
- **Puerto**: `3306`
- **Usuario**: `root`
- **Contraseña**: `12345678`

---

## 🚀 Instalación Rápida

### Windows (PowerShell)

```powershell
# 1. Clonar el repositorio de infraestructura
git clone https://github.com/Inteligencia-Artesanal-FunArqui/OsitoPolar-Infrastructure.git
cd OsitoPolar-Infrastructure

# 2. Ejecutar script de setup automático
.\setup.ps1
```

El script automáticamente:
1. ✅ Verifica requisitos (Git, Docker, MySQL)
2. ✅ Clona todos los repositorios de microservicios
3. ✅ Crea las bases de datos necesarias
4. ✅ Construye y levanta los contenedores Docker

---

## 📝 Instalación Manual

Si prefieres hacerlo manualmente o el script falla:

### Paso 1: Clonar todos los repositorios

```bash
# Crear carpeta base
mkdir Microservicios
cd Microservicios

# Clonar repositorio de infraestructura
git clone https://github.com/Inteligencia-Artesanal-FunArqui/OsitoPolar-Infrastructure.git

# Clonar microservicios (IMPORTANTE: usar estos nombres)
git clone https://github.com/Inteligencia-Artesanal-FunArqui/OsitoPolar.Shared.Events.git OsitoPolar.Shared.Events
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-IAM.git OsitoPolar.IAM.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-Profiles.git OsitoPolar.Profiles.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-Equipment.git OsitoPolar.Equipment.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-WorkOrders.git OsitoPolar.WorkOrders.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-ServiceRequest.git OsitoPolar.ServiceRequests.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-Subscriptions.git OsitoPolar.Subscriptions.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-Notifications.git OsitoPolar.Notifications.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/BC-Analytics.git OsitoPolar.Analytics.Service
git clone https://github.com/Inteligencia-Artesanal-FunArqui/OsitoPolar-Api-Gateway.git OsitoPolar.ApiGateway
```

### Paso 2: Verificar estructura de carpetas

Tu estructura debe verse así:

```
📁 Microservicios/
├── 📁 OsitoPolar-Infrastructure/
│   ├── docker-compose.yml
│   ├── setup.ps1
│   ├── .env.example
│   ├── .env (tu archivo local, NO se sube)
│   ├── .gitignore
│   └── README.md
├── 📁 OsitoPolar.Shared.Events/
├── 📁 OsitoPolar.IAM.Service/
├── 📁 OsitoPolar.Profiles.Service/
├── 📁 OsitoPolar.Equipment.Service/
├── 📁 OsitoPolar.WorkOrders.Service/
├── 📁 OsitoPolar.ServiceRequests.Service/
├── 📁 OsitoPolar.Subscriptions.Service/
├── 📁 OsitoPolar.Notifications.Service/
├── 📁 OsitoPolar.Analytics.Service/
└── 📁 OsitoPolar.ApiGateway/
```

### Paso 3: Configurar variables de entorno

```bash
cd OsitoPolar-Infrastructure

# Copiar el archivo de ejemplo
copy .env.example .env

# Editar .env con tus credenciales
notepad .env
```

**Configuración mínima requerida** en `.env`:
- `MYSQL_PASSWORD`: Tu contraseña de MySQL (si es diferente de `12345678`)

**Configuración opcional** (para probar funcionalidades específicas):
- `MAILERSEND_SMTP_USERNAME`: Tu username de MailerSend (para emails)
- `MAILERSEND_SMTP_PASSWORD`: Tu password de MailerSend (para emails)
- `MAILERSEND_FROM_EMAIL`: Tu email de MailerSend (para emails)
- `STRIPE_SECRET_KEY`: Tu key de Stripe (para pagos)

### Paso 4: Crear bases de datos

Conectarse a MySQL y ejecutar:

```sql
CREATE DATABASE ositopolar_iam;
CREATE DATABASE ositopolar_profiles;
CREATE DATABASE ositopolar_equipment;
CREATE DATABASE ositopolar_workorders;
CREATE DATABASE ositopolar_servicerequests;
CREATE DATABASE ositopolar_subscriptions;
CREATE DATABASE ositopolar_notifications;
CREATE DATABASE ositopolar_analytics;
```

### Paso 5: Levantar los servicios

```bash
cd OsitoPolar-Infrastructure
docker-compose up -d --build
```

La primera vez tomará varios minutos (descarga de imágenes base y compilación).

---

## 🌐 Servicios Disponibles

Una vez levantados los contenedores, puedes acceder a:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **API Gateway** | http://localhost:8080/swagger | Punto de entrada unificado |
| **IAM Service** | http://localhost:5001/swagger | Autenticación y autorización |
| **Profiles Service** | http://localhost:5002/swagger | Gestión de perfiles de usuario |
| **Equipment Service** | http://localhost:5003/swagger | Gestión de equipamiento |
| **WorkOrders Service** | http://localhost:5004/swagger | Órdenes de trabajo |
| **ServiceRequests** | http://localhost:5005/swagger | Solicitudes de servicio |
| **Subscriptions** | http://localhost:5006/swagger | Suscripciones y pagos |
| **Notifications** | http://localhost:5007/swagger | Notificaciones email/in-app |
| **Analytics** | http://localhost:5008/swagger | Análisis y reportes |
| **RabbitMQ UI** | http://localhost:15672 | Gestión de mensajería |

### Credenciales RabbitMQ:
- **Usuario**: `ositopolar`
- **Contraseña**: `OsitoPolar2024!`

---

## 📦 Comandos Útiles

### Docker Compose

```bash
# Levantar servicios (primera vez o después de cambios en código)
docker-compose up -d --build

# Levantar servicios (sin rebuild)
docker-compose up -d

# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f iam-service
docker logs ositopolar-notifications -f

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart notifications-service

# Rebuild un servicio específico
docker-compose up -d --build notifications-service

# Ver estado de contenedores
docker-compose ps
docker ps
```

### Git

```bash
# Actualizar todos los repos (ejecutar desde carpeta Microservicios)
cd OsitoPolar.IAM.Service && git pull && cd ..
cd OsitoPolar.Profiles.Service && git pull && cd ..
cd OsitoPolar.Equipment.Service && git pull && cd ..
cd OsitoPolar.WorkOrders.Service && git pull && cd ..
cd OsitoPolar.ServiceRequests.Service && git pull && cd ..
cd OsitoPolar.Subscriptions.Service && git pull && cd ..
cd OsitoPolar.Notifications.Service && git pull && cd ..
cd OsitoPolar.Analytics.Service && git pull && cd ..
cd OsitoPolar.ApiGateway && git pull && cd ..
cd OsitoPolar-Infrastructure && git pull && cd ..
```

---

## 🛠 Tecnologías

### Backend
- **.NET 9.0** - Framework principal
- **ASP.NET Core** - Web API
- **Entity Framework Core 9.0** - ORM
- **MySQL 8.0** - Base de datos

### Microservices Infrastructure
- **Docker** - Containerización
- **Docker Compose** - Orquestación local
- **Ocelot** - API Gateway
- **MassTransit 8.5** - Message broker abstraction
- **RabbitMQ 3.13** - Message broker

### External Services
- **MailerSend** - Proveedor de emails
- **Stripe** - Procesamiento de pagos

### Patterns & Architecture
- **Domain-Driven Design (DDD)**
- **CQRS** (Command Query Responsibility Segregation)
- **Event-Driven Architecture**
- **RESTful API**

---

## 🔥 Troubleshooting

### Error: "ERR_EMPTY_RESPONSE" en Swagger

**Causa**: El servicio no está levantado correctamente.

**Solución**:
```bash
# Ver logs del servicio
docker logs ositopolar-<nombre-servicio>

# Reiniciar el servicio
docker-compose restart <nombre-servicio>
```

### Error: "Can't connect to MySQL server"

**Causa**: MySQL no está corriendo o la contraseña es incorrecta.

**Solución**:
1. Verificar que MySQL esté corriendo en `localhost:3306`
2. Verificar credenciales: `root` / `12345678`
3. Actualizar `docker-compose.yml` si usas otras credenciales

### Error: "Port is already allocated"

**Causa**: Otro proceso está usando el puerto.

**Solución**:
```bash
# Ver qué está usando el puerto
netstat -ano | findstr :5001

# Matar el proceso o cambiar el puerto en docker-compose.yml
```

### Los contenedores no se comunican entre sí

**Causa**: Están usando IPs en lugar de nombres de servicio.

**Solución**: Verificar que en el código se usen los nombres de servicio (ej: `http://profiles-service:8080` en lugar de `http://localhost:5002`)

---

## 👥 Equipo

Organización: **Inteligencia-Artesanal-FunArqui**

---

## 📄 Licencia

Private - Uso educativo

---

## 📞 Soporte

Para problemas o preguntas:
1. Revisar la sección [Troubleshooting](#-troubleshooting)
2. Revisar los logs: `docker-compose logs -f`
3. Contactar al equipo de desarrollo
