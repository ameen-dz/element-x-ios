# Rebrand Ameen — iOS (Element X iOS)

Compte rendu du 10/11/2026. Base : Element X iOS **release 26.11.0** (05/11/2026, dernière version
stable). Branches : `upstream-sync` (amont, sans modification) et `brand/main` (Ameen). Commits signés
« Ameen <support@ameen.dz> ». Diff : 34 fichiers, dont le projet Xcode régénéré, 186 lignes de couleurs
générées et les images.

## Fait

| Thème | Fichiers | Détail |
| --- | --- | --- |
| Nom, identifiants | `app.yml`, `ElementX/SupportingFiles/target.yml` | « Ameen », `dz.ameen.app`, `group.dz.ameen.app`, équipe `25CWAX4227`. Import des comptes d'Element Classic retiré (groupe d'app et trousseau de l'équipe Element) |
| Réglages Ameen | `ElementX/Sources/Ameen/AmeenAppHooks.swift` (nouveau) | Branchés par le point d'accroche prévu par Element (`AppHooks.setUp`, `AppSettingsHook`) : liens `ameen.dz` (site, conditions, confidentialité, aide), logo MAS `https://ameen.dz/icone-app.png` |
| Serveur | `AmeenAppHooks.swift`, `AppSettings.swift` (1 ligne) | `matrix.org` retiré. Champ vide en release ; `essai.ameen.dz` en debug (un seul endroit). Bouton « Créer un compte » masqué |
| Notifications | `AmeenAppHooks.swift` | Passerelle `https://push.ameen.dz`. `PUSHER_APP_ID` unique `dz.ameen.app.ios` pour tous les builds (décision du 20/11 ; `AppSettings.pusherAppID`, une ligne) |
| MAS (OAuth) | `AmeenAppHooks.swift`, `target.yml` | Retour `https://ameen.dz/oauth/ios/dz.ameen.app`, domaine associé `webcredentials:ameen.dz` ; domaines `element.io` et `matrix.to` retirés |
| Télémétrie | `Components/Secrets/Secrets.swift`, `AppSettings.swift` | PostHog, Sentry, rageshake et MapTiler à `nil`. Clés PostHog et Sentry d'Element Call (écrites en dur) supprimées |
| Couleurs | `ElementX/Sources/Ameen/AmeenColors.swift` (généré par `ameen/generate-colors.py`), `Assets.xcassets/colors` | Palette de l'app web (`ameen.css`) sur 63 couleurs Compound, via `CompoundHook`. Boutons principaux et liens en vert, accent sombre `#219A75`, fond sombre Encre. Contraste élevé inchangé |
| Icône | `ElementX/Resources/AppIcon.icon` | `ameen-icone-ios-carre.svg` en PNG 1024 opaque |
| Écran d'accueil | `ElementX/Sources/Ameen/AmeenWelcomeCard.swift` (nouveau), `AuthenticationStartScreen.swift` (un bloc), `launch-background`, `ameen-welcome-logo`, `app-logo` | Fond illustré de la page de connexion web (version portrait : `ameen/fonds/`), carte avec le logo complet v2 et le slogan de la charte. Symbole Ameen sur les écrans d'attente |
| Textes | `ElementX/Resources/Localizations/{en,fr,ar}.lproj/Ameen.strings`, modèle SwiftGen, `InfoPlist.strings` | Textes Ameen lus avant ceux d'Element (fichiers Localazy non modifiés). Écran du serveur : « domaine de votre entreprise ». Messages de permission : « Ameen » |
| Langues | `target.yml` | Anglais, français et arabe seulement |

## Vérifié (simulateur iPhone 18 Pro, iOS 27.2)

