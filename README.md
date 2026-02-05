# Strix

Security scanning platform that prevents credential leaks and limits cloud blast radius.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Status](https://img.shields.io/badge/status-WIP-yellow)

## What is Strix?
Strix is an automated security platform that detects exposed secrets in code repositories and immediately contains potential cloud compromise.

### The Problem
Developer commits AWS credentials → Automated bots detect the leak within minutes → Unauthorized resource usage begins → Financial and security impact follows.

### The Solution
Strix integrates with repositories as a GitHub App and:

- Scans commits and pull requests for secrets
- Detects exposed AWS credentials, API keys, and tokens
- Automatically revokes compromised keys via AWS Organizations
- Isolates impact using multi-account AWS architecture
- Provides audit-ready security reports

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

