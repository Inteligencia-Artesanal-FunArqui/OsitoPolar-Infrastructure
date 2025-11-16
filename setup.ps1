# ==============================================================================
# OsitoPolar Microservices - Setup Script for Windows
# ==============================================================================
# This script automates the setup process for team members
#
# Prerequisites:
# - Git installed
# - Docker Desktop running
# - MySQL 8.0 running on localhost:3306
# - Access to Inteligencia-Artesanal-FunArqui GitHub organization
# ==============================================================================

Write-Host "🐻 OsitoPolar Microservices - Setup Script" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if running in correct directory
$currentDir = Split-Path -Leaf (Get-Location)
if ($currentDir -ne "OsitoPolar-Infrastructure") {
    Write-Host "❌ Error: This script must be run from the OsitoPolar-Infrastructure directory" -ForegroundColor Red
    Write-Host "Please navigate to the correct directory first" -ForegroundColor Yellow
    exit 1
}

# Move to parent directory
Set-Location ..
$baseDir = Get-Location

Write-Host "📂 Base directory: $baseDir" -ForegroundColor Green
Write-Host ""

# ==============================================================================
# Step 1: Check prerequisites
# ==============================================================================
Write-Host "🔍 Step 1: Checking prerequisites..." -ForegroundColor Yellow

# Check Git
try {
    $gitVersion = git --version
    Write-Host "  ✅ Git installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Git not found. Please install Git first." -ForegroundColor Red
    exit 1
}

