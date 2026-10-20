class_name Defs
extends RefCounted
## All static game data of Pixel TD: classes, difficulties, towers, enemies and the wave generator.
# ---------------------------------------------------------------- enemy classes
# Class only weakens CONTROL effects (stun, slow...). Damage of any kind is never reduced by class.
const CLASS_ROMAN := ["", "I", "II", "III", "IV"]
const CLASS_EFFECT := [1.0, 1.0, 0.7, 0.4, 0.2]
const CLASS_COLORS := [Color.WHITE, Color("c0cbdc"), Color("63c74d"), Color("feae34"), Color("e43b44")]

# ---------------------------------------------------------------- difficulties
const DIFFICULTIES := [
	{"id": "light", "name": "Light", "lives": 200, "cash": 800, "hp": 0.8, "cost": 0.85, "waves": 20,
		"sell": 0.8, "color": Color("63c74d"), "btn": "green",
		"desc": "20 waves. Weaker enemies, cheaper towers, 200 lives.",
		"bonus_multi": 1.2},
	{"id": "medium", "name": "Medium", "lives": 150, "cash": 650, "hp": 1.0, "cost": 1.0, "waves": 30,
		"sell": 0.7, "color": Color("0099db"), "btn": "blue",
		"desc": "30 waves. The standard challenge, 150 lives.",
		"bonus_multi": 1.0},
	{"id": "difficult", "name": "Difficult", "lives": 100, "cash": 600, "hp": 1.12, "cost": 1.08, "waves": 40,
		"sell": 0.7, "color": Color("f77622"), "btn": "gold",
		"desc": "40 waves. Tougher enemies, pricier towers, 100 lives.",
		"bonus_multi": 0.95},
	{"id": "hardcore", "name": "Hardcore", "lives": 1, "cash": 650, "hp": 1.12, "cost": 1.08, "waves": 40,
		"sell": 0.0, "color": Color("e43b44"), "btn": "red",
		"desc": "40 waves. ONE life. Towers can't be sold.",
		"bonus_multi": 0.7},
]

# ---------------------------------------------------------------- towers
# "base" holds level-0 stats; each upgrade overrides some of them ("set"). Upgrades are a single line.
const TOWER_ORDER := ["gunner", "knight", "soldier", "garage", "flamer", "sniper", "necro", "freezer", "toxic",
	"assassin"]
