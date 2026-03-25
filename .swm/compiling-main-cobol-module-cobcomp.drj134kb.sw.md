---
title: Compiling Main COBOL Module (COBCOMP)
---
This document explains the COBCOMP job which compiles the main COBOL application module. It reads the primary COBOL source and copybooks, compiles and syntax-checks the business logic, and produces an optimized object module ready for linking and execution. For example, given a COBOL source file implementing core business rules and referencing shared copybooks, the job compiles these into an executable object module.

## Compile Main Module

Step in this section: `COB1`.

This section compiles the primary COBOL application logic and dependencies into an object module, making it ready for further linking and execution in the system.

- The main COBOL source code is read and parsed to identify supported COBOL syntax and business logic routines used by the system.
- Any referenced shared business rules from the copybook library are included.
- The complete business logic is analyzed, syntax checked, and translated into an optimized object code representation that the execution environment can process.
- The resulting object module contains the executable form of the core application ready for linkage.

### Input

**COBOL main module source**

Contains the main business rules written in COBOL language, implementing the core application logic.

**COBOL copybooks**

Contains reusable business logic routines referenced by the main module.

### Output

**Object module**

The compiled and optimized version of the main application's business logic, ready for linking and execution.

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
