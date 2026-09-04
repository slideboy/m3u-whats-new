# Fresh install validation / Validation d'installation neuve

This checklist validates the same path a new Dockhand/Portainer user would follow.

## Before the test

- Keep a safe copy of any existing installation and `.env`.
- Do not reuse the previous SQLite database or Docker data volume.
- Make sure the GHCR package `ghcr.io/slideboy/xtream-whats-new` is public.

## Stack install

1. Create a new stack from `docker-compose.yml`.
2. Set `XTREAM_PROVIDER_URL`, `XTREAM_USERNAME`, `XTREAM_PASSWORD`.
3. Optionally set SMTP credentials and `TZ`.
4. Deploy.
5. Confirm the container becomes healthy and the web page opens.
6. Confirm logs show that `/data/config.json` was created on first start.
7. Confirm the provider catalogue is discovered.
8. Enable one country and a small set of VOD/Series categories.
9. Run a manual scan and verify the baseline does not create false historical events.
10. Run a manual SQLite backup.
11. Configure SMTP in the UI and send a test email if desired.
12. Restart the container and confirm settings persist.
13. Redeploy the stack and confirm the named volume preserves settings and backups.

## Clean uninstall test

To simulate a truly new user again, remove both the container/stack **and** the Docker volume `xtream-whats-new-data`. Removing only the container is not a fresh install because the database remains in the volume.
