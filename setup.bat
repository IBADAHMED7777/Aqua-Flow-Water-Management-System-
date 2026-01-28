@echo off
echo ========================================
echo Water Supply Management System - Setup
echo ========================================
echo.

echo Step 1: Setting up PostgreSQL database...
echo Please ensure PostgreSQL is running and create the database:
echo.
echo   CREATE DATABASE watersupply;
echo.
echo Update credentials in backend\src\main\resources\application.yml
echo.
pause

echo.
echo Step 2: Building backend...
cd backend
call mvn clean install
if %ERRORLEVEL% NEQ 0 (
    echo Backend build failed!
    pause
    exit /b 1
)

echo.
echo Step 3: Installing frontend dependencies...
cd ..\frontend
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo Frontend install failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To start the application:
echo.
echo 1. Backend:  cd backend  && mvn spring-boot:run
echo 2. Frontend: cd frontend && npm start
echo.
echo Default credentials:
echo   Admin:    admin@water.com    / admin123
echo   Employee: employee@water.com / emp123
echo   User:     user@water.com     / user123
echo.
pause
