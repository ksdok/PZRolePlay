# Spec — Rôles Resident Evil (Leon Kennedy, Chris Redfield, Jill Valentine)

**Date :** 2025-07-29  
**Projet :** PZRolePlay  
**Contexte :** Ajout de 3 rôles inspirés de Resident Evil, dans la continuité du rôle Hunk déjà implémenté.  
**Sets concernés :** Brita (principale) + Vanilla (équivalences)

---

## Rôles existants (rappel)

| Rôle | ID | Style |
|---|---|---|
| Hunk | `hunk` | Opérateur USS / fantôme (SMG suppressé, masque à gaz, furtif) |
| 007 Agent | `agent` | Agent secret (PPK, discrétion) |

## Nouveaux rôles

| Rôle | ID | Style |
|---|---|---|
| Leon Kennedy | `leon` | Agent fédéral DSO, polyvalent (AR + sidearm, mobilité) |
| Chris Redfield | `chris` | BSAA Heavy Assault, tank (shotgun + magnum, force brute) |
| Jill Valentine | `jill` | BSAA Operative, éclaireuse (pistolet + SMG, explosifs, lockpick) |

---

## 1. Leon S. Kennedy — `leon`

### Profil

Agent fédéral DSO (Division of Security Operations). Opérateur polyvalent, précision tir + mobilité.  
Style : agent secret entre Hunk (furtif) et 007 Agent (élégant), mais plus orienté combat ouvert.  
Capacité de port : **50**

### Set Brita

#### Armes

| Slot | Item ID | Qté | Justification lore |
|---|---|---|---|
| Primaire (AR) | `Base.M4A1` | 1 | Fusil d'assaut RE6 (Assault Rifle for Special Tactics) |
| Sidearm | `Base.VP70` | 1 | H&K VP70 = arme de départ RE2 (Matilda) |
| Secondaire (SG) | `Base.M870_Police` | 1 | Riot Gun / shotgun tactique (RE4, RE6) |
| SMG | `Base.MP5_Stock` | 1 | TMP / SMG (RE4, Degeneration) |
| Mêlée | `Base.HuntingKnife` | 1 | Couteau de combat (signature Leon) |
| Grenades | `Base.PipeBomb` | 2 | Grenades frag |

#### Munitions

| Item ID | Qté |
|---|---|
| `Base.556Clip` | 4 |
| `Base.Bullets556` | 120 |
| `Base.9mmClip` | 3 |
| `Base.Bullets9mm` | 90 |
| `Base.ShotgunShells` | 25 |

#### Accessoires d'arme

| Item ID | Qté |
|---|---|
| `Base.Light_Small` | 1 |
| `Base.Sight_EOTech` | 1 |
| `Base.Suppressor_Pistol` | 1 |
| `Base.Cleaning` | 1 |
| `Base.WD` | 1 |

#### Utilitaires & consommables

| Item ID | Qté |
|---|---|
| `Base.Screwdriver` | 1 |
| `Base.TinOpener` | 1 |
| `Base.WaterBottleFull` | 1 |
| `Base.Bandage` | 3 |
| `Base.PillsVitamins` | 1 |
| `Base.TinnedBeans` | 2 |
| `Base.TinnedSoup` | 2 |
| `Base.Crackers` | 1 |
| `Base.Apple` | 1 |

#### Armure / vêtements

| Slot | Item ID | Justification |
|---|---|---|
| Jacket | `Base.Combat_Jumper` | Veste tactique (style RE4 jacket) |
| Pants | `Base.Combat_Pants` | Pantalon combat |
| Shoes | `Base.Tac_Boots` | Bottes tactiques |
| Hands | `Base.Glove_Mechanix_Pact` | Gants tactiques |
| TorsoExtra | `Base.Armor_Defender` | Gilet pare-balles léger (DSO operative) |
| Hat | — | Pas de casque lourd (Leon porte rarement un casque) |

#### Sac

