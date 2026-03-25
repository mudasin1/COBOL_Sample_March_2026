---
title: Build Core Insurance Logic Executable (COBLINK)
---
This document explains the COBLINK job that builds the core insurance logic executable (COBLINK). It consolidates compiled program objects into a single executable with a designated entry point for transaction processing. The resulting load module is stored in the output library for use in production. For example, compiled objects for the insurance transaction handler and supporting modules are linked to produce an executable ready for deployment.

## Build Core Insurance Logic Executable

Step in this section: `BIND`.

This section consolidates compiled program objects that implement the product's main insurance logic into a single loadable executable for use in production.

- The binder utility takes the compiled program objects, including the core insurance transaction handler and supporting logic modules, from the program object library.
- It combines them as specified, sets the designated entry point for transaction handling, and generates a single executable load module.
- The resulting module is placed in the specified output library, ready for use in insurance transaction processing workflows.

### Input

**OBJLIB**

Compiled program objects implementing insurance logic and supporting subroutines.

### Output

**SYSLMOD**

Executable module that can process core insurance transactions.

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
