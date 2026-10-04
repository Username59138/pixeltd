#!/usr/bin/env python3
"""Generates every PNG asset of Pixel TD plus scripts/data/maps_data.gd."""
import os, random, math
from PIL import Image
from sprites import *

ROOT = os.path.join(os.path.dirname(__file__), '..')
A = os.path.join(ROOT, 'assets')
T = 16


def out(path):
    p = os.path.join(A, path)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    return p


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def shade(c, f):
    return tuple(max(0, min(255, int(v * f))) for v in c)


# ------------------------------------------------------------------ sprites
def flash(img):
    """White silhouette used for the hit flash."""
    w = img.copy()
    px = w.load()
    for y in range(w.height):
        for x in range(w.width):
            if px[x, y][3]:
                px[x, y] = (255, 255, 255, 255)
    return w


def gen_sprites():
    for name, rows, cm in [('gunner', GUNNER, GUNNER_C), ('gunner_elite', GUNNER, GUNNER_ELITE),
                           ('knight', KNIGHT, KNIGHT_C), ('knight_elite', KNIGHT, KNIGHT_ELITE),
                           ('flamer', FLAMER, FLAMER_C), ('flamer_elite', FLAMER, FLAMER_ELITE),
                           ('soldier', SOLDIER, SOLDIER_C), ('soldier_elite', SOLDIER, SOLDIER_ELITE),
                           ('garage', GARAGE, GARAGE_C), ('garage_elite', GARAGE, GARAGE_ELITE)]:
        make(rows, cm).save(out(f'sprites/towers/{name}.png'))
    for name, (rows, cm) in ENEMY_SPRITES.items():
        img = make(rows, cm)
        img.save(out(f'sprites/enemies/{name}.png'))
        flash(img).save(out(f'sprites/enemies/{name}_flash.png'))
    for name, (rows, cm) in ICONS.items():
        make(rows, cm).save(out(f'ui/icons/{name}.png'))
    for name, (rows, cm) in UP_ICONS.items():
        make(rows, cm).save(out(f'ui/upgrades/{name}.png'))
    for name, (rows, cm) in VEHICLES.items():
        img = make(rows, cm)
        img.save(out(f'sprites/vehicles/{name}.png'))
        img.save(out(f'ui/upgrades/{name}.png'))
        flash(img).save(out(f'sprites/vehicles/{name}_flash.png'))
    for name, rows in [('arrow', CURSOR_ARROW), ('hand', CURSOR_HAND), ('cross', CURSOR_CROSS)]:
        make(rows, CURSOR_C).save(out(f'ui/cursor_{name}.png'))


# ------------------------------------------------------------------ UI
def bevel_box(w, h, base, border=C['black'], light=None, dark=None, pressed=False):
    light = light or shade(base, 1.25)
    dark = dark or shade(base, 0.7)
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    px = img.load()
    for y in range(h):
        for x in range(w):
            corner = (x in (0, w - 1)) and (y in (0, h - 1))
            if corner:
                continue
            if x == 0 or y == 0 or x == w - 1 or y == h - 1:
                px[x, y] = border + (255,)
                continue
            c = base
            if pressed:
                if y == 1:
                    c = dark
                elif y == h - 2:
                    c = base
            else:
                if y == 1 or (x == 1 and y < h - 3):
                    c = light
                elif y >= h - 3:
                    c = dark
            px[x, y] = c + (255,)
    return img


