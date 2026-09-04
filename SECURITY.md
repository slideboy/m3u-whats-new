# Security

Xtream What's New handles private provider and SMTP credentials.

- Never commit your `.env` file.
- Never post provider URLs, usernames, passwords, SMTP credentials, SQLite databases, or backup files in public issues.
- Redact sensitive values from logs before sharing them.
- The web interface has no built-in authentication. Do not expose port `36401` directly to the public Internet. If remote access is required, place it behind a trusted reverse proxy with authentication, a VPN, or another access-control layer.

If you discover a security issue, avoid publishing credentials or exploit details that could expose another user's private service.