const TOWERS := {
	"gunner": {
		"name": "Gunslinger", "role": "Ranged - single target", "cost": 200, "sprite": "gunner",
		"desc": "Quick pistol shots at one target. Armor reduces each bullet.",
		"unlock": {},
		"base": {"damage": 3, "rate": 2.0, "range": 72, "targets": 1, "slow": 0.0, "slow_time": 0.0,
			"kind": "physical", "armor_pierce": 0.0, "camo": false, "air": true},
		"upgrades": [
			{"name": "Quick Draw", "icon": "quick_draw", "cost": 150, "desc": "Fire rate +50%.", "set": {"rate": 3.0}},
			{"name": "Hollow Points", "icon": "hollow_points", "cost": 340,
				"desc": "Damage 3 > 5. Range +12. Spots INVISIBLE enemies.",
				"set": {"damage": 5, "range": 84, "camo": true}},
			{"name": "Dual Pistols", "icon": "dual_pistols", "cost": 800,
				"desc": "Shoots 2 targets, damage 7. Bullets slow by 35% (control).",
				"set": {"targets": 2, "damage": 7, "slow": 0.35, "slow_time": 0.7, "rate": 3.4}},
			{"name": "Fan the Hammer", "icon": "fan_hammer", "cost": 2400,
				"desc": "Damage 7 > 10, fires faster.",
				"set": {"damage": 10, "rate": 4.2}},
			{"name": "Sharpshooter", "icon": "sharpshooter", "cost": 6000,
				"desc": "Shoots 3 targets, damage 18. Bullets ignore half of armor, slow by 45%.",
				"set": {"targets": 3, "damage": 18, "rate": 4.5, "armor_pierce": 0.5, "slow": 0.45}},
			{"name": "Legend of the West", "icon": "legend_west", "cost": 14000,
				"desc": "Shoots 4 targets at once, damage 36. Ignores 3/4 of armor, slows by 50%.",
				"set": {"targets": 4, "damage": 36, "rate": 5.0, "armor_pierce": 0.75, "slow": 0.5, "slow_time": 0.9}},
		],
	},
	"knight": {
		"name": "Knight", "role": "Melee - stuns", "cost": 250, "sprite": "knight",
		"desc": "Heavy sword. Ignores half of armor. Every 3rd hit stuns (control).",
		"unlock": {},
		"base": {"damage": 10, "rate": 0.9, "range": 30, "cleave": false, "stun_every": 3, "stun": 0.5,
			"aura": 0.0, "kind": "physical", "armor_pierce": 0.5, "camo": false, "air": false},
		"upgrades": [
			{"name": "Sharpened Blade", "icon": "sharpened_blade", "cost": 190, "desc": "Damage 10 > 17, swings faster.",
				"set": {"damage": 17, "rate": 1.1}},
			{"name": "Cleave", "icon": "cleave", "cost": 420, "desc": "Swings hit ALL enemies in range. Range +4.",
				"set": {"cleave": true, "range": 34}},
			{"name": "Champion", "icon": "champion", "cost": 1000, "desc": "Damage 38. Every 2nd hit stuns for 0.8s.",
				"set": {"damage": 38, "rate": 1.3, "stun_every": 2, "stun": 0.8, "armor_pierce": 0.75}},
			{"name": "Templar", "icon": "templar", "cost": 2500, "desc": "Damage 38 > 70, swings faster.",
				"set": {"damage": 70, "rate": 1.4}},
			{"name": "Paladin", "icon": "paladin", "cost": 6000, "desc": "Damage 140. Cuts through ANY armor.",
				"set": {"damage": 140, "rate": 1.5, "armor_pierce": 1.0}},
			{"name": "Holy Champion", "icon": "holy_champion", "cost": 15000,
				"desc": "Damage 300. Holy aura: towers within 48 px deal 15% more damage.",
				"set": {"damage": 300, "rate": 1.6, "aura": 0.15}},
		],
	},
	"soldier": {
		"name": "Soldier", "role": "Ranged - bursts, anti-armor", "cost": 300, "sprite": "soldier",
		"desc": "Assault rifle firing 3-round bursts from long range.",
		"unlock": {"map": "meadow", "difficulty": 1},
		"base": {"damage": 3, "rate": 0.8, "burst": 3, "burst_gap": 0.09, "range": 92, "armor_pierce": 0.0,
			"grenade_every": 0, "grenade_dmg": 0, "grenade_radius": 0, "kind": "physical",
			"camo": false, "air": true},
		"upgrades": [
			{"name": "AP Rounds", "icon": "ap_rounds", "cost": 230,
				"desc": "Bullets ignore 75% of armor. Damage 3 > 4. Spots INVISIBLE enemies.",
				"set": {"armor_pierce": 0.75, "damage": 4, "camo": true}},
			{"name": "Grenades", "icon": "grenades", "cost": 500,
				"desc": "Every 3rd burst also throws a grenade (30 dmg) that hits a whole area.",
				"set": {"grenade_every": 3, "grenade_dmg": 30, "grenade_radius": 24}},
			{"name": "Machine Gun", "icon": "machine_gun", "cost": 1200,
				"desc": "Long 8-round bursts. Damage 4 > 5. Grenades every 2nd burst.",
				"set": {"burst": 8, "burst_gap": 0.06, "rate": 1.0, "damage": 5, "grenade_every": 2}},
			{"name": "Elite Soldier", "icon": "headshot", "cost": 2000,
				"desc": "Long 11-round bursts, and faster. Damage 5 > 6.",
				"set": {"burst": 11, "burst_gap": 0.06, "rate": 1.1, "damage": 6, "grenade_every": 2}},
			{"name": "Heavy Gunner", "icon": "heavy_gunner", "cost": 6500,
				"desc": "14-round bursts, damage 11. Grenades hit for 60.",
				"set": {"burst": 14, "rate": 1.15, "damage": 11, "grenade_dmg": 60}},
			{"name": "Commando", "icon": "commando", "cost": 16000,
				"desc": "16-round bursts, damage 24. Grenades hit for 150 over a bigger area.",
				"set": {"burst": 16, "burst_gap": 0.05, "rate": 1.2, "damage": 24, "grenade_dmg": 150,
					"grenade_radius": 30}},
		],
	},
	"garage": {
		"name": "Garage", "role": "Road - friendly cars", "cost": 400, "sprite": "garage",
		"desc": "Build next to a road. Sends cars that drive INTO the enemies, invisible ones too. On a crash both lose the HP of the weaker one.",
		"unlock": {"map": "gas_station", "difficulty": 2},
		"base": {"interval": 6.0, "car_hp": 20, "car_speed": 70, "vehicle": "car",
			"gun_dmg": 0, "gun_rate": 0.0, "range": 0,
			"camo": true, "air": false},
		"upgrades": [
			{"name": "Pickup", "icon": "pickup", "cost": 260, "desc": "Sturdier car (40 HP), comes out more often.",
				"set": {"vehicle": "pickup", "car_hp": 40, "interval": 5.0}},
			{"name": "Truck", "icon": "truck", "cost": 580, "desc": "Heavy truck with 75 HP. Plows through crowds.",
				"set": {"vehicle": "truck", "car_hp": 75, "car_speed": 60}},
			{"name": "Armored Car", "icon": "armored", "cost": 1350,
				"desc": "110 HP and a turret that shoots while driving.",
				"set": {"vehicle": "armored", "car_hp": 110, "gun_dmg": 4, "gun_rate": 2.5, "interval": 4.5}},
			{"name": "Reinforced Plating", "icon": "plating", "cost": 3000,
				"desc": "250 HP, turret 8 dmg, comes out more often.",
				"set": {"car_hp": 250, "gun_dmg": 8, "gun_rate": 3.0, "interval": 4.0}},
			{"name": "Twin Turret", "icon": "twin_turret", "cost": 7000,
				"desc": "600 HP. Two turrets: 20 dmg, faster.",
				"set": {"car_hp": 600, "gun_dmg": 20, "gun_rate": 4.0}},
			{"name": "Armored Convoy", "icon": "convoy", "cost": 16000,
				"desc": "1500 HP, turret 40 dmg, a car every 3 seconds.",
				"set": {"car_hp": 1500, "gun_dmg": 40, "gun_rate": 4.0, "interval": 3.0}},
		],
	},
	"flamer": {
		"name": "Flamethrower", "role": "Close - area burn", "cost": 400, "sprite": "flamer",
		"desc": "Sprays fire in a cone and sets enemies ablaze. Fire ignores armor. Can't aim at invisible enemies, but the flames still burn them.",
		"unlock": {"map": "volcano", "difficulty": 1},
		"base": {"damage": 1.0, "range": 46, "cone": 56.0, "burn": 2.0, "burn_time": 2.0, "fire_pierce": 0.0,
			"kind": "fire", "camo": false, "air": false},
		"upgrades": [
			{"name": "Bigger Tank", "icon": "bigger_tank", "cost": 300, "desc": "Range 46 > 58. Wider cone.",
				"set": {"range": 58, "cone": 72.0}},
			{"name": "Napalm", "icon": "napalm", "cost": 600, "desc": "Burn 2 > 6 dps for 3s. Spray damage +40%.",
				"set": {"burn": 6.0, "burn_time": 3.0, "damage": 1.4}},
			{"name": "Blue Flame", "icon": "blue_flame", "cost": 1400, "desc": "Spray 25 dps, burn 12. Ignores half of fire resistance.",
				"set": {"damage": 2.5, "burn": 12.0, "fire_pierce": 0.5}},
			{"name": "Pyromania", "icon": "blue_flame", "cost": 2500, "desc": "Spray 40 dps, burn 18. Ignores 3/4 of fire resistance.",
				"set": {"damage": 4.0, "burn": 18.0, "fire_pierce": 0.75}},
			{"name": "Inferno", "icon": "inferno", "cost": 7000, "desc": "Spray 80 dps, burn 40. Longer, wider flames.",
				"set": {"damage": 8.0, "burn": 40.0, "range": 64, "cone": 80.0}},
			{"name": "Dragon's Breath", "icon": "dragon_breath", "cost": 16000,
				"desc": "Spray 180 dps, burn 70 for 4s. Burns through ANY fire resistance.",
				"set": {"damage": 18.0, "burn": 70.0, "burn_time": 4.0, "fire_pierce": 1.0, "range": 70}},
		],
	},
	"sniper": {
		"name": "Sniper", "role": "Ranged - huge range, sees all", "cost": 400, "sprite": "sniper",
		"desc": "Slow, heavy shots from across the map. Sees INVISIBLE and hits FLYING enemies.",
		"unlock": {"map": "meadow", "difficulty": 2},
		"base": {"damage": 15, "rate": 0.45, "range": 170, "armor_pierce": 0.3, "headshot": 0.0,
			"kind": "physical", "camo": true, "air": true},
		"upgrades": [
			{"name": "Optics", "icon": "optics", "cost": 240, "desc": "Range 170 > 240. Damage 15 > 22.",
				"set": {"range": 240, "damage": 22}},
			{"name": "Full Metal Jacket", "icon": "fmj", "cost": 480,
				"desc": "Ignores ALL armor. Damage 22 > 42, shoots faster.",
				"set": {"armor_pierce": 1.0, "damage": 42, "rate": 0.55}},
			{"name": "Headshot", "icon": "headshot", "cost": 1300,
				"desc": "Damage 80. 15% chance to kill any non-boss enemy outright.",
				"set": {"damage": 80, "rate": 0.65, "headshot": 0.15}},
			{"name": "Elite Sniper", "icon": "headshot", "cost": 1850,
				"desc": "Damage 95 and faster rate. 20% chance to kill any non-boss enemy outright.",
				"set": {"damage": 95, "rate": 0.70, "headshot": 0.20}},
			{"name": "Anti-Material Rifle", "icon": "anti_material", "cost": 7000,
				"desc": "Damage 220 a shot.",
				"set": {"damage": 220}},
			{"name": "Deadeye", "icon": "deadeye", "cost": 17000,
				"desc": "Damage 450, shoots faster. 25% chance to kill any non-boss enemy outright.",
				"set": {"damage": 450, "rate": 0.75, "headshot": 0.25}},
		],
	},
	# Halloween event character (can be unlocked any time of the year)
	"necro": {
		"name": "Necromancer", "role": "Magic - raises the dead", "cost": 450, "sprite": "necro",
		"desc": "Dark bolts that ignore most armor. Enemies it finishes off rise as FRIENDLY undead somewhere on the road in its range, walk back and crash into enemies. Never raises flyers or bosses.",
		"unlock": {"map": "graveyard", "difficulty": 2},
		"base": {"damage": 9, "rate": 1.0, "range": 80, "armor_pierce": 0.6, "raise_hp": 0.2, "raise_class": 1,
			"kind": "physical", "camo": false, "air": true},
		"upgrades": [
			{"name": "Dark Pact", "icon": "dark_pact", "cost": 260,
				"desc": "Undead keep 35% HP. Raises class II too. Damage 9 > 13.",
				"set": {"raise_hp": 0.35, "raise_class": 2, "damage": 13}},
			{"name": "Bone Army", "icon": "bone_army", "cost": 620,
				"desc": "Undead keep 50% HP. Damage 22, faster bolts. Spots INVISIBLE enemies.",
				"set": {"raise_hp": 0.5, "damage": 22, "rate": 1.2, "camo": true}},
			{"name": "Lich", "icon": "lich", "cost": 1500,
				"desc": "Undead keep 70% HP. Raises class III. Damage 40.",
				"set": {"raise_hp": 0.7, "raise_class": 3, "damage": 40, "rate": 1.3}},
			{"name": "Soul Harvest", "icon": "soul_harvest", "cost": 3000,
				"desc": "Undead keep 85% HP. Damage 60, faster bolts.",
				"set": {"raise_hp": 0.85, "damage": 60, "rate": 1.4}},
			{"name": "Lord of Bones", "icon": "lord_bones", "cost": 7500,
				"desc": "Undead keep ALL their HP. Damage 100.",
				"set": {"raise_hp": 1.0, "damage": 100, "rate": 1.5}},
			{"name": "Lich King", "icon": "lich_king", "cost": 16000,
				"desc": "Undead come back STRONGER: 130% of their HP. Damage 150.",
				"set": {"raise_hp": 1.3, "damage": 150, "rate": 1.6}},
		],
	},
	"freezer": {
		"name": "Freezer", "role": "Close - chills and freezes", "cost": 350, "sprite": "freezer",
		"desc": "Hoses enemies in a cone with ice water. Soaked enemies slow down more and more, then freeze solid in a block of ice. Higher classes chill slower and thaw faster. Water puts out burning enemies, and fire melts the ice.",
		"unlock": {"map": "frozen_lake", "difficulty": 2},
		"base": {"damage": 0.0, "range": 44, "cone": 60.0, "chill": 0.45, "chill_slow": 0.35, "freeze": 1.0,
			"brittle": 0.0, "kind": "cold", "camo": false, "air": false},
		"upgrades": [
			{"name": "Cold Water", "icon": "cold_water", "cost": 220,
				"desc": "Colder water: chills faster (45% > 65% a second), slows up to 45%.",
				"set": {"chill": 0.65, "chill_slow": 0.45}},
			{"name": "Pressure Hose", "icon": "pressure_hose", "cost": 380,
				"desc": "Range 44 > 56, wider cone. Frozen for 1.5s.",
				"set": {"range": 56, "cone": 72.0, "freeze": 1.5}},
			{"name": "Ice Water", "icon": "ice_water", "cost": 750,
				"desc": "Ice-cold water now hurts: 6 dps that ignores armor. Chills faster, frozen for 2s.",
				"set": {"damage": 0.6, "chill": 0.9, "chill_slow": 0.55, "freeze": 2.0}},
			{"name": "Liquid Nitrogen", "icon": "nitrogen", "cost": 1800,
				"desc": "Swaps water for liquid nitrogen: 15 dps, freezes very fast, frozen for 2.5s.",
				"set": {"damage": 1.5, "chill": 1.4, "chill_slow": 0.65, "freeze": 2.5}},
			{"name": "Cryo Cannon", "icon": "cryo_cannon", "cost": 6500,
				"desc": "60 dps, range 64, frozen for 3s.",
				"set": {"damage": 6.0, "chill": 1.8, "range": 64, "freeze": 3.0}},
			{"name": "Absolute Zero", "icon": "absolute_zero", "cost": 15000,
				"desc": "150 dps, slows up to 75%. Enemies it freezes take 25% more damage from everything.",
				"set": {"damage": 15.0, "chill": 2.4, "chill_slow": 0.75, "freeze": 3.5, "brittle": 0.25}},
		],
	},
	# acid towers: acid hurts over time through armor and eats some armor while it lasts
	"toxic": {
		"name": "Toxic Gunner", "role": "Ranged - acid", "cost": 350, "sprite": "toxic",
		"desc": "Shoots globs of acid. Acid burns through armor over time and eats some of the armor while it lasts, so every other tower hits harder too.",
		"unlock": {"map": "refinery", "difficulty": 2},
		"base": {"damage": 2, "rate": 1.2, "range": 80, "acid_dps": 3.0, "acid_time": 3.0, "acid_shred": 1.0,
			"splash": 0.0, "kind": "physical", "camo": false, "air": true},
		"upgrades": [
			{"name": "Corrosive Mix", "icon": "corrosive_mix", "cost": 220,
				"desc": "Stronger acid: 3 > 6 dps, eats 2 armor.",
				"set": {"acid_dps": 6.0, "acid_shred": 2.0}},
			{"name": "Scope", "icon": "toxic_scope", "cost": 380,
				"desc": "Range 80 > 96, shoots faster. Spots INVISIBLE enemies.",
				"set": {"range": 96, "rate": 1.5, "camo": true}},
			{"name": "Acid Splash", "icon": "acid_splash", "cost": 700,
				"desc": "Globs burst: everyone within 18 px of the target gets the acid too.",
				"set": {"splash": 18.0}},
			{"name": "Toxic Overload", "icon": "toxic_overload", "cost": 1600,
				"desc": "Acid 15 dps for 4s, eats 4 armor. Damage 6, faster, bigger splash.",
				"set": {"damage": 6, "rate": 1.8, "acid_dps": 15.0, "acid_time": 4.0, "acid_shred": 4.0, "splash": 24.0}},
			{"name": "Biohazard", "icon": "biohazard", "cost": 6000,
				"desc": "Acid 45 dps, eats 8 armor. Damage 12, bigger splash.",
				"set": {"damage": 12, "acid_dps": 45.0, "acid_shred": 8.0, "splash": 30.0}},
			{"name": "Plague", "icon": "plague", "cost": 14000,
				"desc": "Acid 120 dps for 5s, eats 15 armor. Damage 25, huge splash.",
				"set": {"damage": 25, "rate": 2.0, "acid_dps": 120.0, "acid_time": 5.0, "acid_shred": 15.0, "splash": 36.0}},
		],
	},
	"assassin": {
		"name": "Toxic Assassin", "role": "Melee - fast, acid, daggers", "cost": 450, "sprite": "assassin",
		"desc": "Quick poisoned blades up close. From level 4 the Assassin also throws daggers at range, and the daggers reach FLYING enemies.",
		"unlock": {"map": "refinery", "difficulty": 3},
		"base": {"damage": 6, "rate": 2.0, "range": 28, "armor_pierce": 0.25, "acid_dps": 4.0, "acid_time": 2.0,
			"acid_shred": 1.0, "dagger_dmg": 0, "dagger_rate": 0.0, "dagger_range": 0, "daggers": 0,
			"kind": "physical", "camo": false, "air": false},
		"upgrades": [
			{"name": "Poisoned Blades", "icon": "poisoned_blades", "cost": 260,
				"desc": "Acid 4 > 8 dps, eats 2 armor.",
				"set": {"acid_dps": 8.0, "acid_shred": 2.0}},
			{"name": "Swift Strikes", "icon": "swift_strikes", "cost": 420,
				"desc": "Attacks 2 > 2.8 times a second, damage 6 > 8.",
				"set": {"rate": 2.8, "damage": 8}},
			{"name": "Throwing Daggers", "icon": "throwing_daggers", "cost": 700,
				"desc": "NEW ATTACK: throws a poisoned dagger (10 dmg) at range 90. Daggers hit FLYING enemies.",
				"set": {"dagger_dmg": 10, "dagger_rate": 1.2, "dagger_range": 90, "daggers": 1}},
			{"name": "Twin Daggers", "icon": "twin_daggers", "cost": 1100,
				"desc": "Throws 2 daggers at once, 12 dmg. Spots INVISIBLE enemies.",
				"set": {"dagger_dmg": 12, "daggers": 2, "camo": true}},
			{"name": "Master Assassin", "icon": "master_assassin", "cost": 2200,
				"desc": "Blades 17 dmg, 3.2 attacks a second, acid 18 dps eating 4 armor. Daggers 17 dmg, faster.",
				"set": {"damage": 17, "rate": 3.2, "acid_dps": 18.0, "acid_shred": 4.0, "dagger_dmg": 17,
					"dagger_rate": 1.6}},
			{"name": "Shadow Blade", "icon": "shadow_blade", "cost": 16000,
				"desc": "Blades 120 dmg, 3.6 a second, acid 60 dps eating 8 armor. Throws 3 daggers of 40.",
				"set": {"damage": 120, "rate": 3.6, "acid_dps": 60.0, "acid_shred": 8.0, "dagger_dmg": 40,
					"daggers": 3, "dagger_rate": 2.0}},
		],
	},
}

