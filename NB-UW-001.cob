       IDENTIFICATION DIVISION.
       PROGRAM-ID. NBUW001.
       AUTHOR.      OPENAI.
       DATE-WRITTEN. 2026-03-24.
       REMARKS.
      *===============================================================*
      * DOMAIN: TERM LIFE POLICY - NEW BUSINESS AND POLICY ISSUANCE   *
      * PURPOSE:                                                       *
      *   Validate eligibility, load plan parameters, determine rating,*
      *   calculate premium, validate riders, and decide whether the   *
      *   case is issued, referred, or declined.                       *
      *===============================================================*

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-CURR-DATE                 PIC 9(08).
       77  WS-RESULT-CODE               PIC 9(02) VALUE 0.
       77  WS-RESULT-MESSAGE            PIC X(100) VALUE SPACES.
       77  WS-RIDER-IDX                 PIC 9(02) VALUE 0.
       77  WS-DATE-INT                  PIC 9(09) VALUE 0.
       77  WS-MODAL-DIVISOR             PIC 9(02) VALUE 1.
       77  WS-MODAL-FACTOR              PIC 9V9999 VALUE 1.0000.
       77  WS-REINSURANCE-REFERRAL      PIC X VALUE 'N'.
           88  WS-REFERRED              VALUE 'Y'.
       77  WS-UW-REFERRAL               PIC X VALUE 'N'.
           88  WS-MANUAL-UW             VALUE 'Y'.

       LINKAGE SECTION.
       COPY POLDATA.
       01  LK-UW-RESULT-CODE            PIC 9(02).
       01  LK-UW-ERROR-MSG              PIC X(100).

       PROCEDURE DIVISION USING WS-POLICY-MASTER-REC
                                LK-UW-RESULT-CODE
                                LK-UW-ERROR-MSG.

       MAIN-PROCESS.
           PERFORM 1000-INITIALIZE
           PERFORM 1100-LOAD-PLAN-PARAMETERS
           PERFORM 1200-VALIDATE-APPLICATION
           IF WS-RESULT-CODE NOT = 0
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF

           PERFORM 1300-DETERMINE-UW-CLASS
           IF PM-UW-DECLINE
              MOVE 21 TO WS-RESULT-CODE
              MOVE "APPLICATION DECLINED BY UNDERWRITING RULES"
                TO WS-RESULT-MESSAGE
              MOVE "RJ" TO PM-CONTRACT-STATUS
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF

           PERFORM 1400-LOAD-RATE-FACTORS
           PERFORM 1500-VALIDATE-RIDERS
           IF WS-RESULT-CODE NOT = 0
              PERFORM 9000-RETURN-ERROR
              GOBACK
           END-IF

           PERFORM 1600-CALCULATE-BASE-PREMIUM
           PERFORM 1700-CALCULATE-RIDER-PREMIUM
           PERFORM 1800-CALCULATE-TOTAL-PREMIUM
           PERFORM 1900-EVALUATE-REFERRALS

           IF WS-REFERRED OR WS-MANUAL-UW
              MOVE 2 TO WS-RESULT-CODE
              MOVE "REFERRED FOR MANUAL UW OR REINSURANCE REVIEW"
                TO WS-RESULT-MESSAGE
              MOVE "PE" TO PM-CONTRACT-STATUS
              PERFORM 9100-RETURN-SUCCESS
              GOBACK
           END-IF

           PERFORM 2000-ISSUE-POLICY
           MOVE 0 TO WS-RESULT-CODE
           MOVE "POLICY ISSUED SUCCESSFULLY" TO WS-RESULT-MESSAGE
           PERFORM 9100-RETURN-SUCCESS
           GOBACK.

       1000-INITIALIZE.
           MOVE ZERO TO PM-RETURN-CODE
                        PM-BASE-ANNUAL-PREMIUM
                        PM-RIDER-ANNUAL-TOTAL
                        PM-GROSS-ANNUAL-PREMIUM
                        PM-TAX-AMOUNT
                        PM-TOTAL-ANNUAL-PREMIUM
                        PM-MODAL-PREMIUM
                        PM-PREMIUM-DELTA
           MOVE SPACES TO PM-RETURN-MESSAGE
                          WS-RESULT-MESSAGE
           MOVE 0 TO WS-RESULT-CODE
           MOVE 'N' TO WS-REINSURANCE-REFERRAL
                        WS-UW-REFERRAL
           ACCEPT WS-CURR-DATE FROM DATE YYYYMMDD
           IF PM-PROCESS-DATE = ZERO
              MOVE WS-CURR-DATE TO PM-PROCESS-DATE
           END-IF
           MOVE PM-PROCESS-DATE TO PM-LAST-ACTION-DATE
           MOVE "NB-UW001" TO PM-LAST-ACTION-USER.

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
              WHEN OTHER
                 MOVE 11 TO WS-RESULT-CODE
                 MOVE "INVALID PLAN CODE" TO WS-RESULT-MESSAGE
           END-EVALUATE

           IF PM-PLAN-TO-65 AND WS-RESULT-CODE = 0
              COMPUTE PM-TERM-YEARS = PM-MATURITY-AGE
                                     - PM-INSURED-AGE-ISSUE
           END-IF.

       1200-VALIDATE-APPLICATION.
      * NB-201: Basic mandatory field checks.
           IF PM-POLICY-ID = SPACES
              MOVE 12 TO WS-RESULT-CODE
              MOVE "POLICY ID IS REQUIRED" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF PM-INSURED-NAME = SPACES
              MOVE 13 TO WS-RESULT-CODE
              MOVE "INSURED NAME IS REQUIRED" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF NOT PM-MALE AND NOT PM-FEMALE
              MOVE 14 TO WS-RESULT-CODE
              MOVE "INVALID GENDER CODE" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF NOT PM-SMOKER AND NOT PM-NON-SMOKER
              MOVE 15 TO WS-RESULT-CODE
              MOVE "INVALID SMOKER INDICATOR" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF
           IF NOT PM-MODE-ANNUAL AND NOT PM-MODE-SEMI
              AND NOT PM-MODE-QUARTERLY AND NOT PM-MODE-MONTHLY
              MOVE 16 TO WS-RESULT-CODE
              MOVE "INVALID BILLING MODE" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * NB-202: Issue age must fall within plan parameters.
           IF PM-INSURED-AGE-ISSUE < PM-MIN-ISSUE-AGE OR
              PM-INSURED-AGE-ISSUE > PM-MAX-ISSUE-AGE
              MOVE 17 TO WS-RESULT-CODE
              MOVE "ISSUE AGE OUTSIDE PLAN LIMITS" TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * NB-203: Face amount must fall within plan parameters.
           IF PM-SUM-ASSURED < PM-MIN-SUM-ASSURED OR
              PM-SUM-ASSURED > PM-MAX-SUM-ASSURED
              MOVE 18 TO WS-RESULT-CODE
              MOVE "SUM ASSURED OUTSIDE PLAN LIMITS"
                TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * NB-204: Maturity age rule for term products.
           IF PM-INSURED-AGE-ISSUE + PM-TERM-YEARS > PM-MATURITY-AGE
              MOVE 19 TO WS-RESULT-CODE
              MOVE "TERM EXCEEDS ALLOWED MATURITY AGE"
                TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * NB-205: T65 disallows hazardous occupations.
           IF PM-PLAN-TO-65 AND PM-OCC-HAZARD
              MOVE 20 TO WS-RESULT-CODE
              MOVE "T65 NOT AVAILABLE FOR HAZARDOUS OCCUPATION"
                TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

      * NB-206: Severe occupation class is declined.
           IF PM-OCC-SEVERE
              MOVE "DP" TO PM-UW-CLASS
           END-IF.

       1300-DETERMINE-UW-CLASS.
      * NB-301: Preferred, standard, table, or decline.
           IF PM-UW-DECLINE
              EXIT PARAGRAPH
           END-IF

           IF PM-NON-SMOKER AND PM-OCC-PROF AND
              PM-INSURED-AGE-ISSUE <= 45 AND
              PM-HIGH-RISK-AVOC-IND NOT = 'Y'
              MOVE "PR" TO PM-UW-CLASS
           ELSE
              MOVE "ST" TO PM-UW-CLASS
           END-IF

      * NB-302: Smoker, hazardous occupation, or avocation trigger table.
           IF PM-SMOKER OR PM-OCC-HAZARD OR PM-HIGH-RISK-AVOC
              MOVE "TB" TO PM-UW-CLASS
           END-IF

      * NB-303: Older smoker with high face amount is declined.
           IF PM-SMOKER AND PM-INSURED-AGE-ISSUE > 60 AND
              PM-SUM-ASSURED > 0001000000000.00
              MOVE "DP" TO PM-UW-CLASS
           END-IF.

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

      * NB-402: Female pricing factor.
           IF PM-FEMALE
              MOVE 0.9200 TO PM-GENDER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-GENDER-FACTOR
           END-IF

      * NB-403: Smoker factor.
           IF PM-SMOKER
              MOVE 1.7500 TO PM-SMOKER-FACTOR
           ELSE
              MOVE 1.0000 TO PM-SMOKER-FACTOR
           END-IF

      * NB-404: Occupation loading factor.
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

      * NB-405: Underwriting class factor.
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

       1500-VALIDATE-RIDERS.
      * NB-501: Limit rider count.
           IF PM-RIDER-COUNT > 5
              MOVE 22 TO WS-RESULT-CODE
              MOVE "RIDER COUNT EXCEEDS PRODUCT LIMIT"
                TO WS-RESULT-MESSAGE
              EXIT PARAGRAPH
           END-IF

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
                 WHEN "WOP01"
      * NB-503: Waiver of premium rider age band 18 to 55.
                    IF PM-INSURED-AGE-ISSUE < 18 OR
                       PM-INSURED-AGE-ISSUE > 55
                       MOVE 24 TO WS-RESULT-CODE
                       MOVE "WOP RIDER AGE OUTSIDE ALLOWED BAND"
                         TO WS-RESULT-MESSAGE
                    END-IF
                 WHEN "CI001"
      * NB-504: Critical illness rider cap 500,000.
                    IF PM-RIDER-SUM-ASSURED(WS-RIDER-IDX)
                       > 0000500000.00
                       MOVE 25 TO WS-RESULT-CODE
                       MOVE "CI RIDER EXCEEDS MAXIMUM RIDER SA"
                         TO WS-RESULT-MESSAGE
                    END-IF
                 WHEN SPACES
                    CONTINUE
                 WHEN OTHER
                    MOVE 26 TO WS-RESULT-CODE
                    MOVE "UNKNOWN RIDER CODE" TO WS-RESULT-MESSAGE
              END-EVALUATE
           END-PERFORM.

       1600-CALCULATE-BASE-PREMIUM.
      * NB-601: Base annual premium uses rate per thousand multiplied
      *         by gender, smoker, occupation, and UW factors.
           COMPUTE PM-BASE-ANNUAL-PREMIUM ROUNDED =
                (PM-SUM-ASSURED / 1000)
              * PM-BASE-RATE-PER-THOU
              * PM-GENDER-FACTOR
              * PM-SMOKER-FACTOR
              * PM-OCC-FACTOR
              * PM-UW-FACTOR

      * NB-602: Flat extra applies as an additive amount per thousand.
           IF PM-FLAT-EXTRA-RATE > 0
              ADD ((PM-SUM-ASSURED / 1000) * PM-FLAT-EXTRA-RATE)
                TO PM-BASE-ANNUAL-PREMIUM
           END-IF.

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
                 WHEN "WOP01"
      * NB-702: WOP premium set at 6 percent of base annual premium.
                    MOVE 00000.0600 TO PM-RIDER-RATE(WS-RIDER-IDX)
                    COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX) ROUNDED =
                           PM-BASE-ANNUAL-PREMIUM * 0.0600
                 WHEN "CI001"
      * NB-703: CI premium priced per thousand on rider SA.
                    MOVE 00001.2500 TO PM-RIDER-RATE(WS-RIDER-IDX)
                    COMPUTE PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX) ROUNDED =
                           (PM-RIDER-SUM-ASSURED(WS-RIDER-IDX) / 1000)
                         * PM-RIDER-RATE(WS-RIDER-IDX)
                 WHEN OTHER
                    MOVE ZERO TO PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
              END-EVALUATE
              MOVE "A" TO PM-RIDER-STATUS(WS-RIDER-IDX)
              ADD PM-RIDER-ANNUAL-PREM(WS-RIDER-IDX)
                TO PM-RIDER-ANNUAL-TOTAL
           END-PERFORM.

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

      * NB-803: Billing mode determines divisor and modal load factor.
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

           COMPUTE PM-MODAL-PREMIUM ROUNDED =
                   (PM-TOTAL-ANNUAL-PREMIUM / WS-MODAL-DIVISOR)
                 * WS-MODAL-FACTOR.

       1900-EVALUATE-REFERRALS.
      * NB-901: Large cases require facultative reinsurance review.
           IF PM-SUM-ASSURED > 0001500000000.00
              MOVE 'Y' TO WS-REINSURANCE-REFERRAL
           END-IF

      * NB-902: Table-rated or large avocation cases require manual UW.
           IF PM-UW-TABLE-B OR PM-HIGH-RISK-AVOC OR
              PM-FLAT-EXTRA-RATE > 00002.50
              MOVE 'Y' TO WS-UW-REFERRAL
           END-IF.

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

       9000-RETURN-ERROR.
           MOVE WS-RESULT-CODE TO PM-RETURN-CODE LK-UW-RESULT-CODE
           MOVE WS-RESULT-MESSAGE TO PM-RETURN-MESSAGE LK-UW-ERROR-MSG.

       9100-RETURN-SUCCESS.
           MOVE WS-RESULT-CODE TO PM-RETURN-CODE LK-UW-RESULT-CODE
           MOVE WS-RESULT-MESSAGE TO PM-RETURN-MESSAGE LK-UW-ERROR-MSG.

       END PROGRAM NBUW001.
