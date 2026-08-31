# M3U What's New

[Français](README.fr.md)

M3U What's New is a lightweight Docker application that monitors an Xtream-compatible VOD and series catalogue and highlights what changed since previous scans.

It does **not** play or proxy streams. It monitors catalogue metadata exposed by the provider API.

## Features

- Automatic discovery of provider VOD and series categories.
- Country/zone detection from category names and flags.
- Per-country and per-category monitoring selection.
- Detection of new movies, series and episodes.
- Category additions, removals and renames, plus confirmed content removals.
- Safe baseline handling when enabling a category.
- Today, 7-day and 30-day history views with 45-day event retention.
- Configurable automatic scans and manual scans.
- Built-in SQLite backups with scheduling, rotation and manual backup.
- SMTP email notifications, immediate or periodic digest.
- French and English interface and email output.
- Provider and SMTP credentials kept outside SQLite.

## Quick install — Dockhand / Portainer / Compose stack

The recommended installation uses the published container image. You do **not** need to download `watcher.py` or create `config.json` manually.

Create a new stack and paste the repository's [`docker-compose.yml`](docker-compose.yml). In your stack manager, define at least:

```env
M3U_PROVIDER_URL=https://your-provider.example
M3U_USERNAME=your_username
M3U_PASSWORD=your_password
```

Optional variables:

```env
SMTP_USERNAME=
SMTP_PASSWORD=
M3U_WHATS_NEW_PORT=36401
TZ=Europe/Paris
```

Deploy the stack, then open:

```text
http://YOUR-SERVER-IP:36401
```

If you changed `M3U_WHATS_NEW_PORT`, use that host port instead.

On the first start the container automatically creates `/data/config.json` and the SQLite database in the persistent Docker volume `m3u-whats-new-data`.

## Docker Compose from the command line

Clone or download the repository, then:

```bash
cp .env.example .env
```

Edit `.env`, then start:

```bash
docker compose up -d
docker compose logs --tail=100
```

Docker Compose automatically reads the local `.env` file. Never commit it.

## First start

The first scan discovers the categories exposed by your provider. No country is forced by default.

Open **Settings**, enable the country/zone you want to monitor, select the VOD and series categories, then save. Existing content is first absorbed as a baseline; later additions are reported as genuine new content.

## Email notifications

SMTP username and password are supplied through environment variables only:

```env
SMTP_USERNAME=your-smtp-user
SMTP_PASSWORD=your-app-password
```

SMTP host, port, TLS/SSL mode, sender, recipients, digest frequency and notification types are configured in the web interface.

When stack environment variables change, recreate/redeploy the container so the new values are loaded.

## Persistent data

The Docker image stores persistent data in `/data`, backed by the named Docker volume:

```text
m3u-whats-new-data
```

It contains:

- `config.json` — non-secret defaults, created automatically on first start.
- `nouveautes.sqlite3` — active SQLite database.
- `backups/` — application-managed SQLite backups.

Deleting/recreating the container does not delete this volume. Removing the volume **does** delete the application database and backups.

The historical filename `nouveautes.sqlite3` is intentionally retained for compatibility.

## Updating

With a stack manager, pull the newest image and redeploy the stack.

From the command line:

```bash
docker compose pull
docker compose up -d
```

The persistent Docker volume is retained.

## Building locally

If you want to build from source instead of using GHCR:

```bash
docker build -t m3u-whats-new:local .
```

The official image is built from this repository by GitHub Actions for `linux/amd64` and `linux/arm64`.

## Security

The web interface currently has no built-in authentication. Do **not** expose it directly to the public Internet. Use a VPN or an authenticated reverse proxy for remote access.

Never commit `.env`, SQLite databases or backup files. See [SECURITY.md](SECURITY.md).

## Support and contributions

Issues and pull requests are welcome. This is a best-effort community project: no support response time, maintenance schedule or future feature development is guaranteed.

## Disclaimer

M3U What's New is an independent project and is not affiliated with Xtream Codes, IPTV providers or M3U Editor. Use it only with services and data sources you are authorized to access.

## License

MIT License. See [LICENSE](LICENSE).
