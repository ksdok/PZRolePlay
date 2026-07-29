# PZRolePlaying

Standalone Project Zomboid mod for role selection at spawn.

## How it works

- Opens a role picker at spawn.
- Applies the chosen role: items, bag, clothes, skills, stats, carry profile.
- Allows duplicate roles (several players can pick the same one).
- Restores an already-assigned role via `modData.PZRP_role`.
- Automatically migrates legacy test keys (`LR_role` / `LR_localRoleApplied`) to `PZRP_*`.
- Uses the **vanilla** set by default.
- Automatically switches to the **Brita** set when Brita/Arsenal is detected at runtime.
- **All roles** get unlimited carry (`setUnlimitedCarry(true)`) — carry weight has no impact on movement/capacity for every role.

## Out of scope

- No teleportation.
- No waves.
- No community stock.
- No confinement.
- No sandbox bootstrap.
- No modification of vanilla zombies.

## Picker UX

- If the picker is closed manually before a choice, it reopens automatically.
- Once a role is chosen, the picker does not reappear for the current session.
- In MP, the server remains authoritative on role selection.

## Roles

Two role sets are available. The active set is chosen automatically: **vanilla** by default, **Brita** when Brita's Weapon Pack / Arsenal[26] GunFighter is detected. Each role grants a primary weapon, a bag, a clothing/armor loadout, skill levels, and adjusted stats. The vanilla set now includes **20 roles**; the Brita set includes **22 roles**.

### Vanilla set

| Role | Primary | Key skills | Armor / clothes | Bag |
|---|---|---|---|---|
| Soldat | Taurus M9 Pistol | Aiming 7, Reloading 7, Strength 5, Fitness 5 | — | Bag_DuffelBag |
| Voleur | Crowbar | Sneak 8, Lightfoot 8, Nimble 8, Sprinting 6 | — | Bag_Schoolbag |
| Local | Hammer | Carpentry 6, Cooking 6, PlantScavenging 5, Mechanics 4 | — | Bag_NormalHikingBag |
| Medic | Kitchen Knife | Doctor 8, Fitness 4, SmallBlade 4, Strength 3 | — | Bag_DuffelBag |
| Rambo | Axe | Strength 10, Fitness 8, Axe 8, LongBlade 6 | — | Bag_NormalHikingBag |
| Sniper | Howa 1500 Hunting Rifle | Aiming 10, Reloading 8, Sneak 6, Strength 4 | — | Bag_NormalHikingBag |
| Samourai | Katana (Cold Steel) | LongBlade 10, SmallBlade 8, Sprinting 8, Nimble 8 | — | Bag_NormalHikingBag |
| Geek | Screwdriver | Electrical 8, Carpentry 5, Mechanics 4, Cooking 3 | — | Bag_NormalHikingBag |
| Survivaliste | Howa 1500 Hunting Rifle | PlantScavenging 8, Trapping 8, Aiming 6, Sneak 6 | — | Bag_ALICEpack |
| Pompier | Axe | Strength 8, Fitness 7, Axe 7, LongBlunt 5 | — | Bag_ALICEpack |
| Athlete | Machete | Sprinting 10, Fitness 10, Nimble 8, Lightfoot 7 | — | Bag_Schoolbag |
| Eclaireur | Machete | Sneak 8, Lightfoot 7, Sprinting 6, Aiming 5 | — | Bag_Schoolbag |
| Demolisseur | Sledgehammer | Electrical 8, Mechanics 7, Strength 6, Fitness 5 | — | Bag_ALICEpack |
| Invincible | M16A1 | Aiming 10, Reloading 10, Strength 10, Fitness 10 | — | Bag_ALICEpack_Army |
| Mule | Crowbar | Strength 10, Sprinting 10, Fitness 7, Carpentry 4 | — | Bag_ALICEpack_Army |
| Builder | Crowbar | Carpentry 10, Electrical 10, MetalWelding 10, Mechanics 10 | Boilersuit | Bag_BigHikingBag |
| Leon Kennedy | Assault Rifle 2 + 9mm Pistol | Aiming 9, Reloading 9, Nimble 8, Sprinting 7 | — | Bag_DuffelBag |
| Chris Redfield | Shotgun + Pistol2 + Assault Rifle | Strength 10, Fitness 9, Aiming 9, Axe 7 | Boilersuit | Bag_ALICEpack |
| Jill Valentine | 9mm Pistol + Shotgun | Aiming 9, Reloading 9, Sneak 8, Nimble 8 | — | Bag_Schoolbag |
| Civil | Kitchen Knife | Carpentry 3, Trapping 3, Fitness 1, Strength 1 | — | Bag_Schoolbag |