def gen_ui():
    variants = {
        'green': C['green'], 'blue': C['dblue'], 'red': C['dred'], 'gold': C['lorange'],
        'gray': C['xdgray'], 'purple': C['purple'],
    }
    for name, base in variants.items():
        bevel_box(16, 16, base).save(out(f'ui/btn_{name}.png'))
        bevel_box(16, 16, shade(base, 1.2), light=shade(base, 1.5)).save(out(f'ui/btn_{name}_hover.png'))
        bevel_box(16, 16, shade(base, 0.9), pressed=True).save(out(f'ui/btn_{name}_pressed.png'))
    bevel_box(16, 16, (60, 60, 72), light=(75, 75, 88), dark=(48, 48, 58)).save(out('ui/btn_disabled.png'))
    # panels
    p = bevel_box(16, 16, C['navy'], light=C['xdgray'], dark=(30, 33, 54))
    p.save(out('ui/panel.png'))
    p = bevel_box(16, 16, (30, 26, 46), border=C['black'], light=C['navy'], dark=(22, 19, 34))
    p.save(out('ui/panel_dark.png'))
    # parchment card
    bevel_box(16, 16, (58, 68, 102), light=C['dgray'], dark=C['navy']).save(out('ui/card.png'))
    bevel_box(16, 16, (78, 90, 130), light=C['gray'], dark=C['xdgray']).save(out('ui/card_hover.png'))
    bevel_box(16, 16, C['dgreen'], light=C['green'], dark=C['xdgreen']).save(out('ui/card_selected.png'))
    gen_logo()


FONT5 = {
    'P': ["1111", "1001", "1001", "1110", "1000", "1000", "1000"],
    'I': ["111", "010", "010", "010", "010", "010", "111"],
    'X': ["10001", "10001", "01010", "00100", "01010", "10001", "10001"],
    'E': ["1111", "1000", "1000", "1110", "1000", "1000", "1111"],
    'L': ["1000", "1000", "1000", "1000", "1000", "1000", "1111"],
    'T': ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
    'D': ["1110", "1001", "1001", "1001", "1001", "1001", "1110"],
    ' ': ["00", "00", "00", "00", "00", "00", "00"],
}
FONT3 = {  # tiny 3x5 sign font
    'G': ["111", "100", "101", "101", "111"], 'A': ["010", "101", "111", "101", "101"],
    'S': ["111", "100", "111", "001", "111"], 'O': ["111", "101", "101", "101", "111"],
    '&': ["010", "101", "010", "101", "011"], ' ': ["0", "0", "0", "0", "0"],
    'M': ["10001", "11011", "10101", "10001", "10001"], 'R': ["110", "101", "110", "101", "101"],
    'T': ["111", "010", "010", "010", "010"],
}


def draw_text3(img, x, y, text, col):
    px = img.load()
    for ch in text:
        g = FONT3[ch]
        for gy, row in enumerate(g):
            for gx, v in enumerate(row):
                if v == '1':
                    px[x + gx, y + gy] = col + (255,)
        x += len(g[0]) + 1


def gen_logo():
    text = "PIXEL TD"
    s = 4
    w = sum(len(FONT5[c][0]) + 1 for c in text) * s + 12
    h = 7 * s + 14
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    mask = Image.new('L', (w, h), 0)
    mp = mask.load()
    x = 6
    for ch in text:
        g = FONT5[ch]
        for gy, row in enumerate(g):
            for gx, v in enumerate(row):
                if v == '1':
                    for yy in range(s):
                        for xx in range(s):
                            mp[x + gx * s + xx, 5 + gy * s + yy] = 255
        x += (len(g[0]) + 1) * s
    px = img.load()
    # shadow (offset 3 down), outline, fill gradient
    for y in range(h):
        for x in range(w):
            def m(a, b):
                return 0 <= a < w and 0 <= b < h and mp[a, b]
            if m(x, y):
                t = (y - 5) / (7 * s)
                if t < 0.5:
                    col = lerp(C['yellow'], C['gold'], t * 2)
                else:
                    col = lerp(C['gold'], C['orange'], (t - 0.5) * 2)
                if (y - 5) % s == 0 and (y - 5) < s * 2:
                    col = lerp(col, C['white'], 0.4)
                px[x, y] = col + (255,)
    src = img.copy().load()
    for y in range(h):
        for x in range(w):
            if src[x, y][3]:
                continue
            near = False
            for dx in range(-2, 3):
                for dy in range(-2, 3):
                    if abs(dx) + abs(dy) <= 2 and 0 <= x + dx < w and 0 <= y + dy < h and src[x + dx, y + dy][3]:
                        near = True
            if near:
                px[x, y] = C['black'] + (255,)
    src = img.copy().load()
    for y in range(h - 1, -1, -1):
        for x in range(w):
            if src[x, y][3] == 0:
                for d in (1, 2, 3):
                    if y - d >= 0 and src[x, y - d][3]:
                        px[x, y] = C['dred'] + (255,) if d < 3 else C['black'] + (255,)
                        break
    img.save(out('ui/logo.png'))


