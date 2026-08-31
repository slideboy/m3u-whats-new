# Fresh installation test checklist

This file is mainly intended for release validation before publishing a version.

1. Start from an empty directory containing only the repository files.
2. Copy `.env.example` to `.env` and fill in valid provider credentials.
3. Run `docker compose up -d`.
4. Confirm the container is named `m3u-whats-new` and the web page opens.
5. Confirm the first provider scan completes without errors.
6. Open Settings and verify that provider countries/zones and categories are discovered.
7. Enable one country and a small set of VOD/Series categories and save.
8. Confirm the baseline is created without reporting the existing catalogue as new content.
9. Run a manual scan and confirm scan timestamps update.
10. Run a manual SQLite backup and confirm a file appears in `data/backups/`.
11. If SMTP is configured, send a test email.
12. Switch FR/EN and verify both UI and email language.
13. Restart the container and confirm settings persist.
14. Reboot the Docker host and confirm settings, scans, backups and categories persist.
