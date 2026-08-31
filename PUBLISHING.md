# Publishing notes

Maintainer checklist for M3U What's New.

## Container image

Pushes to `main` trigger `.github/workflows/docker-publish.yml`, which publishes:

```text
ghcr.io/slideboy/m3u-whats-new:latest
```

Git tags beginning with `v` also publish version tags.

### First GHCR publication

GitHub Container Registry packages are private when first published. After the first successful **Publish Docker image** workflow:

1. Open the `m3u-whats-new` package on GitHub.
2. Open **Package settings**.
3. Under **Danger Zone**, choose **Change visibility**.
4. Make the package **Public**.

A public GHCR package can be pulled anonymously by Docker/Dockhand/Portainer. GitHub warns that changing a package to public is irreversible.

## First release

Create the first GitHub Release only after the fresh-install stack test passes. Suggested first tag:

```text
v1.0.0
```

The tag will also trigger a versioned Docker image build.

## Before every publication

- Never commit `.env`.
- Never commit SQLite databases or `data/backups/`.
- Confirm GitHub Actions are green.
- Test a fresh deployment using the published container image.