# ---------------------------------------------------------------- enemies
const ENEMY_ORDER := ["slime", "rat", "bat", "goblin", "skeleton", "wolf", "ironclad", "imp", "ghost",
	"berserker", "shaman", "slime_king", "harpy", "ogre", "golem", "demon"]
const ENEMIES := {
	"slime": {"name": "Slime", "class": 1, "hp": 12, "speed": 28, "bounty": 2, "radius": 6,
		"desc": "Bouncy and squishy."},
	"rat": {"name": "Sewer Rat", "class": 1, "hp": 8, "speed": 56, "bounty": 2, "radius": 5,
		"desc": "Small and very fast."},
	"goblin": {"name": "Goblin", "class": 1, "hp": 26, "speed": 34, "bounty": 3, "radius": 6,
		"desc": "Standard foot soldier."},
	"bat": {"name": "Bat", "class": 1, "hp": 9, "speed": 52, "bounty": 2, "radius": 5, "flying": true,
		"desc": "Flies in swarms. Melee, fire and cars can't reach it."},
	"skeleton": {"name": "Skeleton", "class": 1, "hp": 28, "speed": 32, "bounty": 3, "radius": 6, "revive": 0.5,
		"desc": "Falls apart, then gets back up once with half HP."},
	"ghost": {"name": "Ghost", "class": 2, "hp": 60, "speed": 36, "bounty": 6, "radius": 6, "invisible": true,
		"desc": "Invisible. Only towers that spot invisible enemies can aim at it."},
	"berserker": {"name": "Orc Berserker", "class": 2, "hp": 130, "speed": 28, "bounty": 9, "radius": 7,
		"rage": 2.0, "desc": "Runs twice as fast once below half HP."},
	"harpy": {"name": "Harpy", "class": 3, "hp": 420, "speed": 30, "bounty": 22, "radius": 8, "flying": true,
		"armor": 1, "desc": "Tough flyer. Ground and melee towers can't touch her."},
	"wolf": {"name": "Dire Wolf", "class": 2, "hp": 40, "speed": 56, "bounty": 5, "radius": 7,
		"desc": "Runs past slow defences."},
	"ironclad": {"name": "Ironclad", "class": 2, "hp": 80, "speed": 25, "bounty": 7, "radius": 7, "armor": 4,
		"desc": "Heavy armor. Pistol bullets barely scratch it."},
	"imp": {"name": "Fire Imp", "class": 2, "hp": 55, "speed": 40, "bounty": 6, "radius": 6, "fire_res": 1.0,
		"desc": "Born in flames. Fire does nothing."},
	"shaman": {"name": "Goblin Shaman", "class": 3, "hp": 170, "speed": 30, "bounty": 12, "radius": 7,
		"heal": 0.12, "desc": "Heals nearby enemies."},
	"slime_king": {"name": "Slime King", "class": 3, "hp": 360, "speed": 24, "bounty": 20, "radius": 9,
		"split": 6, "desc": "Bursts into slimes when defeated."},
	"ogre": {"name": "Ogre", "class": 3, "hp": 520, "speed": 22, "bounty": 25, "radius": 9, "armor": 2,
		"desc": "Big, slow and stubborn."},
	"golem": {"name": "Stone Golem", "class": 4, "hp": 3000, "speed": 15, "bounty": 150, "radius": 12,
		"armor": 4, "desc": "BOSS. Living rock. Shrugs off weak hits."},
	"demon": {"name": "Demon Lord", "class": 4, "hp": 16000, "speed": 17, "bounty": 300, "radius": 13,
		"armor": 4, "fire_res": 0.5, "desc": "FINAL BOSS. Lord of the burning pit."},
}