| Item ID | Justification |
|---|---|
| `Base.Bag_D3M` | Chest rig tactique |

#### bagContents

| Item ID | Qté |
|---|---|
| `Base.556Clip` | 2 |
| `Base.Bullets556` | 60 |
| `Base.9mmClip` | 2 |
| `Base.Bullets9mm` | 45 |
| `Base.ShotgunShells` | 15 |
| `Base.PipeBomb` | 1 |
| `Base.Bandage` | 2 |
| `Base.WaterBottleFull` | 1 |
| `Base.TinnedBeans` | 1 |
| `Base.TinnedSoup` | 1 |
| `Base.Crackers` | 1 |

#### Compétences

| Perk | Niveau |
|---|---|
| Aiming | 9 |
| Reloading | 9 |
| Nimble | 8 |
| Lightfoot | 7 |
| Sprinting | 7 |
| Strength | 6 |
| Fitness | 6 |
| SmallBlade | 5 |
| Sneak | 5 |
| Doctor | 3 |

#### Stats

```lua
stats = { endurance = 0.5, panic = 0, fatigue = 0 }
```

#### equipped

```lua
equipped = {
    primary = "Base.M4A1",
    bag = "Base.Bag_D3M",
    clothes = {
        "Base.Combat_Jumper",
        "Base.Combat_Pants",
        "Base.Tac_Boots",
        "Base.Glove_Mechanix_Pact",
        "Base.Armor_Defender",
    },
}
```

### Set Vanilla

| Slot | Item | Justification |
|---|---|---|
| Primaire | `Base.AssaultRifle2` | M4A1 vanilla (assault rifle) |
| Sidearm | `Base.Pistol` | Pistolet 9mm (Matilda/VP70 équivalent) |
| Mêlée | `Base.HuntingKnife` | Couteau de combat |
| Sac | `Base.Bag_DuffelBag` | Sac tactique |
| Vêtements | — | Pas d'armure vanilla |

Compétences et stats identiques au set Brita.

---

## 2. Chris Redfield — `chris`

### Profil

BSAA Operative / Heavy Assault. Tank, brute force, spécialiste shotgun + magnum.  
Le "Rambo" du Resident Evil — force et endurance au max.  
Capacité de port : **60**

### Set Brita

#### Armes

| Slot | Item ID | Qté | Justification lore |
|---|---|---|---|
| Primaire (SG) | `Base.SPAS12_Fixed` | 1 | SPAS-12 (fusil de combat emblématique RE1/RE5) |
| Sidearm (Magnum) | `Base.M29_44` | 1 | S&W M29 .44 Magnum = arme signature RE5 |
| Secondaire (AR) | `Base.AK103` | 1 | Équivalent SIG 556 (RE5) / AR tactique (RE6) |
| Mêlée | `Base.HuntingKnife` | 1 | Survival Knife (RE5, RE7) |
| Grenades | `Base.PipeBomb` | 3 | Grenade Launcher équivalent |

#### Munitions

| Item ID | Qté |
|---|---|
| `Base.ShotgunShells` | 40 |
| `Base.44Clip` | 2 |
| `Base.Bullets44` | 50 |
| `Base.AKClip` | 4 |
| `Base.Bullets762` | 120 |

#### Accessoires d'arme

| Item ID | Qté |
|---|---|
| `Base.Light_Large` | 1 |
| `Base.Sight_4xACOG` | 1 |
| `Base.ForeGrip` | 1 |
| `Base.Cleaning` | 1 |
| `Base.WD` | 1 |

#### Utilitaires & consommables

| Item ID | Qté |
|---|---|
| `Base.Screwdriver` | 1 |
| `Base.TinOpener` | 1 |
| `Base.WaterBottleFull` | 1 |
| `Base.Bandage` | 3 |
| `Base.PillsVitamins` | 2 |
| `Base.TinnedBeans` | 2 |
| `Base.TinnedSoup` | 2 |
| `Base.Crackers` | 1 |
| `Base.CannedPotatoes` | 1 |

