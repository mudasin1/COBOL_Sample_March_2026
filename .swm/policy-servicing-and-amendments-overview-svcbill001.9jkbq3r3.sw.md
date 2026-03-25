---
title: Policy Servicing and Amendments  Overview (SVCBILL001)
---
# Overview

This document explains the flow of policy servicing for term life insurance policies. The flow validates policy eligibility and amendment requests, applies changes such as plan updates, sum assured modifications, rider additions/removals, billing mode changes, and policy reinstatements. It recalculates premiums and fees as needed and updates policy records or returns error messages.

```mermaid
flowchart TD
    node1["Starting Policy Servicing Flow"]:::HeadingStyle --> node2["Checking Policy Eligibility for Servicing"]:::HeadingStyle
    click node1 goToHeading "Starting Policy Servicing Flow"
    click node2 goToHeading "Checking Policy Eligibility for Servicing"
    node2 -->|"Eligible"| node3["Handling Amendment Actions"]:::HeadingStyle
    click node3 goToHeading "Handling Amendment Actions"
    node2 -->|"Not Eligible"| node4["Completing Policy Servicing"]:::HeadingStyle
    click node4 goToHeading "Completing Policy Servicing"
    node3 -->|"Amendment processed"| node4
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

## Dependencies

### Program

- SVCBILL001 (<SwmPath>[SVC-BILL-001.cob](SVC-BILL-001.cob)</SwmPath>)

### Copybook

- POLDATA (<SwmPath>[POLDATA.cpy](POLDATA.cpy)</SwmPath>)

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
