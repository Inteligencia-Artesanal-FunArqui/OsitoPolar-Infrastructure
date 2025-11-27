# ==============================================================================
# Script de Prueba Local con Docker Compose
# ==============================================================================
#
# Este script facilita probar todos los microservicios localmente antes de
# desplegar a Azure
#
# USO:
# .\test-local.ps1
# ==============================================================================

Write-Host "========================================" -ForegroundColor Green
Write-Host "  OsitoPolar Microservices - Test Local" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificar Docker
Write-Host "Verificando Docker..." -ForegroundColor Yellow
try {
    docker --version | Out-Null
    Write-Host "✓ Docker está instalado" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker no está instalado o no está corriendo" -ForegroundColor Red
    Write-Host "Asegúrate de que Docker Desktop esté corriendo" -ForegroundColor Yellow
    exit 1
}

# Verificar si existe .env
if (-not (Test-Path ".env")) {
    Write-Host ""
    Write-Host "⚠ No se encontró el archivo .env" -ForegroundColor Yellow
    Write-Host "Creando .env desde .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✓ Archivo .env creado" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANTE: Edita el archivo .env con tus credenciales reales" -ForegroundColor Yellow
    Write-Host "Presiona Enter para continuar con valores de prueba..." -ForegroundColor Yellow
    Read-Host
}

# Detener contenedores previos si existen
Write-Host ""
Write-Host "Deteniendo contenedores previos..." -ForegroundColor Yellow
docker-compose down 2>&1 | Out-Null

# Construir las imágenes
Write-Host ""
Write-Host "Construyendo imágenes Docker (esto puede tomar varios minutos)..." -ForegroundColor Cyan
docker-compose build

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al construir las imágenes" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Imágenes construidas" -ForegroundColor Green

# Levantar los servicios
Write-Host ""
Write-Host "Levantando servicios..." -ForegroundColor Cyan
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al levantar los servicios" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Servicios iniciados" -ForegroundColor Green

# Esperar a que los servicios estén listos
Write-Host ""
Write-Host "Esperando a que los servicios estén listos..." -ForegroundColor Yellow

# Esperar MySQL
Write-Host "  Esperando MySQL..." -ForegroundColor Gray
$maxRetries = 30
$retry = 0
$mysqlReady = $false

while ($retry -lt $maxRetries -and -not $mysqlReady) {
    $retry++
    Start-Sleep -Seconds 2
    $healthStatus = docker inspect --format='{{.State.Health.Status}}' ositopolar-mysql 2>&1
    if ($healthStatus -eq "healthy") {
        $mysqlReady = $true
    }
    Write-Host "    Intento $retry/$maxRetries..." -ForegroundColor Gray
}

if ($mysqlReady) {
    Write-Host "  ✓ MySQL está listo" -ForegroundColor Green
} else {
    Write-Host "  ⚠ MySQL tardó demasiado en iniciar" -ForegroundColor Yellow
    Write-Host "  Verifica los logs con: docker-compose logs mysql" -ForegroundColor Yellow
}

# Esperar servicios
Write-Host "  Esperando microservicios..." -ForegroundColor Gray
Start-Sleep -Seconds 10

# Verificar estado de los contenedores
Write-Host ""
Write-Host "Estado de los contenedores:" -ForegroundColor Cyan
docker-compose ps

# Información de acceso
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ¡SERVICIOS LISTOS!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 API Gateway (Single Entry Point):" -ForegroundColor Yellow
Write-Host "   http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔐 IAM Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5001" -ForegroundColor Cyan
Write-Host ""
Write-Host "👤 Profiles Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5002" -ForegroundColor Cyan
Write-Host ""
Write-Host "🛠️ Equipment Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5003" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Work Orders Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5004" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎯 Service Requests Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5005" -ForegroundColor Cyan
Write-Host ""
Write-Host "💳 Subscriptions Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5006" -ForegroundColor Cyan
Write-Host ""
Write-Host "📧 Notifications Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5007" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Analytics Service:" -ForegroundColor Yellow
Write-Host "   http://localhost:5008" -ForegroundColor Cyan
Write-Host ""
Write-Host "🗄️ MySQL:" -ForegroundColor Yellow
Write-Host "   Host: localhost:3306" -ForegroundColor Cyan
Write-Host "   Password: OsitoPolar2024!" -ForegroundColor Cyan
Write-Host "   Databases: ositopolar_iam, ositopolar_profiles, ..." -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Comandos útiles:" -ForegroundColor Yellow
Write-Host "   Ver logs en tiempo real:" -ForegroundColor Gray
Write-Host "     docker-compose logs -f" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Ver logs de un servicio:" -ForegroundColor Gray
Write-Host "     docker-compose logs -f iam-service" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Detener servicios:" -ForegroundColor Gray
Write-Host "     docker-compose down" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Reiniciar servicios:" -ForegroundColor Gray
Write-Host "     docker-compose restart" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Ver todos los servicios corriendo:" -ForegroundColor Gray
Write-Host "     docker-compose ps" -ForegroundColor Cyan
Write-Host ""

# Opción para ver logs en tiempo real
$viewLogs = Read-Host "¿Deseas ver los logs en tiempo real? (s/n)"
if ($viewLogs -eq "s" -or $viewLogs -eq "S") {
    docker-compose logs -f
}