### Brita set

Active when Brita's Weapon Pack + Arsenal[26] GunFighter (+ Brita's Armor Pack for clothing) are loaded. Weapons, magazines, ammo and armor come from those mods.

| Role | Primary | Key skills | Armor / clothes | Bag |
|---|---|---|---|---|
| Soldat | Colt M4A1 Carbine | Aiming 9, Nimble 9, Strength 8, Fitness 8 | Military Field Shirts, Military Field Pants, Ops-Core FAST Ballistic Helmet, Coyote Tactical Boots | D3M Chest Rig (Front) |
| Voleur | Walther PPK | Sneak 9, Sprinting 8, Lightfoot 7, Nimble 6 | GEN3 Hooded Tactical Shirts, Striker XT Combat Pants, Coyote Tactical Boots, Mechanix Wear Covert Gloves | D3M Chest Rig (Front) |
| Local | Hammer | Carpentry 8, Cooking 6, Mechanics 6, Electrical 6 | Turtleneck, Combat Pants, Tac Boots, Leather Gloves | Bag_NormalHikingBag |
| Medic | Kitchen Knife | Doctor 10, SmallBlade 9, Strength 5, Fitness 5 | Turtleneck, Combat Pants, Tac Boots, Mechanix Gloves | Bag_DuffelBag |
| Rambo | Axe | Axe 10, Strength 10, Fitness 9, Reloading 9 | Quarter Zip Combat Shirts, Striker XT Combat Pants, MASKA-1SCh Helmet, Coyote Tactical Boots | Military Combat Webbing Set (Front) |
| Sniper | Remington M40A3 Rifle | Aiming 10, Nimble 9, Reloading 8, Strength 7 | Bars Gorka 4 Camouflage Jacket, Bars Gorka 4 Camouflage Pants, Military PASGT Helmet w/ Neck Protection, Coyote Tactical Boots | D3M Chest Rig (Front) |
| 007 Agent | Walther PPK | Aiming 10, Reloading 10, Nimble 9, Lightfoot 9 | Tactical Cap, Slim Fit Suit Jacket, Combat Pants, Tac Boots, Mechanix Covert Gloves | Military Alice Backpack |
| Hunk | MP5SD6 + P226 + M870 CQB | Aiming 10, Sneak 10, Lightfoot 9, Nimble 9 | FAST Ops-Core Helmet, M50 Gas Mask, Defender Armor, Combat Uniform | Military Alice Backpack |
| Samourai | Katana (Cold Steel) | LongBlade 10, Sprinting 10, Strength 9, Fitness 9 | Elzbieta Bosak's Tactical Jacket, Elzbieta Bosak's Tactical Leggings, Coyote Tactical Boots, Mechanix Wear Covert Gloves | D3M Chest Rig (Front) |
| Geek | Screwdriver | Electrical 10, Sneak 10, Trapping 9, Lightfoot 8 | Long Shirt, Combat Pants, Tac Boots | Bag_NormalHikingBag |
| Survivaliste | Howa 1500 Hunting Rifle | Trapping 10, Aiming 8, Strength 7, Fitness 7 | Bars Gorka 4 Camouflage Jacket, Bars Gorka 4 Camouflage Pants, Military PASGT Helmet w/ Neck Protection, Trackstar Tactical Boots | D3M Chest Rig (Front) |
| Pompier | Axe | Strength 9, Fitness 9, Axe 9, LongBlunt 9 | Fire Jacket, Fire Pants, Tac Boots, Leather Gloves | Bag_ALICEpack |
| Athlete | Machete | Sprinting 10, Fitness 10, Nimble 8, Lightfoot 7 | Adidas Jacket, Adidas Pants, Tac Boots | Bag_Schoolbag |
| Eclaireur | H&K MP7 | Sneak 10, Lightfoot 10, Sprinting 10, Fitness 8 | GEN3 Hooded Tactical Shirts, Striker XT Combat Pants, AN PVS-15 Night Vision Goggles, Coyote Tactical Boots | D3M Chest Rig (Front) |
| Demolisseur | Model 870 MCS:18"BBL | Strength 8, Axe 8, Aiming 8, Nimble 8 | Quarter Zip Combat Shirts, Striker XT Combat Pants, EOD 9A Heavy Protection Helmet, Coyote Tactical Boots | Military Alice Backpack |
| Invincible | M249E2 LMG | Aiming 10, Reloading 10, Strength 10, Fitness 10 | FORT Defender 2 Emerald Armor, Quarter Zip Combat Shirts, Striker XT Combat Pants, Military PASGT Helmet | Military Alice Backpack |
| Mule | Crowbar | Strength 10, Fitness 10, Sprinting 10, Carpentry 4 | Military Field Shirts, Military Field Pants, M1 Helmet, Coyote Tactical Boots, Long Leather Work Gloves | Military Alice Backpack |
| Builder | Crowbar | Carpentry 10, Electrical 10, MetalWelding 10, Mechanics 10 | Boilersuit | Bag_BigHikingBag |
| Leon Kennedy | M4A1 + VP70 + M870 Police | Aiming 9, Reloading 9, Nimble 8, Sprinting 7 | Combat Jumper, Combat Pants, Tac Boots, Mechanix Pact Gloves, Defender Armor | D3M Chest Rig (Front) |
| Chris Redfield | SPAS-12 + M29 .44 + AK103 | Strength 10, Fitness 9, Aiming 9, Axe 7 | FAST Ops-Core Helmet, M50 Gas Mask, Defender Armor, Combat Uniform | Military Alice Backpack |
| Jill Valentine | MP5 + PPK + CZ75 | Aiming 9, Reloading 9, Sneak 8, Nimble 8 | Tactical Cap, Defender Armor, Combat Jumper, Combat Pants, Tac Boots | D3M Chest Rig (Front) |
| Civil | Kitchen Knife | Carpentry 3, Trapping 3, Fitness 1, Strength 1 | Short Shirt, Combat Pants, Tac Boots | Bag_Schoolbag |

> Brita now adds two extra exclusive roles vs vanilla: **007 Agent** (`agent`) and **Hunk** (`hunk`). Leon, Chris, and Jill are available in both sets.

## Main files

- `media/lua/shared/PZRolePlayingRoles.lua` — active set selection (vanilla/Brita) + persisted-key migration.
- `media/lua/shared/PZRolePlayingRolesVanilla.lua` — vanilla role definitions.
- `media/lua/shared/PZRolePlayingRolesBrita.lua` — Brita role definitions.
- `media/lua/shared/PZRolePlayingShared.lua` — loadout helpers (item creation, equip, stats).
- `media/lua/client/PZRolePlayingRolePicker.lua` — picker UI.
- `media/lua/client/PZRolePlayingClient.lua` — solo/MP client flow.
- `media/lua/server/PZRolePlayingServer.lua` — authoritative MP server flow.

## Notes

- Standalone folder: `../PZRolePlay`.
- `name=PZRolePlaying`, `id=PZRolePlaying`.
- Persistence namespace: `PZRP_role`.
