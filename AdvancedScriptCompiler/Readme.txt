NWNScriptCompiler is an improved version of Edward T. Smith (Torlack's)
nwnnsscomp, with numerous bugfixes and improvements.  It is a standalone,
console driven compiler suitable for batch usage outside of the toolset.

Improvements over the stock nwnnsscomp include:

- New -l option to load resources from the game zip files.
- New -b option for true batch mode under Windows.
- Nested structs are now usable and do not produce an erroneous syntax error.
- Case statement blocks now obey proper rules for variable declarations; it is
  no longer possible to declare a variable that is skipped by a case statement,
  which would not compile with the standard (toolset) script compiler.
- The main and StartingConditional symbols are now required to be functions.
- Prototypes that do not match their function declarations are now fixed up by
  the compiler (with a warning) if compiler version 1.69 or lower is specified.
  This allows several broken include scripts shipped with the game to compile
  Note that a prototype cannot be fixed up if a function is called before the
  real declaration is processed.  In this case, an error is generated; the
  standard compiler generates bad code in such a case.  A prototype that is
  fixed up by the compiler generates a compiler warning.
- Uninitialized constants (const int x;) now generate a warning instead of an
  error if compiler version 1.69 or lower is specified.  The standard script
  compiler silently permits such constructs.
- An error is generated if a string literal's length exceeds 511 characters and
  compiler version 1.69 or lower is specified.  This is consistent with the
  standard script compiler's internal limitations.
- Attempts to use a switch statement while immediately located within a
  do/while block now generate a warning.  In the standard script compiler, such
  constructs cause bad code generation due to a compiler bug.
- Nested structure element access now generates a warning.  In the standard
  script compiler, a compiler bug may result in compilation errors or bad code
  generation with nested structure usage.
- Modifying a constant global variable before it is declared now generates a
  warning.  In nwnnsscomp, such constructs could either cause an internal
  compilert assertion failure, or could result in bad code generation.
- Script disassembly now generates a high level IR output (.ir), and a high
  level optimized IR output (.ir-opt).
- Scripts can now be loaded directly from a module.
- NWN1 game resource directories no longer are required to be present on the
  Windows build.
- NWN1-style resource directories can be used with the -1 command line option.

Run NWNScriptCompiler -? for a listing of command line options and their
meanings.  Existing nwnnsscomp options are preserved and kept functional.

