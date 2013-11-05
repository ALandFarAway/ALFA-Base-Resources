@echo off

echo Copying %1 to ..\..\..\..\release\SharedAssemblies (from %CD%)... > ..\..\..\..\release\CLRBUILDLOG

if not exist ..\..\..\..\release ( mkdir ..\..\..\..\release )
if %ERRORLEVEL% NEQ 0 ( goto :EOF )
if not exist ..\..\..\..\release\SharedAssemblies ( mkdir ..\..\..\..\release\SharedAssemblies )
if %ERRORLEVEL% NEQ 0 ( goto :EOF )
copy /y %1 ..\..\..\..\release\SharedAssemblies\ >> ..\..\..\..\release\CLRBUILDLOG
if %ERRORLEVEL% NEQ 0 ( goto :EOF )
