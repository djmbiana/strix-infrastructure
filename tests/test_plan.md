# Strix Test Plan

## Objective
Validate the correctness, reliability, and safety of the Strix Lambda function that scans GitHub webhook payloads for exposed secrets.

---

## Scope

### In Scope
- GitHub webhook payload parsing
- Commit scanning logic (regex-based detection)
- Scan report generation
- Conditional behavior (clean vs findings)
- AWS integrations:
  - S3 (scan report storage)
  - DynamoDB (scan persistence)
  - SNS (alert notifications)

### Out of Scope
- AWS infrastructure provisioning (Terraform)
- External GitHub webhook delivery reliability

---

## Components to Test

1. **Payload Handling**
   - Valid webhook payload
   - Empty or missing commits
   - Malformed payloads

2. **Secret Detection Logic**
   - AWS Access Keys
   - GitHub Personal Access Tokens
   - SSH Private Keys

3. **Scan Report Generation**
   - Correct structure
   - Accurate commit counts
   - Proper clean/flagged classification

4. **System Behavior**
   - Clean commits → no alert
   - Findings → SNS alert triggered

5. **Failure Handling**
   - Missing environment variables
   - Unexpected payload structure

---

## Risks

- **False Negatives** (HIGH)
  - Secrets not detected → security breach

- **False Positives** (MEDIUM)
  - Incorrect alerts → alert fatigue

- **Malformed Payload Handling** (MEDIUM)
  - Lambda crash or incorrect processing

- **AWS Dependency Failures** (LOW)
  - S3/DynamoDB/SNS unavailable

---

## Test Approach

- Use simulated GitHub webhook payloads
- Validate system behavior via:
  - Console logs
  - Output response
  - Side effects (S3, DynamoDB, SNS)
- Cover both normal and edge cases

---

## Environment

- AWS Lambda runtime (Node.js)
- Test payloads via local invocation or AWS test events
- Sample JSON inputs stored in `/tests/sample_payloads/`