# Check Docker
try {
    $dockerVersion = docker --version
    Write-Host "  ✅ Docker installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Docker not found. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "  ✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check MySQL
Write-Host "  ℹ️  Checking MySQL connection (localhost:3306)..." -ForegroundColor Cyan
Write-Host "     Note: This script assumes MySQL is running with user 'root' and password '12345678'" -ForegroundColor Gray

Write-Host ""

# ==============================================================================
# Step 2: Clone repositories
# ==============================================================================
Write-Host "📥 Step 2: Cloning repositories..." -ForegroundColor Yellow

$repos = @(
    @{Name="OsitoPolar.Shared.Events"; Target="OsitoPolar.Shared.Events"},
    @{Name="BC-IAM"; Target="OsitoPolar.IAM.Service"},
    @{Name="BC-Profiles"; Target="OsitoPolar.Profiles.Service"},
    @{Name="BC-Equipment"; Target="OsitoPolar.Equipment.Service"},
    @{Name="BC-WorkOrders"; Target="OsitoPolar.WorkOrders.Service"},
    @{Name="BC-ServiceRequest"; Target="OsitoPolar.ServiceRequests.Service"},
    @{Name="BC-Subscriptions"; Target="OsitoPolar.Subscriptions.Service"},
    @{Name="BC-Notifications"; Target="OsitoPolar.Notifications.Service"},
    @{Name="BC-Analytics"; Target="OsitoPolar.Analytics.Service"},
    @{Name="OsitoPolar-Api-Gateway"; Target="OsitoPolar.ApiGateway"}
)

foreach ($repo in $repos) {
    $repoName = $repo.Name
    $targetDir = $repo.Target

    if (Test-Path $targetDir) {
        Write-Host "  ⏭️  $targetDir already exists, pulling latest changes..." -ForegroundColor Cyan
        Set-Location $targetDir
        git pull
        Set-Location $baseDir
    } else {
        Write-Host "  📦 Cloning $repoName as $targetDir..." -ForegroundColor Cyan
        git clone "https://github.com/Inteligencia-Artesanal-FunArqui/$repoName.git" $targetDir
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ❌ Failed to clone $repoName. Make sure you have access to the repository." -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "  ✅ $targetDir ready" -ForegroundColor Green
}

Write-Host ""

# ==============================================================================
# Step 3: Create .env file
# ==============================================================================
Write-Host "⚙️  Step 3: Setting up environment variables..." -ForegroundColor Yellow

Set-Location "OsitoPolar-Infrastructure"

if (!(Test-Path ".env")) {
    Write-Host "  📝 Creating .env file from .env.example..." -ForegroundColor Cyan
    Copy-Item ".env.example" ".env"
    Write-Host "  ✅ .env file created" -ForegroundColor Green
    Write-Host ""
    Write-Host "  ⚠️  IMPORTANT: Edit the .env file with your credentials:" -ForegroundColor Yellow
    Write-Host "     - MySQL password (if different from 12345678)" -ForegroundColor Gray
    Write-Host "     - MailerSend credentials (if you want to test emails)" -ForegroundColor Gray
    Write-Host "     - Stripe credentials (if you want to test payments)" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "  ✅ .env file already exists" -ForegroundColor Green
}

Set-Location $baseDir

Write-Host ""

# ==============================================================================
# Step 4: Create databases
# ==============================================================================
Write-Host "🗄️  Step 4: Creating MySQL databases..." -ForegroundColor Yellow

$databases = @(
    "ositopolar_iam",
    "ositopolar_profiles",
    "ositopolar_equipment",
    "ositopolar_workorders",
    "ositopolar_servicerequests",
    "ositopolar_subscriptions",
    "ositopolar_notifications",
    "ositopolar_analytics"
)

Write-Host "  ℹ️  Attempting to create databases..." -ForegroundColor Cyan
Write-Host "  ℹ️  If this fails, create them manually using the SQL commands in README.md" -ForegroundColor Cyan

foreach ($db in $databases) {
    $createDbQuery = "CREATE DATABASE IF NOT EXISTS $db;"
    try {
        # Try to create database using mysql command
        $createDbQuery | mysql -u root -p12345678 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Database '$db' created or already exists" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  Could not verify '$db' - please create manually if needed" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ⚠️  Could not create '$db' - please create manually" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "  💡 If database creation failed, run these commands in MySQL:" -ForegroundColor Cyan
foreach ($db in $databases) {
    Write-Host "     CREATE DATABASE $db;" -ForegroundColor Gray
}

Write-Host ""

# ==============================================================================
# Step 5: Build and start containers
# ==============================================================================
Write-Host "🐳 Step 5: Building and starting Docker containers..." -ForegroundColor Yellow

Set-Location "OsitoPolar-Infrastructure"

Write-Host "  📦 This will take several minutes on first run..." -ForegroundColor Cyan
Write-Host ""

docker-compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Services are now running on:" -ForegroundColor Cyan
    Write-Host "   • API Gateway:        http://localhost:8080/swagger" -ForegroundColor White
    Write-Host "   • IAM Service:        http://localhost:5001/swagger" -ForegroundColor White
    Write-Host "   • Profiles Service:   http://localhost:5002/swagger" -ForegroundColor White
    Write-Host "   • Equipment Service:  http://localhost:5003/swagger" -ForegroundColor White
    Write-Host "   • WorkOrders Service: http://localhost:5004/swagger" -ForegroundColor White
    Write-Host "   • ServiceReq Service: http://localhost:5005/swagger" -ForegroundColor White
    Write-Host "   • Subscriptions Svc:  http://localhost:5006/swagger" -ForegroundColor White
    Write-Host "   • Notifications Svc:  http://localhost:5007/swagger" -ForegroundColor White
    Write-Host "   • Analytics Service:  http://localhost:5008/swagger" -ForegroundColor White
    Write-Host "   • RabbitMQ UI:        http://localhost:15672" -ForegroundColor White
    Write-Host "                         (user: ositopolar, pass: OsitoPolar2024!)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📊 To view logs:         docker-compose logs -f" -ForegroundColor Yellow
    Write-Host "⏹️  To stop services:     docker-compose down" -ForegroundColor Yellow
    Write-Host "🔄 To restart services:  docker-compose restart" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Setup failed during Docker build" -ForegroundColor Red
    Write-Host "Please check the error messages above" -ForegroundColor Yellow
    exit 1
}
