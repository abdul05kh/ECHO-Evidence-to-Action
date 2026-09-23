@echo off
echo ===================================================
echo ECHO Mobile Project Verification Script
echo ===================================================

cd mobile

echo [1/3] Running flutter pub get...
call flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] flutter pub get failed!
    exit /b %errorlevel%
)

echo [2/3] Running flutter analyze...
call flutter analyze
if %errorlevel% neq 0 (
    echo [ERROR] flutter analyze failed!
    exit /b %errorlevel%
)

echo [3/3] Running flutter test...
call flutter test
if %errorlevel% neq 0 (
    echo [ERROR] flutter test failed!
    exit /b %errorlevel%
)

echo ===================================================
echo SUCCESS: All project verification checks passed!
echo ===================================================
