# M3U What's New

[Français](README.fr.md)

M3U What's New is a lightweight Docker application that monitors an Xtream-compatible VOD and series catalogue and highlights what changed since the previous scans.

It is designed as a small, independent community project. It does not play or proxy streams; it monitors catalogue metadata exposed by the provider API.

## Features

- Automatic discovery of provider VOD and series categories.
- Country/zone detection from category names and flags.
- Per-country and per-category monitoring selection.
- New movies, new series and new episode detection.
- Category additions, removals and renames, plus confirmed content removals.
- Safe baseline handling when a category is enabled, avoiding thousands of false "new" items.
- Today, 7-day and 30-day history views with 45-day event retention.
- Configurable automatic scans and manual scan trigger.
- Built-in SQLite backups with scheduling, rotation and manual backup.
- SMTP email notifications, either immediate or grouped into periodic digests.
- French and English interface and email output.
- Provider and SMTP credentials kept in `.env`, not in SQLite or `config.json`.

## Requirements

- Docker
- Docker Compose v2 (`docker compose`)
- Access to an Xtream-compatible provider API that you are authorized to use

No Python packages need to be installed on the host. The application uses the Python standard library inside the container.

## Installation

1. Download or clone this repository.
2. Enter the project directory.
3. Create your private environment file:

```bash
cp .env.example .env
```

4. Edit `.env` and set at least:

```env
M3U_PROVIDER_URL=https://your-provider.example
M3U_USERNAME=your_username
M3U_PASSWORD=your_password
```

5. Start the application:

```bash
docker compose up -d
```

6. Check the logs:

```bash
docker compose logs --tail=100
```

7. Open:

```text
http://YOUR-SERVER-IP:36401
```

If you changed `M3U_WHATS_NEW_PORT` in `.env`, use that host port instead.

The application timezone is configured in `data/config.json` (`Europe/Paris` by default). If needed, change that value to a valid IANA timezone such as `Europe/London` or `America/New_York`. The `TZ` value in `.env` sets the container timezone.

## First start

On a fresh installation, the first scan discovers the categories exposed by the provider. No country is forced by default.

Open **Settings**, enable the country/zone you want to monitor, choose the VOD and series categories, then save. Existing items in newly enabled categories are absorbed as a baseline first; later additions are reported as genuine new content.

## Email notifications

SMTP username and password are read only from `.env`:

```env
SMTP_USERNAME=your-smtp-user
SMTP_PASSWORD=your-app-password
```

SMTP host, port, TLS/SSL mode, sender, recipients, digest frequency and notification types are configured from the web interface.

After editing SMTP credentials in `.env`, recreate the container so the new environment is loaded:

```bash
docker compose up -d --force-recreate
```

## Data and backups

Persistent application data is stored in `./data` on the Docker host.

This includes:

- `data/config.json` — non-secret application defaults
- `data/nouveautes.sqlite3` — active SQLite database, created automatically
- `data/backups/` — application-managed SQLite backups

The database and backups are ignored by Git and must never be committed.

The historical internal filename `nouveautes.sqlite3` is intentionally retained for compatibility with existing installations.

## Updating

After updating the repository, the safest command is:

```bash
docker compose up -d --force-recreate
```

Your database, settings and backups remain in `./data`.

## Security

The web interface currently has no built-in authentication. Do **not** expose it directly to the public Internet. Use a VPN or an authenticated reverse proxy if remote access is needed.

Never commit `.env`, SQLite databases, or backup files. See [SECURITY.md](SECURITY.md).

## Support and contributions

Issues and pull requests are welcome. This is a best-effort community project: no support response time, maintenance schedule, or future feature development is guaranteed.

## Disclaimer

M3U What's New is an independent project and is not affiliated with Xtream Codes, IPTV providers, or M3U Editor. Use it only with services and data sources you are authorized to access.

## License

MIT License. See [LICENSE](LICENSE).
