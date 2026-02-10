import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";

export const handler = async (event) => {
  console.log('Strix Lambda starting...');

  const payload = event.body ? JSON.parse(event.body) : event;
  const s3 = new S3Client({ region: process.env.AWS_REGION });

  console.log('Full payload:', JSON.stringify(payload, null, 2));
  console.log('Scanning Repository:', payload.repository.full_name)

// accessing the commits of the github payload
  const commits = payload.commits;


  if (!commits || commits.length === 0) {
    console.log('No commits in webhook');
    return { statusCode: 200, body: JSON.stringify({ message: 'No commits' }) };
  }

  // checks for the number of commits listed within the payload
      if (commits.length == 1) {
          console.log('Found', commits.length, 'commit to scan')
      } else if (commits.length > 1) {
          console.log('Found', commits.length, 'commits to scan')
      }
      else {
          console.log('No commits found')
      }

// collects the results for storing within s3
const scanResults = [];

const scanPattern = (commitMsg, pattern, warningMsg) => {
    const hit = pattern.test(commitMsg);
    if (hit) console.log(warningMsg);
    return hit;
};

  for (const commit of commits) {

      console.log('Scanning commit:', commit.id)
      const commitMsg = commit.message

      const awsFound = scanPattern(
          commitMsg,
          /(ASIA|AKIA)[0-9A-Z]{16}/,
          "WARNING! AWS CREDENTIAL KEYS DETECTED! THIS IS A SECURITY RISK!"
      );

      const ghpFound = scanPattern(
          commitMsg,
          /ghp_[a-zA-Z0-9]{36}/,
          "WARNING! GITHUB PERSONAL TOKEN DETECTED! THIS IS A SECURITY RISK!"
      );

      const sshFound = scanPattern(
          commitMsg,
          /-----BEGIN.*PRIVATE KEY-----/,
          "WARNING! PRIVATE SSH KEY DETECTED! THIS IS A SECURITY RISK!"
      );

      const noRisks = !awsFound && !ghpFound && !sshFound;
      if (noRisks) {
          console.log('No private keys/tokens detected within the commit:', commit.id)
      }

      scanResults.push({
        commitId: commit.id,
        commitMsg: commitMsg,
        findings: {
            awsCredentialDetected: awsFound,
            gitHubTokenDetected: ghpFound,
            sshKeyDetected: sshFound
        },
        clean: noRisks,
      });
  }

  // final scan report in json format
  const scanReport = {
    repository: payload.repository.full_name,
    reference: payload.ref,
    scannedAt: new Date().toISOString(),
    totalCommits: commits.length,
    results: scanResults,
  };

  console.log("Scan summary:", {
    repository: scanReport.repository,
    totalCommits: scanReport.totalCommits,
    anyFindings: scanResults.some((r) => !r.clean),
  });

  // storing the information within an S3 bucket
  const bucket = process.env.SCAN_RESULTS_BUCKET;
  if(!bucket){
    console.log("SCAN_RESULTS_BUCKET env var not set; skipping the S3 upload")
  }
  else {
    const key = `scan-results/${scanReport.repository}/${Date.now()}.json`;
    await s3.send(new PutObjectCommand({
        Bucket: bucket,
        Key: key,
        Body: JSON.stringify(scanReport, null, 2),
        ContentType: "application/json",
        })
    );

    console.log("Scan results uploaded to S3:", `s3://${bucket}/${key}`)
  }

return {
  statusCode: 200,
  body: JSON.stringify({
    message: 'Scan complete',
    repository: scanReport.repository,
    totalCommits: scanReport.totalCommits,
    anyFindings: scanResults.some((r) => !r.clean)})
};
};
