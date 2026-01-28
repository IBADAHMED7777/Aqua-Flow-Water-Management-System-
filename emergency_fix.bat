@echo off
setlocal
echo ===================================================
echo   AQUAFLOW EMERGENCY DATABASE REPAIR TOOL
echo ===================================================
echo.
echo This script will force the database to update without
echo relying on the application startup.
echo.

set MYSQL_CMD=""

:: Attempt to find mysql.exe in common locations
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" set MYSQL_CMD="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if exist "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" set MYSQL_CMD="C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
if exist "C:\xampp\mysql\bin\mysql.exe" set MYSQL_CMD="C:\xampp\mysql\bin\mysql.exe"

if %MYSQL_CMD% == "" (
    echo ERROR: Could not find mysql.exe automatically.
    echo.
    echo Please verify your MySQL installation path.
    goto :MANUAL
)

echo Found MySQL at: %MYSQL_CMD%
echo.
set /p MYSQL_PWD="Enter your MySQL 'root' password (usually ssuet++99 or root): "

echo.
echo Attempting to fix 'orders' table...
%MYSQL_CMD% -u root -p%MYSQL_PWD% -e "USE water_supply_db; ALTER TABLE orders ADD COLUMN paid BOOLEAN NOT NULL DEFAULT FALSE;" 2>nul
%MYSQL_CMD% -u root -p%MYSQL_PWD% -e "USE water_supply_db; ALTER TABLE orders ADD COLUMN paid_at DATETIME NULL;" 2>nul

echo Attempting to fix 'complaints' table...
%MYSQL_CMD% -u root -p%MYSQL_PWD% -e "USE water_supply_db; ALTER TABLE complaints ADD COLUMN subject VARCHAR(255) NOT NULL DEFAULT 'General Issue';" 2>nul
%MYSQL_CMD% -u root -p%MYSQL_PWD% -e "USE water_supply_db; ALTER TABLE complaints MODIFY COLUMN subject VARCHAR(255) NOT NULL DEFAULT 'General Issue';" 2>nul

echo.
echo ===================================================
echo   REPAIR COMMANDS EXECUTED
echo ===================================================
echo.
echo If you saw no errors above, the database is fixed.
echo If you saw "Duplicate column name", THAT IS GOOD! It means it's already fixed.
echo.
echo PLEASE RESTART YOUR APPLICATION NOW.
echo.
pause
exit /b

:MANUAL
echo.
echo We could not find mysql.exe.
echo Please open MySQL Workbench and run the following SQL manually:
echo.
echo ALTER TABLE water_supply_db.orders ADD COLUMN paid BOOLEAN NOT NULL DEFAULT FALSE;
echo ALTER TABLE water_supply_db.orders ADD COLUMN paid_at DATETIME NULL;
echo ALTER TABLE water_supply_db.complaints ADD COLUMN subject VARCHAR(255) NOT NULL DEFAULT 'Subject';
echo.
pause