# ------------------------------------------------------------------ maps
def value_noise(w, h, cell, rnd):
    gw, gh = w // cell + 2, h // cell + 2
    g = [[rnd.random() for _ in range(gw)] for _ in range(gh)]
    res = [[0.0] * w for _ in range(h)]
    for y in range(h):
        for x in range(w):
            fx, fy = x / cell, y / cell
            ix, iy = int(fx), int(fy)
            tx, ty = fx - ix, fy - iy
            tx = tx * tx * (3 - 2 * tx)
            ty = ty * ty * (3 - 2 * ty)
            a = g[iy][ix] + (g[iy][ix + 1] - g[iy][ix]) * tx
            b = g[iy + 1][ix] + (g[iy + 1][ix + 1] - g[iy + 1][ix]) * tx
            res[y][x] = a + (b - a) * ty
    return res


BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]

THEMES = {
    'meadow': dict(ground=[(52, 120, 64), C['green'], (82, 160, 80)], path=[(196, 140, 92), C['tan'], (172, 116, 78)],
                   path_edge=C['dbrown'], ground_edge=C['dgreen'], speck=[C['lgreen'], C['dgreen']],
                   pebble=[C['brown'], C['sand']], details='flowers'),
    'desert': dict(ground=[(214, 176, 120), C['sand'], (226, 196, 140)], path=[C['lorange'], (200, 108, 66), C['brown']],
                   path_edge=C['dbrown'], ground_edge=C['tan'], speck=[C['tan'], C['white']],
                   pebble=[C['dbrown'], C['tan']], details='desert'),
    'gas': dict(ground=[C['gray'], (150, 165, 188), (128, 143, 168)], path=[(48, 52, 76), C['navy'], (56, 62, 88)],
                path_edge=C['black'], ground_edge=C['dgray'], speck=[C['lgray'], C['dgray']],
                pebble=[C['xdgray'], C['dgray']], details='concrete'),
    'snow': dict(ground=[(232, 240, 250), C['white'], C['lgray']], path=[C['gray'], (160, 176, 200), C['lgray']],
                 path_edge=C['dgray'], ground_edge=(180, 196, 220), speck=[C['lgray'], C['white']],
                 pebble=[C['dgray'], C['white']], details='snow'),
    'volcano': dict(ground=[C['navy'], (48, 46, 72), C['xdgray']], path=[(92, 60, 58), C['dbrown'], (100, 70, 62)],
                    path_edge=C['xdbrown'], ground_edge=C['black'], speck=[C['xdgray'], C['dred']],
                    pebble=[C['dred'], C['orange']], details='embers'),
}


def path_tiles(waypoints):
    tiles = []
    for (x0, y0), (x1, y1) in zip(waypoints, waypoints[1:]):
        dx = (x1 > x0) - (x1 < x0)
        dy = (y1 > y0) - (y1 < y0)
        x, y = x0, y0
        tiles.append((x, y))
        while (x, y) != (x1, y1):
            x += dx
            y += dy
            tiles.append((x, y))
    return tiles


def ellipse_tiles(cx, cy, rx, ry):
    res = set()
    for y in range(int(cy - ry) - 1, int(cy + ry) + 2):
        for x in range(int(cx - rx) - 1, int(cx + rx) + 2):
            if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 <= 1:
                res.add((x, y))
    return res


