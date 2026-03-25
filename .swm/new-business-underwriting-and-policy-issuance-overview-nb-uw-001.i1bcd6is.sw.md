---
title: New Business Underwriting and Policy Issuance Overview (NB-UW-001)
---
# Overview

This document describes the flow for processing new term life insurance applications. The flow validates eligibility, assigns risk, calculates premiums, checks rider eligibility, and determines whether the policy is issued, referred, or declined.

```mermaid
flowchart TD
    node1["Starting the Application Processing"]:::HeadingStyle
    click node1 goToHeading "Starting the Application Processing"
    node1 --> node2["Setting Plan Rules and Limits"]:::HeadingStyle
    click node2 goToHeading "Setting Plan Rules and Limits"
    node2 --> node3{"Validating Application Data
Eligibility?
(Validating Application Data)"}:::HeadingStyle
    click node3 goToHeading "Validating Application Data"
    node3 -->|"No"| node7["Final Referral and Policy Issuance
(Declined)
(Final Referral and Policy Issuance)"]:::HeadingStyle
    click node7 goToHeading "Final Referral and Policy Issuance"
    node3 -->|"Yes"| node4["Assigning Underwriting Risk
(Assigning Underwriting Risk)"]:::HeadingStyle
    click node4 goToHeading "Assigning Underwriting Risk"
    node4 --> node5{"Underwriting Risk?
Declined or Referred?
(Assigning Underwriting Risk)"}:::HeadingStyle
    click node5 goToHeading "Assigning Underwriting Risk"
    node5 -->|"Declined or Referred"| node7
    node5 -->|"Eligible"| node6["Total Premium Calculation"]:::HeadingStyle
    click node6 goToHeading "Total Premium Calculation"
    node6 --> node8{"Referral Flagging
Referral Required?
(Referral Flagging)"}:::HeadingStyle
    click node8 goToHeading "Referral Flagging"
    node8 -->|"Yes"| node7
    node8 -->|"No"| node9["Final Referral and Policy Issuance
(Issued)
(Final Referral and Policy Issuance)"]:::HeadingStyle
    click node9 goToHeading "Final Referral and Policy Issuance"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

## Dependencies

### Program

- NBUW001 (<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>)

### Copybook

- POLDATA (<SwmPath>[POLDATA.cpy](POLDATA.cpy)</SwmPath>)

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
