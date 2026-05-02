# Strix Test Cases

## Scope
Test cases for validating webhook handling, secret detection, reporting, and alert behavior.

---

## Test Cases

| ID | Area | Scenario | Input | Expected Result |
|----|------|--------|------|----------------|
| TC-01 | Payload | Valid clean commit | "update README" | Marked clean, no SNS alert |
| TC-02 | Payload | Empty commits array | commits = [] | Returns "No commits" |
| TC-03 | Payload | Missing commits field | no commits key | Safe handling or controlled failure |
| TC-04 | Detection | AWS key detected | AKIA1234567890ABCDEF | awsCredentialDetected = true |
| TC-05 | Detection | GitHub token detected | ghp_abcdefghijklmnopqrstuvwxyz1234567890 | gitHubTokenDetected = true |
| TC-06 | Detection | SSH private key detected | -----BEGIN RSA PRIVATE KEY----- | sshKeyDetected = true |
| TC-07 | Detection | Clean commit | "fixed typo" | clean = true |
| TC-08 | Logic | Mixed commits | 1 clean, 1 secret | Correct per-commit classification |
| TC-09 | Reporting | Multiple commits | 3 commits | totalCommits = 3 |
| TC-10 | SNS | No findings | clean commits only | No SNS alert sent |
| TC-11 | SNS | Findings present | commit with secret | SNS alert triggered |
| TC-12 | S3 | Missing bucket env var | no SCAN_RESULTS_BUCKET | Skip S3 upload safely |
| TC-13 | DynamoDB | Valid scan result | normal execution | Record inserted into DB |
| TC-14 | Error Handling | Malformed payload | missing repository | Safe failure or error handling |