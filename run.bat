@echo off
echo ========================================
echo Water Supply Management System
echo ========================================
echo.

echo [1/2] Starting Backend Server (Spring Boot)...
echo Using Global Maven (mvn)
echo Database: MySQL (Ensure service is running)
start "Backend - Water Supply System" cmd /k "cd backend && mvn spring-boot:run"

echo Waiting for backend to initialize...
timeout /t 10 /nobreak

echo.

echo.
echo [2/2] Starting Frontend Server (React)...
set BROWSER=none
start "Frontend - Water Supply System" cmd /k "cd frontend && npm start"

echo.
echo ========================================
echo Servers are starting...
echo ========================================
echo.
echo Backend:  http://localhost:8080
echo Frontend: http://localhost:3000
echo.
echo Waiting for frontend to be ready...
timeout /t 15 /nobreak
start http://localhost:3000/login?fresh=true

echo.
echo Default Login Credentials:
echo   Admin:    admin@water.com    / admin123
echo   Employee: employee@water.com / emp123
echo   User:     user@water.com     / user123
echo.
echo Both servers will open in separate windows.
echo Close those windows to stop the servers.
echo.
pause