MAPS = [
    dict(id='meadow', name='Green Meadow', theme='meadow', tier='Beginner', hp_mult=1.0, seed=11,
         paths=[[(-1, 4), (8, 4), (8, 15), (16, 15), (16, 6), (24, 6), (24, 17), (33, 17)]],
         decor=['tree', 'tree', 'bush', 'bush', 'rock'], density=0.07,
         desc='A calm field. Perfect for learning the ropes.'),
    dict(id='canyon', name='Dusty Canyon', theme='desert', tier='Beginner', hp_mult=1.05, seed=23,
         paths=[[(-1, 17), (5, 17), (5, 4), (12, 4), (12, 13), (19, 13), (19, 3), (27, 3), (27, 18), (14, 18),
                 (14, 23)]],
         decor=['cactus', 'cactus', 'rock', 'skull', 'dead_tree'], density=0.06,
         desc='Long dusty road through the badlands.'),
    dict(id='gas_station', name='Gas Station', theme='gas', tier='Intermediate', hp_mult=1.1, seed=5,
         paths=[[(-1, 2), (4, 2), (4, 18), (12, 18), (12, 8), (20, 8), (20, 18), (28, 18), (28, 4), (33, 4)]],
         decor=['barrel', 'tires', 'cone', 'cone'], density=0.035,
         desc='Something is leaking. Fuel for a new recruit?'),
    dict(id='frozen_lake', name='Frozen Lake', theme='snow', tier='Advanced', hp_mult=1.15, seed=7,
         paths=[[(3, -1), (3, 7), (14, 7), (14, 11), (20, 11), (20, 3), (27, 3), (27, 18), (33, 18)],
                [(3, 23), (3, 15), (14, 15), (14, 11), (20, 11), (20, 3), (27, 3), (27, 18), (33, 18)]],
         decor=['snow_pine', 'snow_pine', 'snow_pine', 'snowman', 'ice_block', 'rock'], density=0.06,
         desc='Two trails meet on the ice. Watch both flanks.'),
    dict(id='volcano', name='Volcano', theme='volcano', tier='Expert', hp_mult=1.45, seed=3,
         paths=[[(5, -1), (5, 6), (27, 6), (27, 23)],
                [(-1, 17), (14, 17), (14, 12), (27, 12), (27, 23)]],
         decor=['lava_rock', 'lava_rock', 'crystal', 'dead_tree', 'skull'], density=0.04,
         desc='Two short roads, lava eats the best spots. It erupts!'),
]
MENU_MAP = dict(id='menu', name='Menu', theme='meadow', tier='', hp_mult=1.0, seed=99,
                paths=[[(-1, 9), (7, 9), (7, 18), (15, 18), (15, 13), (25, 13), (25, 18), (33, 18), (33, 8),
                        (41, 8)]],
                decor=['tree', 'tree', 'bush', 'rock', 'bush'], density=0.08, desc='')


