       IDENTIFICATION DIVISION.
       PROGRAM-ID. SVCBILL001.
       AUTHOR.      OPENAI.
       DATE-WRITTEN. 2026-03-24.
       REMARKS.
      *===============================================================*
      * DOMAIN: POLICY SERVICING - POLICY CHANGES AND AMENDMENTS      *
      * PURPOSE:                                                       *
      *   Re-price policy changes, control status transitions,         *
      *   reinstate lapsed business, and calculate amendment fees.     *
      *===============================================================*

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-CURR-DATE                 PIC 9(08).
       77  WS-DAYS-SINCE-PAID           PIC 9(05) VALUE 0.
       77  WS-ATTAINED-AGE              PIC 9(03) VALUE 0.
       77  WS-DATE-INT                  PIC 9(09) VALUE 0.
       77  WS-MODAL-DIVISOR             PIC 9(02) VALUE 1.
       77  WS-MODAL-FACTOR              PIC 9V9999 VALUE 1.0000.
       77  WS-RIDER-IDX                 PIC 9(02) VALUE 0.
       77  WS-OLD-ANNUAL-PREMIUM        PIC 9(09)V99 VALUE 0.
       77  WS-TEMP-NEW-ANNUAL           PIC 9(09)V99 VALUE 0.
       77  WS-SA-INCREASE-PCT           PIC 9(03)V99 VALUE 0.

       LINKAGE SECTION.
       COPY POLDATA.

       PROCEDURE DIVISION USING WS-POLICY-MASTER-REC.

       MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           PERFORM 1200-CALCULATE-ATTAINED-AGE
           PERFORM 1300-EVALUATE-PAYMENT-STATUS
           PERFORM 1400-VALIDATE-SERVICING-REQUEST
           IF PM-RETURN-CODE NOT = 0
              GOBACK
           END-IF

           EVALUATE TRUE
              WHEN PM-AMEND-CHANGE-PLAN
                 PERFORM 2100-CHANGE-PLAN
              WHEN PM-AMEND-CHANGE-SA
                 PERFORM 2200-CHANGE-SUM-ASSURED
              WHEN PM-AMEND-BILLING-MODE
                 PERFORM 2300-CHANGE-BILLING-MODE
              WHEN PM-AMEND-ADD-RIDER
                 PERFORM 2400-ADD-RIDER
              WHEN PM-AMEND-REMOVE-RIDER
                 PERFORM 2500-REMOVE-RIDER
              WHEN PM-AMEND-REINSTATE
                 PERFORM 2600-PROCESS-REINSTATEMENT
              WHEN OTHER
                 MOVE 41 TO PM-RETURN-CODE
                 MOVE "INVALID OR MISSING AMENDMENT TYPE"
                   TO PM-RETURN-MESSAGE
           END-EVALUATE

           IF PM-RETURN-CODE = 0
              MOVE PM-PROCESS-DATE TO PM-LAST-MAINT-DATE PM-LAST-ACTION-DATE
              MOVE "SVC001" TO PM-LAST-ACTION-USER
           END-IF
           GOBACK.

       1000-INITIALIZE.
           MOVE 0 TO PM-RETURN-CODE
                     PM-SERVICE-FEE
                     PM-PREMIUM-DELTA
                     PM-OUTSTANDING-PREMIUM
           MOVE SPACES TO PM-RETURN-MESSAGE
                           PM-AMENDMENT-STATUS
           ACCEPT WS-CURR-DATE FROM DATE YYYYMMDD
           IF PM-PROCESS-DATE = ZERO
              MOVE WS-CURR-DATE TO PM-PROCESS-DATE
           END-IF
           MOVE PM-TOTAL-ANNUAL-PREMIUM TO WS-OLD-ANNUAL-PREMIUM
           MOVE "N" TO PM-UW-REQUIRED-IND.

       1100-LOAD-PLAN-PARAMETERS.
      * SV-101: Servicing uses the same plan parameters as issue.
           EVALUATE PM-PLAN-CODE
              WHEN "T1001"
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 060 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0001000000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 010 TO PM-TERM-YEARS
                 MOVE 070 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000045.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
              WHEN "T2001"
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 055 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0002000000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 020 TO PM-TERM-YEARS
                 MOVE 075 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000055.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
              WHEN "T6501"
                 MOVE 018 TO PM-MIN-ISSUE-AGE
                 MOVE 050 TO PM-MAX-ISSUE-AGE
                 MOVE 0000100000000.00 TO PM-MIN-SUM-ASSURED
                 MOVE 0001500000000.00 TO PM-MAX-SUM-ASSURED
                 MOVE 065 TO PM-MATURITY-AGE
                 MOVE 031 TO PM-GRACE-DAYS
                 MOVE 730 TO PM-REINSTATE-DAYS
                 MOVE 0000060.00 TO PM-POLICY-FEE-ANNUAL
                 MOVE 0000015.00 TO PM-SERVICE-FEE-STD
                 MOVE 0.0200 TO PM-TAX-RATE
              WHEN OTHER
                 MOVE 11 TO PM-RETURN-CODE
                 MOVE "UNSUPPORTED EXISTING PLAN CODE"
                   TO PM-RETURN-MESSAGE
           END-EVALUATE.

       1200-CALCULATE-ATTAINED-AGE.
           IF PM-ISSUE-DATE NOT = ZERO
              COMPUTE WS-DATE-INT =
                      FUNCTION INTEGER-OF-DATE(PM-PROCESS-DATE)
                    - FUNCTION INTEGER-OF-DATE(PM-ISSUE-DATE)
              COMPUTE WS-ATTAINED-AGE = PM-INSURED-AGE-ISSUE
                                      + (WS-DATE-INT / 365)
              MOVE WS-ATTAINED-AGE TO PM-ATTAINED-AGE
           ELSE
              MOVE PM-INSURED-AGE-ISSUE TO PM-ATTAINED-AGE
           END-IF.

       1300-EVALUATE-PAYMENT-STATUS.
      * SV-201: Status moves to grace then lapse based on paid-to-date.
           IF PM-PAID-TO-DATE NOT = ZERO
              COMPUTE WS-DAYS-SINCE-PAID =
                      FUNCTION INTEGER-OF-DATE(PM-PROCESS-DATE)
                    - FUNCTION INTEGER-OF-DATE(PM-PAID-TO-DATE)
              IF WS-DAYS-SINCE-PAID > 0 AND
                 WS-DAYS-SINCE-PAID <= PM-GRACE-DAYS AND
                 PM-STAT-ACTIVE
                 MOVE "GR" TO PM-CONTRACT-STATUS
              END-IF
              IF WS-DAYS-SINCE-PAID > PM-GRACE-DAYS AND
                 NOT PM-STAT-LAPSED AND
                 NOT PM-STAT-TERMINATED AND
                 NOT PM-STAT-CLAIMED
                 MOVE "LA" TO PM-CONTRACT-STATUS
              END-IF
           END-IF

      * SV-202: Outstanding premium is one modal installment if overdue.
           IF WS-DAYS-SINCE-PAID > 0
              MOVE PM-MODAL-PREMIUM TO PM-OUTSTANDING-PREMIUM
           END-IF.

       1400-VALIDATE-SERVICING-REQUEST.
      * SV-301: Claimed or terminated policies cannot be amended.
           IF PM-STAT-CLAIMED OR PM-STAT-TERMINATED
              MOVE 12 TO PM-RETURN-CODE
              MOVE "POLICY STATUS DOES NOT ALLOW SERVICING"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * SV-302: General servicing requires an amendment type.
           IF PM-AMENDMENT-TYPE = SPACES
              MOVE 13 TO PM-RETURN-CODE
              MOVE "AMENDMENT TYPE IS REQUIRED" TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF.

       2100-CHANGE-PLAN.
      * SV-401: Change plan only on active or grace policies.
           IF NOT PM-STAT-ACTIVE AND NOT PM-STAT-GRACE
              MOVE 21 TO PM-RETURN-CODE
              MOVE "PLAN CHANGE ALLOWED ONLY ON ACTIVE OR GRACE"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

           MOVE PM-PLAN-CODE TO PM-OLD-PLAN-CODE
           MOVE PM-NEW-PLAN-CODE TO PM-PLAN-CODE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           IF PM-RETURN-CODE NOT = 0
              MOVE PM-OLD-PLAN-CODE TO PM-PLAN-CODE
              EXIT PARAGRAPH
           END-IF

      * SV-402: New plan must still satisfy age and maturity limits.
           IF PM-ATTAINED-AGE > PM-MAX-ISSUE-AGE AND NOT PM-PLAN-TO-65
              MOVE 22 TO PM-RETURN-CODE
              MOVE "CURRENT ATTAINED AGE EXCEEDS NEW PLAN LIMIT"
                TO PM-RETURN-MESSAGE
              MOVE PM-OLD-PLAN-CODE TO PM-PLAN-CODE
              EXIT PARAGRAPH
           END-IF
           IF PM-PLAN-TO-65
              COMPUTE PM-TERM-YEARS = PM-MATURITY-AGE - PM-ATTAINED-AGE
              IF PM-TERM-YEARS <= 0
                 MOVE 23 TO PM-RETURN-CODE
                 MOVE "NO TERM REMAINS UNDER T65 PLAN"
                   TO PM-RETURN-MESSAGE
                 MOVE PM-OLD-PLAN-CODE TO PM-PLAN-CODE
                 EXIT PARAGRAPH
              END-IF
           END-IF

           PERFORM 3100-REPRICE-POLICY
           IF PM-RETURN-CODE = 0
              MOVE PM-SERVICE-FEE-STD TO PM-SERVICE-FEE
              MOVE "AP" TO PM-AMENDMENT-STATUS
              MOVE "PLAN CHANGE APPLIED" TO PM-RETURN-MESSAGE
           END-IF.

       2200-CHANGE-SUM-ASSURED.
           MOVE PM-SUM-ASSURED TO PM-OLD-SUM-ASSURED

      * SV-501: New sum assured must be present and within plan limits.
           IF PM-NEW-SUM-ASSURED = ZERO
              MOVE 24 TO PM-RETURN-CODE
              MOVE "NEW SUM ASSURED IS REQUIRED" TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF PM-NEW-SUM-ASSURED < PM-MIN-SUM-ASSURED OR
              PM-NEW-SUM-ASSURED > PM-MAX-SUM-ASSURED
              MOVE 25 TO PM-RETURN-CODE
              MOVE "NEW SUM ASSURED OUTSIDE PLAN LIMITS"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * SV-502: Large increases require underwriting review.
           IF PM-NEW-SUM-ASSURED > PM-OLD-SUM-ASSURED
              COMPUTE WS-SA-INCREASE-PCT ROUNDED =
                      ((PM-NEW-SUM-ASSURED - PM-OLD-SUM-ASSURED)
                       / PM-OLD-SUM-ASSURED) * 100
              IF WS-SA-INCREASE-PCT > 25.00 OR
                 PM-NEW-SUM-ASSURED > 0001000000000.00
                 MOVE "Y" TO PM-UW-REQUIRED-IND
                 MOVE "PE" TO PM-AMENDMENT-STATUS
                 MOVE "SUM ASSURED INCREASE REQUIRES UW APPROVAL"
                   TO PM-RETURN-MESSAGE
                 EXIT PARAGRAPH
              END-IF
           END-IF

           MOVE PM-NEW-SUM-ASSURED TO PM-SUM-ASSURED
           PERFORM 3100-REPRICE-POLICY
           IF PM-RETURN-CODE = 0
              MOVE 0000015.00 TO PM-SERVICE-FEE
              MOVE "AP" TO PM-AMENDMENT-STATUS
              MOVE "SUM ASSURED CHANGE APPLIED" TO PM-RETURN-MESSAGE
           END-IF.

       2300-CHANGE-BILLING-MODE.
      * SV-601: Mode changes do not require UW, but must be valid.
           IF PM-NEW-BILLING-MODE = SPACES
              MOVE 26 TO PM-RETURN-CODE
              MOVE "NEW BILLING MODE IS REQUIRED" TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF PM-NEW-BILLING-MODE NOT = "A" AND
              PM-NEW-BILLING-MODE NOT = "S" AND
              PM-NEW-BILLING-MODE NOT = "Q" AND
              PM-NEW-BILLING-MODE NOT = "M"
              MOVE 27 TO PM-RETURN-CODE
              MOVE "INVALID NEW BILLING MODE" TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

           MOVE PM-BILLING-MODE TO PM-OLD-BILLING-MODE
           MOVE PM-NEW-BILLING-MODE TO PM-BILLING-MODE
           PERFORM 3200-RECALCULATE-MODAL-PREMIUM
           MOVE 0000010.00 TO PM-SERVICE-FEE
           MOVE "AP" TO PM-AMENDMENT-STATUS
           MOVE "BILLING MODE CHANGE APPLIED" TO PM-RETURN-MESSAGE.

       2400-ADD-RIDER.
      * SV-701: Add rider only if capacity remains and rider is eligible.
           IF PM-RIDER-COUNT >= 5
              MOVE 28 TO PM-RETURN-CODE
              MOVE "NO ADDITIONAL RIDER CAPACITY REMAINS"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

           ADD 1 TO PM-RIDER-COUNT
           MOVE "ADB01" TO PM-RIDER-CODE(PM-RIDER-COUNT)
           MOVE PM-SUM-ASSURED TO PM-RIDER-SUM-ASSURED(PM-RIDER-COUNT)
           MOVE "A" TO PM-RIDER-STATUS(PM-RIDER-COUNT)

      * SV-702: ADB rider cannot be added above age 60.
           IF PM-ATTAINED-AGE > 60
              MOVE 29 TO PM-RETURN-CODE
              MOVE "ADB RIDER CANNOT BE ADDED ABOVE AGE 60"
                TO PM-RETURN-MESSAGE
              SUBTRACT 1 FROM PM-RIDER-COUNT
              EXIT PARAGRAPH
           END-IF

           PERFORM 3100-REPRICE-POLICY
           IF PM-RETURN-CODE = 0
              MOVE 0000012.00 TO PM-SERVICE-FEE
              MOVE "AP" TO PM-AMENDMENT-STATUS
              MOVE "RIDER ADDED AND POLICY REPRICED"
                TO PM-RETURN-MESSAGE
           END-IF.

       2500-REMOVE-RIDER.
      * SV-801: Remove the first active rider matching rider code.
           PERFORM VARYING WS-RIDER-IDX FROM 1 BY 1
                   UNTIL WS-RIDER-IDX > PM-RIDER-COUNT OR
                         PM-RIDER-CODE(WS-RIDER-IDX) = "ADB01"
           END-PERFORM

           IF WS-RIDER-IDX > PM-RIDER-COUNT
              MOVE 30 TO PM-RETURN-CODE
              MOVE "REQUESTED RIDER NOT FOUND FOR REMOVAL"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF

           MOVE "R" TO PM-RIDER-STATUS(WS-RIDER-IDX)
           MOVE ZERO TO PM-RIDER-SUM-ASSURED(WS-RIDER-IDX)
                        PM-RIDER-RATE(WS-RIDER-IDX)
                        PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
           PERFORM 3100-REPRICE-POLICY
           IF PM-RETURN-CODE = 0
              MOVE 0000010.00 TO PM-SERVICE-FEE
              MOVE "AP" TO PM-AMENDMENT-STATUS
              MOVE "RIDER REMOVED AND POLICY REPRICED"
                TO PM-RETURN-MESSAGE
           END-IF.

       2600-PROCESS-REINSTATEMENT.
      * SV-901: Reinstatement only for lapsed policies within window.
           IF NOT PM-STAT-LAPSED
              MOVE 31 TO PM-RETURN-CODE
              MOVE "ONLY LAPSED POLICIES CAN BE REINSTATED"
                TO PM-RETURN-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF WS-DAYS-SINCE-PAID > PM-REINSTATE-DAYS
              MOVE 32 TO PM-RETURN-CODE
              MOVE "POLICY EXCEEDS REINSTATEMENT WINDOW"
                TO PM-RETURN-MESSAGE
              MOVE "TE" TO PM-CONTRACT-STATUS
              EXIT PARAGRAPH
           END-IF

      * SV-902: Reinstatement requires outstanding premium plus fee.
           COMPUTE PM-SERVICE-FEE = PM-SERVICE-FEE-STD + 25.00
           MOVE PM-MODAL-PREMIUM TO PM-OUTSTANDING-PREMIUM
           MOVE "RS" TO PM-CONTRACT-STATUS
           MOVE PM-PROCESS-DATE TO PM-PAID-TO-DATE
           MOVE "AP" TO PM-AMENDMENT-STATUS
           MOVE "POLICY REINSTATED SUBJECT TO COLLECTION"
             TO PM-RETURN-MESSAGE.

       3100-REPRICE-POLICY.
      * SV-1001: Servicing repricing reuses the issue rating approach.
           PERFORM 3110-LOAD-RATING-FACTORS
           PERFORM 3120-CALCULATE-BASE-ANNUAL
           PERFORM 3130-CALCULATE-RIDER-ANNUAL
           PERFORM 3140-CALCULATE-TOTAL-ANNUAL
           PERFORM 3200-RECALCULATE-MODAL-PREMIUM
           COMPUTE PM-PREMIUM-DELTA ROUNDED =
                   PM-TOTAL-ANNUAL-PREMIUM - WS-OLD-ANNUAL-PREMIUM.

       3110-LOAD-RATING-FACTORS.
           EVALUATE TRUE
              WHEN PM-ATTAINED-AGE <= 30
                 MOVE 00000.8500 TO PM-BASE-RATE-PER-THOU
              WHEN PM-ATTAINED-AGE <= 40
                 MOVE 00001.2000 TO PM-BASE-RATE-PER-THOU
              WHEN PM-ATTAINED-AGE <= 50
                 MOVE 00002.1500 TO PM-BASE-RATE-PER-THOU
              WHEN PM-ATTAINED-AGE <= 60
                 MOVE 00004.1000 TO PM-BASE-RATE-PER-THOU
              WHEN OTHER
                 MOVE 00007.2500 TO PM-BASE-RATE-PER-THOU
           END-EVALUATE

           IF PM-FEMALE
              MOVE 0.9200 TO PM-GENDER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-GENDER-FACTOR
           END-IF

           IF PM-SMOKER
              MOVE 1.7500 TO PM-SMOKER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-SMOKER-FACTOR
           END-IF

           EVALUATE PM-OCCUPATION-CLASS
              WHEN 1 MOVE 1.0000 TO PM-OCC-FACTOR
              WHEN 2 MOVE 1.1500 TO PM-OCC-FACTOR
              WHEN 3 MOVE 1.4000 TO PM-OCC-FACTOR
              WHEN OTHER MOVE 1.0000 TO PM-OCC-FACTOR
           END-EVALUATE

           EVALUATE PM-UW-CLASS
              WHEN "PR" MOVE 0.9000 TO PM-UW-FACTOR
              WHEN "TB" MOVE 1.2500 TO PM-UW-FACTOR
              WHEN OTHER MOVE 1.0000 TO PM-UW-FACTOR
           END-EVALUATE.

       3120-CALCULATE-BASE-ANNUAL.
           COMPUTE PM-BASE-ANNUAL-PREMIUM ROUNDED =
                (PM-SUM-ASSURED / 1000)
              * PM-BASE-RATE-PER-THOU
              * PM-GENDER-FACTOR
              * PM-SMOKER-FACTOR
              * PM-OCC-FACTOR
              * PM-UW-FACTOR
           IF PM-FLAT-EXTRA-RATE > 0
              ADD ((PM-SUM-ASSURED / 1000) * PM-FLAT-EXTRA-RATE)
                TO PM-BASE-ANNUAL-PREMIUM
           END-IF.

       3130-CALCULATE-RIDER-ANNUAL.
           MOVE ZERO TO PM-RIDER-ANNUAL-TOTAL
           PERFORM VARYING WS-RIDER-IDX FROM 1 BY 1
                   UNTIL WS-RIDER-IDX > PM-RIDER-COUNT
              IF PM-RIDER-STATUS(WS-RIDER-IDX) = "A"
                 EVALUATE PM-RIDER-CODE(WS-RIDER-IDX)
                    WHEN "ADB01"
                       MOVE 00000.1800 TO PM-RIDER-RATE(WS-RIDER-IDX)
                       COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                               ROUNDED =
                             (PM-RIDER-SUM-ASSURED(WS-RIDER-IDX) / 1000)
                           * PM-RIDER-RATE(WS-RIDER-IDX)
                    WHEN "WOP01"
                       MOVE 00000.0600 TO PM-RIDER-RATE(WS-RIDER-IDX)
                       COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                               ROUNDED =
                             PM-BASE-ANNUAL-PREMIUM * 0.0600
                    WHEN "CI001"
                       MOVE 00001.2500 TO PM-RIDER-RATE(WS-RIDER-IDX)
                       COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                               ROUNDED =
                             (PM-RIDER-SUM-ASSURED(WS-RIDER-IDX) / 1000)
                           * PM-RIDER-RATE(WS-RIDER-IDX)
                    WHEN OTHER
                       MOVE ZERO TO PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                 END-EVALUATE
                 ADD PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                   TO PM-RIDER-ANNUAL-TOTAL
              END-IF
           END-PERFORM.

       3140-CALCULATE-TOTAL-ANNUAL.
           COMPUTE WS-TEMP-NEW-ANNUAL ROUNDED =
                   PM-BASE-ANNUAL-PREMIUM
                 + PM-RIDER-ANNUAL-TOTAL
                 + PM-POLICY-FEE-ANNUAL
           MOVE WS-TEMP-NEW-ANNUAL TO PM-GROSS-ANNUAL-PREMIUM
           COMPUTE PM-TAX-AMOUNT ROUNDED =
                   PM-GROSS-ANNUAL-PREMIUM * PM-TAX-RATE
           COMPUTE PM-TOTAL-ANNUAL-PREMIUM ROUNDED =
                   PM-GROSS-ANNUAL-PREMIUM + PM-TAX-AMOUNT.

       3200-RECALCULATE-MODAL-PREMIUM.
           EVALUATE PM-BILLING-MODE
              WHEN "A"
                 MOVE 1 TO WS-MODAL-DIVISOR
                 MOVE 1.0000 TO WS-MODAL-FACTOR
              WHEN "S"
                 MOVE 2 TO WS-MODAL-DIVISOR
                 MOVE 1.0150 TO WS-MODAL-FACTOR
              WHEN "Q"
                 MOVE 4 TO WS-MODAL-DIVISOR
                 MOVE 1.0300 TO WS-MODAL-FACTOR
              WHEN "M"
                 MOVE 12 TO WS-MODAL-DIVISOR
                 MOVE 1.0800 TO WS-MODAL-FACTOR
              WHEN OTHER
                 MOVE 33 TO PM-RETURN-CODE
                 MOVE "UNABLE TO RECALCULATE MODAL PREMIUM"
                   TO PM-RETURN-MESSAGE
           END-EVALUATE
           IF PM-RETURN-CODE = 0
              COMPUTE PM-MODAL-PREMIUM ROUNDED =
                      (PM-TOTAL-ANNUAL-PREMIUM / WS-MODAL-DIVISOR)
                    * WS-MODAL-FACTOR
           END-IF.

       END PROGRAM SVCBILL001.