# ---------------------------------------------------------------- friendly units (sent by the Garage)
# They are Enemy nodes with is_friendly = true: drive backwards along the road and crash into enemies.
# HP and speed come from the garage's stats (car_hp / car_speed).
const VEHICLES := {
	"car": {"name": "Car", "radius": 6, "desc": "Friendly. Crashes into enemies."},
	"pickup": {"name": "Pickup", "radius": 7, "desc": "Friendly. Crashes into enemies."},
	"truck": {"name": "Truck", "radius": 8, "desc": "Friendly. Crashes into enemies."},
	"armored": {"name": "Armored Car", "radius": 8, "desc": "Friendly. Crashes and shoots."},
}

# first wave each enemy may appear in, and its "threat cost" for the wave budget
const POOL := [
	["slime", 1, 1.2], ["rat", 4, 1.0], ["goblin", 5, 2.6], ["bat", 8, 2.2], ["skeleton", 9, 4.2],
	["wolf", 10, 4.5], ["ironclad", 11, 9.0], ["ghost", 12, 7.0], ["imp", 13, 5.5], ["berserker", 15, 11.0],
	["shaman", 16, 17.0], ["slime_king", 19, 36.0], ["harpy", 21, 42.0], ["ogre", 23, 52.0],
]
# placement limits per battle: all towers together, and per tower type unless the tower sets its own "limit"
const MAX_TOWERS := 50
const MAX_PER_TYPE := 10

