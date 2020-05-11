@if not exist %~dps0\release mkdir %~dps0\..\release
@nmake /NOLOGO PROJECT_SOURCE_ROOT=%~dps0\..\ %1 %2 %3 %4 %5 %6 %7 %8 %9
