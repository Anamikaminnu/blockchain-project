@echo off
REM Firebase Configuration Helper Script for Windows
REM This script helps test and troubleshoot Firebase connection

echo.
echo ========================================
echo Firebase Configuration Helper
echo ========================================
echo.

:menu
echo.
echo Select an option:
echo 1. Test Firebase Connection
echo 2. Start Django Server
echo 3. Open Firebase Console
echo 4. Show Configuration
echo 5. Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto test_firebase
if "%choice%"=="2" goto start_server
if "%choice%"=="3" goto open_firebase
if "%choice%"=="4" goto show_config
if "%choice%"=="5" goto end

echo Invalid choice. Please try again.
goto menu

:test_firebase
echo.
echo Testing Firebase connection...
echo.
python manage.py test_firebase
pause
goto menu

:start_server
echo.
echo Starting Django development server...
echo Access at: http://localhost:8000/
echo Vehicle Tracking: http://localhost:8000/vehicle-tracking/
echo.
python manage.py runserver
goto menu

:open_firebase
echo.
echo Opening Firebase Console...
echo.
start https://console.firebase.google.com/project/accidentdetection-a3f5c/database/rules
echo.
echo Instructions:
echo 1. Replace the existing rules with:
echo {
echo   "rules": {
echo     ".read": true,
echo     ".write": false
echo   }
echo }
echo 2. Click "Publish"
echo 3. Come back and run test_firebase.py
echo.
pause
goto menu

:show_config
echo.
echo Current Firebase Configuration:
echo.
python -c "from django.conf import settings; import django; django.setup(); print('Database URL:', settings.FIREBASE_DATABASE_URL); print('API Key:', settings.FIREBASE_API_KEY[:20] + '...')"
echo.
pause
goto menu

:end
echo.
echo Goodbye!
echo.
