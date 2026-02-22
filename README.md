# Strix

![Status](https://img.shields.io/badge/status-WIP-orange)
![AWS](https://img.shields.io/badge/cloud-AWS-orange)
![Serverless](https://img.shields.io/badge/architecture-serverless-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)
![Node.js](https://img.shields.io/badge/runtime-Node.js-green)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Real-time credential leak detection for Git repositories using serverless architecture. Strix scans Github commits for exposed secrets (AWS Keys, Github Tokens, SSH keys) and sends alerts to prevent credentials from being exposed. Strix is managed with terraform and can be deployed via `terraform apply`. 

**Built with: Lambda, API gateway, DynamoDB, S3, SNS, and Terraform**

**Architecture:**


## Architecture
**GitHub Integration:**
- GitHub App + Webhook → Lambda scanning engine
- Pre-commit hooks (optional client-side)
- Pull request status checks

**Multi-Account Isolation:**
- **Dev Account:** Test scanning rules safely
- **Staging Account:** Validate detection accuracy
- **Production Accounts:** Customer isolation (one compromise ≠ total breach)

**Security Components:**
- **Lambda Scanning Engine:** Processes untrusted code in isolated private subnet
- **Pattern Detection:** Regex + entropy analysis for secrets
- **Automated Response:** IAM key revocation via AWS Organizations SCPs
- **Audit Trail:** Immutable logs in CloudWatch

## Threat Model

**Prevented Attacks:**
- Account takeover via exposed credentials
- Resource abuse (compute, storage)
- Data exfiltration from compromised accounts
- Lateral movement between environments
- Compliance violations (exposed PII, secrets)

**Blast Radius Containment:**
Multi-account architecture ensures one compromised scanning operation cannot access other customers' data or infrastructure.

