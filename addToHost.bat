@echo off
setlocal enabledelayedexpansion

:: Definir entradas
set marker=#FACTURADOR GS
set entry1=192.168.0.145    facturador.gs
set entry2=192.168.0.145    mjm.facturador.gs
set entry3=192.168.0.145    caliprix.facturador.gs
set entry4=192.168.0.145    lacompania.facturador.gs
set entry5=192.168.0.145    bienesraices.facturador.gs
set entry6=192.168.0.145    semaan.facturador.gs
set entry7=192.168.0.145    gruposemaan.facturador.gs


set hostsFile=%SystemRoot%\System32\drivers\etc\hosts

:: Verificar si ya existen
findstr /C:"%entry1%" "%hostsFile%" >nul || (
    echo Agregando entradas al archivo hosts...
    echo. >> "%hostsFile%"
    echo %marker% >> "%hostsFile%"
    echo %entry1% >> "%hostsFile%"
    echo %entry2% >> "%hostsFile%"
    echo %entry3% >> "%hostsFile%"
    echo %entry4% >> "%hostsFile%"
    echo %entry5% >> "%hostsFile%"
    echo %entry6% >> "%hostsFile%"
    echo %entry7% >> "%hostsFile%"
    echo Entradas agregadas correctamente.
) 

findstr /C:"%entry1%" "%hostsFile%" >nul && echo Las entradas ya están presentes. No se hizo ningún cambio.

pause