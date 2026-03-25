# COBOL Sample for Business Rule Extraction

This sample is designed for Swimm analysis with rich domain logic.

## Domains covered

1. Term Life Policy - New Business and Policy Issuance
2. Policy Servicing - Policy Changes and Amendments
3. Term Policy Claims - End-to-End Claims Processing

## Files

- `POLDATA.cpy`
  - Shared policy, premium, servicing, and claims data structure
- `NB-UW-001.cob`
  - Eligibility validation
  - Plan parameter loading
  - Underwriting class assignment
  - Premium and rider calculations
  - Reinsurance and manual referral rules
- `SVC-BILL-001.cob`
  - Grace and lapse status logic
  - Plan changes
  - Sum assured changes
  - Billing mode changes
  - Rider adds and removals
  - Reinstatement processing
  - Repricing and premium delta logic
- `CLM-ADJ-001.cob`
  - Claim intake validation
  - Investigation triggers
  - Coverage adjudication
  - Suicide exclusion
  - Contestability
  - Accidental death rider payout
  - Loan and unpaid premium offsets

## Business rule coverage added

### New Business
- Issue age min and max by plan
- Sum assured min and max by plan
- Maturity age checks
- T65 hazardous occupation restriction
- Preferred, standard, table, and decline UW logic
- Gender, smoker, occupation, and UW class rating factors
- Modal premium calculation with mode factors
- Rider eligibility and pricing
- Reinsurance and manual UW referral triggers

### Servicing
- Payment status evaluation: active, grace, lapse
- Outstanding premium tracking
- Plan change validation and repricing
- Sum assured increase thresholds that trigger underwriting
- Billing mode changes with modal repricing
- Rider add/remove flows
- Reinstatement window and fee logic
- Premium delta calculation

### Claims
- Required claim intake fields and documents
- Contestability investigation trigger
- Suspicious cause of death investigation triggers
- Suicide exclusion window
- Expiry check
- Accidental death rider settlement
- Grace premium deduction
- Policy loan deduction
- Claim decision and settlement update flow

## Note

This sample is optimized for business-rule richness for analysis.
