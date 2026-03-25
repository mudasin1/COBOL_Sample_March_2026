---
title: Claim Adjudication and Settlement (CLM-ADJ-001)
---
# Overview

This document describes the flow for processing term life insurance claims. Claims are validated for eligibility, flagged for investigation if contestability or documentation issues arise, and either routed for manual review, rejected, or settled automatically.

```mermaid
flowchart TD
    node1["Starting claim adjudication"]:::HeadingStyle --> node2{"Checking claim eligibility
(Checking claim eligibility)"}:::HeadingStyle
    click node1 goToHeading "Starting claim adjudication"
    click node2 goToHeading "Checking claim eligibility"
    node2 -->|"Rejected"| node3["Routing claims after investigation check
(Claim rejected)
(Routing claims after investigation check)"]:::HeadingStyle
    click node3 goToHeading "Routing claims after investigation check"
    node2 -->|"Eligible"| node4["Flagging claims for investigation"]:::HeadingStyle
    click node4 goToHeading "Flagging claims for investigation"
    node4 --> node5{"Routing claims after investigation
check
(Routing claims after investigation check)"}:::HeadingStyle
    click node5 goToHeading "Routing claims after investigation check"
    node5 -->|"Manual review"| node6["Manual investigation"]
    node5 -->|"Rejected"| node3
    node5 -->|"Settled"| node7["Claim settled"]
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

## Dependencies

### Program

- <SwmToken path="cobol/CLM-ADJ-001.cob" pos="2:6:6" line-data="       PROGRAM-ID. CLMADJ001.">`CLMADJ001`</SwmToken> (<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>)

### Copybook

- POLDATA (<SwmPath>[cpy/POLDATA.cpy](cpy/POLDATA.cpy)</SwmPath>)

# Where is this program used?

This program is used once, as represented in the following diagram:

```mermaid
graph TD
  dih6g("(DRIVER-CLMADJ001) Integration testing for claim adjustment") --> mf4og("CLMADJ001 Claim adjudication and settlement"):::currentEntity
click dih6g openCode "cobol/drivers/DRIVER-CLMADJ001.cob:1"
  
  
click mf4og openCode "cobol/CLM-ADJ-001.cob:1"
    classDef currentEntity color:#000000,fill:#7CB9F4

%% Swimm:
%% graph TD
%%   dih6g("(DRIVER-CLMADJ001) Integration testing for claim adjustment") --> mf4og("<SwmToken path="cobol/CLM-ADJ-001.cob" pos="2:6:6" line-data="       PROGRAM-ID. CLMADJ001.">`CLMADJ001`</SwmToken> Claim adjudication and settlement"):::currentEntity
%% click dih6g openCode "<SwmPath>[cobol/drivers/DRIVER-CLMADJ001.cob](cobol/drivers/DRIVER-CLMADJ001.cob)</SwmPath>:1"
%%   
%%   
%% click mf4og openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:1"
%%     classDef currentEntity color:#000000,fill:#7CB9F4
```

# Workflow

# Starting claim adjudication

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Validate claim intake"]
    click node1 openCode "cobol/CLM-ADJ-001.cob:41:44"
    node1 --> node2{"Claim rejected after validation?"}
    
    node2 -->|"Yes"| node3["Reject claim"]
    click node3 openCode "cobol/CLM-ADJ-001.cob:45:48"
    node2 -->|"No"| node4["Flagging claims for investigation"]
    
    node4 --> node5{"Manual review or rejection after
investigation?"}
    click node5 openCode "cobol/CLM-ADJ-001.cob:51:64"
    node5 -->|"Manual review"| node6["Route for manual investigation"]
    click node6 openCode "cobol/CLM-ADJ-001.cob:51:58"
    node5 -->|"Rejected"| node3
    node5 -->|"No"| node7["Settle claim automatically"]
    click node7 openCode "cobol/CLM-ADJ-001.cob:66:68"
    node6 --> node8["End"]
    node7 --> node8
    node3 --> node8
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
click node2 goToHeading "Checking claim eligibility"
node2:::HeadingStyle
click node4 goToHeading "Flagging claims for investigation"
node4:::HeadingStyle

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Validate claim intake"]
%%     click node1 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:41:44"
%%     node1 --> node2{"Claim rejected after validation?"}
%%     
%%     node2 -->|"Yes"| node3["Reject claim"]
%%     click node3 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:45:48"
%%     node2 -->|"No"| node4["Flagging claims for investigation"]
%%     
%%     node4 --> node5{"Manual review or rejection after
%% investigation?"}
%%     click node5 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:51:64"
%%     node5 -->|"Manual review"| node6["Route for manual investigation"]
%%     click node6 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:51:58"
%%     node5 -->|"Rejected"| node3
%%     node5 -->|"No"| node7["Settle claim automatically"]
%%     click node7 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:66:68"
%%     node6 --> node8["End"]
%%     node7 --> node8
%%     node3 --> node8
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
%% click node2 goToHeading "Checking claim eligibility"
%% node2:::HeadingStyle
%% click node4 goToHeading "Flagging claims for investigation"
%% node4:::HeadingStyle
```

