# M3U What's New

[English](README.md)

M3U What's New est une petite application Docker qui surveille un catalogue VOD et Séries compatible Xtream et affiche ce qui a changé depuis les scans précédents.

Le projet est indépendant et destiné à un usage communautaire. Il ne lit ni ne proxyfie les flux : il surveille les métadonnées du catalogue exposées par l'API du fournisseur.

## Fonctionnalités

- Découverte automatique des catégories VOD et Séries du fournisseur.
- Détection des pays/zones à partir des noms de catégories et des drapeaux.
- Sélection du suivi par pays et par catégorie.
- Détection des nouveaux films, nouvelles séries et nouveaux épisodes.
- Détection des ajouts, suppressions et renommages de catégories, ainsi que des suppressions de contenus confirmées.
- Création sûre d'une référence lors de l'activation d'une catégorie afin d'éviter des milliers de fausses nouveautés.
- Historique Aujourd'hui, 7 jours et 30 jours, avec rétention des événements pendant 45 jours.
- Périodicité de scan configurable et scan manuel.
- Sauvegardes SQLite intégrées avec planification, rotation et sauvegarde manuelle.
- Notifications email SMTP immédiates ou regroupées en récapitulatifs périodiques.
- Interface et emails en français ou en anglais.
- Identifiants fournisseur et SMTP conservés dans `.env`, jamais dans SQLite ni dans `config.json`.

## Prérequis

- Docker
- Docker Compose v2 (`docker compose`)
- Un accès autorisé à une API fournisseur compatible Xtream

Aucun paquet Python n'est à installer sur l'hôte. L'application utilise uniquement la bibliothèque standard Python dans le conteneur.

## Installation

1. Téléchargez ou clonez ce dépôt.
2. Placez-vous dans le dossier du projet.
3. Créez votre fichier d'environnement privé :

```bash
cp .env.example .env
```

4. Modifiez `.env` et renseignez au minimum :

```env
M3U_PROVIDER_URL=https://votre-fournisseur.example
M3U_USERNAME=votre_identifiant
M3U_PASSWORD=votre_mot_de_passe
```

5. Démarrez l'application :

```bash
docker compose up -d
```

6. Vérifiez les logs :

```bash
docker compose logs --tail=100
```

7. Ouvrez :

```text
http://IP-DE-VOTRE-SERVEUR:36401
```

Si vous avez modifié `M3U_WHATS_NEW_PORT` dans `.env`, utilisez ce port côté hôte.

Le fuseau horaire utilisé par l’application se règle dans `data/config.json` (`Europe/Paris` par défaut). Si nécessaire, remplacez-le par un fuseau IANA valide, par exemple `Europe/London` ou `America/New_York`. La valeur `TZ` de `.env` règle le fuseau du conteneur.

## Premier démarrage

Sur une installation neuve, le premier scan découvre les catégories proposées par le fournisseur. Aucun pays n'est imposé par défaut.

Ouvrez **Paramètres**, activez le pays ou la zone souhaitée, sélectionnez les catégories Films et Séries à surveiller puis enregistrez. Le contenu déjà présent dans une catégorie nouvellement activée est d'abord absorbé comme référence ; seuls les ajouts ultérieurs apparaissent comme de vraies nouveautés.

## Notifications email

Le nom d'utilisateur et le mot de passe SMTP sont lus uniquement depuis `.env` :

```env
SMTP_USERNAME=votre-utilisateur-smtp
SMTP_PASSWORD=votre-mot-de-passe-application
```

Le serveur SMTP, le port, STARTTLS/SSL, l'expéditeur, les destinataires, la fréquence des récapitulatifs et les types de notifications se règlent depuis l'interface web.

Après une modification des identifiants SMTP dans `.env`, recréez le conteneur :

```bash
docker compose up -d --force-recreate
```

## Données et sauvegardes

Les données persistantes sont stockées dans `./data` sur l'hôte Docker.

On y trouve notamment :

- `data/config.json` — réglages par défaut non sensibles
- `data/nouveautes.sqlite3` — base SQLite active, créée automatiquement
- `data/backups/` — sauvegardes SQLite gérées par l'application

La base et les sauvegardes sont ignorées par Git et ne doivent jamais être publiées.

Le nom interne historique `nouveautes.sqlite3` est volontairement conservé pour assurer la compatibilité avec les installations existantes.

## Mise à jour

Après une mise à jour du dépôt, la commande la plus sûre est :

```bash
docker compose up -d --force-recreate
```

La base, les paramètres et les sauvegardes restent dans `./data`.

## Sécurité

L'interface web ne possède actuellement aucune authentification intégrée. Ne l'exposez **pas directement sur Internet**. Pour un accès distant, utilisez un VPN ou un reverse proxy avec authentification.

Ne publiez jamais `.env`, les bases SQLite ou les fichiers de sauvegarde. Consultez [SECURITY.md](SECURITY.md).

## Support et contributions

Les issues et pull requests sont les bienvenues. Le projet est maintenu selon les disponibilités : aucun délai de support, calendrier de maintenance ou développement futur n'est garanti.

## Avertissement

M3U What's New est un projet indépendant, sans affiliation avec Xtream Codes, les fournisseurs IPTV ou M3U Editor. Utilisez-le uniquement avec des services et sources de données auxquels vous êtes autorisé à accéder.

## Licence

Licence MIT. Consultez [LICENSE](LICENSE).
