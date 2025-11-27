# ==============================================================================
# OsitoPolar - Start ALL Services with Rebuild
# ==============================================================================
# This script starts ALL microservices with fresh Docker builds
# ==============================================================================

Write-Host "OsitoPolar - Starting ALL Services" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Building and starting ALL microservices..." -ForegroundColor Yellow
Write-Host "This will take several minutes on first run..." -ForegroundColor Gray
Write-Host ""

# Stop any running containers first
Write-Host "Stopping existing containers..." -ForegroundColor Cyan
docker-compose down

Write-Host ""
Write-Host "Building images and starting containers..." -ForegroundColor Cyan
Write-Host ""

# Build and start all services
docker-compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "All services started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Service URLs:" -ForegroundColor Cyan
    Write-Host "   - API Gateway:              http://localhost:8080/swagger" -ForegroundColor White
    Write-Host "   - IAM Service:              http://localhost:5001/swagger" -ForegroundColor White
    Write-Host "   - Profiles Service:         http://localhost:5002/swagger" -ForegroundColor White
    Write-Host "   - Equipment Service:        http://localhost:5003/swagger" -ForegroundColor White
    Write-Host "   - WorkOrders Service:       http://localhost:5004/swagger" -ForegroundColor White
    Write-Host "   - ServiceRequests Service:  http://localhost:5005/swagger" -ForegroundColor White
    Write-Host "   - Subscriptions Service:    http://localhost:5006/swagger" -ForegroundColor White
    Write-Host "   - Notifications Service:    http://localhost:5007/swagger" -ForegroundColor White
    Write-Host "   - Analytics Service:        http://localhost:5008/swagger" -ForegroundColor White
    Write-Host "   - RabbitMQ Management UI:   http://localhost:15672" -ForegroundColor White
    Write-Host "     (user: ositopolar, pass: OsitoPolar2024!)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Useful commands:" -ForegroundColor Yellow
    Write-Host "   - View all logs:    docker-compose logs -f" -ForegroundColor Gray
    Write-Host "   - View IAM logs:    docker-compose logs -f iam-service" -ForegroundColor Gray
    Write-Host "   - Stop all:         docker-compose down" -ForegroundColor Gray
    Write-Host "   - Restart service:  docker-compose restart iam-service" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Check service health:" -ForegroundColor Yellow
    Write-Host "   docker ps --filter name=ositopolar" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Failed to start services" -ForegroundColor Red
    Write-Host "Check the logs with: docker-compose logs" -ForegroundColor Yellow
    exit 1
}
