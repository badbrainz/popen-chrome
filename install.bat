@echo off

fsutil dirty query %systemdrive% >nul
if %errorlevel% == 0 (
    goto :install
) else (
    echo Error: Run as administrator.
)

:install
set name=cheeky
set desc=%name% host file
set exe=%name%.exe
set host=com.%name%
set json=com.%name%.json
set origin=fbbbambpgamdpfjihafdpbehndhjifdf
@echo {^
 "name": "%host%",^
 "description": "%desc%",^
 "path": "%exe%",^
 "type": "stdio",^
 "allowed_origins": [^
 "chrome-extension://%origin%/"^
 ]^
} > %json%
reg add HKLM\SOFTWARE\Google\Chrome\NativeMessagingHosts\%host% /f /ve /t REG_SZ /d %~dp0%json%
exit /b