# readable names for stats (tower info screens)
const STAT_LABELS := {"damage": "Damage", "rate": "Attacks/s", "range": "Range", "targets": "Targets",
	"slow": "Slow", "slow_time": "Slow time", "armor_pierce": "Armor pierce", "cleave": "Cleave",
	"stun_every": "Stun every N hits", "stun": "Stun time", "burst": "Burst size", "burst_gap": "Burst gap",
	"grenade_every": "Grenade every N bursts", "grenade_dmg": "Grenade dmg", "grenade_radius": "Grenade radius",
	"interval": "Car every (s)", "car_hp": "Car HP",
	"car_speed": "Car speed", "vehicle": "Vehicle", "gun_dmg": "Turret dmg", "gun_rate": "Turret shots/s",
	"cone": "Cone angle", "burn": "Burn dps", "burn_time": "Burn time", "fire_pierce": "Fire res. pierce",
	"headshot": "Headshot chance", "camo": "Sees invisible", "air": "Hits flying",
	"raise_hp": "Undead HP", "raise_class": "Raises up to class",
	"chill": "Chill /s", "chill_slow": "Max slow", "freeze": "Freeze time",
	"acid_dps": "Acid dps", "acid_time": "Acid time", "acid_shred": "Armor eaten", "splash": "Acid splash",
	"dagger_dmg": "Dagger dmg", "dagger_rate": "Daggers/s", "dagger_range": "Dagger range", "daggers": "Daggers",
	"aura": "Aura dmg bonus", "brittle": "Frozen take extra"}
