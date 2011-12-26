@echo off

echo Packaging %1 into %2...

..\..\..\..\CLRScript\NativeScriptUtil.exe -i %1 -o %2 -q
copy /y %2 ..\..\..\..\release
