# z/OS JCL templates

These members are **skeletons**. Replace symbolic placeholders with your installation’s data set names, compiler PROCs (`COB2`, `IGYWCLG`, etc.), and load-library conventions.

## Placeholders

| Symbol | Meaning |
|--------|---------|
| `&HLQ.` or `YOUR.HLQ` | High-level qualifier for sources and objects |
| `&PROJ.` | Project / application prefix (e.g. `COBSAMP`) |
| `&LOAD.` | Load library PDSE for executable modules |
| `&OBJ.` | Object library for `SYSOBJ` / `SYSLIN` |
| `&CPY.` | Copybook PDS (`POLDATA` must resolve via `SYSLIB`) |

## Entry points

Batch **drivers** (`DRIVENBUW`, `DRIVESVC`, `DRIVECLM`) are the programs to execute under `EXEC PGM=`. The business modules (`NBUW001`, `SVCBILL001`, `CLMADJ001`) are called dynamically/statically from those drivers and must reside in `STEPLIB` or the link edit must include them in the same load module (depending on your bind).

## Members

- `COMPILE.jcl` — compile COBOL sources with `IGYCRCTL`; `SYSLIB` must list the PDS containing `POLDATA`.
- `BIND.jcl` — bind skeleton using `IEWL` (replace with your binder `PGM` if required).
- `RUNNBUW.jcl` — execute the new-business driver load module (set `STEPLIB` / `JOBLIB`).

Extend `RUNNBUW.jcl` pattern for `DRIVESVC` and `DRIVECLM`.