- Build de référence (26.11.0 sans modification) : OK. Build Ameen debug : OK. SwiftFormat : aucune erreur.
- Écran d'accueil Ameen en clair et en sombre ; icône et nom « Ameen » sur l'écran d'accueil d'iOS.
- Langues embarquées : `ar`, `en`, `en-US`, `fr`.
- Connexion : `essai.ameen.dz` trouvé par `.well-known`, enregistrement du client auprès de MAS réussi.
  20/11 : fichier `apple-app-site-association` lu par Apple (ouverture internationale d'AT) ; avec la signature de l'équipe Ameen,
  iOS demande « Ameen souhaite utiliser essai.ameen.dz pour se connecter », puis la page de connexion Ameen (MAS) s'ouvre.

## Reste à faire

1. ~~Fichier `apple-app-site-association`~~ : en ligne et lu par Apple le 20/11. Était : fichier sur `https://ameen.dz/.well-known/` (modèle dans le coffre :
   `03 - Infrastructure/config/apple-app-site-association`). Servi en HTTPS, sans redirection, type
   `application/json`. Apple le lit par son propre réseau (CDN) : le site doit être joignable depuis l'étranger.
2. ~~Sygnal~~ : un seul identifiant `dz.ameen.app.ios`, `platform: production` depuis l'envoi à Apple (20/11). Les builds Xcode et simulateur (sandbox) ne reçoivent plus de notifications.
3. **Capacités de l'App ID** `dz.ameen.app` : créé le 29/10 avec App Groups et Push Notifications seulement. L'app déclare aussi Associated Domains (`webcredentials:ameen.dz`) et les notifications de communication ; les extensions `dz.ameen.app.nse` et `dz.ameen.app.shareextension` ont besoin de leur propre App ID. La signature automatique de Xcode les ajoute au premier build pour un iPhone, à vérifier ce jour-là. La clé APNs existe déjà (« Sandbox & Production », 29/10) : la même sert aux deux identifiants Sygnal.
4. **Test sur un vrai iPhone** (signé avec l'équipe `25CWAX4227`) : connexion MAS, messages, fichiers, appels,
   notifications app fermée, contrôle réseau. Le simulateur ne peut pas tester le retour de connexion ni les notifications.
5. Relecture des textes arabes par un arabophone ; traduction anglaise et arabe du slogan à valider.
6. Pages `ameen.dz/aide`, `/confidentialite`, `/conditions` (avant TestFlight).
7. ~~Archive App Store~~ : envoyée à App Store Connect le 20/11 (version 26.11.0, build 1). Mac enregistré comme appareil sur le compte développeur (exigé par Xcode pour signer). Filtrage des notifications (`com.apple.developer.usernotifications.filtering`) retiré de l'extension NSE en attendant l'accord d'Apple (demande à envoyer, texte dans la fiche App Store du coffre).
8. Fusion d'une nouvelle version amont dans `upstream-sync` puis `brand/main`, pour tester.

## Écarts avec `REBRAND_PLAN.md`

- Point d'entrée non prévu au plan, mais prévu par Element : les « hooks » (`AppHooks`). Réglages et couleurs
  y sont branchés, dans `ElementX/Sources/Ameen/`, ce qui garde le diff du code d'Element très petit.
- `showCreateAccountButton` n'est pas réglable par les hooks : une ligne modifiée dans `AppSettings.swift`.
- Textes : pas de mécanisme de surcharge chez Element. Ajout d'une table `Ameen.strings` lue en premier
  (modèle SwiftGen modifié). `InfoPlist.strings` modifié directement (« Element X » → « Ameen »).
- `PUSHER_APP_ID` : Element ajoute `.ios.dev` / `.ios.prod` ; remplacé par un identifiant unique `dz.ameen.app.ios`.
- Écran d'accueil iPad : fond paysage de la page web (pas de version dédiée).
- Liens « copyright » et « conditions » pointent tous deux vers `https://ameen.dz/conditions`.
- Le bouton « Se connecter avec un code QR » reste affiché (il suppose MAS, désormais en place).
- Build simulateur : toujours signer **avec l'équipe Ameen** (`CODE_SIGN_IDENTITY="-" CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM=25CWAX4227 PROVISIONING_PROFILE_SPECIFIER=""`). Sans signature, faux écran de code PIN ; sans équipe, l'app s'appelle `FAKETEAMID.dz.ameen.app` et iOS refuse le retour de connexion MAS.
- `CFBundleName` réglé sur « Ameen » (`target.yml`) : iOS l'affiche dans « … souhaite utiliser essai.ameen.dz pour se connecter ».

## Décisions à prendre (Yasser)

- Slogan en anglais (« The business messaging app you own. ») et en arabe : à valider.
