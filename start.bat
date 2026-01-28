@echo off
echo Starting Water Supply Management System...
echo.

start "Backend Server" cmd /k "cd backend && .\mvnw.cmd spring-boot:run"
timeout /t 5 /nobreak > nul

start "Frontend Server" cmd /k "cd frontend && npm start"

echo.
echo Both servers are starting...
echo Backend:  http://localhost:8080
echo Frontend: http://localhost:3000
echo.