const PERCENT_STATS := ["slow", "armor_pierce", "fire_pierce", "headshot", "raise_hp", "chill", "chill_slow", "aura",
	"brittle"]
# level colors: red, yellow, green, blue, purple, pink, and gold for the top level
const RAINBOW := [Color("e43b44"), Color("fee761"), Color("63c74d"), Color("2c9aceff"), Color(0.473, 0.411, 0.962, 1.0),
	Color("f6757a"), Color("feae34")]

# global knobs used for balancing
static var BUDGET_MULT := 1.0
static var HP_GROWTH := 1.0
static var BOUNTY_MULT := 2.5
const BOSS_TYPES := ["golem", "demon"]
const SPACING := {"slime": 0.55, "rat": 0.35, "goblin": 0.6, "wolf": 0.45, "ironclad": 0.9, "imp": 0.6,
	"shaman": 1.4, "slime_king": 1.8, "ogre": 2.2, "golem": 6.0, "demon": 6.0,
	"bat": 0.3, "skeleton": 0.6, "ghost": 0.8, "berserker": 1.1, "harpy": 2.0}


static func enemy_hp_scale(wave: int) -> float:
	return 1.0 + (0.03 * float(wave - 1) + 0.0006 * float((wave - 1) * (wave - 1))) * HP_GROWTH


