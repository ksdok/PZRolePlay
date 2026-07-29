# Spec — Réouverture du role picker en cours de partie (debug/test)

**Date :** 2025-07-29
**Projet :** PZRolePlay
**Contexte :** Permettre de tester tous les rôles sans redémarrer une partie à chaque fois.
**Portée :** Solo uniquement · Debug-only (gated par flag) · Clean slate complet à chaque switch.
**Révision :** v2 — corrige les 3 bloquants + 2 points de la revue de la v1.

---

## Objectif

Pouvoir rouvrir le role picker **après** qu'un rôle a été choisi, puis en appliquer un autre, en repartant d'un état propre (inventaire / équipement / **skills** / **carry** remis à zéro puis rechargés selon le nouveau rôle). Destiné au test rapide de tous les rôles en solo.

## Décisions de design (confirmées)

| Choix | Valeur |
|---|---|
| Déclencheur | Touche clavier (défaut : `Keyboard.KEY_K`, modifiable) |
| Items au switch | **Clean slate** : vider inventaire + items portés + mains **avant toute mutation d'inventaire** (donc avant la création du sac) |
| Skills au switch | **Reset des perks/XP** (union des perks utilisés par les rôles) avant d'appliquer celles du nouveau rôle |
| Carry au switch | **Reset du carry profile** (UnlimitedCarry/MaxWeightBase/MaxWeight → baseline) avant d'appliquer celui du nouveau rôle |
| MP | **Solo only** — inactif en MP |
| Gating | Flag `PZRolePlayingShared.DEBUG_TOOLS` (default **false**) |
| Annulation (fermeture sans choix) | **No-op** : l'état logique n'est jamais muté avant validation ; fermer le picker debug = conserver l'ancien rôle |

## Comportement actuel (gards) — contournement sans casser les invariants

