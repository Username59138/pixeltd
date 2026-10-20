extends RefCounted
## What's new, shown from the main menu. Newest version first.

const ENTRIES := [
	{"version": "0.2", "title": "In progress", "date": "October 2026", "items": [
		"BIG REBALANCE: every tower now has 7 levels. Early levels deal small damage, the top upgrades cost thousands and deal dozens of times more, so a run is about saving up for big towers instead of building more and more cheap ones.",
		"New top upgrades include Holy Champion (towers around the Knight deal 15% more damage), Absolute Zero (frozen enemies take 25% more damage), Legend of the West, Commando, Dragon's Breath, Deadeye, Lich King, Plague and Shadow Blade.",
		"Difficult has brand new waves: they start tiny (8 slimes of 9 HP) and end huge (5000 HP goblins, 20k ogres), with a 10k Golem on wave 20, two 20k Golems on wave 30 and a 50k Demon Lord at the end. The other difficulties get theirs next.",
		"Money: tougher enemies pay more, and clearing a wave pays more and more as the waves go on.",
		"Every difficulty now has its own handmade waves. After a win, Continue goes on with generated waves that start from the strength of the last one.",
		"Tower limits: at most 50 towers in a battle and 10 of each type. The shop shows how many you've built.",
		"MUSIC! Chiptune tracks by Juhani Junkala play across the menu and the battles, boss waves get their own track and a win plays a little fanfare. Settings has a music volume and a player: see what's playing, skip to the previous or next track.",
	]},
	{"version": "0.12", "title": "Acid Refinery", "date": "October 2026", "items": [
		"NEW MAP: Acid Refinery (Advanced). Two roads through a leaking chemical plant join in the middle; acid lakes, storage tanks and huge hazard barrels take some of the space.",
		"ACID: hurts over time through armor and eats some of the armor while it lasts, so every other tower hits harder too.",
		"NEW TOWER: the Toxic Gunner. Beat Acid Refinery on Difficult. Shoots globs of acid, and from Acid Splash on they burst over everyone around the target.",
		"NEW TOWER: the Toxic Assassin. Beat Acid Refinery on Hardcore. Very fast poisoned blades up close; from level 4 the Assassin also throws daggers at range, and the daggers reach flying enemies.",
		"Keys 9 and 0 buy the 9th and 10th tower.",
		"Fixed letters running into each other in some words (\"fi\" could turn into a garbled glyph or lose the i).",
		"The tower list in battle and the changelog got a pixel art scrollbar with arrow buttons.",
		"The Armory's Enemies tab uses the same 2 rows of 5 cards with pages as the Towers tab.",
		"Enemies are never tinted any more, every status shows with particles: a green plus floats up from enemies healed by a Goblin Shaman, slowed enemies shed grey specks, and enraged Orc Berserkers throw off red sparks. The Necromancer's undead aren't green any more either: you can tell they're yours because they walk back down the road.",
	]},
	{"version": "0.11", "title": "The Freezer", "date": "October 2026", "items": [
		"NEW TOWER: the Freezer. Beat Frozen Lake on Difficult to unlock it. Hoses enemies with ice water: the more they get soaked the slower they walk, until they freeze solid in a block of ice. Higher classes chill slower and thaw faster, so bosses only freeze now and then.",
		"Its upgrades make the water colder and colder: Cold Water, Pressure Hose, Ice Water (starts to hurt) and Liquid Nitrogen.",
		"Water and fire cancel out: the Freezer puts out burning enemies and the Flamethrower melts the ice.",
		"Burning enemies no longer turn red: flames dance on them instead. Hover an enemy to see how chilled or frozen it is.",
		"Stone Golem is weaker: 3000 HP instead of 4500, armor 4 instead of 8. Medium could not be beaten with only the Gunslinger and the Knight.",
		"Key 8 buys the 8th tower. The tower list in battle scrolls when it doesn't fit, and the Armory shows towers in pages of 2 rows of 5.",
	]},
	{"version": "0.1", "title": "First version + Halloween event", "date": "October 2026", "items": [
		"7 maps in 4 tiers: Green Meadow, Dusty Canyon, Gas Station, Murky Swamp, Frozen Lake, Old Graveyard, Volcano.",
		"Maps are unlocked with paper maps: every battle pays some (harder maps and difficulties pay more, a loss pays a little), so you can farm them and buy the maps you want.",
		"7 towers with their own upgrade paths: Gunslinger, Knight, Soldier, Garage, Flamethrower, Sniper, Necromancer. New towers are unlocked by beating maps.",
		"16 enemies with flying, invisible, reviving, raging, healing and splitting tricks, plus two bosses.",
		"4 difficulties: Light, Medium, Difficult and Hardcore (one life, no selling).",
		"Volcano eruptions, a self-crossing boardwalk in the swamp and a crypt that spawns enemies in the graveyard.",
		"Rebindable keys, 1x-3x zoom, game speed up to 3x and a Continue button after winning.",
		"HALLOWEEN EVENT (Oct 10 - Nov 7): Green Meadow and the menu turn orange, with autumn trees and jack-o'-lanterns.",
		"HALLOWEEN CHARACTER: the Necromancer. Beat Old Graveyard on Difficult to unlock him, any time of the year. Enemies his bolts finish off rise as friendly undead.",
	]},
]