def bake_map(m, cols=32, rows=23):
    rnd = random.Random(m['seed'])
    th = THEMES[m['theme']]
    W, H = cols * T, rows * T
    img = Image.new('RGBA', (W, H))
    px = img.load()
    # tile classification
    ptiles = set()
    for p in m['paths']:
        ptiles |= set(path_tiles(p))
    special = {}  # tile -> kind (lake/lava/building)
    ellipses = []  # (kind, cx, cy, rx, ry) in tile units, rendered per pixel
    if m['id'] == 'frozen_lake':
        ellipses += [('lake', 9, 11.5, 4.6, 2.6), ('lake', 23.5, 15.5, 2.6, 2.4)]
    if m['id'] == 'volcano':
        ellipses += [('lava', cx, cy, rx, ry) for (cx, cy, rx, ry) in
                     [(2.5, 3.0, 2.0, 2.2), (9.0, 10.5, 3.5, 2.2), (20.5, 9.0, 4.0, 1.4), (31.0, 9.0, 1.6, 2.6),
                      (20.0, 17.0, 4.0, 2.6), (8.5, 20.5, 3.5, 1.5)]]
    for (k, cx, cy, rx, ry) in ellipses:
        for ty in range(int(cy - ry) - 1, int(cy + ry) + 2):
            for tx in range(int(cx - rx) - 1, int(cx + rx) + 2):
                hit = 0
                for sx in (0.15, 0.5, 0.85):
                    for sy in (0.15, 0.5, 0.85):
                        if ((tx + sx - cx) / rx) ** 2 + ((ty + sy - cy) / ry) ** 2 <= 1:
                            hit += 1
                if hit >= 2:
                    special[(tx, ty)] = k
    if m['id'] == 'gas_station':
        for x in range(9, 23):
            for y in range(0, 5):
                special[(x, y)] = 'building'
        for x in range(14, 19):
            for y in range(11, 15):
                special[(x, y)] = 'island'
    for t in list(special):
        if t in ptiles:
            del special[t]

    def is_path_px(x, y):
        return (x // T, y // T) in ptiles

    def special_px(x, y):
        if (x // T, y // T) in ptiles:
            return None
        for (k, cx, cy, rx, ry) in ellipses:
            if ((x / T - cx) / rx) ** 2 + ((y / T - cy) / ry) ** 2 <= 1:
                return k
        k = special.get((x // T, y // T))
        return k if k in ('building', 'island') else None

    nz = value_noise(W, H, 12, rnd)
    nz2 = value_noise(W, H, 5, rnd)
    for y in range(H):
        for x in range(W):
            n = nz[y][x] * 0.7 + nz2[y][x] * 0.3
            b = BAYER[y % 4][x % 4] / 16.0 - 0.5
            v = n + b * 0.18
            if is_path_px(x, y):
                pal = th['path']
            else:
                pal = th['ground']
            idx = 0 if v < 0.42 else (1 if v < 0.6 else 2)
            col = pal[idx]
            px[x, y] = col + (255,)
    # specials
    for y in range(H):
        for x in range(W):
            k = special_px(x, y)
            if not k:
                continue
            if k == 'lake':
                v = nz2[y][x]
                col = C['cyan'] if v > 0.72 else ((126, 200, 240) if v > 0.4 else (96, 176, 230))
                if (x + y * 3) % 23 == 0:
                    col = C['white']
                px[x, y] = col + (255,)
            elif k == 'lava':
                v = nz[y][x] * 0.6 + nz2[y][x] * 0.4
                col = C['yellow'] if v > 0.68 else (C['orange'] if v > 0.45 else C['red'])
                px[x, y] = col + (255,)
            elif k == 'island':
                px[x, y] = (C['lgray'] if (x // 4 + y // 4) % 2 else (176, 188, 206)) + (255,)
    # edges for path / specials
    src = img.copy().load()
    for y in range(H):
        for x in range(W):
            here_p = is_path_px(x, y)
            here_s = special_px(x, y)
            near_ground = False
            near_path = False
            near_special = None
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)):
                nx, ny = x + dx, y + dy
                if not (0 <= nx < W and 0 <= ny < H):
                    continue
                p2 = is_path_px(nx, ny)
                s2 = special_px(nx, ny)
                if here_p and not p2:
                    near_ground = True
                if not here_p and p2:
                    near_path = True
                if here_s and s2 != here_s:
                    near_special = here_s
            if here_p and near_ground:
                px[x, y] = th['path_edge'] + (255,)
            elif not here_p and near_path and not here_s:
                px[x, y] = th['ground_edge'] + (255,)
            elif near_special:
                k = near_special
                ec = {'lake': C['white'], 'lava': C['black'], 'island': C['dgray'], 'building': None}[k]
                if ec:
                    px[x, y] = ec + (255,)
    # ground details & pebbles
    for _ in range(int(W * H / 90)):
        x, y = rnd.randrange(W), rnd.randrange(H)
        if special_px(x, y):
            continue
        if is_path_px(x, y):
            if 2 < x % T < 14 and 2 < y % T < 14 or True:
                px[x, y] = rnd.choice(th['pebble']) + (255,)
        else:
            px[x, y] = rnd.choice(th['speck']) + (255,)
    det = th['details']
    for _ in range(int(cols * rows * 0.5)):
        tx, ty = rnd.randrange(cols), rnd.randrange(rows)
        if (tx, ty) in ptiles or (tx, ty) in special:
            continue
        x, y = tx * T + rnd.randrange(2, 13), ty * T + rnd.randrange(3, 13)
        if det == 'flowers':
            if rnd.random() < 0.6:  # grass tuft
                for (dx, dy) in ((0, 0), (-1, -1), (1, -1), (0, -2)):
                    px[x + dx, y + dy] = (C['lgreen'] if dy < -1 else C['dgreen']) + (255,)
            else:
                c = rnd.choice([C['yellow'], C['white'], C['pink'], C['red']])
                px[x, y] = c + (255,)
                px[x + 1, y] = c + (255,)
                px[x, y - 1] = c + (255,)
                px[x + 1, y - 1] = C['gold'] + (255,)
        elif det == 'desert':
            for (dx, dy) in ((0, 0), (1, 0), (2, 0)):
                px[x + dx, y + dy] = C['tan'] + (255,)
            px[x + 1, y - 1] = C['white'] + (255,)
        elif det == 'snow':
            px[x, y] = C['lgray'] + (255,)
            px[x + 1, y] = C['lgray'] + (255,)
            px[x, y - 1] = C['white'] + (255,)
        elif det == 'embers':
            px[x, y] = rnd.choice([C['orange'], C['red'], C['dred']]) + (255,)
    # concrete slab lines for gas station ground
    if det == 'concrete':
        for y in range(H):
            for x in range(W):
                if is_path_px(x, y) or special_px(x, y):
                    continue
                if (x % 32 == 0 or y % 32 == 0):
                    px[x, y] = C['dgray'] + (255,)
        # yellow dashes along road centre
        for p in m['paths']:
            for (x0, y0), (x1, y1) in zip(p, p[1:]):
                ax, ay, bx, by = x0 * T + 8, y0 * T + 8, x1 * T + 8, y1 * T + 8
                n = max(abs(bx - ax), abs(by - ay))
                for i in range(n):
                    if (i // 4) % 2:
                        continue
                    xx = ax + (bx - ax) * i // max(n, 1)
                    yy = ay + (by - ay) * i // max(n, 1)
                    if 0 <= xx < W and 0 <= yy < H:
                        px[xx, yy] = C['gold'] + (255,)
    # lava glow speck
    if det == 'embers':
        for (tx, ty), k in special.items():
            pass

    blocked = set(ptiles) | set(special)
    decor_list = []

    def place(name, tx, ty, fw=1, fh=1):
        for xx in range(tx, tx + fw):
            for yy in range(ty, ty + fh):
                blocked.add((xx, yy))
        decor_list.append((name, tx, ty, fw, fh))

    # fixed gas station props
    if m['id'] == 'gas_station':
        draw_station(img, 9 * T, 0, 14 * T, 5 * T)
        for x in (14, 16, 18):
            place('pump', x, 12)
        place('car_red', 23, 10, 2, 1)
        place('car_blue', 6, 6, 2, 1)
        place('car_red', 29, 13, 2, 1)
        place('car_blue', 14, 20, 2, 1)
    # random decor
    cand = [(x, y) for x in range(cols) for y in range(rows - 1) if (x, y) not in blocked]
    rnd.shuffle(cand)
    n = int(len(cand) * m['density'])
    for (x, y) in cand[:n]:
        if (x, y) in blocked:
            continue
        place(rnd.choice(m['decor']), x, y)
    # draw decor sorted by y
    for name, tx, ty, fw, fh in sorted(decor_list, key=lambda d: d[2]):
        rows_, cm = DECOR_SPRITES[name]
        spr = make(rows_, cm)
        x = tx * T + (fw * T - spr.width) // 2
        y = (ty + fh) * T - spr.height - 1
        # shadow
        sh = Image.new('RGBA', spr.size, (0, 0, 0, 0))
        shp = sh.load()
        sp = spr.load()
        for yy in range(spr.height):
            for xx in range(spr.width):
                if sp[xx, yy][3] and yy > spr.height - 4:
                    shp[xx, yy] = (0, 0, 0, 70)
        img.alpha_composite(sh, (x + 2, y + 1))
        if y >= 0:
            img.alpha_composite(spr, (x, y))
        else:
            img.alpha_composite(spr.crop((0, -y, spr.width, spr.height)), (x, 0))
    return img, blocked, ptiles, special


def draw_station(img, x0, y0, w, h):
    px = img.load()
    wall = C['sand']
    for y in range(y0, y0 + h):
        for x in range(x0, x0 + w):
            ly, lx = y - y0, x - x0
            if lx in (0, w - 1) or ly == h - 1:
                c = C['black']
            elif ly < 14:
                c = C['red'] if (lx // 6) % 2 == 0 else C['white']
                if ly == 13:
                    c = C['dred']
            else:
                c = wall if (ly % 6) else C['tan']
            px[x, y] = c + (255,)
    # sign
    for y in range(y0 + 2, y0 + 11):
        for x in range(x0 + w // 2 - 22, x0 + w // 2 + 22):
            edge = y in (y0 + 2, y0 + 10) or x in (x0 + w // 2 - 22, x0 + w // 2 + 21)
            px[x, y] = (C['black'] if edge else C['navy']) + (255,)
    draw_text3(img, x0 + w // 2 - 15, y0 + 4, "GAS & GO", C['yellow'])
    # windows and door
    for (wx, ww) in [(10, 40), (w - 50, 40)]:
        for y in range(y0 + 22, y0 + 40):
            for x in range(x0 + wx, x0 + wx + ww):
                edge = y in (y0 + 22, y0 + 39) or x in (x0 + wx, x0 + wx + ww - 1)
                c = C['black'] if edge else (C['cyan'] if (x - y) % 11 < 2 else C['blue'])
                px[x, y] = c + (255,)
    for y in range(y0 + 20, y0 + h - 1):
        for x in range(x0 + w // 2 - 10, x0 + w // 2 + 10):
            edge = y == y0 + 20 or x in (x0 + w // 2 - 10, x0 + w // 2 + 9)
            c = C['black'] if edge else (C['dbrown'] if x != x0 + w // 2 else C['black'])
            px[x, y] = c + (255,)


def gen_maps():
    lines = ['# AUTO-GENERATED by tools/gen_art.py - do not edit by hand', 'class_name MapsData', 'extends RefCounted', '',
             'const ORDER = [%s]' % ', '.join('"%s"' % m['id'] for m in MAPS), '', 'const MAPS = {']
    for m in MAPS + [MENU_MAP]:
        cols = 40 if m['id'] == 'menu' else 32
        img, blocked, ptiles, special = bake_map(m, cols=cols)
        img.save(out(f'maps/{m["id"]}.png'))
        if m['id'] != 'menu':
            th = img.crop((0, 0, 512, 352)).resize((128, 88), Image.BOX)
            th.save(out(f'maps/{m["id"]}_thumb.png'))
        rows_txt = []
        for y in range(23):
            rows_txt.append('"' + ''.join('1' if (x, y) in blocked else '0' for x in range(cols)) + '"')
        paths_txt = []
        for p in m['paths']:
            paths_txt.append('[' + ', '.join('Vector2(%d, %d)' % (x * T + 8, y * T + 8) for x, y in p) + ']')
        lines.append('\t"%s": {' % m['id'])
        lines.append('\t\t"name": "%s", "tier": "%s", "hp_mult": %s, "theme": "%s",' % (
            m['name'], m['tier'], m['hp_mult'], m['theme']))
        lines.append('\t\t"desc": "%s",' % m['desc'])
        lines.append('\t\t"bg": "res://assets/maps/%s.png", "thumb": "res://assets/maps/%s_thumb.png",' % (
            m['id'], m['id']))
        lines.append('\t\t"paths": [%s],' % ', '.join(paths_txt))
        lines.append('\t\t"blocked": [%s],' % ', '.join(rows_txt))
        lava = sorted(t for t, k in special.items() if k == 'lava' and 0 <= t[0] < cols and 0 <= t[1] < 22)
        lines.append('\t\t"lava": [%s],' % ', '.join('Vector2i(%d, %d)' % t for t in lava))
        lines.append('\t},')
    lines.append('}')
    with open(os.path.join(ROOT, 'scripts/data/maps_data.gd'), 'w') as f:
        f.write('\n'.join(lines) + '\n')


if __name__ == '__main__':
    gen_sprites()
    gen_ui()
    gen_maps()
    print('ok')
