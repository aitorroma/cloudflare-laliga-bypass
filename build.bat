@echo off
where uv >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing uv package manager...
    pip install uv
)

echo Installing required packages...
uv pip install requests
uv pip install configparser
uv pip install pyinstaller

echo Building executable with PyInstaller...
uv run pyinstaller cloudflare.spec

echo Done! The executable should be in the dist folder.
echo.
echo If you still get antivirus warnings, try these steps:
echo 1. Add an exclusion in Windows Defender:
echo    - Open Windows Security
echo    - Go to Virus ^& threat protection
echo    - Under Virus ^& threat protection settings, click "Manage settings"
echo    - Scroll down to "Exclusions" and click "Add or remove exclusions"
echo    - Add the dist folder or the cloudflare.exe file
echo.
echo 2. Alternatively, try running with this command instead:
echo    uv run pyinstaller --noupx --clean --onefile --hidden-import=requests --hidden-import=configparser cloudflare.py