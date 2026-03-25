---
title: NBUW001 - New Business Underwriting and Policy Issuance (NB-UW-001)
---
# Overview

This document describes the flow for processing new term life insurance applications. The flow validates eligibility, assigns risk categories, calculates premiums, checks rider eligibility, and determines whether the policy is issued, referred, or declined.

```mermaid
flowchart TD
  node1["Starting the policy processing sequence"]:::HeadingStyle --> node2{"Setting plan-specific rules
Is plan
code valid?
(Setting plan-specific rules)"}:::HeadingStyle
  click node1 goToHeading "Starting the policy processing sequence"
  click node2 goToHeading "Setting plan-specific rules"
  node2 -->|"Valid"| node3{"Assigning risk category
Is application
declined?
(Assigning risk category)"}:::HeadingStyle
  node2 -->|"Invalid"| node7["Finalizing underwriting
outcome
(Application not processed)
(Finalizing underwriting outcome)"]:::HeadingStyle
  click node3 goToHeading "Assigning risk category"
  click node7 goToHeading "Finalizing underwriting outcome"
  node3 -->|"No"| node4["Setting rating factors"]:::HeadingStyle
  node3 -->|"Yes"| node7
  click node4 goToHeading "Setting rating factors"
  node4 --> node5["Validating rider eligibility"]:::HeadingStyle
  click node5 goToHeading "Validating rider eligibility"
  node5 --> node6{"Checking rider rules
Are all riders
eligible?
(Checking rider rules)"}:::HeadingStyle
  click node6 goToHeading "Checking rider rules"
  node6 -->|"Yes"| node8{"Checking for referral or manual
underwriting
Is referral required?
(Checking for referral or manual underwriting)"}:::HeadingStyle
  node6 -->|"No"| node7
  click node8 goToHeading "Checking for referral or manual underwriting"
  node8 -->|"Yes"| node9["Flagging cases for review or reinsurance"]:::HeadingStyle
  node8 -->|"No"| node10["Finalizing underwriting
outcome
(Policy issued)
(Finalizing underwriting outcome)"]:::HeadingStyle
  click node9 goToHeading "Flagging cases for review or reinsurance"
  click node10 goToHeading "Finalizing underwriting outcome"
  node9 --> node11["Finalizing underwriting
outcome
(Application referred)
(Finalizing underwriting outcome)"]:::HeadingStyle
  click node11 goToHeading "Finalizing underwriting outcome"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

## Dependencies

### Program

- <SwmToken path="NB-UW-001.cob" pos="2:6:6" line-data="       PROGRAM-ID. NBUW001.">`NBUW001`</SwmToken> (<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>)

### Copybook

- POLDATA (<SwmPath>[POLDATA.cpy](POLDATA.cpy)</SwmPath>)

# Workflow

# Starting the policy processing sequence

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Initialize and load plan parameters"] --> node2["Setting plan-specific rules"]
    click node1 openCode "NB-UW-001.cob:42:45"
    
    node2 --> node3{"WS-RESULT-CODE != 0?"}
    click node3 openCode "NB-UW-001.cob:46:49"
    node3 -->|"Yes"| node4["Return error (Pending)"]
    click node4 openCode "NB-UW-001.cob:47:49"
    node3 -->|"No"| node5["Assigning risk category"]
    
    node5 --> node6{"PM-UW-DECLINE = true?"}
    click node6 openCode "NB-UW-001.cob:52:59"
    node6 -->|"Yes"| node7["Decline application ('RJ')"]
    click node7 openCode "NB-UW-001.cob:53:59"
    node6 -->|"No"| node8["Setting rating factors"]
    
    node8 --> node9["Checking rider rules"]
    
    node9 --> node10{"WS-RESULT-CODE != 0 after riders?"}
    click node10 openCode "NB-UW-001.cob:63:66"
    node10 -->|"Yes"| node11["Return error (Pending)"]
    click node11 openCode "NB-UW-001.cob:64:66"
    node10 -->|"No"| node12["Pricing insurance riders"]
    
    node12 --> node13["Flagging cases for review or reinsurance"]
    
    node13 --> node14{"WS-REFERRED or WS-MANUAL-UW = true?"}
    click node14 openCode "NB-UW-001.cob:73:80"
    node14 -->|"Yes"| node15["Refer for manual UW/reinsurance ('PE')"]
    click node15 openCode "NB-UW-001.cob:74:79"
    node14 -->|"No"| node16["Issue policy successfully ('AC')"]
    click node16 openCode "NB-UW-001.cob:83:86"

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
click node2 goToHeading "Setting plan-specific rules"
node2:::HeadingStyle
click node5 goToHeading "Assigning risk category"
node5:::HeadingStyle
click node8 goToHeading "Setting rating factors"
node8:::HeadingStyle
click node9 goToHeading "Checking rider rules"
node9:::HeadingStyle
click node12 goToHeading "Pricing insurance riders"
node12:::HeadingStyle
click node13 goToHeading "Flagging cases for review or reinsurance"
node13:::HeadingStyle

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Initialize and load plan parameters"] --> node2["Setting plan-specific rules"]
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:42:45"
%%     
%%     node2 --> node3{"<SwmToken path="NB-UW-001.cob" pos="46:3:7" line-data="           IF WS-RESULT-CODE NOT = 0">`WS-RESULT-CODE`</SwmToken> != 0?"}
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:46:49"
%%     node3 -->|"Yes"| node4["Return error (Pending)"]
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:47:49"
%%     node3 -->|"No"| node5["Assigning risk category"]
%%     
%%     node5 --> node6{"<SwmToken path="NB-UW-001.cob" pos="52:3:7" line-data="           IF PM-UW-DECLINE">`PM-UW-DECLINE`</SwmToken> = true?"}
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:52:59"
%%     node6 -->|"Yes"| node7["Decline application ('RJ')"]
%%     click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:53:59"
%%     node6 -->|"No"| node8["Setting rating factors"]
%%     
%%     node8 --> node9["Checking rider rules"]
%%     
%%     node9 --> node10{"<SwmToken path="NB-UW-001.cob" pos="46:3:7" line-data="           IF WS-RESULT-CODE NOT = 0">`WS-RESULT-CODE`</SwmToken> != 0 after riders?"}
%%     click node10 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:63:66"
%%     node10 -->|"Yes"| node11["Return error (Pending)"]
%%     click node11 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:64:66"
%%     node10 -->|"No"| node12["Pricing insurance riders"]
%%     
%%     node12 --> node13["Flagging cases for review or reinsurance"]
%%     
%%     node13 --> node14{"<SwmToken path="NB-UW-001.cob" pos="73:3:5" line-data="           IF WS-REFERRED OR WS-MANUAL-UW">`WS-REFERRED`</SwmToken> or <SwmToken path="NB-UW-001.cob" pos="73:9:13" line-data="           IF WS-REFERRED OR WS-MANUAL-UW">`WS-MANUAL-UW`</SwmToken> = true?"}
%%     click node14 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:73:80"
%%     node14 -->|"Yes"| node15["Refer for manual UW/reinsurance ('PE')"]
%%     click node15 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:74:79"
%%     node14 -->|"No"| node16["Issue policy successfully ('AC')"]
%%     click node16 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:83:86"
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
%% click node2 goToHeading "Setting plan-specific rules"
%% node2:::HeadingStyle
%% click node5 goToHeading "Assigning risk category"
%% node5:::HeadingStyle
%% click node8 goToHeading "Setting rating factors"
%% node8:::HeadingStyle
%% click node9 goToHeading "Checking rider rules"
%% node9:::HeadingStyle
%% click node12 goToHeading "Pricing insurance riders"
%% node12:::HeadingStyle
%% click node13 goToHeading "Flagging cases for review or reinsurance"
%% node13:::HeadingStyle
```

This section initiates the policy processing workflow, loading plan parameters and orchestrating the main business decisions for policy issuance, including error handling, risk categorization, rider validation, premium calculation, and referral or issuance outcomes.

| Rule ID | Category        | Rule Name                                   | Description                                                                                                                                                              | Implementation Details                                                                                        |
| ------- | --------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Plan parameter loading error                | If plan parameters cannot be loaded due to an invalid plan code or missing requirements, the policy processing returns an error and sets the contract status to pending. | The contract status is set to 'PE' (pending). The error message is returned as a string up to 100 characters. |
| BR-002  | Data validation | Rider validation error                      | If rider validation fails after checking rider rules, the policy processing returns an error and sets the contract status to pending.                                    | The contract status is set to 'PE' (pending). The error message is returned as a string up to 100 characters. |
| BR-003  | Decision Making | Application decline decision                | If the risk category assignment results in a decline, the application is declined and the contract status is set to 'RJ'.                                                | The contract status is set to 'RJ' (declined).                                                                |
| BR-004  | Decision Making | Manual underwriting or reinsurance referral | If the policy is flagged for manual underwriting or reinsurance review, the contract status is set to pending and the policy is referred for further review.             | The contract status is set to 'PE' (pending).                                                                 |
| BR-005  | Decision Making | Successful policy issuance                  | If all validations and checks pass and no referral is required, the policy is issued successfully and the contract status is set to active.                              | The contract status is set to 'AC' (active).                                                                  |

<SwmSnippet path="/NB-UW-001.cob" line="42">

---

In <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, we kick off the policy workflow by initializing the environment and then calling <SwmToken path="NB-UW-001.cob" pos="44:3:9" line-data="           PERFORM 1100-LOAD-PLAN-PARAMETERS">`1100-LOAD-PLAN-PARAMETERS`</SwmToken>. This step is needed because the plan parameters (like age limits, sum assured, fees, and tax rates) are required for all subsequent validation and calculation steps. The function assumes global variables are set and updated by each subroutine, so the state of these variables controls the flow and error handling throughout the process.

```cobol
       MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           PERFORM 1200-VALIDATE-APPLICATION
```

---

</SwmSnippet>

