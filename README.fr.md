# M3U What's New

[English](README.md)

M3U What's New est une petite application Docker qui surveille un catalogue VOD et Séries compatible Xtream et affiche ce qui a changé depuis les scans précédents.

Elle ne lit ni ne proxyfie les flux : elle surveille les métadonnées du catalogue exposées par l'API du fournisseur.

## Fonctionnalités

- Découverte automatique des catégories VOD et Séries du fournisseur.
- Détection des pays/zones à partir des noms de catégories et des drapeaux.
- Sélection du suivi par pays et par catégorie.
- Détection des nouveaux films, nouvelles séries et nouveaux épisodes.
- Détection des ajouts, suppressions et renommages de catégories, ainsi que des suppressions de contenus confirmées.
- Création sûre d'une référence lors de l'activation d'une catégorie.
- Historique Aujourd'hui, 7 jours et 30 jours avec rétention des événements pendant 45 jours.
- Périodicité de scan configurable et scan manuel.
- Sauvegardes SQLite intégrées avec planification, rotation et sauvegarde manuelle.
- Notifications email SMTP immédiates ou regroupées en récapitulatifs périodiques.
- Interface et emails en français ou en anglais.
- Identifiants fournisseur et SMTP conservés hors de SQLite.

### Installation avec Dockhand / Portainer

Créez une nouvelle Stack et collez le Compose suivant :

```yaml
services:
  m3u-whats-new:
    image: ghcr.io/slideboy/m3u-whats-new:latest
    container_name: m3u-whats-new
    restart: unless-stopped

    ports:
      - "${M3U_WHATS_NEW_PORT:-36401}:36401"

    environment:
      M3U_PROVIDER_URL: "${M3U_PROVIDER_URL}"
      M3U_USERNAME: "${M3U_USERNAME}"
      M3U_PASSWORD: "${M3U_PASSWORD}"
      SMTP_USERNAME: "${SMTP_USERNAME:-}"
      SMTP_PASSWORD: "${SMTP_PASSWORD:-}"
      TZ: "${TZ:-Europe/Paris}"

    volumes:
      - m3u-whats-new-data:/data

    healthcheck:
      test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:36401/', timeout=5)"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 30s

volumes:
  m3u-whats-new-data:
    name: m3u-whats-new-data
```

Si vous avez modifié `M3U_WHATS_NEW_PORT`, utilisez ce port côté hôte.

Au premier démarrage, le conteneur crée automatiquement `/data/config.json` et la base SQLite dans le volume Docker persistant `m3u-whats-new-data`.

## Docker Compose en ligne de commande

Clonez ou téléchargez le dépôt puis :

```bash
cp .env.example .env
```

Modifiez `.env`, puis démarrez :

```bash
docker compose up -d
docker compose logs --tail=100
```

Docker Compose lit automatiquement le fichier `.env` local. Ne le publiez jamais.

## Premier démarrage

Le premier scan découvre les catégories proposées par votre fournisseur. Aucun pays n'est imposé par défaut.

Ouvrez **Paramètres**, activez le pays ou la zone souhaitée, sélectionnez les catégories Films et Séries à surveiller puis enregistrez. Le contenu déjà présent est d'abord absorbé comme référence ; seuls les ajouts ultérieurs apparaissent comme de vraies nouveautés.

## Notifications email

Le nom d'utilisateur et le mot de passe SMTP sont fournis uniquement via les variables d'environnement :

```env
SMTP_USERNAME=votre-utilisateur-smtp
SMTP_PASSWORD=votre-mot-de-passe-application
```

Le serveur SMTP, le port, STARTTLS/SSL, l'expéditeur, les destinataires, la fréquence des récapitulatifs et les types de notifications se règlent depuis l'interface web.

Après modification des variables d'environnement de la stack, redéployez/recréez le conteneur pour charger les nouvelles valeurs.

## Données persistantes

L'image Docker stocke ses données dans `/data`, relié au volume Docker nommé :

```text
m3u-whats-new-data
```

Il contient :

- `config.json` — valeurs par défaut non sensibles, créé automatiquement au premier démarrage.
- `nouveautes.sqlite3` — base SQLite active.
- `backups/` — sauvegardes SQLite gérées par l'application.

Supprimer/recréer le conteneur ne supprime pas ce volume. En revanche, supprimer le volume **efface** la base et les sauvegardes de l'application.

Le nom interne historique `nouveautes.sqlite3` est volontairement conservé pour la compatibilité.

## Mise à jour

Avec un gestionnaire de stack, récupérez la nouvelle image puis redéployez la stack.

En ligne de commande :

```bash
docker compose pull
docker compose up -d
```

Le volume Docker persistant est conservé.

## Construction locale

Pour construire l'image depuis les sources au lieu d'utiliser GHCR :

```bash
docker build -t m3u-whats-new:local .
```

L'image officielle est construite automatiquement par GitHub Actions pour `linux/amd64` et `linux/arm64`.

## Sécurité

L'interface web ne possède actuellement aucune authentification intégrée. Ne l'exposez **pas directement sur Internet**. Pour un accès distant, utilisez un VPN ou un reverse proxy avec authentification.

Ne publiez jamais `.env`, les bases SQLite ou les fichiers de sauvegarde. Consultez [SECURITY.md](SECURITY.md).

## Support et contributions

Les issues et pull requests sont les bienvenues. Le projet est maintenu selon les disponibilités : aucun délai de support, calendrier de maintenance ou développement futur n'est garanti.

## Avertissement

M3U What's New est un projet indépendant, sans affiliation avec Xtream Codes, les fournisseurs IPTV ou M3U Editor. Utilisez-le uniquement avec des services et sources de données auxquels vous êtes autorisé à accéder.

## Licence

Licence MIT. Consultez [LICENSE](LICENSE).