#### Armure / vêtements

| Slot | Item ID | Justification |
|---|---|---|
| Hat | `Base.Hat_FAST_Opscore` | Casque balistique (RE7 Not A Hero) |
| Mask | `Base.Hat_M50` | Masque à gaz (RE7 — respirateur signature Chris) |
| TorsoExtra | `Base.Armor_Defender` | Gilet pare-balles lourd |
| Jacket | `Base.Combat_Jumper` | Veste combat |
| Pants | `Base.Combat_Pants` | Pantalon combat |
| Shoes | `Base.Tac_Boots` | Bottes |
| Hands | `Base.Glove_Mechanix_Pact` | Gants |

#### Sac

| Item ID | Justification |
|---|---|
| `Base.Bag_Tactical_Alice` | Sac militaire |

#### bagContents

| Item ID | Qté |
|---|---|
| `Base.ShotgunShells` | 25 |
| `Base.Bullets44` | 25 |
| `Base.AKClip` | 2 |
| `Base.Bullets762` | 60 |
| `Base.PipeBomb` | 1 |
| `Base.Bandage` | 2 |
| `Base.WaterBottleFull` | 1 |
| `Base.TinnedBeans` | 1 |
| `Base.TinnedSoup` | 1 |
| `Base.Crackers` | 1 |
| `Base.Battery` | 2 |

#### Compétences

| Perk | Niveau |
|---|---|
| Strength | 10 |
| Fitness | 9 |
| Aiming | 9 |
| Reloading | 8 |
| Axe | 7 |
| Sprinting | 6 |
| Nimble | 5 |
| LongBlunt | 5 |
| Doctor | 3 |
| Maintenance | 3 |

#### Stats

```lua
stats = { endurance = 0.3, panic = 0, fatigue = 0 }
```

#### equipped

```lua
equipped = {
    primary = "Base.SPAS12_Fixed",
    bag = "Base.Bag_Tactical_Alice",
    clothes = {
        "Base.Hat_FAST_Opscore",
        "Base.Hat_M50",
        "Base.Armor_Defender",
        "Base.Combat_Jumper",
        "Base.Combat_Pants",
        "Base.Tac_Boots",
        "Base.Glove_Mechanix_Pact",
    },
}
```

### Set Vanilla

| Slot | Item | Justification |
|---|---|---|
| Primaire | `Base.Shotgun` | SPAS-12 vanilla |
| Sidearm | `Base.Pistol2` | Magnum vanilla (revolver .44) |
| Secondaire | `Base.AssaultRifle` | AK vanilla |
| Mêlée | `Base.HuntingKnife` | Couteau |
| Sac | `Base.Bag_ALICEpack` | Sac militaire |
| Vêtements | `Base.Boilersuit` | Combination (style BSAA) |

Compétences et stats identiques au set Brita.

---

## 3. Jill Valentine — `jill`

### Profil

BSAA Operative / éclaireuse. Spécialiste pistolet + SMG + explosifs.  
Experte en crochetage (lockpick RE1/RE3), mobilité et précision.  
Plus fragile que Chris mais plus agile.  
Capacité de port : **40** (pas de carry profile spécial)

### Set Brita

#### Armes

| Slot | Item ID | Qté | Justification lore |
|---|---|---|---|
| Primaire (SMG) | `Base.MP5_Stock` | 1 | H&K MP5 (RE5 Mercenaries BSAA loadout) |
| Sidearm | `Base.PPK` | 1 | Samurai Edge / pistolet de précision (RE1 remake, RE3) |
| Secondaire (Pistol) | `Base.CZ75` | 1 | Beretta 92F équivalent (RE1, RE3 sidearm) |
| Mêlée | `Base.HuntingKnife` | 1 | Combat Knife (RE1 Battle Game) |
| Grenades | `Base.PipeBomb` | 3 | Grenade Launcher équivalent (RE1, RE3 signature) |