## Money for clearing a wave: grows fast, late waves pay for the expensive top upgrades (BTD6-style).
static func wave_bonus(wave: int) -> int:
	return roundi(20.0 * pow(float(wave), 1.5))


## Returns {"spawns": [[time, type], ...], "boss": bool}
static func build_wave(wave: int, total: int, seed_base: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_base * 1000 + wave * 7919
	var spawns: Array = []
	var budget := (6.0 + wave * 2.5 + wave * wave * 0.9) * BUDGET_MULT
	if wave <= 10:
		budget *= 0.55 + 0.045 * wave   # gentle early game
	elif wave > 20:
		budget *= 1.0 + 0.012 * (wave - 20)  # late game pressure
	var boss := false
	# boss waves
	var boss_list: Array = []
	if wave == total:
		if total >= 40:
			boss_list = ["demon"]
		elif total >= 30:
			boss_list = ["golem", "golem"]
		else:
			boss_list = ["golem"]
	elif wave == 20 and total > 20:
		boss_list = ["golem"]
	elif wave == 30 and total > 30:
		boss_list = ["golem", "golem"]
	if boss_list.size() > 0:
		boss = true
		budget *= 0.45
	# early hand-tuned waves
	var t := 0.0
	var avail: Array = []
	for p in POOL:
		if wave >= p[1] and not (wave >= 15 and p[1] <= 5):
			avail.append(p)
	var groups := 1
	if wave >= 4:
		groups = 2
	if wave >= 12:
		groups = 3
	if wave >= 26:
		groups = 4
	var used: Array = []
	for g in groups:
		# prefer newer enemy types, avoid repeating a type inside one wave
		var p: Array = []
		for attempt in 8:
			var idx := avail.size() - 1 - int(pow(rng.randf(), 1.6) * avail.size())
			p = avail[clampi(idx, 0, avail.size() - 1)]
			if not used.has(p[0]) or used.size() >= avail.size():
				break
		used.append(p[0])
		var share := budget / groups
		var count := maxi(1, int(round(share / p[2])))
		count = mini(count, 60)
		var gap: float = SPACING[p[0]] * (0.9 if wave > 20 else (1.6 if wave <= 5 else 1.0))
		for i in count:
			spawns.append([t, p[0]])
			t += gap
		t += 1.2
	for b in boss_list:
		spawns.append([t + 1.0, b])
		t += SPACING[b]
	spawns.sort_custom(func(a, b): return a[0] < b[0])
	return {"spawns": spawns, "boss": boss}
