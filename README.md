# PZRolePlaying

Mod Project Zomboid standalone de sélection de rôle.

## Fonctionnement

- ouvre un picker de rôle au spawn
- applique le rôle choisi : items, sac, vêtements, skills, stats, carry profile
- autorise les doublons de rôles
- restaure le rôle déjà assigné via `modData.PZRP_role`
- migre automatiquement les anciennes clés de test (`LR_role` / `LR_localRoleApplied`) vers `PZRP_*`
- utilise le set **vanilla** par défaut
- bascule automatiquement sur le set **Brita** si Brita/Arsenal est détecté au runtime

## Hors périmètre

- pas de téléportation
- pas de vagues
- pas de stock communautaire
- pas de confinement
- pas de bootstrap sandbox
- pas de modification des zombies vanilla

## UX picker

- si le picker est fermé manuellement avant choix, il se rouvre automatiquement
- une fois le rôle choisi, le picker ne réapparaît plus pour la partie en cours
- en MP, le serveur reste autoritaire sur le choix du rôle

## Fichiers principaux

- `media/lua/shared/PZRolePlayingRoles.lua` : sélection du set actif (vanilla/Brita) + migration des clés persistées
- `media/lua/shared/PZRolePlayingShared.lua` : helpers de loadout
- `media/lua/client/PZRolePlayingRolePicker.lua` : UI du picker
- `media/lua/client/PZRolePlayingClient.lua` : flow client solo/MP
- `media/lua/server/PZRolePlayingServer.lua` : flow serveur autoritaire en MP

## Notes

- dossier standalone : `../PZRolePlay`
- `name=PZRolePlaying`
- `id=PZRolePlaying`
- namespace de persistance : `PZRP_role`
