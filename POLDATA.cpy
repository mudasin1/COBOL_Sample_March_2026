      ****************************************************************
      * COPYBOOK: POLDATA.CPY
      * SAMPLE TERM LIFE INSURANCE DATA STRUCTURE
      * PURPOSE:
      *   Provide one shared record layout for three domains:
      *   1. New Business and Policy Issuance
      *   2. Policy Servicing and Amendments
      *   3. Term Policy Claims Processing
      *
      * NOTE:
      *   This layout is intentionally rich in business attributes so
      *   Swimm can analyze plan rules, calculations, rates, eligibility,
      *   servicing decisions, and claims adjudication logic.
      ****************************************************************
       01  WS-POLICY-MASTER-REC.
           05  PM-CONTROL-AREA.
               10  PM-POLICY-ID                 PIC X(12).
               10  PM-APPLICATION-ID            PIC X(12).
               10  PM-PROCESS-DATE              PIC 9(08).
               10  PM-PLAN-CODE                 PIC X(05).
                   88  PM-PLAN-TERM-10          VALUE "T1001".
                   88  PM-PLAN-TERM-20          VALUE "T2001".
                   88  PM-PLAN-TO-65            VALUE "T6501".
               10  PM-CONTRACT-STATUS          PIC X(02).
                   88  PM-STAT-PENDING          VALUE "PE".
                   88  PM-STAT-ACTIVE           VALUE "AC".
                   88  PM-STAT-GRACE            VALUE "GR".
                   88  PM-STAT-LAPSED           VALUE "LA".
                   88  PM-STAT-REINSTATED       VALUE "RS".
                   88  PM-STAT-CLAIMED          VALUE "CL".
                   88  PM-STAT-TERMINATED       VALUE "TE".
                   88  PM-STAT-DECLINED         VALUE "RJ".
               10  PM-ISSUE-CHANNEL             PIC X(02).
                   88  PM-CHANNEL-BRANCH        VALUE "BR".
                   88  PM-CHANNEL-AGENT         VALUE "AG".
                   88  PM-CHANNEL-ONLINE        VALUE "ON".
               10  PM-CURRENCY-CODE            PIC X(03).
               10  PM-RETURN-CODE              PIC 9(04).
               10  PM-RETURN-MESSAGE           PIC X(100).

           05  PM-PLAN-PARAMETERS.
               10  PM-MIN-ISSUE-AGE            PIC 9(03).
               10  PM-MAX-ISSUE-AGE            PIC 9(03).
               10  PM-MIN-SUM-ASSURED          PIC 9(11)V99.
               10  PM-MAX-SUM-ASSURED          PIC 9(11)V99.
               10  PM-TERM-YEARS               PIC 9(03).
               10  PM-MATURITY-AGE             PIC 9(03).
               10  PM-GRACE-DAYS               PIC 9(03).
               10  PM-CONTESTABLE-YEARS        PIC 9(02).
               10  PM-SUICIDE-EXCL-YEARS       PIC 9(02).
               10  PM-REINSTATE-DAYS           PIC 9(04).
               10  PM-POLICY-FEE-ANNUAL        PIC 9(07)V99.
               10  PM-SERVICE-FEE-STD          PIC 9(07)V99.
               10  PM-TAX-RATE                 PIC 9V9999.

           05  PM-INSURED-DETAILS.
               10  PM-INSURED-NAME             PIC X(50).
               10  PM-INSURED-DOB              PIC 9(08).
               10  PM-INSURED-AGE-ISSUE        PIC 9(03).
               10  PM-ATTAINED-AGE             PIC 9(03).
               10  PM-INSURED-GENDER           PIC X(01).
                   88  PM-MALE                  VALUE "M".
                   88  PM-FEMALE                VALUE "F".
               10  PM-SMOKER-IND               PIC X(01).
                   88  PM-SMOKER                VALUE "S".
                   88  PM-NON-SMOKER            VALUE "N".
               10  PM-OCCUPATION-CLASS         PIC 9(01).
                   88  PM-OCC-PROF              VALUE 1.
                   88  PM-OCC-STANDARD          VALUE 2.
                   88  PM-OCC-HAZARD            VALUE 3.
                   88  PM-OCC-SEVERE            VALUE 4.
               10  PM-UW-CLASS                 PIC X(02).
                   88  PM-UW-PREFERRED          VALUE "PR".
                   88  PM-UW-STANDARD           VALUE "ST".
                   88  PM-UW-TABLE-B           VALUE "TB".
                   88  PM-UW-DECLINE            VALUE "DP".
               10  PM-HIGH-RISK-AVOC-IND       PIC X(01).
                   88  PM-HIGH-RISK-AVOC        VALUE "Y".
                   88  PM-NO-HIGH-RISK-AVOC     VALUE "N".
               10  PM-FLAT-EXTRA-RATE          PIC 9(05)V99.

           05  PM-BENEFIT-DETAILS.
               10  PM-SUM-ASSURED              PIC 9(11)V99.
               10  PM-POLICY-LOAN-BALANCE      PIC 9(09)V99.
               10  PM-BILLING-MODE             PIC X(01).
                   88  PM-MODE-ANNUAL           VALUE "A".
                   88  PM-MODE-SEMI             VALUE "S".
                   88  PM-MODE-QUARTERLY        VALUE "Q".
                   88  PM-MODE-MONTHLY          VALUE "M".
               10  PM-BASE-RATE-PER-THOU       PIC 9(05)V9999.
               10  PM-GENDER-FACTOR            PIC 9V9999.
               10  PM-SMOKER-FACTOR            PIC 9V9999.
               10  PM-OCC-FACTOR               PIC 9V9999.
               10  PM-UW-FACTOR                PIC 9V9999.
               10  PM-RIDER-COUNT              PIC 9(02).
               10  PM-RIDER-TABLE OCCURS 5 TIMES.
                   15  PM-RIDER-CODE           PIC X(05).
                   15  PM-RIDER-SUM-ASSURED    PIC 9(09)V99.
                   15  PM-RIDER-RATE           PIC 9(05)V9999.
                   15  PM-RIDER-ANNUAL-PREM    PIC 9(07)V99.
                   15  PM-RIDER-STATUS         PIC X(01).
                       88  PM-RIDER-ACTIVE     VALUE "A".
                       88  PM-RIDER-REMOVED    VALUE "R".

           05  PM-PREMIUM-RESULTS.
               10  PM-BASE-ANNUAL-PREMIUM      PIC 9(09)V99.
               10  PM-RIDER-ANNUAL-TOTAL       PIC 9(09)V99.
               10  PM-GROSS-ANNUAL-PREMIUM     PIC 9(09)V99.
               10  PM-TAX-AMOUNT               PIC 9(09)V99.
               10  PM-TOTAL-ANNUAL-PREMIUM     PIC 9(09)V99.
               10  PM-MODAL-PREMIUM            PIC 9(09)V99.
               10  PM-OUTSTANDING-PREMIUM      PIC 9(09)V99.
               10  PM-PREMIUM-DELTA            PIC S9(07)V99.

           05  PM-DATE-DETAILS.
               10  PM-ISSUE-DATE               PIC 9(08).
               10  PM-EFFECTIVE-DATE           PIC 9(08).
               10  PM-PAID-TO-DATE             PIC 9(08).
               10  PM-EXPIRY-DATE              PIC 9(08).
               10  PM-LAST-MAINT-DATE          PIC 9(08).
               10  PM-DATE-OF-DEATH            PIC 9(08).

           05  PM-SERVICING-DETAILS.
               10  PM-AMENDMENT-TYPE           PIC X(02).
                   88  PM-AMEND-CHANGE-PLAN     VALUE "PL".
                   88  PM-AMEND-CHANGE-SA       VALUE "SA".
                   88  PM-AMEND-BILLING-MODE    VALUE "BM".
                   88  PM-AMEND-ADD-RIDER       VALUE "AR".
                   88  PM-AMEND-REMOVE-RIDER    VALUE "RR".
                   88  PM-AMEND-REINSTATE       VALUE "RI".
               10  PM-AMENDMENT-REASON         PIC X(40).
               10  PM-OLD-PLAN-CODE            PIC X(05).
               10  PM-NEW-PLAN-CODE            PIC X(05).
               10  PM-OLD-SUM-ASSURED          PIC 9(11)V99.
               10  PM-NEW-SUM-ASSURED          PIC 9(11)V99.
               10  PM-OLD-BILLING-MODE         PIC X(01).
               10  PM-NEW-BILLING-MODE         PIC X(01).
               10  PM-SERVICE-FEE              PIC 9(07)V99.
               10  PM-UW-REQUIRED-IND          PIC X(01).
                   88  PM-UW-REQUIRED           VALUE "Y".
                   88  PM-UW-NOT-REQUIRED       VALUE "N".
               10  PM-AMENDMENT-STATUS         PIC X(02).
                   88  PM-AMEND-PENDING         VALUE "PE".
                   88  PM-AMEND-APPROVED        VALUE "AP".
                   88  PM-AMEND-REJECTED        VALUE "RJ".

           05  PM-CLAIM-DETAILS.
               10  PM-CLAIM-ID                 PIC X(12).
               10  PM-CLAIM-TYPE               PIC X(02).
                   88  PM-CLAIM-DEATH          VALUE "CD".
               10  PM-CAUSE-OF-DEATH           PIC X(03).
               10  PM-CLAIM-DOC-DEATH-CERT     PIC X(01).
                   88  PM-DOC-DEATH-CERT-YES    VALUE "Y".
               10  PM-CLAIM-DOC-CLAIM-FORM     PIC X(01).
                   88  PM-DOC-CLAIM-FORM-YES    VALUE "Y".
               10  PM-CLAIM-DOC-ID-PROOF       PIC X(01).
                   88  PM-DOC-ID-PROOF-YES      VALUE "Y".
               10  PM-CLAIM-DOC-MEDICAL        PIC X(01).
                   88  PM-DOC-MEDICAL-YES       VALUE "Y".
               10  PM-CLAIM-SUBMIT-DATE        PIC 9(08).
               10  PM-CLAIM-INVEST-DATE        PIC 9(08).
               10  PM-CLAIM-ADJUDICATE-DATE    PIC 9(08).
               10  PM-CLAIM-SETTLE-DATE        PIC 9(08).
               10  PM-BENEFICIARY-NAME         PIC X(50).
               10  PM-BENEFICIARY-RELATION     PIC X(10).
               10  PM-CLAIM-PAYMENT-MODE       PIC X(01).
                   88  PM-CLAIM-MODE-CHECK     VALUE "C".
                   88  PM-CLAIM-MODE-ACH       VALUE "A".
               10  PM-CLAIM-INVEST-STATUS      PIC X(01).
                   88  PM-INV-NOT-REQ          VALUE "N".
                   88  PM-INV-PENDING          VALUE "P".
                   88  PM-INV-COMPLETE         VALUE "C".
               10  PM-CLAIM-DECISION           PIC X(01).
                   88  PM-CLAIM-APPROVED       VALUE "A".
                   88  PM-CLAIM-REJECTED       VALUE "R".
                   88  PM-CLAIM-MANUAL         VALUE "P".
               10  PM-CLAIM-PAYMENT-AMOUNT     PIC 9(11)V99.
               10  PM-CLAIM-HOLD-REASON        PIC X(60).

           05  PM-AUDIT-DETAILS.
               10  PM-LAST-ACTION-USER         PIC X(12).
               10  PM-LAST-ACTION-DATE         PIC 9(08).