Gards existants à ne **pas** court-circuiter en vidant `modData` (cela casserait l'invariant README « picker fermé avant choix → se rouvre » et laisserait le joueur sans `PZRP_role`) :

- `chooseRoleLocal` : refuse si `modData[ROLE_KEY] ~= nil` (l.111).
- `applyRoleLocally` : skip si `modData[LOCAL_APPLIED_KEY] == roleKey` (même rôle) (l.73).

**Approche retenue : bypass debug explicite, sans toucher à `modData` avant validation.**

- La touche K ouvre le picker en mode « debug switch » via un flag transient `debugSwitchPending = true`. **`modData[ROLE_KEY]` / `LOCAL_APPLIED_KEY` ne sont pas modifiés à l'ouverture.**
- Le bouton « Choisir » appelle `chooseRoleLocal(roleKey)` ; si `debugSwitchPending` est vrai, on **bypass** le garde `ROLE_KEY ~= nil` et on appelle `applyRoleLocally(player, roleKey, { force = true })`.
- `applyRoleLocally` avec `force = true` : bypass le garde `LOCAL_APPLIED_KEY == roleKey` et exécute le **clean slate complet** (inv/worn/hands + reset perks + reset carry) **avant** la création du sac / `addRoleItems` / skills / equip / stats / carry, puis écrit `modData[ROLE_KEY] = roleKey` et `LOCAL_APPLIED_KEY = roleKey`.
- **Fermeture sans choix** : `close()` remet `debugSwitchPending = false`. Aucun `modData` n'a été muté, l'ancien rôle et son loadout sont intacts → annulation propre, pas de restauration nécessaire, pas de réouverture auto (le fallback de spawn ne se réarme pas car `ROLE_KEY` n'a jamais été vidé).

## Implémentation prévue

### 1. Flag debug — `media/lua/shared/PZRolePlayingShared.lua`
```lua
if PZRolePlayingShared.DEBUG_TOOLS == nil then
    PZRolePlayingShared.DEBUG_TOOLS = false
end
```

### 2. Helpers « clean slate » — `media/lua/shared/PZRolePlayingShared.lua`

**`clearPlayerLoadout(player)`** — vide inventaire + équipement porté + mains :
- `player:setPrimaryHandItem(nil)` ; `player:setSecondaryHandItem(nil)` (garder `~= nil`).
- Retirer les vêtements portés : si `player.clearWornItems` existe, l'utiliser ; sinon boucler sur les `BodyLocation` connues et `setWornItem(loc, nil)`. *(API à valider — garder un fallback défensif.)*
- Vider l'inventaire : si `player:getInventory().clear` existe, `inv:clear()` ; sinon retirer les items un par un (`inv:getItems()` → `inv:Remove(item)`).
- Retourne `true` si quelque chose a été retiré.

**`resetPlayerPerks(player, perkSet)`** — remet à 0 les perks de l'union des rôles :
- Pour chaque `perk` dans `perkSet` : `applyPerkLevel(player, perk, 0)` (la fonction existante descend via `LoseLevel` jusqu'au niveau 0).
- `perkSet` = union des `Perks.X` utilisés par tous les `ROLE_DEFS` du set actif, précalculée une fois au chargement (`PZRolePlayingShared.buildRolePerkUnion()`).
- Perks hors union (levelés organiquement par le joueur) ne sont pas touchés : comportement acceptable en debug.

**`resetCarryProfile(player)`** — remet le carry à la baseline vanilla :
- `player:setMaxWeightBase(<baseline>)` et `player:setMaxWeight(<baseline>)` ; désactiver `UnlimitedCarry` si actif. *(Baseline = valeur vanilla défaut, à confirmer en API ; stocker la baseline avant application si possible.)* `applyCarryProfile` ne fait qu'augmenter, donc le reset explicite est nécessaire avant d'appliquer le nouveau rôle.

### 3. Keybind + réouverture — `media/lua/client/PZRolePlayingClient.lua`
```lua
local REOPEN_KEY = Keyboard.KEY_K
local debugSwitchPending = false   -- module-local

local function onKeyPressed(key)
    if PZRolePlayingShared.DEBUG_TOOLS ~= true then return end
    if key ~= REOPEN_KEY then return end
    if not isSinglePlayerRuntime() then return end            -- solo only
    if PZRolePlayingRolePicker.isVisible() then return end
    local player = getPlayer()
    if player == nil or player:isDead() then return end
    if getTextManager() ~= nil and getTextManager().isTextInputActive ~= nil
       and getTextManager():isTextInputActive() then return end   -- pas pendant la saisie chat
    debugSwitchPending = true
    PZRolePlayingRolePicker.openLocal()
end
Events.OnKeyPressed.Add(onKeyPressed)
```

`PZRolePlayingRolePicker.close()` (existant) : ajouter `debugSwitchPending = false` via un hook ou appeler depuis le client quand le picker se ferme sans choix (annulation propre).

### 4. `chooseRoleLocal` — bypass debug
```lua
function PZRolePlayingClient.chooseRoleLocal(roleKey)
    local player = getPlayer()
    if player == nil or roleKey == nil then return false end
    local modData = PZRolePlayingRoles.normalizeModData(player:getModData())
    local force = debugSwitchPending
    if not force and modData[ROLE_KEY] ~= nil then
        PZRolePlayingRolePicker.setStatus("Role deja choisi pour cette partie.")
        return false
    end
    local applied = PZRolePlayingClient.applyRoleLocally(player, roleKey, { force = force })
    if applied then
        PZRolePlayingRolePicker.close()
        return true
    end
    PZRolePlayingRolePicker.pendingRole = nil
    PZRolePlayingRolePicker.setStatus("Echec de l'application locale du role.")
    return false
end
```

### 5. `applyRoleLocally(player, roleKey, opts)` — clean slate complet quand `opts.force`
Au **tout début**, après la récupération de `def`, avant **toute** mutation d'inventaire :
```lua
local force = opts ~= nil and opts.force == true
if not force and modData[LOCAL_APPLIED_KEY] == roleKey then
    logSpawn("applyRoleLocally SKIP ..."); return false
end
if force then
    PZRolePlayingShared.clearPlayerLoadout(player)   -- avant la création du sac
    PZRolePlayingShared.resetPlayerPerks(player, PZRolePlayingShared.getRolePerkUnion())
    PZRolePlayingShared.resetCarryProfile(player)
    debugSwitchPending = false
end
-- ... suite existante : creation bag, addRoleItems, skills, equip, stats, carry ...
modData[ROLE_KEY] = roleKey
modData[LOCAL_APPLIED_KEY] = roleKey
```
Le clean slate précède donc la création du sac (résout le point 4).

## Choix de la touche

Défaut : `Keyboard.KEY_K` (constante `REOPEN_KEY` modifiable).

## Cas limites / risques

- **Destructif** : clean slate supprime TOUT l'inventaire (y compris loot crafté/ramassé) + reset perks/carry. Accepté pour le test ; mitigé par gate `DEBUG_TOOLS` + solo only.
- **Annulation** : fermer le picker debug sans choisir = no-op (état logique intact, `ROLE_KEY` non vidé). Pas de réouverture auto (le fallback de spawn ne se réarme pas).
- **Même rôle re-choisi** : `force = true` bypass le garde `LOCAL_APPLIED_KEY == roleKey` → re-application (clean slate + réapplique) → utile pour re-tester le même rôle.
- **Persistance** : après switch validé, le nouveau rôle est écrit dans `modData[ROLE_KEY]` → persiste. OK pour le test.
- **API PZ** : `clearWornItems`, `Inventory:clear`, `isTextInputActive`, baseline de `MaxWeightBase` sont plausibles mais à **valider** en implémentation ; garder des fallbacks défensifs (vérifier `~= nil`, retrait unitaire si besoin).
- **MP** : volontairement non supporté (gate `isSinglePlayerRuntime()`).

## Fichiers modifiés

- `media/lua/shared/PZRolePlayingShared.lua` : flag `DEBUG_TOOLS` + `clearPlayerLoadout` + `resetPlayerPerks` + `resetCarryProfile` + `buildRolePerkUnion`/`getRolePerkUnion`.
- `media/lua/client/PZRolePlayingClient.lua` : keybind `onKeyPressed`, `debugSwitchPending`, bypass dans `chooseRoleLocal`, param `opts.force` dans `applyRoleLocally`, reset `debugSwitchPending` à la fermeture sans choix.

## Vérification

1. `PZRolePlayingShared.DEBUG_TOOLS = true`, lancer solo, choisir rôle A → loadout/skills/carry de A.
2. Appuyer sur **K** → picker réapparaît (rôle A toujours actif).
3. Fermer le picker sans choisir → rien ne change (inventaire A intact, `ROLE_KEY` = A).
4. Rappuyer K, choisir rôle B → **clean slate** (plus de trace de A), skills = B, carry = B, équipement porté = B.
5. Choisir à nouveau B → re-clean slate + re-applique B (vérifie le bypass même-rôle).
6. `DEBUG_TOOLS = false` → K ne fait rien.
7. Lancer en MP (host) → K ne fait rien (gate solo).
8. Vérifier qu'après un switch B, une fermeture sans choix laisse B intact (pas de retour à A).