#### Munitions

| Item ID | Qté |
|---|---|
| `Base.9mmClip` | 5 |
| `Base.Bullets9mm` | 150 |
| `Base.380Clip` | 2 |
| `Base.Bullets380` | 40 |

#### Accessoires d'arme

| Item ID | Qté |
|---|---|
| `Base.Light_Small` | 1 |
| `Base.Sight_MicroDot` | 1 |
| `Base.Suppressor_Pistol` | 1 |
| `Base.Cleaning` | 1 |
| `Base.WD` | 1 |

#### Utilitaires & consommables

| Item ID | Qté |
|---|---|
| `Base.Screwdriver` | 1 |
| `Base.TinOpener` | 1 |
| `Base.WaterBottleFull` | 1 |
| `Base.Bandage` | 3 |
| `Base.PillsVitamins` | 1 |
| `Base.TinnedBeans` | 2 |
| `Base.TinnedSoup` | 2 |
| `Base.Crackers` | 1 |
| `Base.Apple` | 1 |

#### Armure / vêtements

| Slot | Item ID | Justification |
|---|---|---|
| Hat | `Base.Hat_Tactical_Cap` | Casquette tactique (style BSAA Jill) |
| TorsoExtra | `Base.Armor_Defender` | Gilet pare-balles (BSAA operative) |
| Jacket | `Base.Combat_Jumper` | Veste tactique |
| Pants | `Base.Combat_Pants` | Pantalon combat |
| Shoes | `Base.Tac_Boots` | Bottes tactiques |
| Hands | `Base.Glove_Mechanix_Pact` | Gants |

#### Sac

| Item ID | Justification |
|---|---|
| `Base.Bag_D3M` | Chest rig (mobilité légère) |

#### bagContents

| Item ID | Qté |
|---|---|
| `Base.9mmClip` | 3 |
| `Base.Bullets9mm` | 60 |
| `Base.PipeBomb` | 1 |
| `Base.Bandage` | 3 |
| `Base.WaterBottleFull` | 1 |
| `Base.PillsVitamins` | 1 |
| `Base.TinnedBeans` | 1 |
| `Base.TinnedSoup` | 1 |
| `Base.Crackers` | 1 |
| `Base.Torch` | 1 |
| `Base.Battery` | 1 |

#### Compétences

| Perk | Niveau |
|---|---|
| Aiming | 9 |
| Reloading | 9 |
| Sneak | 8 |
| Lightfoot | 8 |
| Nimble | 8 |
| Sprinting | 7 |
| Fitness | 5 |
| Strength | 5 |
| SmallBlade | 5 |
| Electrical | 4 |
| Doctor | 3 |

#### Stats

```lua
stats = { endurance = 0.5, panic = 0, fatigue = 0 }
```

#### equipped

```lua
equipped = {
    primary = "Base.MP5_Stock",
    bag = "Base.Bag_D3M",
    clothes = {
        "Base.Hat_Tactical_Cap",
        "Base.Armor_Defender",
        "Base.Combat_Jumper",
        "Base.Combat_Pants",
        "Base.Tac_Boots",
        "Base.Glove_Mechanix_Pact",
    },
}
```

### Set Vanilla

| Slot | Item | Justification |
|---|---|---|
| Primaire | `Base.Pistol` | Beretta (sidearm signature RE1) |
| Secondaire | `Base.Shotgun` | Shotgun (RE1, RE3) |
| Mêlée | `Base.HuntingKnife` | Combat Knife |
| Sac | `Base.Bag_Schoolbag` | Sac léger (mobilité) |
| Vêtements | — | Pas d'armure vanilla |

Compétences et stats identiques au set Brita.

---

## Intégration technique

### Fichiers à modifier

1. **`media/lua/shared/PZRolePlayingRolesBrita.lua`**
   - `ROLE_ORDER` : ajouter `"leon"`, `"chris"`, `"jill"` (après `"hunk"`)
   - `ROLE_NAMES` : ajouter les 3 IDs
   - `ROLE_INFO` : ajouter les 3 entrées
   - `ROLE_DEFS` : ajouter les 3 définitions complètes