## Setting plan-specific rules

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Start: Load plan parameters"] --> node2{"Which plan code?"}
    click node1 openCode "NB-UW-001.cob:109:112"
    node2 -->|"10-year (T1001)"| node3["Set parameters for 10-year plan (ages
18-60, sum assured 10M-100M, fee 45, tax
2%)"]
    click node2 openCode "NB-UW-001.cob:112:113"
    click node3 openCode "NB-UW-001.cob:113:126"
    node2 -->|"20-year (T2001)"| node4["Set parameters for 20-year plan (ages
18-55, sum assured 10M-200M, fee 55, tax
2%)"]
    click node4 openCode "NB-UW-001.cob:127:140"
    node2 -->|"To-age-65 (T6501)"| node5["Set parameters for to-age-65 plan (ages
18-50, sum assured 10M-150M, fee 60, tax
2%)"]
    click node5 openCode "NB-UW-001.cob:141:153"
    node2 -->|"Other"| node6["Set error: Invalid plan code"]
    click node6 openCode "NB-UW-001.cob:154:156"
    node5 --> node7{"Is result code 0? (No error)"}
    click node7 openCode "NB-UW-001.cob:159:159"
    node7 -->|"Yes"| node8["Recalculate term years as maturity age
minus insured's issue age"]
    click node8 openCode "NB-UW-001.cob:160:162"
    node7 -->|"No"| node9["End"]
    node3 --> node9
    node4 --> node9
    node6 --> node9
    node8 --> node9
    click node9 openCode "NB-UW-001.cob:162:162"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Start: Load plan parameters"] --> node2{"Which plan code?"}
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:109:112"
%%     node2 -->|"10-year (T1001)"| node3["Set parameters for 10-year plan (ages
%% 18-60, sum assured 10M-100M, fee 45, tax
%% 2%)"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:112:113"
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:113:126"
%%     node2 -->|"20-year (T2001)"| node4["Set parameters for 20-year plan (ages
%% 18-55, sum assured 10M-200M, fee 55, tax
%% 2%)"]
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:127:140"
%%     node2 -->|"To-age-65 (T6501)"| node5["Set parameters for to-age-65 plan (ages
%% 18-50, sum assured 10M-150M, fee 60, tax
%% 2%)"]
%%     click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:141:153"
%%     node2 -->|"Other"| node6["Set error: Invalid plan code"]
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:154:156"
%%     node5 --> node7{"Is result code 0? (No error)"}
%%     click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:159:159"
%%     node7 -->|"Yes"| node8["Recalculate term years as maturity age
%% minus insured's issue age"]
%%     click node8 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:160:162"
%%     node7 -->|"No"| node9["End"]
%%     node3 --> node9
%%     node4 --> node9
%%     node6 --> node9
%%     node8 --> node9
%%     click node9 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:162:162"
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section sets up all plan-specific parameters for a term life insurance policy based on the selected plan code. It ensures that each plan type has the correct eligibility and pricing values, and handles errors for unsupported plan codes.

| Rule ID | Category        | Rule Name                    | Description                                                                                                                                                                                                                                                                                                                                                                  | Implementation Details                                                                                                                                                                                                                                                                                                                                  |
| ------- | --------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Calculation     | To-age-65 term recalculation | For the to-age-65 plan, if no error is present, recalculate the term years as the maturity age minus the insured's issue age.                                                                                                                                                                                                                                                | Term years is recalculated as an integer: maturity age minus insured's issue age. This makes the term dynamic based on the insured's age at issue.                                                                                                                                                                                                      |
| BR-002  | Decision Making | 10-year plan parameters      | For the 10-year plan, set minimum issue age to 18, maximum issue age to 60, minimum sum assured to 10,000,000.00, maximum sum assured to 100,000,000.00, term years to 10, maturity age to 70, grace days to 31, contestable years to 2, suicide exclusion years to 2, reinstate days to 730, annual policy fee to 45.00, standard service fee to 15.00, and tax rate to 2%. | All values are hardcoded: min age 18, max age 60, min sum assured 10,000,000.00, max sum assured 100,000,000.00, term years 10, maturity age 70, grace days 31, contestable years 2, suicide exclusion years 2, reinstate days 730, annual policy fee 45.00, standard service fee 15.00, tax rate 2%. All values are numbers except tax rate (decimal). |
| BR-003  | Decision Making | 20-year plan parameters      | For the 20-year plan, set minimum issue age to 18, maximum issue age to 55, minimum sum assured to 10,000,000.00, maximum sum assured to 200,000,000.00, term years to 20, maturity age to 75, grace days to 31, contestable years to 2, suicide exclusion years to 2, reinstate days to 730, annual policy fee to 55.00, standard service fee to 15.00, and tax rate to 2%. | All values are hardcoded: min age 18, max age 55, min sum assured 10,000,000.00, max sum assured 200,000,000.00, term years 20, maturity age 75, grace days 31, contestable years 2, suicide exclusion years 2, reinstate days 730, annual policy fee 55.00, standard service fee 15.00, tax rate 2%. All values are numbers except tax rate (decimal). |
| BR-004  | Decision Making | To-age-65 plan parameters    | For the to-age-65 plan, set minimum issue age to 18, maximum issue age to 50, minimum sum assured to 10,000,000.00, maximum sum assured to 150,000,000.00, maturity age to 65, grace days to 31, contestable years to 2, suicide exclusion years to 2, reinstate days to 730, annual policy fee to 60.00, standard service fee to 15.00, and tax rate to 2%.                 | All values are hardcoded: min age 18, max age 50, min sum assured 10,000,000.00, max sum assured 150,000,000.00, maturity age 65, grace days 31, contestable years 2, suicide exclusion years 2, reinstate days 730, annual policy fee 60.00, standard service fee 15.00, tax rate 2%. All values are numbers except tax rate (decimal).                |
| BR-005  | Decision Making | Invalid plan code error      | If the plan code is not recognized, set an error code and message indicating an invalid plan code.                                                                                                                                                                                                                                                                           | Error code is set to 11, error message is set to 'INVALID PLAN CODE'. Error code is a number, message is a string.                                                                                                                                                                                                                                      |

<SwmSnippet path="/NB-UW-001.cob" line="109">

---

In <SwmToken path="NB-UW-001.cob" pos="109:1:7" line-data="       1100-LOAD-PLAN-PARAMETERS.">`1100-LOAD-PLAN-PARAMETERS`</SwmToken>, we use EVALUATE to set all the plan-specific parameters like age limits, sum assured, fees, and tax rates based on the plan term. These values are hardcoded and control eligibility and pricing for each plan. The function expects <SwmToken path="NB-UW-001.cob" pos="113:3:7" line-data="              WHEN PM-PLAN-TERM-10">`PM-PLAN-TERM`</SwmToken> to be set and uses global error variables for reporting issues.

```cobol
       1100-LOAD-PLAN-PARAMETERS.
      * NB-101: Each plan carries its own issue age, sum assured,
      *         maturity, fee, and tax rules.
           EVALUATE TRUE
              WHEN PM-PLAN-TERM-10
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 060 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0001000000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 010 TO PM-TERM-YEARS
                 MOVE 070 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 02  TO PM-CONTESTABLE-YEARS
                 MOVE 02  TO PM-SUICIDE-EXCL-YEARS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000045.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="127">

---

This part handles the plan term '20', assigning its specific limits and fees. It follows the same structure as the previous snippet for term '10', and sets up the parameters needed for later validation and calculations.

```cobol
              WHEN PM-PLAN-TERM-20
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 055 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0002000000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 020 TO PM-TERM-YEARS
                 MOVE 075 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 02  TO PM-CONTESTABLE-YEARS
                 MOVE 02  TO PM-SUICIDE-EXCL-YEARS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000055.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="141">

---

This section sets the parameters for the 'to 65' plan, using domain-specific constants for age, sum assured, fees, and tax. These values are different from the previous plan terms and are critical for eligibility and pricing checks.

```cobol
              WHEN PM-PLAN-TO-65
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 050 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0001500000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 065 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 02  TO PM-CONTESTABLE-YEARS
                 MOVE 02  TO PM-SUICIDE-EXCL-YEARS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000060.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="154">

---

This handles invalid plan codes and sets an error so the flow can exit early.

```cobol
              WHEN OTHER
                 MOVE 11 TO WS-RESULT-CODE
                 MOVE "INVALID PLAN CODE" TO WS-RESULT-MESSAGE
           END-EVALUATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="159">

---

After setting plan parameters, if the plan is 'to 65' and no error occurred, the term years are recalculated based on the insured's age. This makes the term dynamic for this plan type, which is a business rule.

```cobol
           IF PM-PLAN-TO-65 AND WS-RESULT-CODE = 0
              COMPUTE PM-TERM-YEARS = PM-MATURITY-AGE
                                     - PM-INSURED-AGE-ISSUE
           END-IF.
```

---

</SwmSnippet>

## Handling plan validation results

This section governs the flow after plan validation, ensuring that errors are handled before proceeding to underwriting class determination. It ensures that only valid applications are processed for underwriting class assignment, which impacts downstream eligibility and pricing decisions.

| Rule ID | Category        | Rule Name                      | Description                                                                                                                             | Implementation Details                                                                                                                                                                        |
| ------- | --------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Plan validation error handling | If any validation error is detected in the plan parameters, the process stops and an error is returned to the user.                     | The result code is a number. If it is not zero, an error message is returned and processing stops. The error message format is not specified in this section.                                 |
| BR-002  | Decision Making | Underwriting class assignment  | If no validation errors are present, the underwriting class is determined based on risk factors, which affects eligibility and pricing. | The underwriting class is determined by risk factors. The specific risk factors and class values are not detailed in this section. The underwriting class influences eligibility and pricing. |

<SwmSnippet path="/NB-UW-001.cob" line="46">

---

After loading plan parameters, <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> checks for errors and exits if any were set.

```cobol
           IF WS-RESULT-CODE NOT = 0
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="51">

---

Next in <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, we call <SwmToken path="NB-UW-001.cob" pos="51:3:9" line-data="           PERFORM 1300-DETERMINE-UW-CLASS">`1300-DETERMINE-UW-CLASS`</SwmToken> to assign the underwriting class based on risk factors. This step is needed because the underwriting class affects eligibility, pricing, and whether the application is declined or referred.

```cobol
           PERFORM 1300-DETERMINE-UW-CLASS
```

---

</SwmSnippet>

## Assigning risk category

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1{"Is applicant declined?"}
    click node1 openCode "NB-UW-001.cob:233:235"
    node1 -->|"Yes"| node2["Assign 'Decline' underwriting class"]
    click node2 openCode "NB-UW-001.cob:233:235"
    node1 -->|"No"| node3{"Non-smoker, Professional, Age <= 45, Not
High-Risk Avocation?"}
    click node3 openCode "NB-UW-001.cob:237:239"
    node3 -->|"Yes"| node4["Assign 'Preferred' underwriting class"]
    click node4 openCode "NB-UW-001.cob:240:240"
    node3 -->|"No"| node5["Assign 'Standard' underwriting class"]
    click node5 openCode "NB-UW-001.cob:242:242"
    node6{"Smoker, Hazardous Occupation, or
High-Risk Avocation?"}
    click node6 openCode "NB-UW-001.cob:246:246"
    node6 -->|"Yes"| node7["Assign 'Table' underwriting class"]
    click node7 openCode "NB-UW-001.cob:247:247"
    node8{"Smoker, Age > 60, Sum Assured >
1,000,000?"}
    click node8 openCode "NB-UW-001.cob:251:252"
    node8 -->|"Yes"| node2

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1{"Is applicant declined?"}
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:233:235"
%%     node1 -->|"Yes"| node2["Assign 'Decline' underwriting class"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:233:235"
%%     node1 -->|"No"| node3{"Non-smoker, Professional, Age <= 45, Not
%% High-Risk Avocation?"}
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:237:239"
%%     node3 -->|"Yes"| node4["Assign 'Preferred' underwriting class"]
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:240:240"
%%     node3 -->|"No"| node5["Assign 'Standard' underwriting class"]
%%     click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:242:242"
%%     node6{"Smoker, Hazardous Occupation, or
%% High-Risk Avocation?"}
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:246:246"
%%     node6 -->|"Yes"| node7["Assign 'Table' underwriting class"]
%%     click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:247:247"
%%     node8{"Smoker, Age > 60, Sum Assured >
%% 1,000,000?"}
%%     click node8 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:251:252"
%%     node8 -->|"Yes"| node2
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section determines the underwriting risk category for an insurance application based on applicant risk factors. The assigned risk class impacts pricing and eligibility for the policy.

| Rule ID | Category        | Rule Name                 | Description                                                                                                                                                                | Implementation Details                                                                                                                                                                                                                            |
| ------- | --------------- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Decision Making | Decline assignment        | If the application is flagged for decline, the underwriting class is set to 'Decline'.                                                                                     | The output is the underwriting class code 'DP', a 2-character string. This code is used for declined applications.                                                                                                                                |
| BR-002  | Decision Making | Preferred risk assignment | If the applicant is a non-smoker, has a professional occupation, is age 45 or younger, and does not have a high-risk avocation, assign the 'Preferred' underwriting class. | The output is the underwriting class code 'PR', a 2-character string. Age threshold is 45. Professional occupation is indicated by occupation class 1. Non-smoker is indicated by smoker indicator 'N'. High-risk avocation indicator is not 'Y'. |
| BR-003  | Decision Making | Standard risk assignment  | If the applicant does not meet the preferred risk criteria, assign the 'Standard' underwriting class.                                                                      | The output is the underwriting class code 'ST', a 2-character string. This is the default assignment if preferred criteria are not met.                                                                                                           |
| BR-004  | Decision Making | Table rating assignment   | If the applicant is a smoker, has a hazardous occupation, or has a high-risk avocation, assign the 'Table' underwriting class.                                             | The output is the underwriting class code 'TB', a 2-character string. Hazardous occupation is indicated by occupation class 3. Smoker is indicated by smoker indicator 'S'. High-risk avocation indicator is 'Y'.                                 |
| BR-005  | Decision Making | High-risk smoker decline  | If the applicant is a smoker, over age 60, and the sum assured is greater than 1,000,000, assign the 'Decline' underwriting class.                                         | The output is the underwriting class code 'DP', a 2-character string. Age threshold is 60. Sum assured threshold is 1,000,000.00 (twelve digits including decimals).                                                                              |

<SwmSnippet path="/NB-UW-001.cob" line="231">

---

In <SwmToken path="NB-UW-001.cob" pos="231:1:7" line-data="       1300-DETERMINE-UW-CLASS.">`1300-DETERMINE-UW-CLASS`</SwmToken>, we first check if the application is already flagged for decline. If not, we use risk factors like smoking status, occupation, age, and avocation to assign a risk class. These codes drive pricing and eligibility downstream.

```cobol
       1300-DETERMINE-UW-CLASS.
      * NB-301: Preferred, standard, table, or decline.
           IF PM-UW-DECLINE
              EXIT PARAGRAPH
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="237">

---

This part assigns 'PR' for preferred risk if the insured meets strict criteria, otherwise 'ST' for standard. These codes are used later for pricing and eligibility checks.

```cobol
           IF PM-NON-SMOKER AND PM-OCC-PROF AND
              PM-INSURED-AGE-ISSUE <= 45 AND
              PM-HIGH-RISK-AVOC-IND NOT = 'Y'
              MOVE "PR" TO PM-UW-CLASS
           ELSE
              MOVE "ST" TO PM-UW-CLASS
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="246">

---

Here we check for smoker, hazardous occupation, or high-risk avocation and set the risk class to 'TB' (table rating). This overrides previous assignments and is used for pricing adjustments.

```cobol
           IF PM-SMOKER OR PM-OCC-HAZARD OR PM-HIGH-RISK-AVOC
              MOVE "TB" TO PM-UW-CLASS
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="251">

---

This part flags the policy for decline if the insured is a high-risk smoker with a big coverage amount.

```cobol
           IF PM-SMOKER AND PM-INSURED-AGE-ISSUE > 60 AND
              PM-SUM-ASSURED > 0001000000000.00
              MOVE "DP" TO PM-UW-CLASS
           END-IF.
```

---

</SwmSnippet>

## Handling underwriting decisions

This section governs the business logic for handling applications that are declined after underwriting. It ensures that declined applications are flagged, appropriate messages and statuses are set, and the process exits with an error indication.

| Rule ID | Category        | Rule Name                     | Description                                                                                                                                                                                                                                                                       | Implementation Details                                                                                                                                                                                              |
| ------- | --------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Decision Making | Underwriting Decline Handling | When an application is flagged for decline after underwriting, the system sets the result code to 21, updates the result message to indicate the application was declined by underwriting rules, sets the contract status to 'declined', and triggers the error handling process. | The result code is set to 21. The result message is set to 'APPLICATION DECLINED BY UNDERWRITING RULES' (alphanumeric, up to 100 characters). The contract status is set to 'RJ' (2-character code for 'declined'). |

<SwmSnippet path="/NB-UW-001.cob" line="52">

---

<SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> checks for decline after underwriting and exits if flagged.

```cobol
           IF PM-UW-DECLINE
              MOVE 21 TO WS-RESULT-CODE
              MOVE "APPLICATION DECLINED BY UNDERWRITING RULES"
                TO WS-RESULT-MESSAGE
              MOVE "RJ" TO PM-CONTRACT-STATUS
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="61">

---

Next, <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> calls <SwmToken path="NB-UW-001.cob" pos="61:3:9" line-data="           PERFORM 1400-LOAD-RATE-FACTORS">`1400-LOAD-RATE-FACTORS`</SwmToken> to set up all the rate and adjustment factors needed for premium calculation. This step is required because the premium depends on age, gender, smoker status, occupation, and underwriting class.

```cobol
           PERFORM 1400-LOAD-RATE-FACTORS
           PERFORM 1500-VALIDATE-RIDERS
```

---

</SwmSnippet>

## Setting rating factors

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Start: Load rate factors for policy"] --> node2{"Insured's age at issue?"}
    click node1 openCode "NB-UW-001.cob:256:258"
    node2 -->|"#lt;= 30"| node3["Assign base rate for age <= 30: 0.8500"]
    click node2 openCode "NB-UW-001.cob:258:269"
    node2 -->|"#lt;= 40"| node4["Assign base rate for age <= 40: 1.2000"]
    node2 -->|"#lt;= 50"| node5["Assign base rate for age <= 50: 2.1500"]
    node2 -->|"#lt;= 60"| node6["Assign base rate for age <= 60: 4.1000"]
    node2 -->|"#gt; 60"| node7["Assign base rate for age > 60: 7.2500"]
    click node3 openCode "NB-UW-001.cob:259:260"
    click node4 openCode "NB-UW-001.cob:261:262"
    click node5 openCode "NB-UW-001.cob:263:264"
    click node6 openCode "NB-UW-001.cob:265:266"
    click node7 openCode "NB-UW-001.cob:267:268"
    node3 --> node8
    node4 --> node8
    node5 --> node8
    node6 --> node8
    node7 --> node8
    node8{"Insured female?"}
    click node8 openCode "NB-UW-001.cob:272:276"
    node8 -->|"Yes"| node9["Assign gender factor: 0.92"]
    node8 -->|"No"| node10["Assign gender factor: 1.00"]
    click node9 openCode "NB-UW-001.cob:273:273"
    click node10 openCode "NB-UW-001.cob:275:275"
    node9 --> node11
    node10 --> node11
    node11{"Insured smoker?"}
    click node11 openCode "NB-UW-001.cob:279:283"
    node11 -->|"Yes"| node12["Assign smoker factor: 1.75"]
    node11 -->|"No"| node13["Assign smoker factor: 1.00"]
    click node12 openCode "NB-UW-001.cob:280:280"
    click node13 openCode "NB-UW-001.cob:282:282"
    node12 --> node14
    node13 --> node14
    node14{"Occupation class?"}
    click node14 openCode "NB-UW-001.cob:286:295"
    node14 -->|"Professional"| node15["Assign occupation factor: 1.00"]
    node14 -->|"Standard"| node16["Assign occupation factor: 1.15"]
    node14 -->|"Hazardous"| node17["Assign occupation factor: 1.40"]
    node14 -->|"Other"| node18["Assign occupation factor: 1.00"]
    click node15 openCode "NB-UW-001.cob:288:288"
    click node16 openCode "NB-UW-001.cob:290:290"
    click node17 openCode "NB-UW-001.cob:292:292"
    click node18 openCode "NB-UW-001.cob:294:294"
    node15 --> node19
    node16 --> node19
    node17 --> node19
    node18 --> node19
    node19{"Underwriting class?"}
    click node19 openCode "NB-UW-001.cob:298:307"
    node19 -->|"Preferred"| node20["Assign underwriting factor: 0.90"]
    node19 -->|"Standard"| node21["Assign underwriting factor: 1.00"]
    node19 -->|"Table B"| node22["Assign underwriting factor: 1.25"]
    node19 -->|"Other"| node23["Assign underwriting factor: 1.00"]
    click node20 openCode "NB-UW-001.cob:300:300"
    click node21 openCode "NB-UW-001.cob:302:302"
    click node22 openCode "NB-UW-001.cob:304:304"
    click node23 openCode "NB-UW-001.cob:306:306"
    node20 --> node24["All rate factors loaded"]
    node21 --> node24
    node22 --> node24
    node23 --> node24
    click node24 openCode "NB-UW-001.cob:307:307"

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Start: Load rate factors for policy"] --> node2{"Insured's age at issue?"}
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:256:258"
%%     node2 -->|"#lt;= 30"| node3["Assign base rate for age <= 30: 0.8500"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:258:269"
%%     node2 -->|"#lt;= 40"| node4["Assign base rate for age <= 40: 1.2000"]
%%     node2 -->|"#lt;= 50"| node5["Assign base rate for age <= 50: 2.1500"]
%%     node2 -->|"#lt;= 60"| node6["Assign base rate for age <= 60: 4.1000"]
%%     node2 -->|"#gt; 60"| node7["Assign base rate for age > 60: 7.2500"]
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:259:260"
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:261:262"
%%     click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:263:264"
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:265:266"
%%     click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:267:268"
%%     node3 --> node8
%%     node4 --> node8
%%     node5 --> node8
%%     node6 --> node8
%%     node7 --> node8
%%     node8{"Insured female?"}
%%     click node8 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:272:276"
%%     node8 -->|"Yes"| node9["Assign gender factor: 0.92"]
%%     node8 -->|"No"| node10["Assign gender factor: 1.00"]
%%     click node9 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:273:273"
%%     click node10 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:275:275"
%%     node9 --> node11
%%     node10 --> node11
%%     node11{"Insured smoker?"}
%%     click node11 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:279:283"
%%     node11 -->|"Yes"| node12["Assign smoker factor: 1.75"]
%%     node11 -->|"No"| node13["Assign smoker factor: 1.00"]
%%     click node12 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:280:280"
%%     click node13 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:282:282"
%%     node12 --> node14
%%     node13 --> node14
%%     node14{"Occupation class?"}
%%     click node14 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:286:295"
%%     node14 -->|"Professional"| node15["Assign occupation factor: 1.00"]
%%     node14 -->|"Standard"| node16["Assign occupation factor: 1.15"]
%%     node14 -->|"Hazardous"| node17["Assign occupation factor: 1.40"]
%%     node14 -->|"Other"| node18["Assign occupation factor: 1.00"]
%%     click node15 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:288:288"
%%     click node16 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:290:290"
%%     click node17 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:292:292"
%%     click node18 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:294:294"
%%     node15 --> node19
%%     node16 --> node19
%%     node17 --> node19
%%     node18 --> node19
%%     node19{"Underwriting class?"}
%%     click node19 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:298:307"
%%     node19 -->|"Preferred"| node20["Assign underwriting factor: 0.90"]
%%     node19 -->|"Standard"| node21["Assign underwriting factor: 1.00"]
%%     node19 -->|"Table B"| node22["Assign underwriting factor: 1.25"]
%%     node19 -->|"Other"| node23["Assign underwriting factor: 1.00"]
%%     click node20 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:300:300"
%%     click node21 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:302:302"
%%     click node22 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:304:304"
%%     click node23 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:306:306"
%%     node20 --> node24["All rate factors loaded"]
%%     node21 --> node24
%%     node22 --> node24
%%     node23 --> node24
%%     click node24 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:307:307"
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section sets all rating factors that determine the premium for a new or amended term life insurance policy. It applies business rules to assign each factor based on the insured's attributes.

| Rule ID | Category    | Rule Name                      | Description                                                                                                                                                                                         | Implementation Details                                                                                                                                                                                    |
| ------- | ----------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Calculation | Base rate by age band          | Assign the base rate per thousand sum assured according to the insured's age at issue, using defined age bands and corresponding rates.                                                             | The base rate is set as follows: 0.8500 for age <= 30, 1.2000 for age <= 40, 2.1500 for age <= 50, 4.1000 for age <= 60, and 7.2500 for age > 60. The output is a numeric value with four decimal places. |
| BR-002  | Calculation | Gender factor assignment       | Assign a gender factor based on whether the insured is female. Female insureds receive a lower factor, reducing the premium.                                                                        | The gender factor is set to 0.92 if the insured is female, otherwise 1.00. The output is a numeric value with two decimal places.                                                                         |
| BR-003  | Calculation | Smoker factor assignment       | Assign a smoker factor based on whether the insured is a smoker. Smokers receive a higher factor, increasing the premium.                                                                           | The smoker factor is set to 1.75 if the insured is a smoker, otherwise 1.00. The output is a numeric value with two decimal places.                                                                       |
| BR-004  | Calculation | Occupation factor assignment   | Assign an occupation factor based on the insured's occupation class. Hazardous jobs get a higher factor, standard jobs get a moderate factor, and professional or other jobs get the lowest factor. | The occupation factor is set to 1.00 for professional or other, 1.15 for standard, and 1.40 for hazardous. The output is a numeric value with two decimal places.                                         |
| BR-005  | Calculation | Underwriting factor assignment | Assign an underwriting factor based on the insured's underwriting class. Preferred gets a discount, standard is neutral, table gets a surcharge, and other classes are neutral.                     | The underwriting factor is set to 0.90 for preferred, 1.00 for standard or other, and 1.25 for table B. The output is a numeric value with two decimal places.                                            |

<SwmSnippet path="/NB-UW-001.cob" line="256">

---

In <SwmToken path="NB-UW-001.cob" pos="256:1:7" line-data="       1400-LOAD-RATE-FACTORS.">`1400-LOAD-RATE-FACTORS`</SwmToken>, we set the base rate per thousand sum assured based on the insured's age. The age bands are hardcoded and control how much the policy costs for different ages.

```cobol
       1400-LOAD-RATE-FACTORS.
      * NB-401: Base mortality rate by issue age band.
           EVALUATE TRUE
              WHEN PM-INSURED-AGE-ISSUE <= 30
                 MOVE 00000.8500 TO PM-BASE-RATE-PER-THOU
              WHEN PM-INSURED-AGE-ISSUE <= 40
                 MOVE 00001.2000 TO PM-BASE-RATE-PER-THOU
              WHEN PM-INSURED-AGE-ISSUE <= 50
                 MOVE 00002.1500 TO PM-BASE-RATE-PER-THOU
              WHEN PM-INSURED-AGE-ISSUE <= 60
                 MOVE 00004.1000 TO PM-BASE-RATE-PER-THOU
              WHEN OTHER
                 MOVE 00007.2500 TO PM-BASE-RATE-PER-THOU
           END-EVALUATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="272">

---

After setting the base rate, we assign the gender factor. Female insureds get a lower factor, which reduces their premium. This is a business rule for gender-based pricing.

```cobol
           IF PM-FEMALE
              MOVE 0.9200 TO PM-GENDER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-GENDER-FACTOR
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="279">

---

Next we set the smoker factor. Smokers get a higher adjustment, which increases their premium. This is a standard risk pricing rule.

```cobol
           IF PM-SMOKER
              MOVE 1.7500 TO PM-SMOKER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-SMOKER-FACTOR
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="286">

---

Here we set the occupation factor based on the insured's job class. Hazardous jobs get a higher factor, standard jobs get a moderate bump, and professional jobs get the lowest. This affects the premium calculation.

```cobol
           EVALUATE TRUE
              WHEN PM-OCC-PROF
                 MOVE 1.0000 TO PM-OCC-FACTOR
              WHEN PM-OCC-STANDARD
                 MOVE 1.1500 TO PM-OCC-FACTOR
              WHEN PM-OCC-HAZARD
                 MOVE 1.4000 TO PM-OCC-FACTOR
              WHEN OTHER
                 MOVE 1.0000 TO PM-OCC-FACTOR
           END-EVALUATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="298">

---

Finally, we set the underwriting factor based on the assigned risk class. Preferred gets a discount, standard is neutral, table gets a surcharge. This wraps up all the adjustments needed for premium calculation.

```cobol
           EVALUATE TRUE
              WHEN PM-UW-PREFERRED
                 MOVE 0.9000 TO PM-UW-FACTOR
              WHEN PM-UW-STANDARD
                 MOVE 1.0000 TO PM-UW-FACTOR
              WHEN PM-UW-TABLE-B
                 MOVE 1.2500 TO PM-UW-FACTOR
              WHEN OTHER
                 MOVE 1.0000 TO PM-UW-FACTOR
           END-EVALUATE.
```

---

</SwmSnippet>

## Validating rider eligibility

This section ensures that all riders attached to a policy meet the product's eligibility rules before premium calculation. It enforces business constraints and communicates any eligibility failures through result codes and messages.

| Rule ID | Category        | Rule Name                     | Description                                                                                                                                                                                                               | Implementation Details                                                                                                                                                                        |
| ------- | --------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Rider eligibility enforcement | Each attached rider is checked to ensure it meets all product eligibility rules before premium calculation proceeds. If a rider does not meet eligibility, an error code and message are set in the policy master record. | Error codes are numeric and messages are alphanumeric strings. The result code is a number and the result message is a string up to 100 characters, left-aligned and space-padded if shorter. |

<SwmSnippet path="/NB-UW-001.cob" line="61">

---

Back in <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, after loading rate factors, we call <SwmToken path="NB-UW-001.cob" pos="62:3:7" line-data="           PERFORM 1500-VALIDATE-RIDERS">`1500-VALIDATE-RIDERS`</SwmToken> to check if all attached riders meet product rules. This step is needed because riders have their own eligibility limits and business rules that must be enforced before calculating premiums.

```cobol
           PERFORM 1400-LOAD-RATE-FACTORS
           PERFORM 1500-VALIDATE-RIDERS
```

---

</SwmSnippet>

## Checking rider rules

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Check if number of riders > 5"]
    click node1 openCode "NB-UW-001.cob:311:315"
    node1 -->|"Yes"| node2["Reject: Rider count exceeds product
limit"]
    click node2 openCode "NB-UW-001.cob:312:314"
    node1 -->|"No"| node3["Validate each rider"]
    click node3 openCode "NB-UW-001.cob:318:351"
    subgraph loop1["For each rider"]
      node3 --> node4{"Rider type?"}
      click node4 openCode "NB-UW-001.cob:321:350"
      node4 -->|ADB01| node5{"Insured age > 60?"}
      click node5 openCode "NB-UW-001.cob:324:328"
      node5 -->|"Yes"| node6["Reject: ADB rider not allowed above age
60"]
      click node6 openCode "NB-UW-001.cob:325:327"
      node5 -->|"No"| node4
      node4 -->|WOP01| node7{"Insured age < 18 or > 55?"}
      click node7 openCode "NB-UW-001.cob:331:335"
      node7 -->|"Yes"| node8["Reject: WOP rider age outside allowed
band"]
      click node8 openCode "NB-UW-001.cob:333:335"
      node7 -->|"No"| node4
      node4 -->|CI001| node10{"Sum assured > 500,000?"}
      click node10 openCode "NB-UW-001.cob:339:344"
      node10 -->|"Yes"| node11["Reject: CI rider exceeds maximum sum
assured"]
      click node11 openCode "NB-UW-001.cob:341:343"
      node10 -->|"No"| node4
      node4 -->|"SPACES"| node4
      node4 -->|"Unknown code"| node12["Reject: Unknown rider code"]
      click node12 openCode "NB-UW-001.cob:348:349"
    end
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Check if number of riders > 5"]
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:311:315"
%%     node1 -->|"Yes"| node2["Reject: Rider count exceeds product
%% limit"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:312:314"
%%     node1 -->|"No"| node3["Validate each rider"]
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:318:351"
%%     subgraph loop1["For each rider"]
%%       node3 --> node4{"Rider type?"}
%%       click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:321:350"
%%       node4 -->|<SwmToken path="NB-UW-001.cob" pos="322:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken>| node5{"Insured age > 60?"}
%%       click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:324:328"
%%       node5 -->|"Yes"| node6["Reject: ADB rider not allowed above age
%% 60"]
%%       click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:325:327"
%%       node5 -->|"No"| node4
%%       node4 -->|<SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken>| node7{"Insured age < 18 or > 55?"}
%%       click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:331:335"
%%       node7 -->|"Yes"| node8["Reject: WOP rider age outside allowed
%% band"]
%%       click node8 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:333:335"
%%       node7 -->|"No"| node4
%%       node4 -->|<SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken>| node10{"Sum assured > 500,000?"}
%%       click node10 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:339:344"
%%       node10 -->|"Yes"| node11["Reject: CI rider exceeds maximum sum
%% assured"]
%%       click node11 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:341:343"
%%       node10 -->|"No"| node4
%%       node4 -->|"SPACES"| node4
%%       node4 -->|"Unknown code"| node12["Reject: Unknown rider code"]
%%       click node12 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:348:349"
%%     end
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section validates attached riders for a term life insurance policy. It enforces product limits and eligibility criteria for each rider type, ensuring compliance with business rules before policy issuance.

| Rule ID | Category        | Rule Name                | Description                                                                                                                                                                                                                                                                                                                                                                                                                              | Implementation Details                                                                                                                                                                                                                                 |
| ------- | --------------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| BR-001  | Data validation | Rider count limit        | Reject the policy if the number of attached riders exceeds 5, as per product constraints.                                                                                                                                                                                                                                                                                                                                                | The maximum allowed number of riders is 5. If this rule is triggered, the result code is set to 22 and the message is set to 'RIDER COUNT EXCEEDS PRODUCT LIMIT'. The output message is a string, and the result code is a number.                     |
| BR-002  | Data validation | ADB rider age cap        | Reject the policy if an <SwmToken path="NB-UW-001.cob" pos="322:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken> rider is attached and the insured's age at issue is above 60.                                                                                                                                                                                                                                | The maximum allowed age for the ADB rider is 60. If this rule is triggered, the result code is set to 23 and the message is set to 'ADB RIDER NOT ALLOWED ABOVE AGE 60'. The output message is a string, and the result code is a number.              |
| BR-003  | Data validation | WOP rider age band       | Reject the policy if a <SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken> rider is attached and the insured's age at issue is less than 18 or greater than 55.                                                                                                                                                                                                          | The allowed age band for the WOP rider is 18 to 55 inclusive. If this rule is triggered, the result code is set to 24 and the message is set to 'WOP RIDER AGE OUTSIDE ALLOWED BAND'. The output message is a string, and the result code is a number. |
| BR-004  | Data validation | CI rider sum assured cap | Reject the policy if a <SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken> rider is attached and the sum assured for that rider exceeds 500,000.                                                                                                                                                                                                                         | The maximum allowed sum assured for the CI rider is 500,000. If this rule is triggered, the result code is set to 25 and the message is set to 'CI RIDER EXCEEDS MAXIMUM RIDER SA'. The output message is a string, and the result code is a number.   |
| BR-005  | Data validation | Unknown rider code       | Reject the policy if a rider code is not recognized (i.e., not <SwmToken path="NB-UW-001.cob" pos="322:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken>, <SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken>, <SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken>, or blank). | If this rule is triggered, the result code is set to 26 and the message is set to 'UNKNOWN RIDER CODE'. The output message is a string, and the result code is a number.                                                                               |

<SwmSnippet path="/NB-UW-001.cob" line="309">

---

In <SwmToken path="NB-UW-001.cob" pos="309:1:5" line-data="       1500-VALIDATE-RIDERS.">`1500-VALIDATE-RIDERS`</SwmToken>, we first check if the rider count exceeds 5. If it does, we set an error and exit. This enforces the product limit for attached riders.

```cobol
       1500-VALIDATE-RIDERS.
      * NB-501: Limit rider count.
           IF PM-RIDER-COUNT > 5
              MOVE 22 TO WS-RESULT-CODE
              MOVE "RIDER COUNT EXCEEDS PRODUCT LIMIT"
                TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="318">

---

Here we start looping through each rider and apply validation rules. For <SwmToken path="NB-UW-001.cob" pos="322:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken>, we check if the insured's age is above 60 and reject if so. This is the first rider-specific check in the loop.

```cobol
           PERFORM VARYING WS-RIDER-IDX FROM 1 BY 1
                   UNTIL WS-RIDER-IDX > PM-RIDER-COUNT OR
                         WS-RESULT-CODE NOT = 0
              EVALUATE PM-RIDER-CODE(WS-RIDER-IDX)
                 WHEN "ADB01"
      * NB-502: Accidental death rider issue age cap 60.
                    IF PM-INSURED-AGE-ISSUE > 60
                       MOVE 23 TO WS-RESULT-CODE
                       MOVE "ADB RIDER NOT ALLOWED ABOVE AGE 60"
                         TO WS-RESULT-MESSAGE
                    END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="329">

---

Next in the loop, we check for <SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken> and enforce the age band rule (18 to 55). If the insured's age is outside this range, we set an error and exit.

```cobol
                 WHEN "WOP01"
      * NB-503: Waiver of premium rider age band 18 to 55.
                    IF PM-INSURED-AGE-ISSUE < 18 OR
                       PM-INSURED-AGE-ISSUE > 55
                       MOVE 24 TO WS-RESULT-CODE
                       MOVE "WOP RIDER AGE OUTSIDE ALLOWED BAND"
                         TO WS-RESULT-MESSAGE
                    END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="337">

---

Here we check for <SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken> and enforce the sum assured cap. If the rider's sum assured is above 500,000, we set an error and exit.

```cobol
                 WHEN "CI001"
      * NB-504: Critical illness rider cap 500,000.
                    IF PM-RIDER-SUM-ASSURED(WS-RIDER-IDX)
                       > 0000500000.00
                       MOVE 25 TO WS-RESULT-CODE
                       MOVE "CI RIDER EXCEEDS MAXIMUM RIDER SA"
                         TO WS-RESULT-MESSAGE
                    END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="345">

---

This part flags unknown rider codes and wraps up the rider validation loop.

```cobol
                 WHEN SPACES
                    CONTINUE
                 WHEN OTHER
                    MOVE 26 TO WS-RESULT-CODE
                    MOVE "UNKNOWN RIDER CODE" TO WS-RESULT-MESSAGE
              END-EVALUATE
           END-PERFORM.
```

---

</SwmSnippet>

## Handling rider validation results

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1{"WS-RESULT-CODE = 0?"}
    click node1 openCode "NB-UW-001.cob:63:66"
    node1 -->|"No (error)"| node2["Return error (9000-RETURN-ERROR) and
stop"]
    click node2 openCode "NB-UW-001.cob:64:65"
    node1 -->|"Yes"| node3["Calculate base premium"]
    click node3 openCode "NB-UW-001.cob:68:68"
    node3 --> node4["Calculate rider premium"]
    click node4 openCode "NB-UW-001.cob:69:69"
    node4 --> node5["Calculate total premium"]
    click node5 openCode "NB-UW-001.cob:70:70"
    node5 --> node6["Evaluate referrals"]
    click node6 openCode "NB-UW-001.cob:71:71"

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1{"<SwmToken path="NB-UW-001.cob" pos="46:3:7" line-data="           IF WS-RESULT-CODE NOT = 0">`WS-RESULT-CODE`</SwmToken> = 0?"}
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:63:66"
%%     node1 -->|"No (error)"| node2["Return error (<SwmToken path="NB-UW-001.cob" pos="47:3:7" line-data="              PERFORM 9000-RETURN-ERROR">`9000-RETURN-ERROR`</SwmToken>) and
%% stop"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:64:65"
%%     node1 -->|"Yes"| node3["Calculate base premium"]
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:68:68"
%%     node3 --> node4["Calculate rider premium"]
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:69:69"
%%     node4 --> node5["Calculate total premium"]
%%     click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:70:70"
%%     node5 --> node6["Evaluate referrals"]
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:71:71"
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section governs the transition from rider validation to premium and referral processing. It ensures that only valid riders proceed to premium calculation and referral evaluation.

| Rule ID | Category        | Rule Name                                     | Description                                                                                                                                                                                     | Implementation Details                                                                                                                                                                              |
| ------- | --------------- | --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Data validation | Rider validation error handling               | If any errors are detected during rider validation (result code not zero), the process stops and an error is returned. Premium calculations and referral checks are not performed in this case. | The result code is a number. If it is not zero, an error response is triggered and further processing is halted.                                                                                    |
| BR-002  | Calculation     | Premium calculation sequence                  | If no errors are detected during rider validation (result code is zero), the process continues to calculate the base premium, then the rider premium, then the total premium, in that order.    | Premium calculations are performed in the following order: base premium, rider premium, total premium. Each calculation step depends on the completion of the previous step.                        |
| BR-003  | Decision Making | Referral evaluation after premium calculation | After all premium calculations are completed, the process evaluates whether the case requires referral for further review.                                                                      | Referral evaluation is performed after all premium calculations are done. The outcome may affect policy issuance or require manual review, depending on referral logic (not shown in this section). |

<SwmSnippet path="/NB-UW-001.cob" line="63">

---

Back in <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, after validating riders, we check for errors. If any were set, we call the error handler and exit. This prevents invalid riders from affecting premium calculations.

```cobol
           IF WS-RESULT-CODE NOT = 0
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="68">

---

Next, <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> calls the premium calculation routines. We start with base premium, then rider premium, then total premium, and finally referral checks. Calculating rider premium is needed because each rider adds cost and must be priced according to its rules.

```cobol
           PERFORM 1600-CALCULATE-BASE-PREMIUM
           PERFORM 1700-CALCULATE-RIDER-PREMIUM
           PERFORM 1800-CALCULATE-TOTAL-PREMIUM
           PERFORM 1900-EVALUATE-REFERRALS
```

---

</SwmSnippet>

## Pricing insurance riders

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Start calculation of all rider premiums"]
    click node1 openCode "NB-UW-001.cob:370:371"
    
    subgraph loop1["For each rider on the policy"]
        node2{"What is the rider type?"}
        click node2 openCode "NB-UW-001.cob:374:392"
        node2 -->|"ADB"| node3["Premium = (Sum Assured / 1000) * 0.1800"]
        click node3 openCode "NB-UW-001.cob:375:380"
        node2 -->|"WOP"| node4["Premium = Base Premium * 0.0600"]
        click node4 openCode "NB-UW-001.cob:381:385"
        node2 -->|"CI"| node5["Premium = (Sum Assured / 1000) * 1.2500"]
        click node5 openCode "NB-UW-001.cob:386:391"
        node2 -->|"Other"| node6["Premium = 0"]
        click node6 openCode "NB-UW-001.cob:392:393"
        node3 --> node7["Set rider status to Active; add to total"]
        node4 --> node7
        node5 --> node7
        node6 --> node7
        click node7 openCode "NB-UW-001.cob:395:397"
        node7 --> node2
    end
    loop1 -->|"All riders processed"| node8["Total annual rider premium calculated"]
    click node8 openCode "NB-UW-001.cob:398:398"

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Start calculation of all rider premiums"]
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:370:371"
%%     
%%     subgraph loop1["For each rider on the policy"]
%%         node2{"What is the rider type?"}
%%         click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:374:392"
%%         node2 -->|"ADB"| node3["Premium = (Sum Assured / 1000) * 0.1800"]
%%         click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:375:380"
%%         node2 -->|"WOP"| node4["Premium = Base Premium * <SwmToken path="NB-UW-001.cob" pos="385:11:13" line-data="                           PM-BASE-ANNUAL-PREMIUM * 0.0600">`0.0600`</SwmToken>"]
%%         click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:381:385"
%%         node2 -->|"CI"| node5["Premium = (Sum Assured / 1000) * <SwmToken path="NB-UW-001.cob" pos="304:3:5" line-data="                 MOVE 1.2500 TO PM-UW-FACTOR">`1.2500`</SwmToken>"]
%%         click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:386:391"
%%         node2 -->|"Other"| node6["Premium = 0"]
%%         click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:392:393"
%%         node3 --> node7["Set rider status to Active; add to total"]
%%         node4 --> node7
%%         node5 --> node7
%%         node6 --> node7
%%         click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:395:397"
%%         node7 --> node2
%%     end
%%     loop1 -->|"All riders processed"| node8["Total annual rider premium calculated"]
%%     click node8 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:398:398"
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section calculates the annual premium for each insurance rider on a policy, applying business-specific pricing rules based on rider type and aggregating the results.

| Rule ID | Category        | Rule Name                        | Description                                                                                                                                                                                                                                                                                                                                                             | Implementation Details                                                                                                                                                                                                                                                                                                                                                                                                               |
| ------- | --------------- | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| BR-001  | Calculation     | ADB rider pricing                | For riders with code <SwmToken path="NB-UW-001.cob" pos="322:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken>, the annual premium is calculated as the sum assured divided by 1000, multiplied by a fixed rate of 0.1800.                                                                                                                    | The rate used is 0.1800. The sum assured is a number. The premium is calculated as (sum assured / 1000) \* 0.1800 and rounded. Output is a number.                                                                                                                                                                                                                                                                                   |
| BR-002  | Calculation     | WOP rider pricing                | For riders with code <SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken>, the annual premium is calculated as 6% of the base annual premium.                                                                                                                                                            | The rate used is <SwmToken path="NB-UW-001.cob" pos="385:11:13" line-data="                           PM-BASE-ANNUAL-PREMIUM * 0.0600">`0.0600`</SwmToken> (6%). The base annual premium is a number. The premium is calculated as base annual premium \* <SwmToken path="NB-UW-001.cob" pos="385:11:13" line-data="                           PM-BASE-ANNUAL-PREMIUM * 0.0600">`0.0600`</SwmToken> and rounded. Output is a number. |
| BR-003  | Calculation     | CI rider pricing                 | For riders with code <SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken>, the annual premium is calculated as the sum assured divided by 1000, multiplied by a fixed rate of <SwmToken path="NB-UW-001.cob" pos="304:3:5" line-data="                 MOVE 1.2500 TO PM-UW-FACTOR">`1.2500`</SwmToken>. | The rate used is <SwmToken path="NB-UW-001.cob" pos="304:3:5" line-data="                 MOVE 1.2500 TO PM-UW-FACTOR">`1.2500`</SwmToken>. The sum assured is a number. The premium is calculated as (sum assured / 1000) \* <SwmToken path="NB-UW-001.cob" pos="304:3:5" line-data="                 MOVE 1.2500 TO PM-UW-FACTOR">`1.2500`</SwmToken> and rounded. Output is a number.                                             |
| BR-004  | Decision Making | Unknown rider pricing            | For any rider code not explicitly handled, the annual premium is set to zero.                                                                                                                                                                                                                                                                                           | Premium is set to zero. Output is a number.                                                                                                                                                                                                                                                                                                                                                                                          |
| BR-005  | Writing Output  | Rider activation and aggregation | After pricing, each rider is marked as active and its premium is added to the total annual rider premium for the policy.                                                                                                                                                                                                                                                | Rider status is set to 'A' (active). Premium is added to the total annual rider premium. Status is a string, premium and total are numbers.                                                                                                                                                                                                                                                                                          |

<SwmSnippet path="/NB-UW-001.cob" line="370">

---

In <SwmToken path="NB-UW-001.cob" pos="370:1:7" line-data="       1700-CALCULATE-RIDER-PREMIUM.">`1700-CALCULATE-RIDER-PREMIUM`</SwmToken>, we loop through all riders and price each one based on its code. For <SwmToken path="NB-UW-001.cob" pos="375:4:4" line-data="                 WHEN &quot;ADB01&quot;">`ADB01`</SwmToken>, we use a per-thousand rate; for <SwmToken path="NB-UW-001.cob" pos="329:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken>, a percentage of base premium; for <SwmToken path="NB-UW-001.cob" pos="337:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken>, another per-thousand rate. All rates are hardcoded and tied to business rules.

```cobol
       1700-CALCULATE-RIDER-PREMIUM.
           MOVE ZERO TO PM-RIDER-ANNUAL-TOTAL
           PERFORM VARYING WS-RIDER-IDX FROM 1 BY 1
                   UNTIL WS-RIDER-IDX > PM-RIDER-COUNT
              EVALUATE PM-RIDER-CODE(WS-RIDER-IDX)
                 WHEN "ADB01"
      * NB-701: ADB premium priced per thousand on rider SA.
                    MOVE 00000.1800 TO PM-RIDER-RATE(WS-RIDER-IDX)
                    COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX) ROUNDED =
                           (PM-RIDER-SUM-ASSURED(WS-RIDER-IDX) / 1000)
                         * PM-RIDER-RATE(WS-RIDER-IDX)
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="381">

---

Here we handle <SwmToken path="NB-UW-001.cob" pos="381:4:4" line-data="                 WHEN &quot;WOP01&quot;">`WOP01`</SwmToken> riders, pricing them at 6% of the base premium. This is a different calculation from the previous rider and shows how each rider type has its own pricing logic.

```cobol
                 WHEN "WOP01"
      * NB-702: WOP premium set at 6 percent of base annual premium.
                    MOVE 00000.0600 TO PM-RIDER-RATE(WS-RIDER-IDX)
                    COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX) ROUNDED =
                           PM-BASE-ANNUAL-PREMIUM * 0.0600
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="386">

---

Next we handle <SwmToken path="NB-UW-001.cob" pos="386:4:4" line-data="                 WHEN &quot;CI001&quot;">`CI001`</SwmToken> riders, pricing them per thousand sum assured at a fixed rate. This is another rider-specific calculation, using its own hardcoded rate.

```cobol
                 WHEN "CI001"
      * NB-703: CI premium priced per thousand on rider SA.
                    MOVE 00001.2500 TO PM-RIDER-RATE(WS-RIDER-IDX)
                    COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX) ROUNDED =
                           (PM-RIDER-SUM-ASSURED(WS-RIDER-IDX) / 1000)
                         * PM-RIDER-RATE(WS-RIDER-IDX)
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="392">

---

This section sets the premium to zero for any unknown rider codes, making sure only valid riders are priced before updating statuses and totals.

```cobol
                 WHEN OTHER
                    MOVE ZERO TO PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
              END-EVALUATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="395">

---

After pricing, each rider is marked active and its premium is added to the total, finalizing the rider premium calculation.

```cobol
              MOVE "A" TO PM-RIDER-STATUS(WS-RIDER-IDX)
              ADD PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                TO PM-RIDER-ANNUAL-TOTAL
           END-PERFORM.
```

---

</SwmSnippet>

## Calculating the total policyholder premium

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
  node1["Add base premium, riders, and policy fee
to get gross annual premium"]
  click node1 openCode "NB-UW-001.cob:400:406"
  node2["Apply tax rate to gross annual premium"]
  click node2 openCode "NB-UW-001.cob:407:410"
  node3["Add gross annual premium and tax to get
total annual premium"]
  click node3 openCode "NB-UW-001.cob:411:412"
  node1 --> node2
  node2 --> node3
  node3 --> node4{"Which billing mode is selected?"}
  click node4 openCode "NB-UW-001.cob:415:428"
  node4 -->|"Annual"| node5a["Set divisor=1, factor=1.0000"]
  click node5a openCode "NB-UW-001.cob:416:418"
  node4 -->|"Semi-annual"| node5b["Set divisor=2, factor=1.0150"]
  click node5b openCode "NB-UW-001.cob:419:421"
  node4 -->|"Quarterly"| node5c["Set divisor=4, factor=1.0300"]
  click node5c openCode "NB-UW-001.cob:422:424"
  node4 -->|"Monthly"| node5d["Set divisor=12, factor=1.0800"]
  click node5d openCode "NB-UW-001.cob:425:427"
  node5a --> node6["Calculate modal premium: (total annual
premium / divisor) * factor"]
  node5b --> node6
  node5c --> node6
  node5d --> node6
  click node6 openCode "NB-UW-001.cob:430:432"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%   node1["Add base premium, riders, and policy fee
%% to get gross annual premium"]
%%   click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:400:406"
%%   node2["Apply tax rate to gross annual premium"]
%%   click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:407:410"
%%   node3["Add gross annual premium and tax to get
%% total annual premium"]
%%   click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:411:412"
%%   node1 --> node2
%%   node2 --> node3
%%   node3 --> node4{"Which billing mode is selected?"}
%%   click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:415:428"
%%   node4 -->|"Annual"| node5a["Set divisor=1, factor=<SwmToken path="NB-UW-001.cob" pos="275:3:5" line-data="              MOVE 1.0000 TO PM-GENDER-FACTOR">`1.0000`</SwmToken>"]
%%   click node5a openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:416:418"
%%   node4 -->|"Semi-annual"| node5b["Set divisor=2, factor=<SwmToken path="NB-UW-001.cob" pos="421:3:5" line-data="                 MOVE 1.0150 TO WS-MODAL-FACTOR">`1.0150`</SwmToken>"]
%%   click node5b openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:419:421"
%%   node4 -->|"Quarterly"| node5c["Set divisor=4, factor=<SwmToken path="NB-UW-001.cob" pos="424:3:5" line-data="                 MOVE 1.0300 TO WS-MODAL-FACTOR">`1.0300`</SwmToken>"]
%%   click node5c openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:422:424"
%%   node4 -->|"Monthly"| node5d["Set divisor=12, factor=<SwmToken path="NB-UW-001.cob" pos="427:3:5" line-data="                 MOVE 1.0800 TO WS-MODAL-FACTOR">`1.0800`</SwmToken>"]
%%   click node5d openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:425:427"
%%   node5a --> node6["Calculate modal premium: (total annual
%% premium / divisor) * factor"]
%%   node5b --> node6
%%   node5c --> node6
%%   node5d --> node6
%%   click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:430:432"
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section determines the final premium amount a policyholder pays per billing cycle by aggregating all premium components, applying tax, and adjusting for the selected billing frequency.

| Rule ID | Category        | Rule Name                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Implementation Details                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ------- | --------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Calculation     | Gross annual premium calculation        | The gross annual premium is calculated by summing the base annual premium, all rider premiums, and the annual policy fee.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | The gross annual premium is a number with two decimal places. All components are summed before any further calculations.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| BR-002  | Calculation     | Tax calculation on premium              | The tax amount is calculated by multiplying the gross annual premium by the tax rate.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | The tax rate is <SwmToken path="NB-UW-001.cob" pos="126:3:5" line-data="                 MOVE 0.0200 TO PM-TAX-RATE">`0.0200`</SwmToken> for all plan terms. The tax amount is a number with two decimal places.                                                                                                                                                                                                                                                                                                                                                                                                  |
| BR-003  | Calculation     | Total annual premium calculation        | The total annual premium is calculated by adding the gross annual premium and the tax amount.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | The total annual premium is a number with two decimal places. It is the sum of gross annual premium and tax amount.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| BR-004  | Calculation     | Modal premium calculation               | The modal premium is calculated by dividing the total annual premium by the divisor and multiplying by the factor determined by the billing mode.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | The modal premium is a number with two decimal places. It is calculated as (total annual premium / divisor) \* factor.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| BR-005  | Decision Making | Billing mode divisor and factor mapping | The billing mode determines the divisor and factor used to calculate the modal premium. Annual mode uses divisor 1 and factor <SwmToken path="NB-UW-001.cob" pos="275:3:5" line-data="              MOVE 1.0000 TO PM-GENDER-FACTOR">`1.0000`</SwmToken>; semi-annual uses divisor 2 and factor <SwmToken path="NB-UW-001.cob" pos="421:3:5" line-data="                 MOVE 1.0150 TO WS-MODAL-FACTOR">`1.0150`</SwmToken>; quarterly uses divisor 4 and factor <SwmToken path="NB-UW-001.cob" pos="424:3:5" line-data="                 MOVE 1.0300 TO WS-MODAL-FACTOR">`1.0300`</SwmToken>; monthly uses divisor 12 and factor <SwmToken path="NB-UW-001.cob" pos="427:3:5" line-data="                 MOVE 1.0800 TO WS-MODAL-FACTOR">`1.0800`</SwmToken>. | Divisor and factor are constants: Annual (1, <SwmToken path="NB-UW-001.cob" pos="275:3:5" line-data="              MOVE 1.0000 TO PM-GENDER-FACTOR">`1.0000`</SwmToken>), Semi-annual (2, <SwmToken path="NB-UW-001.cob" pos="421:3:5" line-data="                 MOVE 1.0150 TO WS-MODAL-FACTOR">`1.0150`</SwmToken>), Quarterly (4, <SwmToken path="NB-UW-001.cob" pos="424:3:5" line-data="                 MOVE 1.0300 TO WS-MODAL-FACTOR">`1.0300`</SwmToken>), Monthly (12, <SwmToken path="NB-UW-001.cob" pos="427:3:5" line-data="                 MOVE 1.0800 TO WS-MODAL-FACTOR">`1.0800`</SwmToken>). |

<SwmSnippet path="/NB-UW-001.cob" line="400">

---

In <SwmToken path="NB-UW-001.cob" pos="400:1:7" line-data="       1800-CALCULATE-TOTAL-PREMIUM.">`1800-CALCULATE-TOTAL-PREMIUM`</SwmToken>, we sum up the base premium, rider premiums, and policy fee to get the gross annual premium. Then we calculate the tax amount based on this gross premium and add it to get the total annual premium. This sets up the final premium before adjusting for billing frequency.

```cobol
       1800-CALCULATE-TOTAL-PREMIUM.
      * NB-801: Gross annual premium includes base, riders, and fee.
           COMPUTE PM-GROSS-ANNUAL-PREMIUM ROUNDED =
                   PM-BASE-ANNUAL-PREMIUM
                 + PM-RIDER-ANNUAL-TOTAL
                 + PM-POLICY-FEE-ANNUAL

      * NB-802: Tax is calculated on the gross annual premium.
           COMPUTE PM-TAX-AMOUNT ROUNDED =
                   PM-GROSS-ANNUAL-PREMIUM * PM-TAX-RATE

           COMPUTE PM-TOTAL-ANNUAL-PREMIUM ROUNDED =
                   PM-GROSS-ANNUAL-PREMIUM + PM-TAX-AMOUNT
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="415">

---

Here we set the modal divisor and factor based on the billing mode. This determines how the annual premium is split and adjusted for payment frequency, using fixed business rules for each mode before calculating the modal premium.

```cobol
           EVALUATE TRUE
              WHEN PM-MODE-ANNUAL
                 MOVE 1 TO WS-MODAL-DIVISOR
                 MOVE 1.0000 TO WS-MODAL-FACTOR
              WHEN PM-MODE-SEMI
                 MOVE 2 TO WS-MODAL-DIVISOR
                 MOVE 1.0150 TO WS-MODAL-FACTOR
              WHEN PM-MODE-QUARTERLY
                 MOVE 4 TO WS-MODAL-DIVISOR
                 MOVE 1.0300 TO WS-MODAL-FACTOR
              WHEN PM-MODE-MONTHLY
                 MOVE 12 TO WS-MODAL-DIVISOR
                 MOVE 1.0800 TO WS-MODAL-FACTOR
           END-EVALUATE
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="430">

---

Finally we calculate the modal premium by dividing the total annual premium by the divisor and multiplying by the modal factor. This gives the actual premium amount the customer pays per billing cycle, adjusted for frequency.

```cobol
           COMPUTE PM-MODAL-PREMIUM ROUNDED =
                   (PM-TOTAL-ANNUAL-PREMIUM / WS-MODAL-DIVISOR)
                 * WS-MODAL-FACTOR.
```

---

</SwmSnippet>

## Checking for referral or manual underwriting

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Calculate base premium"] --> node2["Calculate rider premium"]
    click node1 openCode "NB-UW-001.cob:68:68"
    node2 --> node3["Calculate total premium"]
    click node2 openCode "NB-UW-001.cob:69:69"
    node3 --> node4["Evaluate if referral is needed"]
    click node3 openCode "NB-UW-001.cob:70:70"
    node4 --> node5{"Is manual underwriting required?"}
    click node4 openCode "NB-UW-001.cob:71:71"
    node5 -->|"Yes"| node6["Refer for manual underwriting"]
    node5 -->|"No"| node7{"Is reinsurance referral required?"}
    node7 -->|"Yes"| node8["Refer for reinsurance"]
    node7 -->|"No"| node9["Policy can be issued"]

classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Calculate base premium"] --> node2["Calculate rider premium"]
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:68:68"
%%     node2 --> node3["Calculate total premium"]
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:69:69"
%%     node3 --> node4["Evaluate if referral is needed"]
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:70:70"
%%     node4 --> node5{"Is manual underwriting required?"}
%%     click node4 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:71:71"
%%     node5 -->|"Yes"| node6["Refer for manual underwriting"]
%%     node5 -->|"No"| node7{"Is reinsurance referral required?"}
%%     node7 -->|"Yes"| node8["Refer for reinsurance"]
%%     node7 -->|"No"| node9["Policy can be issued"]
%% 
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section evaluates whether a policy application should be referred for manual underwriting or reinsurance review based on business-defined thresholds and criteria. It ensures that high-risk or high-coverage cases are flagged for additional review before policy issuance.

| Rule ID | Category        | Rule Name                        | Description                                                                                                                                                               | Implementation Details                                                                                                                                                                                                 |
| ------- | --------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BR-001  | Decision Making | Manual underwriting referral     | If the policy application meets criteria for manual underwriting referral, the case is flagged for manual underwriting review before proceeding.                          | The criteria for manual underwriting referral are based on business thresholds, which may include age, sum assured, or other risk factors. The output is a referral status indicating manual underwriting is required. |
| BR-002  | Decision Making | Reinsurance referral             | If the policy application does not require manual underwriting but meets criteria for reinsurance referral, the case is flagged for reinsurance review before proceeding. | The criteria for reinsurance referral are based on business thresholds, which may include sum assured or other risk factors. The output is a referral status indicating reinsurance review is required.                |
| BR-003  | Decision Making | Policy issuance without referral | If the policy application does not require manual underwriting or reinsurance referral, the policy can proceed to issuance.                                               | If no referral is required, the output is a status indicating the policy can be issued. No additional review is triggered.                                                                                             |

<SwmSnippet path="/NB-UW-001.cob" line="68">

---

After calculating the total premium in <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken>, we call <SwmToken path="NB-UW-001.cob" pos="71:3:7" line-data="           PERFORM 1900-EVALUATE-REFERRALS">`1900-EVALUATE-REFERRALS`</SwmToken> to check if the policy needs manual underwriting or reinsurance review. This step uses risk and coverage thresholds to flag cases for referral before moving to policy issuance.

```cobol
           PERFORM 1600-CALCULATE-BASE-PREMIUM
           PERFORM 1700-CALCULATE-RIDER-PREMIUM
           PERFORM 1800-CALCULATE-TOTAL-PREMIUM
           PERFORM 1900-EVALUATE-REFERRALS
```

---

</SwmSnippet>

## Flagging cases for review or reinsurance

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
flowchart TD
    node1["Start evaluation"]
    click node1 openCode "NB-UW-001.cob:434:434"
    node1 --> node2{"Is sum assured greater than $1,500,000?"}
    click node2 openCode "NB-UW-001.cob:436:436"
    node2 -->|"Yes"| node3["Flag for reinsurance referral"]
    click node3 openCode "NB-UW-001.cob:437:437"
    node2 -->|"No"| node4
    node3 --> node4
    node4 --> node5{"Is applicant high risk? (Table B,
Avocation, or Flat Extra > 2.50)"}
    click node5 openCode "NB-UW-001.cob:441:442"
    node5 -->|"Yes"| node6["Flag for underwriting referral"]
    click node6 openCode "NB-UW-001.cob:443:443"
    node5 -->|"No"| node7["End"]
    click node7 openCode "NB-UW-001.cob:444:444"
classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;

%% Swimm:
%% %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
%% flowchart TD
%%     node1["Start evaluation"]
%%     click node1 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:434:434"
%%     node1 --> node2{"Is sum assured greater than $1,500,000?"}
%%     click node2 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:436:436"
%%     node2 -->|"Yes"| node3["Flag for reinsurance referral"]
%%     click node3 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:437:437"
%%     node2 -->|"No"| node4
%%     node3 --> node4
%%     node4 --> node5{"Is applicant high risk? (Table B,
%% Avocation, or Flat Extra > 2.50)"}
%%     click node5 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:441:442"
%%     node5 -->|"Yes"| node6["Flag for underwriting referral"]
%%     click node6 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:443:443"
%%     node5 -->|"No"| node7["End"]
%%     click node7 openCode "<SwmPath>[NB-UW-001.cob](NB-UW-001.cob)</SwmPath>:444:444"
%% classDef HeadingStyle fill:#777777,stroke:#333,stroke-width:2px;
```

This section determines if a policy application should be flagged for reinsurance or underwriting review based on sum assured and risk factors. The referral flags guide subsequent manual review processes.

| Rule ID | Category        | Rule Name                              | Description                                                                                                                                                                         | Implementation Details                                                                                                                                                                                                                                                                     |
| ------- | --------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| BR-001  | Decision Making | Large sum assured reinsurance referral | Flag the policy for reinsurance referral if the sum assured is greater than $1,500,000.                                                                                             | The threshold for sum assured is $1,500,000. The output is a referral flag set to 'Y' (yes) when the condition is met. The flag is used by downstream processes to determine if reinsurance review is required.                                                                            |
| BR-002  | Decision Making | High risk underwriting referral        | Flag the policy for underwriting referral if the applicant is high risk, defined as having underwriting class Table B, high-risk avocation, or a flat extra rate greater than 2.50. | The underwriting class Table B, high-risk avocation indicator, and flat extra rate threshold of 2.50 are the criteria. The output is a referral flag set to 'Y' (yes) when any condition is met. The flag is used by downstream processes to determine if underwriting review is required. |

<SwmSnippet path="/NB-UW-001.cob" line="434">

---

We check sum assured and risk factors to flag policies for reinsurance or underwriting review.

```cobol
       1900-EVALUATE-REFERRALS.
      * NB-901: Large cases require facultative reinsurance review.
           IF PM-SUM-ASSURED > 0001500000000.00
              MOVE 'Y' TO WS-REINSURANCE-REFERRAL
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="441">

---

After checking thresholds and risk factors, we set referral flags for reinsurance or underwriting review. These flags are used by <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> to decide if the policy needs manual handling or can be issued directly.

```cobol
           IF PM-UW-TABLE-B OR PM-HIGH-RISK-AVOC OR
              PM-FLAT-EXTRA-RATE > 00002.50
              MOVE 'Y' TO WS-UW-REFERRAL
           END-IF.
```

---

</SwmSnippet>

## Finalizing underwriting outcome

This section determines the final underwriting outcome for a policy. It either refers the policy for manual review or issues it, updating all relevant status fields and dates accordingly.

| Rule ID | Category        | Rule Name                            | Description                                                                                                                                                                                                                                                                                                                    | Implementation Details                                                                                                                                                                                                                                                                                       |
| ------- | --------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| BR-001  | Calculation     | Policy issuance and date calculation | If no referral is detected, the policy is issued successfully. All key policy dates (issue, effective, paid-to, last maintenance) are set to the process date. The expiry date is calculated by adding the term years times 365 days to the effective date, ignoring leap years. The contract status is set to 'AC' (active).  | All key policy dates are set to the process date (8-digit number, YYYYMMDD). The expiry date is calculated as effective date plus (term years \* 365 days), formatted as an 8-digit number (YYYYMMDD). The contract status is set to 'AC' (active). Leap years are not considered in the expiry calculation. |
| BR-002  | Decision Making | Referral outcome handling            | If a referral for manual underwriting or reinsurance is detected, the policy is not issued. Instead, the result code is set to 2, the result message is set to 'REFERRED FOR MANUAL UW OR REINSURANCE REVIEW', and the contract status is set to 'PE' (pending). The process then exits, routing the policy for manual review. | The result code is set to 2 (number). The result message is set to the string 'REFERRED FOR MANUAL UW OR REINSURANCE REVIEW'. The contract status is set to 'PE' (pending).                                                                                                                                  |
| BR-003  | Writing Output  | Successful issuance outcome          | After issuing the policy, the result code is set to 0 and the result message is set to 'POLICY ISSUED SUCCESSFULLY'. The process then calls the success handler and exits, indicating a successful underwriting outcome.                                                                                                       | The result code is set to 0 (number). The result message is set to the string 'POLICY ISSUED SUCCESSFULLY'.                                                                                                                                                                                                  |

<SwmSnippet path="/NB-UW-001.cob" line="73">

---

After returning from <SwmToken path="NB-UW-001.cob" pos="71:3:7" line-data="           PERFORM 1900-EVALUATE-REFERRALS">`1900-EVALUATE-REFERRALS`</SwmToken>, <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> checks if referral flags are set. If so, it updates the result code and message, marks the contract as pending, and exits, routing the policy for manual review instead of issuing it.

```cobol
           IF WS-REFERRED OR WS-MANUAL-UW
              MOVE 2 TO WS-RESULT-CODE
              MOVE "REFERRED FOR MANUAL UW OR REINSURANCE REVIEW"
                TO WS-RESULT-MESSAGE
              MOVE "PE" TO PM-CONTRACT-STATUS
              PERFORM 9100-RETURN-SUCCESS
              GOBACK
           END-IF
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="82">

---

<SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> calls <SwmToken path="NB-UW-001.cob" pos="82:3:7" line-data="           PERFORM 2000-ISSUE-POLICY">`2000-ISSUE-POLICY`</SwmToken> to finalize and activate the policy.

```cobol
           PERFORM 2000-ISSUE-POLICY
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="446">

---

<SwmToken path="NB-UW-001.cob" pos="446:1:5" line-data="       2000-ISSUE-POLICY.">`2000-ISSUE-POLICY`</SwmToken> sets all key policy dates to the process date, calculates the expiry date by adding term years times 365 days, and marks the contract as active. This finalizes the policy record for issuance, but ignores leap years in expiry calculation.

```cobol
       2000-ISSUE-POLICY.
      * NB-1001: Successful issue sets policy active and populates dates.
           MOVE PM-PROCESS-DATE TO PM-ISSUE-DATE
                                 PM-EFFECTIVE-DATE
                                 PM-PAID-TO-DATE
                                 PM-LAST-MAINT-DATE
           COMPUTE WS-DATE-INT = FUNCTION INTEGER-OF-DATE(PM-EFFECTIVE-DATE)
                               + (PM-TERM-YEARS * 365)
           MOVE FUNCTION DATE-OF-INTEGER(WS-DATE-INT) TO PM-EXPIRY-DATE
           MOVE "AC" TO PM-CONTRACT-STATUS.
```

---

</SwmSnippet>

<SwmSnippet path="/NB-UW-001.cob" line="83">

---

After returning from <SwmToken path="NB-UW-001.cob" pos="82:3:7" line-data="           PERFORM 2000-ISSUE-POLICY">`2000-ISSUE-POLICY`</SwmToken>, <SwmToken path="NB-UW-001.cob" pos="42:1:3" line-data="       MAIN-PROCESS.">`MAIN-PROCESS`</SwmToken> sets the result code and message for successful issuance, calls the success handler, and exits. This wraps up the flow, using domain-specific codes and messages to indicate the underwriting outcome.

```cobol
           MOVE 0 TO WS-RESULT-CODE
           MOVE "POLICY ISSUED SUCCESSFULLY" TO WS-RESULT-MESSAGE
           PERFORM 9100-RETURN-SUCCESS
           GOBACK.
```

---

</SwmSnippet>

&nbsp;

*This is an auto-generated document by Swimm 🌊 and has not yet been verified by a human*

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBQ09CT0xfU2FtcGxlX01hcmNoXzIwMjYlM0ElM0FtdWRhc2luMQ==" repo-name="COBOL_Sample_March_2026"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
