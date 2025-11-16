# OsitoPolar Microservices Infrastructure

This repository contains the Docker Compose orchestration and infrastructure configuration for the OsitoPolar microservices platform.

## Architecture Overview

The platform consists of 9 containerized services:

### Services

1. **API Gateway** (Port 8080) - Ocelot reverse proxy, single entry point
2. **IAM Service** (Port 5001) - Identity & Access Management, authentication, JWT tokens
3. **Profiles Service** (Port 5002) - Owner and Provider profile management
4. **Equipment Service** (Port 5003) - Equipment and rental equipment management
5. **Work Orders Service** (Port 5004) - Maintenance work orders and technicians
6. **Service Requests Service** (Port 5005) - Marketplace service requests
7. **Subscriptions Service** (Port 5006) - Subscription plans and Stripe payments
8. **Notifications Service** (Port 5007) - Email notifications via MailerSend
9. **Analytics Service** (Port 5008) - Business intelligence and reporting

### Infrastructure

- **MySQL 8.0** - 8 isolated databases (one per microservice)
- **Docker Network** - Private bridge network for inter-service communication
- **Persistent Volumes** - MySQL data persistence

## Prerequisites

- **Docker Desktop** - Latest version
- **Docker Compose** - v3.8 or higher
- **.NET 9.0 SDK** - For local development (optional)
- **Git** - For version control

## Quick Start

### 1. Clone and Setup

```bash
cd C:\Users\josep\RiderProjects\Microservicios\OsitoPolar.Infrastructure
```

### 2. Configure Environment Variables

```bash
# Copy the example file
cp .env.example .env

# Edit .env and fill in your credentials
notepad .env
```

Required variables:
- `MYSQL_ROOT_PASSWORD` - MySQL root password
- `JWT_SECRET` - JWT token secret
- `STRIPE_SECRET_KEY` - Stripe secret key
- `STRIPE_PUBLISHABLE_KEY` - Stripe publishable key
- `MAILERSEND_USERNAME` - MailerSend SMTP username
- `MAILERSEND_PASSWORD` - MailerSend SMTP password
- `MAILERSEND_FROM_EMAIL` - From email address

### 3. Run the Stack

#### Option A: Using the Script (Recommended)

```powershell
.\test-local.ps1
```

This script will:
- Verify Docker is running
- Build all service images
- Start all containers
- Wait for health checks
- Display access information

#### Option B: Manual Docker Compose

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 4. Access the Services

Once all services are running:

- **API Gateway**: http://localhost:8080
- **IAM Service**: http://localhost:5001/swagger
- **Profiles Service**: http://localhost:5002/swagger
- **Equipment Service**: http://localhost:5003/swagger
- **Work Orders Service**: http://localhost:5004/swagger
- **Service Requests Service**: http://localhost:5005/swagger
- **Subscriptions Service**: http://localhost:5006/swagger
- **Notifications Service**: http://localhost:5007/swagger
- **Analytics Service**: http://localhost:5008/swagger

## Service Communication

### Phase 2 - HTTP Communication

Services communicate via HTTP using Anti-Corruption Layer (ACL) facades:

```
IAM Service → Profiles, Subscriptions, Notifications
Profiles Service → Subscriptions, Notifications
Equipment Service → Profiles, Notifications
Work Orders Service → Profiles, Equipment, Notifications
Service Requests → Profiles, Equipment, Work Orders, Notifications
Analytics Service → Profiles, Equipment, Work Orders, Subscriptions
```

### Phase 3 - API Gateway

Frontend applications access all services through the API Gateway on port 8080:

```
Frontend → http://localhost:8080/api/v1/authentication/* → IAM Service (5001)
Frontend → http://localhost:8080/api/v1/profiles/* → Profiles Service (5002)
Frontend → http://localhost:8080/api/v1/equipment/* → Equipment Service (5003)
...etc
```

## Database Structure

Each microservice has its own isolated database:

1. `ositopolar_iam` - Users, roles, permissions
2. `ositopolar_profiles` - Owners, providers
3. `ositopolar_equipment` - Equipment, rental equipment
4. `ositopolar_workorders` - Work orders, technicians
5. `ositopolar_servicerequests` - Service requests
6. `ositopolar_subscriptions` - Plans, payments
7. `ositopolar_notifications` - Email notifications
8. `ositopolar_analytics` - Analytics data

### Running Migrations

After first startup, run migrations for each service:

```bash
# IAM Service
docker exec -it ositopolar-iam dotnet ef database update

# Profiles Service
docker exec -it ositopolar-profiles dotnet ef database update

# Repeat for all services...
```

## Common Commands

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f iam-service
docker-compose logs -f api-gateway

# Last 100 lines
docker-compose logs --tail=100 iam-service
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart iam-service
```

### Stop Services

```bash
# Stop all containers
docker-compose down

# Stop and remove volumes (WARNING: Deletes database data!)
docker-compose down -v
```

### Rebuild Service

```bash
# Rebuild specific service
docker-compose build iam-service

# Rebuild and restart
docker-compose up -d --build iam-service
```

### Check Service Status

```bash
docker-compose ps
```

### Access MySQL

```bash
# Connect to MySQL container
docker exec -it ositopolar-mysql mysql -uroot -pOsitoPolar2024!

# Show databases
SHOW DATABASES LIKE 'ositopolar%';
```

## Troubleshooting

### Service Won't Start

1. Check logs: `docker-compose logs -f <service-name>`
2. Verify database connection: Ensure MySQL is healthy
3. Check environment variables in docker-compose.yml
4. Rebuild image: `docker-compose build <service-name>`

### Database Connection Errors

1. Wait for MySQL health check: Takes 30-60 seconds after startup
2. Check MySQL logs: `docker-compose logs mysql`
3. Verify connection string uses hostname `mysql` (not `localhost`)
4. Ensure databases were created: Check `mysql-init/01-create-databases.sql`

### Port Conflicts

If ports are already in use:

1. Check what's using the port: `netstat -ano | findstr :8080`
2. Stop conflicting service or change port in docker-compose.yml
3. Restart: `docker-compose down && docker-compose up -d`

### Image Build Failures

1. Clear Docker cache: `docker-compose build --no-cache`
2. Verify Dockerfile paths in docker-compose.yml
3. Check .NET SDK version in Dockerfiles (should be 9.0)

## Performance Tips

### Development Mode

```yaml
# In docker-compose.yml, uncomment for faster rebuilds:
volumes:
  - ../OsitoPolar.IAM.Service/IAM.API:/app
```

### Production Mode

```bash
# Set environment to Production
ASPNETCORE_ENVIRONMENT=Production docker-compose up -d
```

## Azure Deployment

### Prerequisites

- Azure subscription
- Azure CLI installed
- Azure Container Registry (ACR)

### Steps

1. Build and tag images:
```bash
docker-compose build
docker tag ositopolar-api-gateway:latest yourregistry.azurecr.io/api-gateway:latest
docker tag ositopolar-iam-service:latest yourregistry.azurecr.io/iam-service:latest
# ...tag all services
```

2. Push to ACR:
```bash
az acr login --name yourregistry
docker push yourregistry.azurecr.io/api-gateway:latest
docker push yourregistry.azurecr.io/iam-service:latest
# ...push all services
```

3. Deploy to Azure Container Apps or App Service

## Security Notes

- **NEVER** commit `.env` file
- Change default passwords in production
- Generate new JWT secret: `openssl rand -base64 32`
- Use Azure Key Vault for production secrets
- Enable HTTPS in production
- Configure firewall rules for MySQL

## Support

For issues or questions:
1. Check logs: `docker-compose logs -f`
2. Review documentation in each microservice repo
3. Check Phase 2 HTTP Migration Guide
4. Contact development team

## License

Proprietary - OsitoPolar Platform
