@echo off
echo ========================================
echo Database Migration: Add Payment Tracking
echo ========================================
echo.

REM Try to find MySQL in common installation paths
set MYSQL_PATH=
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
if exist "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe
if exist "C:\xampp\mysql\bin\mysql.exe" set MYSQL_PATH=C:\xampp\mysql\bin\mysql.exe

if "%MYSQL_PATH%"=="" (
    echo ERROR: MySQL not found in common paths!
    echo.
    echo Please run the migration manually:
    echo 1. Open MySQL Workbench or phpMyAdmin
    echo 2. Execute the file: add_payment_columns.sql
    echo.
    pause
    exit /b 1
)

echo Found MySQL at: %MYSQL_PATH%
echo.
echo This will add payment tracking columns to the orders table.
echo.
set /p password="Enter MySQL root password: "

echo.
echo Running migration...
"%MYSQL_PATH%" -u root -p%password% < add_payment_columns.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Migration completed successfully!
    echo ========================================
    echo.
    echo Next steps:
    echo 1. Restart the application (stop run.bat and start again)
    echo 2. Test placing an order
    echo 3. Check the Billing tab
    echo.
) else (
    echo.
    echo ERROR: Migration failed!
    echo Please check your MySQL password and try again.
    echo.
)

pause