This section governs the initial adjudication of life insurance claims. It determines whether claims are accepted, rejected, flagged for investigation, routed for manual review, or settled automatically based on business rules and plan parameters.

| Rule ID | Category        | Rule Name              | Description                                                                                                                                                                                                                                           | Implementation Details                                                                                                                                                                      |
| ------- | --------------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Claim intake rejection | If a claim fails intake validation (e.g., not a death claim, policy is lapsed or terminated, missing essential data, or missing mandatory documents), the claim is marked as rejected and an error message and code are set.                          | Rejection is indicated by a flag and accompanied by a reason code and message. Error messages are alphanumeric strings up to 100 characters. Error codes are numeric values up to 4 digits. |
| BR-002  | Decision Making | Flag for investigation | If a claim passes intake validation, it is evaluated for investigation based on contestable period, cause of death, and presence of required medical documents. If any investigation criteria are met, the claim is flagged for manual investigation. | Flagging for investigation is indicated by a status flag and a hold reason. Investigation status is an alphanumeric string, and hold reason is a descriptive string.                        |
| BR-003  | Decision Making | Manual review routing  | If a claim is flagged for manual investigation, it is routed for manual review and the process ends for this claim in this section.                                                                                                                   | Manual review status is indicated by a flag. Routing for manual review is a process outcome, not a data output.                                                                             |
| BR-004  | Decision Making | Automatic settlement   | If a claim passes both intake validation and investigation criteria (i.e., does not require manual review or rejection after investigation), it is settled automatically.                                                                             | Automatic settlement is indicated by a status flag. Settlement outcome is a process result, not a data output in this section.                                                              |

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="41">

---

In <SwmToken path="cobol/CLM-ADJ-001.cob" pos="41:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, we run initialization and load plan parameters, then call <SwmToken path="cobol/CLM-ADJ-001.cob" pos="44:3:9" line-data="           PERFORM 1200-VALIDATE-CLAIM-INTAKE">`1200-VALIDATE-CLAIM-INTAKE`</SwmToken> to check if the claim meets intake rules. Validation needs plan-specific info, so it has to come after loading those parameters.

```cobol
       MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           PERFORM 1200-VALIDATE-CLAIM-INTAKE
```

---

</SwmSnippet>

