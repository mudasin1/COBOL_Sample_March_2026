       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLMADJ001.
       AUTHOR.      OPENAI.
       DATE-WRITTEN. 2026-03-24.
       REMARKS.
      *===============================================================*
      * DOMAIN: TERM POLICY CLAIMS - END-TO-END CLAIMS PROCESSING     *
      * PURPOSE:                                                       *
      *   Validate claim intake, identify investigation triggers,      *
      *   adjudicate coverage, and calculate net settlement.           *
      *===============================================================*

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-CURR-DATE                 PIC 9(08).
       77  WS-DATE-DIFF                 PIC 9(05) VALUE 0.
       77  WS-CLAIM-PAYOUT              PIC 9(11)V99 VALUE 0.
       77  WS-RIDER-IDX                 PIC 9(02) VALUE 0.
       77  WS-MISSING-DOCS              PIC X VALUE 'N'.
           88  WS-DOCS-MISSING          VALUE 'Y'.
       77  WS-MANUAL-REVIEW             PIC X VALUE 'N'.
           88  WS-MANUAL                VALUE 'Y'.
       77  WS-REJECT-CLAIM              PIC X VALUE 'N'.
           88  WS-REJECTED              VALUE 'Y'.

       LINKAGE SECTION.
       COPY POLDATA.
       01  LK-CLAIM-STATUS              PIC X.
           88  LK-CLAIM-APPROVED        VALUE 'A'.
           88  LK-CLAIM-REJECTED        VALUE 'R'.
           88  LK-CLAIM-PENDING         VALUE 'P'.

       PROCEDURE DIVISION USING WS-POLICY-MASTER-REC
                                LK-CLAIM-STATUS.

       MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           PERFORM 1200-VALIDATE-CLAIM-INTAKE
           IF WS-REJECTED
              PERFORM 9000-REJECT-AND-RETURN
              GOBACK
           END-IF

           PERFORM 1300-DETERMINE-INVESTIGATION
           IF WS-MANUAL
              MOVE 'P' TO LK-CLAIM-STATUS
              MOVE 'P' TO PM-CLAIM-DECISION
              MOVE "CLAIM ROUTED FOR MANUAL INVESTIGATION"
                TO PM-RETURN-MESSAGE
              MOVE 2 TO PM-RETURN-CODE
              GOBACK
           END-IF

           PERFORM 1400-ADJUDICATE-COVERAGE
           IF WS-REJECTED
              PERFORM 9000-REJECT-AND-RETURN
              GOBACK
           END-IF

           PERFORM 1500-CALCULATE-SETTLEMENT
           PERFORM 1600-SETTLE-CLAIM
           GOBACK.

       1000-INITIALIZE.
           MOVE ZERO TO PM-RETURN-CODE PM-CLAIM-PAYMENT-AMOUNT
           MOVE SPACES TO PM-RETURN-MESSAGE PM-CLAIM-HOLD-REASON
           MOVE 'N' TO WS-MISSING-DOCS WS-MANUAL-REVIEW WS-REJECT-CLAIM
           MOVE 'P' TO LK-CLAIM-STATUS
           ACCEPT WS-CURR-DATE FROM DATE YYYYMMDD
           IF PM-PROCESS-DATE = ZERO
              MOVE WS-CURR-DATE TO PM-PROCESS-DATE
           END-IF
           MOVE PM-PROCESS-DATE TO PM-LAST-ACTION-DATE
           MOVE "CLM001" TO PM-LAST-ACTION-USER.

       1100-LOAD-PLAN-PARAMETERS.
      * CL-101: Claim rules depend on plan contestable and suicide windows.
           EVALUATE PM-PLAN-CODE
              WHEN "T1001" OR "T2001" OR "T6501"
                 MOVE 02 TO PM-CONTESTABLE-YEARS
                 MOVE 02 TO PM-SUICIDE-EXCL-YEARS
              WHEN OTHER
                 MOVE 'Y' TO WS-REJECT-CLAIM
                 MOVE 11 TO PM-RETURN-CODE
                 MOVE "UNKNOWN PLAN CODE FOR CLAIM ADJUDICATION"
                   TO PM-RETURN-MESSAGE
           END-EVALUATE.

       1200-VALIDATE-CLAIM-INTAKE.
      * CL-201: Claim must be death claim for this sample domain.
           IF NOT PM-CLAIM-DEATH
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 12 TO PM-RETURN-CODE
              MOVE "ONLY DEATH CLAIMS ARE SUPPORTED IN THIS SAMPLE"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * CL-202: Policy must be active or in grace. Lapsed and terminated
      *         claims are not payable in this sample.
           IF PM-STAT-LAPSED OR PM-STAT-TERMINATED
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 13 TO PM-RETURN-CODE
              MOVE "POLICY NOT IN FORCE AT CLAIM INTAKE"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * CL-203: Core claim data must be present.
           IF PM-CLAIM-ID = SPACES OR PM-DATE-OF-DEATH = ZERO OR
              PM-BENEFICIARY-NAME = SPACES
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 14 TO PM-RETURN-CODE
              MOVE "CLAIM ID, DATE OF DEATH, AND BENEFICIARY ARE REQUIRED"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * CL-204: Required documents.
           IF NOT PM-DOC-DEATH-CERT-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
           IF NOT PM-DOC-CLAIM-FORM-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
           IF NOT PM-DOC-ID-PROOF-YES
              MOVE 'Y' TO WS-MISSING-DOCS
           END-IF
           IF WS-DOCS-MISSING
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "MISSING CORE CLAIM DOCUMENTS"
                TO PM-CLAIM-HOLD-REASON
           END-IF.

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

      * CL-302: Unknown, homicide, and suicide causes require review.
           IF PM-CAUSE-OF-DEATH = "UNK" OR
              PM-CAUSE-OF-DEATH = "HOM" OR
              PM-CAUSE-OF-DEATH = "SUI"
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "CAUSE OF DEATH REQUIRES CLAIMS INVESTIGATION"
                TO PM-CLAIM-HOLD-REASON
           END-IF

      * CL-303: Missing medical documents also trigger review for
      *         accidental or suspicious claims.
           IF (PM-CAUSE-OF-DEATH = "ACC" OR
               PM-CAUSE-OF-DEATH = "HOM" OR
               PM-CAUSE-OF-DEATH = "UNK") AND
              NOT PM-DOC-MEDICAL-YES
              MOVE 'Y' TO WS-MANUAL-REVIEW
              MOVE "MEDICAL DOCUMENTATION REQUIRED FOR THIS CLAIM"
                TO PM-CLAIM-HOLD-REASON
           END-IF

           IF WS-MANUAL
              MOVE 'P' TO PM-CLAIM-INVEST-STATUS
              MOVE PM-PROCESS-DATE TO PM-CLAIM-INVEST-DATE
           ELSE
              MOVE 'N' TO PM-CLAIM-INVEST-STATUS
           END-IF.

       1400-ADJUDICATE-COVERAGE.
      * CL-401: Suicide within exclusion period is rejected.
           IF PM-CAUSE-OF-DEATH = "SUI"
              COMPUTE WS-DATE-DIFF =
                      FUNCTION INTEGER-OF-DATE(PM-DATE-OF-DEATH)
                    - FUNCTION INTEGER-OF-DATE(PM-ISSUE-DATE)
              IF WS-DATE-DIFF < (PM-SUICIDE-EXCL-YEARS * 365)
                 MOVE 'Y' TO WS-REJECT-CLAIM
                 MOVE 21 TO PM-RETURN-CODE
                 MOVE "SUICIDE EXCLUSION APPLIES WITHIN 2 YEARS"
                   TO PM-RETURN-MESSAGE
              END-IF
           END-IF

      * CL-402: Expired policies are not payable after expiry date.
           IF PM-DATE-OF-DEATH > PM-EXPIRY-DATE
              MOVE 'Y' TO WS-REJECT-CLAIM
              MOVE 22 TO PM-RETURN-CODE
              MOVE "DATE OF DEATH IS AFTER POLICY EXPIRY"
                TO PM-RETURN-MESSAGE
           END-IF.

       1500-CALCULATE-SETTLEMENT.
      * CL-501: Base death benefit starts with sum assured.
           MOVE ZERO TO WS-CLAIM-PAYOUT
           ADD PM-SUM-ASSURED TO WS-CLAIM-PAYOUT

      * CL-502: Active ADB rider pays extra on accidental death.
           IF PM-CAUSE-OF-DEATH = "ACC"
              PERFORM VARYING WS-RIDER-IDX FROM 1 BY 1
                      UNTIL WS-RIDER-IDX > PM-RIDER-COUNT
                 IF PM-RIDER-CODE(WS-RIDER-IDX) = "ADB01" AND
                    PM-RIDER-STATUS(WS-RIDER-IDX) = "A"
                    ADD PM-RIDER-SUM-ASSURED(WS-RIDER-IDX)
                      TO WS-CLAIM-PAYOUT
                 END-IF
              END-PERFORM
           END-IF

      * CL-503: Deduct unpaid modal premium when death occurs in grace.
           IF PM-STAT-GRACE
              SUBTRACT PM-MODAL-PREMIUM FROM WS-CLAIM-PAYOUT
           END-IF

      * CL-504: Deduct outstanding policy loan balance.
           IF PM-POLICY-LOAN-BALANCE > 0
              SUBTRACT PM-POLICY-LOAN-BALANCE FROM WS-CLAIM-PAYOUT
           END-IF

           IF WS-CLAIM-PAYOUT < 0
              MOVE ZERO TO WS-CLAIM-PAYOUT
           END-IF
           MOVE WS-CLAIM-PAYOUT TO PM-CLAIM-PAYMENT-AMOUNT.

       1600-SETTLE-CLAIM.
      * CL-601: Approved claims are adjudicated and settled.
           MOVE 'A' TO LK-CLAIM-STATUS
           MOVE 'A' TO PM-CLAIM-DECISION
           MOVE 'C' TO PM-CLAIM-INVEST-STATUS
           MOVE PM-PROCESS-DATE TO PM-CLAIM-ADJUDICATE-DATE
                                 PM-CLAIM-SETTLE-DATE
                                 PM-LAST-MAINT-DATE
           MOVE PM-CLAIM-PAYMENT-AMOUNT TO PM-CLAIM-PAYMENT-AMOUNT
           IF PM-CLAIM-PAYMENT-MODE = SPACES
              MOVE 'A' TO PM-CLAIM-PAYMENT-MODE
           END-IF
           MOVE "CL" TO PM-CONTRACT-STATUS
           MOVE 0 TO PM-RETURN-CODE
           MOVE "CLAIM APPROVED AND SETTLED" TO PM-RETURN-MESSAGE.

       9000-REJECT-AND-RETURN.
           MOVE 'R' TO LK-CLAIM-STATUS
           MOVE 'R' TO PM-CLAIM-DECISION.

       END PROGRAM CLMADJ001.
