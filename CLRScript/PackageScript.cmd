@echo off

echo Packaging %1 into %2 (from %CD%)... > ..\..\..\..\release\CLRBUILDLOG

"%~dp0\NativeScriptUtil.exe" -i %1 -o %2 -q >> ..\..\..\..\release\CLRBUILDLOG
if %ERRORLEVEL% NEQ 0 ( goto :EOF )
copy /y %2 ..\..\..\..\release >> ..\..\..\..\release\CLRBUILDLOG
if %ERRORLEVEL% NEQ 0 ( goto :EOF )
