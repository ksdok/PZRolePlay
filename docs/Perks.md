# Project Zomboid — Référence des perks (clés Lua `Perks.X`)

Référence des clés utilisables dans le code Lua du mod (`{Perks.<Key>, <level>}`).
Les clés Lua `Perks.X` correspondent aux noms de l'enum Java `PerkFactory.Perks`
(`zombie.characters.skills.PerkFactory.Perks`). **Le nom affiché en jeu diffère
parfois du nom de la clé** — c'est la source des bugs « talent reste à 0 ».

> Sources : enum Java `PerkFactory.Perks` (javadoc officielle) + vanilla
> `server/XpSystem/XPSystem_SkillBook.lua` (usage réel `Perks.X`).

---

## ⚠️ Pièges — clés qui n'existent PAS (→ nil → talent à 0)

| ❌ Mauvaise clé (nil) | ✅ Clé correcte | Nom affiché (EN / FR) |
|---|---|---|
| `Perks.Carpentry` | `Perks.Woodwork` | Carpentry / Menuiserie |
| `Perks.Electrical` | `Perks.Electricity` | Electrical / Électricité |
| `Perks.FirstAid` | `Perks.Doctor` | First Aid / Premiers soins |
| `Perks.Cook` | `Perks.Cooking` | Cooking / Cuisine |
| `Perks.Welding` | `Perks.MetalWelding` | Metalworking / Travail des métaux |
| `Perks.Foraging` | `Perks.PlantScavenging` | Foraging / Cueillette |
| `Perks.Spear` existe bien | (pas de piège) | Spear / Lance |

Règle : la clé Lua = le nom de l'enum Java. En cas de doute, vérifier la
[javadoc PerkFactory.Perks](https://projectzomboid.com/modding/zombie/characters/skills/PerkFactory.Perks.html).

---

## Clés valides par catégorie

### Passif (force/endurance) — `setPerkLevelDebug` dans `applyPerkLevel`
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.Fitness` | Fitness / Endurance |
| `Perks.Strength` | Strength / Force |

### Agilité
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.Sprinting` | Sprinting / Sprint |
| `Perks.Lightfoot` | Lightfoot / Pas léger |
| `Perks.Nimble` | Nimble / Agilité |
| `Perks.Sneak` | Sneak / Discrétion |

### Maniement d'armes (combat)
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.Axe` | Axe / Hache |
| `Perks.LongBlade` | Long Blade / Lame longue |
| `Perks.SmallBlade` | Small Blade / Petite lame |
| `Perks.LongBlunt` | Long Blunt / Arme contondante longue |
| `Perks.SmallBlunt` | Small Blunt / Arme contondante courte |
| `Perks.Spear` | Spear / Lance |
| `Perks.Maintenance` | Maintenance / Entretien |

### Armes à feu
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.Aiming` | Aiming / Visée |
| `Perks.Reloading` | Reloading / Rechargement |

### Artisanat / crafting
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.Woodwork` | Carpentry / Menuiserie |
| `Perks.Mechanics` | Mechanics / Mécanique |
| `Perks.Electricity` | Electrical / Électricité |
| `Perks.MetalWelding` | Metalworking / Travail des métaux |
| `Perks.Tailoring` | Tailoring / Couture |
| `Perks.Cooking` | Cooking / Cuisine |
| `Perks.Doctor` | First Aid / Premiers soins |
| `Perks.Blacksmith` | Blacksmith / Forge |
| `Perks.Melting` | Melting / Fusion |

### Survie / nature
| Clé Lua | Affiché (EN / FR) |
|---|---|
| `Perks.PlantScavenging` | Foraging / Cueillette |
| `Perks.Trapping` | Trapping / Piégeage |
| `Perks.Farming` | Farming / Agriculture |
| `Perks.Fishing` | Fishing / Pêche |
| `Perks.Survivalist` | Survivalist / Survie |

### Build 42 — nouveaux artisanats (non présents en B41)
| Clé Lua | Affiché (EN) |
|---|---|
| `Perks.Butchering` | Butchering |
| `Perks.Carving` | Carving |
| `Perks.FlintKnapping` | Flint Knapping |
| `Perks.Glassmaking` | Glassmaking |
| `Perks.Husbandry` | Husbandry |
| `Perks.Masonry` | Masonry |
| `Perks.Pottery` | Pottery |
| `Perks.Tracking` | Tracking |

> B42-only : n'existent pas forcément en B41. Ne pas utiliser pour un mod
> ciblant B41 (le mod actuel tourne avec Brita/Arsenal[26] = B41).

---

## Categories parentes (ne pas utiliser pour monter un skill)

`Perks.None`, `Perks.Agility`, `Perks.Melee`, `Perks.Crafting`, `Perks.Firearm`,
`Perks.Combat`, `Perks.Passiv`, `Perks.MAX` — ce sont des groupes/catégories de
l'enum, pas des perks individuels jouables.

---

## Application dans PZRolePlay

La fonction `PZRolePlayingShared.applyPerkLevel(player, perk, level)` :
1. `xp:setXPToLevel(perk, level)`
2. Pour `Strength`/`Fitness` (passifs) : `player:setPerkLevelDebug(perk, level)`
3. Boucle `player:LevelPerk(perk, false)` / `player:LoseLevel(perk)` pour
   ajuster le niveau affiché.
4. `xp:setXPToLevel(perk, level)` à nouveau.

Si `perk` est `nil` (mauvaise clé), la fonction retourne immédiatement sans rien
faire → le talent reste à 0, sans erreur dans la log. D'où l'importance
d'utiliser exactement les clés ci-dessus.

---

## Historique des corrections dans ce mod

| Commit | Correction |
|---|---|
| `d2f0c3c` | `Perks.Electrical` → `Perks.Electricity` (compétence restait à 0) |
| `e2a78c9` | `Perks.Carpentry` → `Perks.Woodwork` (Menuiserie restait à 0) + ajout des 6 perks manquantes à Invincible (Farming, MetalWelding, Tailoring, Fishing, Spear, Maintenance) |