# Security policy

## Supported version

Only the latest commit on `main` is supported.

## Reporting

Please report a suspected vulnerability through GitHub's private vulnerability reporting when available. Do not include conversation content, credentials, tokens, or other personal data in a public issue.

## Trust boundaries

Claude Styled does not modify `/Applications/Claude.app`, but it does place three local extension files in the current user's Claude application-data directory. It relies on an undocumented Claude Desktop startup branch and may stop working after an upstream update.

The repository distributes source code, not a notarized binary. Build it locally and inspect changes before updating.
