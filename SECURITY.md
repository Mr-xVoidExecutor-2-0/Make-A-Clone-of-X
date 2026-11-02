# Security Policy

## Supported versions

Security fixes are provided for the latest published version of MACX. Upgrade to
the latest release before reporting a problem that may already have been resolved.

## Reporting a vulnerability

Do not disclose vulnerabilities, proof-of-concept exploits, or credentials in a
public issue.

Use **Report a vulnerability** in the repository's **Security** tab as the
preferred way to submit the report privately.

Include the affected MACX version, operating system/distribution, selected
provider and version, impact, reproduction conditions, and any suggested
mitigation in the private report.

The maintainer will acknowledge the report, assess its scope, and coordinate
remediation and disclosure timing with the reporter.

## Security boundary

MACX authenticates its analysis provider bridges with per-session random
capability tokens. This is not a sandbox and does not protect against malicious
processes already running as the same operating-system user.