## Checking claim eligibility

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node2{"Is this a death claim?"}
    click node2 openCode "cobol/CLM-ADJ-001.cob:103:109"
    node2 -->|"No"| node3["Reject claim: Only death claims
supported"]
    click node3 openCode "cobol/CLM-ADJ-001.cob:104:108"
    node2 -->|"Yes"| node4{"Is policy in force? (Not
lapsed/terminated)"}
    click node4 openCode "cobol/CLM-ADJ-001.cob:113:119"
    node4 -->|"No"| node5["Reject claim: Policy not in force"]
    click node5 openCode "cobol/CLM-ADJ-001.cob:114:118"
    node4 -->|"Yes"| node6{"Are claim ID, date of death, and
beneficiary present?"}
    click node6 openCode "cobol/CLM-ADJ-001.cob:122:129"
    node6 -->|"No"| node7["Reject claim: Missing claim ID, date of
death, or beneficiary"]
    click node7 openCode "cobol/CLM-ADJ-001.cob:124:128"
    node6 -->|"Yes"| node8{"Are all required documents provided?
(Death cert, claim form, ID proof)"}
    click node8 openCode "cobol/CLM-ADJ-001.cob:132:140"
    node8 -->|"No"| node9["Flag for manual review: Missing core
claim documents"]
    click node9 openCode "cobol/CLM-ADJ-001.cob:141:144"
    node8 -->|"Yes"| node10["Claim intake passes validation"]
    click node10 openCode "cobol/CLM-ADJ-001.cob:101:145"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node2{"Is this a death claim?"}
%%     click node2 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:103:109"
%%     node2 -->|"No"| node3["Reject claim: Only death claims
%% supported"]
%%     click node3 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:104:108"
%%     node2 -->|"Yes"| node4{"Is policy in force? (Not
%% lapsed/terminated)"}
%%     click node4 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:113:119"
%%     node4 -->|"No"| node5["Reject claim: Policy not in force"]
%%     click node5 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:114:118"
%%     node4 -->|"Yes"| node6{"Are claim ID, date of death, and
%% beneficiary present?"}
%%     click node6 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:122:129"
%%     node6 -->|"No"| node7["Reject claim: Missing claim ID, date of
%% death, or beneficiary"]
%%     click node7 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:124:128"
%%     node6 -->|"Yes"| node8{"Are all required documents provided?
%% (Death cert, claim form, ID proof)"}
%%     click node8 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:132:140"
%%     node8 -->|"No"| node9["Flag for manual review: Missing core
%% claim documents"]
%%     click node9 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:141:144"
%%     node8 -->|"Yes"| node10["Claim intake passes validation"]
%%     click node10 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:101:145"
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section validates claim eligibility for term life insurance policies, ensuring only valid death claims with all required information and documents proceed. It enforces business rules for claim intake and flags issues for rejection or manual review.

| Rule ID | Category        | Rule Name                      | Description                                                                                                                                | Implementation Details                                                                                                                                    |
| ------- | --------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Death claim only               | Reject any claim that is not a death claim. Only death claims are supported for this domain.                                               | Rejection code is 12. Rejection message is 'ONLY DEATH CLAIMS SUPPORTED IN SAMPLE'. Output format: code (number), message (string, up to 100 characters). |
| BR-002  | Data validation | Policy in force                | Reject claims where the policy is not in force, specifically if the policy is lapsed or terminated.                                        | Rejection code is 13. Rejection message is 'POLICY NOT IN FORCE AT CLAIM INTAKE'. Output format: code (number), message (string, up to 100 characters).   |
| BR-003  | Data validation | Required claim fields          | Reject claims missing any of the following: claim ID, date of death, or beneficiary name.                                                  | Rejection code is 14. Rejection message is 'CLAIM ID DOB BENEFICIARY REQUIRED'. Output format: code (number), message (string, up to 100 characters).     |
| BR-004  | Data validation | Missing core claim documents   | Flag claims for manual review if any required document (death certificate, claim form, ID proof) is missing.                               | Hold reason is 'MISSING CORE CLAIM DOCUMENTS'. Output format: hold reason (string, up to 100 characters).                                                 |
| BR-005  | Decision Making | Claim intake passes validation | Claims that pass all eligibility checks and have all required documents are considered valid for intake and proceed to further processing. | No rejection or hold reason is set. Claim proceeds to next stage. Output format: claim status (string, e.g. 'valid').                                     |

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="101">

---

In <SwmToken path="cobol/CLM-ADJ-001.cob" pos="101:1:7" line-data="       1200-VALIDATE-CLAIM-INTAKE.">`1200-VALIDATE-CLAIM-INTAKE`</SwmToken>, we start by checking if the claim is for death. If not, we reject it with code 12 and a message. The function relies on input flags being set correctly and uses domain-specific codes to signal validation failures.

```cobol
       1200-VALIDATE-CLAIM-INTAKE.
      * CL-201: Claim must be death claim for this sample domain.
           IF NOT PM-CLAIM-DEATH
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 12 TO PM-RETURN-CODE
              MOVE "ONLY DEATH CLAIMS SUPPORTED IN SAMPLE"
                   TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="113">

---

After checking claim type, we check if the policy is lapsed or terminated. If so, we reject the claim with code 13 and a message, skipping the rest of the validation steps.

```cobol
           IF PM-STAT-LAPSED OR PM-STAT-TERMINATED
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 13 TO PM-RETURN-CODE
              MOVE "POLICY NOT IN FORCE AT CLAIM INTAKE"
                   TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="122">

---

Here we check for missing claim ID, date of death, or beneficiary name. If any are missing, we reject the claim with code 14 and a specific message, using domain codes to indicate the failure.

```cobol
           IF PM-CLAIM-ID = SPACES OR PM-DATE-OF-DEATH = ZERO OR
              PM-BENEFICIARY-NAME = SPACES
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 14 TO PM-RETURN-CODE
              MOVE "CLAIM ID DOB BENEFICIARY REQUIRED"
                   TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="132">

---

Now we check if the death certificate is missing. If it is, we flag the claim for manual review, but don't reject it immediately.

```cobol
           IF NOT PM-DOC-DEATH-CERT-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="135">

---

Next we check for the claim form. If it's missing, we flag for manual review, just like with the death certificate.

```cobol
           IF NOT PM-DOC-CLAIM-FORM-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="138">

---

Here we check for missing ID proof. Like the other document checks, it flags for manual review if not present, relying on input flags being set up correctly.

```cobol
           IF NOT PM-DOC-ID-PROOF-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="141">

---

Finally, if any required document is missing, we flag the claim for manual review and set a hold reason. The function stops at the first failure, so only one error is reported.

```cobol
           IF WS-DOCS-MISSING
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "MISSING CORE CLAIM DOCUMENTS"
                TO PM-CLAIM-HOLD-REASON
           END-IF.
```

---

</SwmSnippet>

## Handling validation outcomes

This section governs the process flow after claim validation, ensuring that rejected claims are not processed further and are routed to the rejection handling routine.

| Rule ID | Category        | Rule Name                 | Description                                                                                                                                                                                                           | Implementation Details                                                                                                                                                                                                      |
| ------- | --------------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Decision Making | Rejected claim early exit | If a claim is marked as rejected after validation, the claim adjudication process stops and the rejection handling routine is invoked. No further claim processing steps are executed for that claim in this context. | The rejection status is indicated by a flag set to 'Y'. The process flow is terminated for the current claim, and the rejection handling routine is called. No output format or error message is specified in this section. |

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="45">

---

Back in <SwmToken path="cobol/CLM-ADJ-001.cob" pos="41:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, after returning from <SwmToken path="cobol/CLM-ADJ-001.cob" pos="44:3:9" line-data="           PERFORM 1200-VALIDATE-CLAIM-INTAKE">`1200-VALIDATE-CLAIM-INTAKE`</SwmToken>, if the claim was rejected, we call <SwmToken path="cobol/CLM-ADJ-001.cob" pos="46:3:9" line-data="              PERFORM 9000-REJECT-AND-RETURN">`9000-REJECT-AND-RETURN`</SwmToken> and exit. No more steps are run for rejected claims.

```cobol
           IF WS-REJECTED
              PERFORM 9000-REJECT-AND-RETURN
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="50">

---

Here we call <SwmToken path="cobol/CLM-ADJ-001.cob" pos="50:3:7" line-data="           PERFORM 1300-DETERMINE-INVESTIGATION">`1300-DETERMINE-INVESTIGATION`</SwmToken> to check if the claim needs manual investigation based on contestability period, cause of death, or missing medical docs.

```cobol
           PERFORM 1300-DETERMINE-INVESTIGATION
```

---

</SwmSnippet>

## Flagging claims for investigation

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Assess claim for investigation"]
    click node1 openCode "cobol/CLM-ADJ-001.cob:147:148"
    node1 --> node2{"Death within contestability period
(PM-CONTESTABLE-YEARS * 365)?"}
    click node2 openCode "cobol/CLM-ADJ-001.cob:149:152"
    node2 -->|"Yes"| node3["Flag for manual review: Contestability"]
    click node3 openCode "cobol/CLM-ADJ-001.cob:153:155"
    node2 -->|"No"| node4{"Cause of death is UNK, HOM, or SUI?"}
    click node4 openCode "cobol/CLM-ADJ-001.cob:159:161"
    node4 -->|"Yes"| node5["Flag for manual review: Cause of death"]
    click node5 openCode "cobol/CLM-ADJ-001.cob:162:164"
    node4 -->|"No"| node6{"Cause is ACC, HOM, or UNK AND no
medical docs?"}
    click node6 openCode "cobol/CLM-ADJ-001.cob:169:172"
    node6 -->|"Yes"| node7["Flag for manual review: Missing medical
docs"]
    click node7 openCode "cobol/CLM-ADJ-001.cob:173:175"
    node6 -->|"No"| node8{"Manual review required?"}
    click node8 openCode "cobol/CLM-ADJ-001.cob:178:178"
    node3 --> node8
    node5 --> node8
    node7 --> node8
    node8 -->|"Yes"| node9["Set investigation status to 'Pending'
(P) and set date"]
    click node9 openCode "cobol/CLM-ADJ-001.cob:179:180"
    node8 -->|"No"| node10["Set investigation status to 'Not
required' (N)"]
    click node10 openCode "cobol/CLM-ADJ-001.cob:182:183"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Assess claim for investigation"]
%%     click node1 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:147:148"
%%     node1 --> node2{"Death within contestability period
%% (<SwmToken path="cobol/CLM-ADJ-001.cob" pos="152:12:16" line-data="           IF WS-DATE-DIFF &lt; (PM-CONTESTABLE-YEARS * 365)">`PM-CONTESTABLE-YEARS`</SwmToken> * 365)?"}
%%     click node2 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:149:152"
%%     node2 -->|"Yes"| node3["Flag for manual review: Contestability"]
%%     click node3 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:153:155"
%%     node2 -->|"No"| node4{"Cause of death is UNK, HOM, or SUI?"}
%%     click node4 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:159:161"
%%     node4 -->|"Yes"| node5["Flag for manual review: Cause of death"]
%%     click node5 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:162:164"
%%     node4 -->|"No"| node6{"Cause is ACC, HOM, or UNK AND no
%% medical docs?"}
%%     click node6 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:169:172"
%%     node6 -->|"Yes"| node7["Flag for manual review: Missing medical
%% docs"]
%%     click node7 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:173:175"
%%     node6 -->|"No"| node8{"Manual review required?"}
%%     click node8 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:178:178"
%%     node3 --> node8
%%     node5 --> node8
%%     node7 --> node8
%%     node8 -->|"Yes"| node9["Set investigation status to 'Pending'
%% (P) and set date"]
%%     click node9 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:179:180"
%%     node8 -->|"No"| node10["Set investigation status to 'Not
%% required' (N)"]
%%     click node10 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:182:183"
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section determines whether a claim requires investigation and flags it for manual review based on contestability, cause of death, and documentation criteria. It sets investigation status and hold reasons accordingly.

| Rule ID | Category        | Rule Name                                     | Description                                                                                                                                                                                                                                                                 | Implementation Details                                                                                                                                                          |
| ------- | --------------- | --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Calculation     | Date-to-integer conversion for contestability | The section converts date fields (date of death and issue date) to integer values using an intrinsic function, enabling calculation of the days between dates for contestability checks.                                                                                    | Dates are converted from YYYYMMDD format to integer (days since base date) for arithmetic operations.                                                                           |
| BR-002  | Decision Making | Contestability period review                  | If the number of days between the date of death and the policy issue date is less than the contestability period (contestable years multiplied by 365), the claim is flagged for manual review and the hold reason is set to 'Death occurred within contestability period'. | The contestable years constant is 2 for all plan codes. The hold reason is set as a string: 'Death occurred within contestability period'.                                      |
| BR-003  | Decision Making | Cause of death review                         | If the cause of death is unknown, homicide, or suicide, the claim is flagged for manual review and the hold reason is set to 'Cause of death requires claims investigation'.                                                                                                | Hold reason is set as a string: 'Cause of death requires claims investigation'.                                                                                                 |
| BR-004  | Decision Making | Missing medical documentation review          | If the cause of death is accidental, homicide, or unknown and medical documentation is missing, the claim is flagged for manual review and the hold reason is set to 'Medical documentation required for this claim'.                                                       | Hold reason is set as a string: 'Medical documentation required for this claim'.                                                                                                |
| BR-005  | Writing Output  | Investigation status assignment               | If manual review is flagged, the claim investigation status is set to 'Pending' and the investigation date is set to the process date. Otherwise, the status is set to 'Not required'.                                                                                      | Investigation status is set as a single character: 'P' for pending, 'N' for not required. Investigation date is set as an 8-digit number (YYYYMMDD), matching the process date. |

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="147">

---

In <SwmToken path="cobol/CLM-ADJ-001.cob" pos="147:1:5" line-data="       1300-DETERMINE-INVESTIGATION.">`1300-DETERMINE-INVESTIGATION`</SwmToken>, we calculate the days between death and policy issue date. If it's within the contestability period, we flag for manual review and set a hold reason.

```cobol
       1300-DETERMINE-INVESTIGATION.
      * CL-301: Contestable claims go to investigation.
           COMPUTE WS-DATE-DIFF =
                   FUNCTION INTEGER-OF-DATE(PM-DATE-OF-DEATH)
                 - FUNCTION INTEGER-OF-DATE(PM-ISSUE-DATE)
           IF WS-DATE-DIFF < (PM-CONTESTABLE-YEARS * 365)
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "DEATH OCCURRED WITHIN CONTESTABILITY PERIOD"
                TO PM-CLAIM-HOLD-REASON
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="159">

---

After contestability check, we look at cause of death codes. If it's unknown, homicide, or suicide, we flag for manual review and update the hold reason.

```cobol
           IF PM-CAUSE-OF-DEATH = "UNK" OR
              PM-CAUSE-OF-DEATH = "HOM" OR
              PM-CAUSE-OF-DEATH = "SUI"
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "CAUSE OF DEATH REQUIRES CLAIMS INVESTIGATION"
                TO PM-CLAIM-HOLD-REASON
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="169">

---

Next, if the cause of death is accidental, homicide, or unknown and medical docs are missing, we flag for manual review and set a specific hold reason.

```cobol
           IF (PM-CAUSE-OF-DEATH = "ACC" OR
               PM-CAUSE-OF-DEATH = "HOM" OR
               PM-CAUSE-OF-DEATH = "UNK") AND
              NOT PM-DOC-MEDICAL-YES
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "MEDICAL DOCUMENTATION REQUIRED FOR THIS CLAIM"
                TO PM-CLAIM-HOLD-REASON
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="178">

---

Finally, if manual review is flagged, we set the claim investigation status to pending and record the investigation date. Otherwise, status is set to not under investigation.

```cobol
           IF WS-MANUAL
              MOVE 'P' TO PM-CLAIM-INVEST-STATUS
              MOVE PM-PROCESS-DATE TO PM-CLAIM-INVEST-DATE
           ELSE
              MOVE 'N' TO PM-CLAIM-INVEST-STATUS
           END-IF.
```

---

</SwmSnippet>

## Routing claims after investigation check

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Begin claim adjudication"] --> node2{"Manual review required? (WS-MANUAL =
'Y')"}
    click node2 openCode "cobol/CLM-ADJ-001.cob:51:58"
    node2 -->|"Yes"| node3["Route claim for manual
investigation
Set status:
Pending
Message: 'CLAIM ROUTED FOR
MANUAL INVESTIGATION'
Code: 2"]
    click node3 openCode "cobol/CLM-ADJ-001.cob:51:58"
    node2 -->|"No"| node4{"Reject claim? (WS-REJECTED = 'Y')"}
    click node4 openCode "cobol/CLM-ADJ-001.cob:61:64"
    node4 -->|"Yes"| node5["Reject claim and return
PERFORM
9000-REJECT-AND-RETURN"]
    click node5 openCode "cobol/CLM-ADJ-001.cob:61:64"
    node4 -->|"No"| node6["Calculate and settle claim
PERFORM
1500-CALCULATE-SETTLEMENT
PERFORM
1600-SETTLE-CLAIM"]
    click node6 openCode "cobol/CLM-ADJ-001.cob:66:68"

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Begin claim adjudication"] --> node2{"Manual review required? (<SwmToken path="cobol/CLM-ADJ-001.cob" pos="51:3:5" line-data="           IF WS-MANUAL">`WS-MANUAL`</SwmToken> =
%% 'Y')"}
%%     click node2 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:51:58"
%%     node2 -->|"Yes"| node3["Route claim for manual
%% investigation
%% Set status:
%% Pending
%% Message: 'CLAIM ROUTED FOR
%% MANUAL INVESTIGATION'
%% Code: 2"]
%%     click node3 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:51:58"
%%     node2 -->|"No"| node4{"Reject claim? (<SwmToken path="cobol/CLM-ADJ-001.cob" pos="45:3:5" line-data="           IF WS-REJECTED">`WS-REJECTED`</SwmToken> = 'Y')"}
%%     click node4 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:61:64"
%%     node4 -->|"Yes"| node5["Reject claim and return
%% PERFORM
%% <SwmToken path="cobol/CLM-ADJ-001.cob" pos="46:3:9" line-data="              PERFORM 9000-REJECT-AND-RETURN">`9000-REJECT-AND-RETURN`</SwmToken>"]
%%     click node5 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:61:64"
%%     node4 -->|"No"| node6["Calculate and settle claim
%% PERFORM
%% <SwmToken path="cobol/CLM-ADJ-001.cob" pos="66:3:7" line-data="           PERFORM 1500-CALCULATE-SETTLEMENT">`1500-CALCULATE-SETTLEMENT`</SwmToken>
%% PERFORM
%% <SwmToken path="cobol/CLM-ADJ-001.cob" pos="67:3:7" line-data="           PERFORM 1600-SETTLE-CLAIM">`1600-SETTLE-CLAIM`</SwmToken>"]
%%     click node6 openCode "<SwmPath>[cobol/CLM-ADJ-001.cob](cobol/CLM-ADJ-001.cob)</SwmPath>:66:68"
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section determines the next step for a claim after the investigation check. It routes the claim for manual investigation, rejection, or settlement based on business conditions.

| Rule ID | Category        | Rule Name                            | Description                                                                                                                                                                                                                                                              | Implementation Details                                                                                                                                                                                                                                  |
| ------- | --------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Decision Making | Manual investigation routing         | When manual review is required, the claim is routed for manual investigation. The claim status and decision are set to 'P', the return message is set to 'CLAIM ROUTED FOR MANUAL INVESTIGATION', and the return code is set to 2. Processing stops after these updates. | Status and decision are set to 'P' (pending). Return message is the string 'CLAIM ROUTED FOR MANUAL INVESTIGATION' (alphanumeric, up to 100 characters). Return code is the number 2. No further processing occurs in this section after these updates. |
| BR-002  | Decision Making | Claim rejection after investigation  | If manual review is not required and the claim is marked for rejection, the claim is rejected and rejection processing is invoked. Processing stops after rejection.                                                                                                     | Rejection processing is invoked. No further processing occurs in this section after rejection.                                                                                                                                                          |
| BR-003  | Decision Making | Claim settlement after investigation | If manual review is not required and the claim is not rejected, the claim proceeds to settlement calculation and settlement processing.                                                                                                                                  | Settlement calculation and settlement processing are invoked in sequence. No status, message, or code updates are specified in this section for this path.                                                                                              |

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="51">

---

Back in <SwmToken path="cobol/CLM-ADJ-001.cob" pos="41:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, after returning from <SwmToken path="cobol/CLM-ADJ-001.cob" pos="50:3:7" line-data="           PERFORM 1300-DETERMINE-INVESTIGATION">`1300-DETERMINE-INVESTIGATION`</SwmToken>, if manual review is needed, we update claim status and decision, set a message, and exit. Claim goes to manual investigation.

```cobol
           IF WS-MANUAL
              MOVE 'P' TO LK-CLAIM-STATUS
              MOVE 'P' TO PM-CLAIM-DECISION
              MOVE "CLAIM ROUTED FOR MANUAL INVESTIGATION"
                TO PM-RETURN-MESSAGE
              MOVE 2 TO PM-RETURN-CODE
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="60">

---

Here we call <SwmToken path="cobol/CLM-ADJ-001.cob" pos="60:3:7" line-data="           PERFORM 1400-ADJUDICATE-COVERAGE">`1400-ADJUDICATE-COVERAGE`</SwmToken> to check for coverage exclusions, but only if the claim wasn't routed for manual investigation.

```cobol
           PERFORM 1400-ADJUDICATE-COVERAGE
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="61">

---

After adjudication, we check if the claim was rejected. If so, we call <SwmToken path="cobol/CLM-ADJ-001.cob" pos="62:3:9" line-data="              PERFORM 9000-REJECT-AND-RETURN">`9000-REJECT-AND-RETURN`</SwmToken> and exit, just like after validation.

```cobol
           IF WS-REJECTED
              PERFORM 9000-REJECT-AND-RETURN
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/cobol/CLM-ADJ-001.cob" line="66">

---

Finally, we calculate the settlement amount, settle the claim, and exit. Claim is marked as settled and payout is processed.

```cobol
           PERFORM 1500-CALCULATE-SETTLEMENT
           PERFORM 1600-SETTLE-CLAIM
           GOBACK.
```

---

</SwmSnippet>

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