2. **`media/lua/shared/PZRolePlayingRolesVanilla.lua`**
   - `ROLE_ORDER` : ajouter `"leon"`, `"chris"`, `"jill"` (à la fin, avant `"civil"`)
   - `ROLE_NAMES` : ajouter les 3 IDs
   - `ROLE_INFO` : ajouter les 3 entrées
   - `ROLE_DEFS` : ajouter les 3 définitions (armes vanilla)

3. **`media/lua/shared/PZRolePlayingShared.lua`**
   - `ROLE_CARRY_CAPACITY` : ajouter `leon = 50`, `chris = 60`
   - Jill n'a pas de carry profile (sac normal)

4. **`README.md`**
   - Mettre à jour les tableaux Vanilla set et Brita set
   - Mettre à jour le count de rôles (17→20 vanilla, 19→22 Brita)

### Ordre des rôles

**Brita :**
```
"soldat", "voleur", "local_", "medic",
"rambo", "sniper", "agent", "hunk", "samourai", "geek",
"survivaliste", "pompier", "athlete", "eclaireur",
"demolisseur", "invincible", "mule", "builder",
"leon", "chris", "jill",
"civil",
```

**Vanilla :**
```
"soldat", "voleur", "local_", "medic",
"rambo", "sniper", "samourai", "geek",
"survivaliste", "pompier", "athlete", "eclaireur",
"demolisseur", "invincible", "mule", "builder",
"leon", "chris", "jill",
"civil",
```

### ROLE_INFO (Brita)

```lua
leon = { name = "Leon Kennedy", summary = "Agent federal DSO / polyvalent", strengths = "M4A1, VP70, couteau, mobilite" },
chris = { name = "Chris Redfield", summary = "BSAA Heavy Assault / tank", strengths = "SPAS-12, Magnum .44, force brute" },
jill = { name = "Jill Valentine", summary = "BSAA Operative / eclaireuse", strengths = "MP5, explosifs, lockpick, discretion" },
```

### ROLE_INFO (Vanilla)

Identique aux trois entrées ci-dessus.

---

## Comparatif des 4 rôles Resident Evil

| | Hunk | Leon | Chris | Jill |
|---|---|---|---|---|
| **Style** | Fantôme / furtif | Agent polyvalent | Tank / brute force | Éclaireuse / agilité |
| **Primaire** | MP5SD6 (SMG suppressé) | M4A1 (AR) | SPAS-12 (Shotgun) | MP5 (SMG) |
| **Sidearm** | P226 (pistolet 9mm) | VP70 (pistolet 9mm) | M29 .44 (Magnum) | PPK (pistolet .380) |
| **Armure** | Casque + masque gaz | Gilet léger | Casque + masque gaz + gilet | Casquette + gilet |
| **Force** | 8 | 6 | 10 | 5 |
| **Discrétion** | Sneak 10, Lightfoot 9 | Sneak 5, Lightfoot 7 | — | Sneak 8, Lightfoot 8 |
| **Sac** | Tactical Alice | D3M Chest Rig | Tactical Alice | D3M Chest Rig |
| **Capacité port** | 50 | 50 | 60 | — (normal) |

---

## Sources

- [Leon S. Kennedy — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Leon_S._Kennedy)
- [Chris Redfield — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Chris_Redfield)
- [Jill Valentine — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Jill_Valentine)
- [Leon gameplay — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Leon_S._Kennedy/gameplay)
- [Chris gameplay — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Chris_Redfield/gameplay)
- [Jill gameplay — Resident Evil Wiki](https://residentevil.fandom.com/wiki/Jill_Valentine/gameplay)
- [Brita Weapons & Armor — docs/Brita_Weapons_Armor.md](./Brita_Weapons_Armor.md)