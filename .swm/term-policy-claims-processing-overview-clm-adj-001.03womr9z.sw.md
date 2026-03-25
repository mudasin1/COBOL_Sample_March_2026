---
title: Term Policy Claims Processing - Overview (CLM-ADJ-001)
---
# Overview

This document explains the flow for processing term policy claims. The system validates claim eligibility, checks for investigation triggers, adjudicates coverage, and calculates settlement. Claims are either rejected, routed for manual review, or settled based on plan rules and completeness of information.

```mermaid
flowchart TD
    node1["Initializing and Loading Plan Rules"]:::HeadingStyle
    click node1 goToHeading "Initializing and Loading Plan Rules"
    node1 --> node2{"Claim Intake Validation
(Eligibility,
completeness, document checks)
(Claim Intake Validation)"}:::HeadingStyle
    click node2 goToHeading "Claim Intake Validation"
    node2 -->|"Rejected"| node3["Post-Validation Routing
(Reject
claim)
(Post-Validation Routing)"]:::HeadingStyle
    click node3 goToHeading "Post-Validation Routing"
    node2 -->|"Manual Review"| node4["Post-Validation Routing
(Route for
manual investigation)
(Post-Validation Routing)"]:::HeadingStyle
    click node4 goToHeading "Post-Validation Routing"
    node2 -->|"Valid"| node5["Post-Validation Routing
(Settle
claim)
(Post-Validation Routing)"]:::HeadingStyle
    click node5 goToHeading "Post-Validation Routing"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

## Dependencies

### Program

- CLMADJ001 (<SwmPath>[CLM-ADJ-001.cob](CLM-ADJ-001.cob)</SwmPath>)

### Copybook

- POLDATA (<SwmPath>[POLDATA.cpy](POLDATA.cpy)</SwmPath>)

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
