@echo off
REM Setup script for Food Delivery Application (Windows)
REM This script prepares your environment for development

echo.
echo ╔════════════════════════════════════════╗
echo ║  Food Delivery App - Setup (Windows)   ║
echo ╚════════════════════════════════════════╝
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if errorlevel 1 (
    echo ❌ Node.js is not installed. Please install it first.
    exit /b 1
)

for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
echo ✅ Node.js %NODE_VERSION% found

REM Check if Docker is installed
where docker >nul 2>nul
if errorlevel 1 (
    echo ⚠️  Docker is not installed. You can still run locally without Docker.
    set DOCKER_INSTALLED=false
) else (
    echo ✅ Docker installed
    set DOCKER_INSTALLED=true
)

echo.
echo 📦 Installing dependencies...
echo.

echo Installing backend dependencies...
cd backend
call npm install
cd ..

echo Installing frontend dependencies...
cd frontend
call npm install
cd ..

echo Installing admin dependencies...
cd admin
call npm install
cd ..

echo.
echo ✅ Dependencies installed
echo.

REM Create environment files if they don't exist
echo 🔧 Setting up environment variables...

if not exist "backend\.env" (
    copy backend\.env.example backend\.env
    echo ✅ Created backend\.env
) else (
    echo ⚠️  backend\.env already exists
)

if not exist "frontend\.env" (
    copy frontend\.env.example frontend\.env
    echo ✅ Created frontend\.env
) else (
    echo ⚠️  frontend\.env already exists
)

if not exist "admin\.env" (
    copy admin\.env.example admin\.env
    echo ✅ Created admin\.env
) else (
    echo ⚠️  admin\.env already exists
)

REM Create uploads directory
if not exist "backend\uploads" (
    mkdir backend\uploads
    echo ✅ Created uploads directory
)

echo.
echo ════════════════════════════════════════
echo ✅ Setup Complete!
echo ════════════════════════════════════════
echo.
echo 📝 Next Steps:
echo.
echo 1. Edit environment files (if needed):
echo    - backend\.env
echo    - frontend\.env
echo    - admin\.env
echo.

if "%DOCKER_INSTALLED%"=="true" (
    echo 2. Start Docker containers:
    echo    docker-compose up --build
    echo.
)

echo 3. Or run services individually in separate terminals:
echo    - Backend: cd backend ^& npm run server
echo    - Frontend: cd frontend ^& npm run dev
echo    - Admin: cd admin ^& npm run dev
echo.
echo 4. For Railway deployment:
echo    - Read: RAILWAY_DEPLOYMENT.md
echo    - Check: DEPLOYMENT_CHECKLIST.md
echo.
echo 5. Visit URLs:
echo    - Frontend: http://localhost:5173
echo    - Admin: http://localhost:5174
echo    - Backend API: http://localhost:4000
echo.
pause
