# Pixel TD v0.1

A pixel art tower defense game made with Godot 4.7.2 (GL Compatibility renderer, runs on pretty much any Linux machine with OpenGL 3.3).

## Running

```
chmod +x PixelTD.x86_64
./PixelTD.x86_64
```

Progress is saved to `~/.local/share/godot/app_userdata/Pixel TD/pixel_td_save.json`.

## Controls

Every key below is a default and can be changed in **Settings** (gear button in the main menu, or Settings in the pause menu). Keys follow the physical keyboard position, so they work on any layout.

| Action | Default |
|---|---|
| Buy a tower | Button on the right or keys **1–5** (the shop only shows unlocked towers) |
| Place it | Left click on a tile (hold **Shift** to place several) |
| Select a tower | Left click on it |
| Upgrade selected tower | **E** |
| Sell selected tower | **X** |
| Targeting mode | **T** |
| Next wave | **Space** |
| Game speed 1x/2x/3x | **F** |
| Pause | **P** |
| Zoom in / out | Mouse wheel (1x, 2x, 3x) |
| Move the map when zoomed | Hold the mouse wheel and drag |
| Cancel / deselect / back | **Esc** or right click (fixed) |
| Fullscreen | **F11** (fixed) |

Hover over an enemy to see its name, class, HP, speed, armor, fire resistance, control strength and current effects.

## Mechanics

- **Enemy classes I–IV** only weaken control effects (stun, slow): 100% / 70% / 40% / 20%. Damage, including burning, always applies in full.
- **Difficulties:** Light (20 waves), Medium (30), Difficult (40), Hardcore (40 waves, 1 life, no selling).
- **Towers are unlocked by beating maps** (a higher difficulty counts too):
  - Soldier: Green Meadow on Medium
  - Garage: Gas Station on Difficult
  - Flamethrower: Volcano on Medium
- **Volcano:** two short roads, lava on the best spots and an eruption every second wave. Tiles next to the lava flash orange, then towers on them stop shooting for 6 seconds.
- The final boss of a run gets a big HP bar at the top of the screen. Hover other enemies to see their HP.
- The bar under a tower shows its level by color: red → yellow → green → purple (max).

## Towers

- **Gunslinger:** single shots; armor reduces bullet damage. Quick Draw → Hollow Points → Dual Pistols (2 targets + slow).
- **Knight:** melee, ignores 50% of armor, every 3rd hit stuns. Sharpened Blade → Cleave → Champion.
- **Soldier:** long range rifle bursts. AP Rounds (armor piercing) → Grenades → Machine Gun.
- **Garage:** must be built next to a road. Sends friendly cars (`is_friendly` enemies) that drive along the road towards the enemies. On a crash both sides lose `min(car HP, enemy HP)`. Pickup → Truck → Armored Car (with a turret).
- **Flamethrower:** fire cone and burning, ignores armor, but the Fire Imp is immune. Bigger Tank → Napalm → Blue Flame.

Open **Towers** in the main menu and click a portrait to see every tower's full stats and upgrade path.

## Source

> **After cloning or pulling**, open the project in the Godot editor once (or run `godot --headless --import`)
> before running the game. Scripts use `class_name`, and Godot only registers those names when it scans the
> project. Without that step you get errors like `Identifier "Defs" not declared in the current scope`.


- `scripts/data/defs.gd`: all the numbers (towers, enemies, difficulties, wave generator).
- `scripts/battle/`: the battlefield (`battle.gd`), towers (`tower.gd`) and enemies (`enemy.gd`).
- `scripts/ui/`: menus, the in-battle HUD and tooltips.
- `tools/gen_art.py`, `tools/sprites.py`: generate all the pixel art and maps (Python + Pillow). Run `python3 tools/gen_art.py` after editing them. `scripts/data/maps_data.gd` is generated too, so don't edit it by hand.
- `tools/gen_sfx.py`: generates the 8-bit sound effects.
- Building: open the project in Godot 4.7.2 → Project → Export → Linux.

Developer flags (passed after `--`):

- `--sim`: run the balance bot on every map and difficulty (works with `--headless`).
- `--unlock-all`: unlock everything.
- `--battle <map> <0-3> --bot`: watch the bot play.

## License

The game is licensed under the **GNU General Public License v3.0**, see [LICENSE](LICENSE).

The fonts are third party and keep their own license, the SIL Open Font License 1.1:

- Tiny5: [assets/fonts/OFL-tiny5.txt](assets/fonts/OFL-tiny5.txt)
- Press Start 2P: [assets/fonts/OFL-pressstart2p.txt](assets/fonts/OFL-pressstart2p.txt)
