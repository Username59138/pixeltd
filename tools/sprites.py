# Pixel art definitions for Pixel TD. Each sprite is a list of rows; each char maps to a palette colour.
# '.' = transparent. An outline is added automatically around opaque pixels.
from PIL import Image

PAL = {
    'outline': (24, 20, 37),
}

C = {  # Endesga-32 inspired palette
    'red': (228, 59, 68), 'dred': (162, 38, 51), 'maroon': (115, 62, 57),
    'orange': (247, 118, 34), 'gold': (254, 174, 52), 'yellow': (254, 231, 97),
    'lgreen': (99, 199, 77), 'green': (62, 137, 72), 'dgreen': (38, 92, 66), 'xdgreen': (25, 60, 62),
    'dblue': (18, 78, 137), 'blue': (0, 153, 219), 'cyan': (44, 232, 245), 'white': (255, 255, 255),
    'lgray': (192, 203, 220), 'gray': (139, 155, 180), 'dgray': (90, 105, 136), 'xdgray': (58, 68, 102),
    'navy': (38, 43, 68), 'black': (24, 20, 37), 'pink': (246, 117, 122), 'purple': (104, 56, 108),
    'magenta': (181, 80, 136), 'skin': (232, 183, 150), 'dskin': (194, 133, 105), 'tan': (228, 166, 114),
    'brown': (184, 111, 80), 'dbrown': (115, 62, 57), 'xdbrown': (62, 39, 49), 'sand': (234, 212, 170),
    'rust': (190, 74, 47), 'lorange': (215, 118, 67),
}


def make(rows, cmap, outline=True, ocol=None):
    h = len(rows)
    w = max(len(r) for r in rows)
    pad = 1 if outline else 0
    img = Image.new('RGBA', (w + 2 * pad, h + 2 * pad), (0, 0, 0, 0))
    px = img.load()
    for y, r in enumerate(rows):
        for x, ch in enumerate(r):
            if ch == '.' or ch == ' ':
                continue
            col = cmap[ch]
            if isinstance(col, str):
                col = C[col]
            px[x + pad, y + pad] = tuple(col) + (255,) if len(col) == 3 else tuple(col)
    if outline:
        oc = ocol or C['black']
        src = img.copy().load()
        W, H = img.size
        for y in range(H):
            for x in range(W):
                if src[x, y][3] == 0:
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        nx, ny = x + dx, y + dy
                        if 0 <= nx < W and 0 <= ny < H and src[nx, ny][3] > 0:
                            px[x, y] = oc + (255,)
                            break
    return img


# ---------------------------------------------------------------- TOWERS (face right)
GUNNER = [
    "................",
    "......HHHH......",
    ".....HHhhHH.....",
    "...BBBBBBBBBB...",
    "......SSSS......",
    "......SSES......",
    "......SSSS......",
    ".....RRRRRR.....",
    "....CCCCCCCC....",
    "....CCLCCCCAAGGG",
    "....CCLCCCC.GG..",
    "....CCLCCCC.....",
    ".....WWYWWW.....",
    ".....PP..PP.....",
    ".....FF..FF.....",
]
GUNNER_C = {'H': 'dbrown', 'h': 'gold', 'B': 'maroon', 'S': 'skin', 'E': 'black', 'R': 'red',
            'C': 'brown', 'L': 'lorange', 'A': 'skin', 'G': 'gray', 'W': 'xdbrown', 'Y': 'gold',
            'P': 'dblue', 'F': 'xdbrown'}
GUNNER_ELITE = dict(GUNNER_C, H='navy', h='yellow', B='xdgray', C='purple', L='magenta', R='gold', G='lgray')

KNIGHT = [
    ".......RR.......",
    "......HHHH...w..",
    ".....HHHHHH..w..",
    ".....HHHHvv..w..",
    ".....HHHHHH..w..",
    "......GGGG...w..",
    "..SSSTTTTTT..w..",
    ".SSySSTTtTT.ggg.",
    ".SyyySTTtTTMAb..",
    ".SSySSTTtTTM.b..",
    "..SSSTTTTTT.....",
    "......LLLL......",
    "......LL.LL.....",
    ".....DDD.DDD....",
]
KNIGHT_C = {'R': 'red', 'H': 'lgray', 'v': 'navy', 'G': 'gray', 'S': 'dblue', 'y': 'gold', 'T': 'blue',
            't': 'white', 'w': 'white', 'g': 'gold', 'M': 'gray', 'A': 'lgray', 'b': 'dbrown', 'L': 'gray',
            'D': 'dgray'}
KNIGHT_ELITE = dict(KNIGHT_C, R='cyan', H='gold', G='yellow', S='dred', T='red', t='gold', w='cyan', L='gold',
                    D='brown', M='gold', A='yellow')

FLAMER = [
    "................",
    ".....HHHH.......",
    "....HHHHHH......",
    ".TTHHgGHgG......",
    ".TTHHHHHHH......",
    ".TTHHmmmH.......",
    ".TT.SSSSSS......",
    ".TTSSSSSSSS.....",
    ".TTSSsSSSAAnnnN.",
    ".TTSSsSSSA......",
    ".TT.SSSSSS......",
    "....WWWWWW......",
    ".....SS.SS......",
    ".....BB.BB......",
]
FLAMER_C = {'H': 'gold', 'g': 'cyan', 'G': 'dblue', 'm': 'dgray', 'T': 'red', 'S': 'orange', 's': 'gold',
            'A': 'xdbrown', 'n': 'gray', 'N': 'dgray', 'W': 'xdbrown', 'B': 'xdbrown'}
FLAMER_ELITE = dict(FLAMER_C, H='lgray', S='dgray', s='cyan', T='blue', g='orange', G='red', n='lgray')

# ---------------------------------------------------------------- ENEMIES (face right)
SLIME = [
    "....gggg....",
    "...gwGGGG...",
    "..gwGGGGGG..",
    "..GGGGGEGE..",
    ".GGGGGGGGGG.",
    ".GGGGGGGGGG.",
    ".DDDDDDDDDD.",
]
SLIME_C = {'g': 'lgreen', 'w': 'white', 'G': 'lgreen', 'E': 'black', 'D': 'green'}

RAT = [
    "..........ee..",
    "...GGGGGGGeG..",
    "..GGGGGGGGGEGp",
    "tGGGGGGGGGGGG.",
    "t.GGgggggGG...",
    "...f.f..f.f...",
]
RAT_C = {'e': 'pink', 'G': 'gray', 'E': 'red', 'p': 'pink', 't': 'pink', 'g': 'lgray', 'f': 'pink'}

GOBLIN = [
    "...........",
    ".e.GGGGG.e.",
    ".eGGGGGGGe.",
    "..GGGGGEGE.",
    "..GGGGGGGG.",
    "...GGGrrr..",
    "...BBBBB...",
    "..GBBbBBG.k",
    "..GBBbBBGkk",
    "...BBBBB.k.",
    "...WW.WW...",
    "...FF.FF...",
]
GOBLIN_C = {'e': 'green', 'G': 'lgreen', 'E': 'red', 'r': 'dgreen', 'B': 'brown', 'b': 'dbrown',
            'k': 'lgray', 'W': 'dbrown', 'F': 'xdbrown'}

WOLF = [
    "..............ee.",
    "..............EE.",
    "t.GGGGGGGGGGGGGGEn",
    "ttGGGGGGGGGGGGGGGn",
    "..GGGGGGGGGGGgww.",
    "..GG.GG...GG.GG..",
    "..GG.GG...GG.GG..",
]
WOLF_C = {'e': 'gray', 'E': 'dgray', 't': 'dgray', 'G': 'dgray', 'n': 'black', 'g': 'gray', 'w': 'white'}
# make a nicer wolf with an eye
WOLF[2] = "t.GGGGGGGGGGGGGyGn"
WOLF_C['y'] = 'yellow'

IRONCLAD = [
    "....HHHHH....",
    "...HHHHHHH...",
    "...HHHHvvH...",
    "...HHHHHHH...",
    "....hhhhh....",
    "..AAAAAAAAA..",
    ".AAAaAAAAAAA.",
    "SSSSAAAAAAAAk",
    "SySSAAaAAAAkk",
    "SSSSAAAAAAA.k",
    ".SS.LLLLLL...",
    "....LL..LL...",
    "...DDD..DDD..",
]
IRONCLAD_C = {'H': 'gray', 'v': 'black', 'h': 'dgray', 'A': 'lgray', 'a': 'white', 'S': 'xdgray', 'y': 'red',
              'k': 'lgray', 'L': 'dgray', 'D': 'xdgray'}

IMP = [
    ".h.......h.",
    ".hh.RRR.hh.",
    "..RRRRRRR..",
    "..RRRRRYRY.",
    "..RRRRRRRR.",
    "...RRwwwR..",
    "w..RRRRR...",
    "wwRRDDDRRR.",
    ".w.RDDDRR..",
    "...RRRRR...",
    "...RR.RR...",
    "..ff..ff...",
]
IMP_C = {'h': 'xdbrown', 'R': 'red', 'Y': 'yellow', 'w': 'orange', 'D': 'dred', 'f': 'dred'}

SHAMAN = [
    "....FF.......",
    "...FFFF...c..",
    "..MMMMMM.ccc.",
    "..MmmmmM..s..",
    "..mGGGEm..s..",
    "...GGGG...s..",
    "..PPPPPP..s..",
    ".PPPpPPPPGs..",
    ".PPPpPPPP.s..",
    ".PPPpPPPP.s..",
    ".PPPPPPPP.s..",
    "..PPPPPP..s..",
    "...ff.ff.....",
]
SHAMAN_C = {'F': 'red', 'M': 'gold', 'm': 'brown', 'G': 'lgreen', 'E': 'yellow', 'P': 'purple', 'p': 'magenta',
            'c': 'cyan', 's': 'brown', 'f': 'xdbrown'}

OGRE = [
    "......GGGGGG......",
    ".....GGGGGGGG.....",
    ".....GGGGGEGGE....",
    ".....GGGGGGGGG....",
    "......GGGwGwG.....",
    "...GGGGGGGGGGG....",
    "..GGGGGGGGGGGGG.cc",
    ".GGGBBBBBBBBBGGccc",
    ".GG.BBBBBBBBBGGcc.",
    ".GG.BBBBbBBBB.cbc.",
    ".GG.BBBBbBBBB..b..",
    ".gg.BBBBbBBBB..b..",
    ".gg..WWWWWWWW..b..",
    ".....GGG..GGG..b..",
    ".....GGG..GGG.....",
    "....FFFF..FFFF....",
]
OGRE_C = {'G': 'tan', 'E': 'black', 'w': 'white', 'B': 'dbrown', 'b': 'brown', 'g': 'dskin', 'W': 'xdbrown',
          'F': 'xdbrown', 'c': 'brown'}

SLIME_KING = [
    "......y.y.y.......",
    "......yyyyy.......",
    ".....ggggggg......",
    "...ggwwGGGGGGg....",
    "..gwwGGGGGGGGGG...",
    ".gwGGGGGGGEEGEEG..",
    ".GGGGGGGGGEEGEEGG.",
    "GGGGGGGGGGGGGGGGGG",
    "GGGGGGGGGGGGGGGGGG",
    "GGGGGGGGGGmmmmGGGG",
    "GGGGGGGGGGGGGGGGGG",
    ".DDDDDDDDDDDDDDDD.",
]
SLIME_KING_C = {'y': 'gold', 'g': 'cyan', 'w': 'white', 'G': 'blue', 'E': 'black', 'm': 'dblue', 'D': 'dblue'}
SLIME_KING_C['y'] = 'gold'

GOLEM = [
    "........SSSSSSS.........",
    ".......SSSSSSSSS........",
    ".......SSsSSSSSS........",
    ".......SSSSScSScS.......",
    ".......SSSSSSSSSS.......",
    "........SSSSSSSS........",
    "...SSSS..SSSSSS..SSSS...",
    "..SSSSSSSSSSSSSSSSSSSS..",
    ".SSSSSSSSSSSSSSSSSSSSSS.",
    ".SSSSsSSSSmcmSSSSsSSSSS.",
    ".SSSS.SSSSmccSSSS.SSSSS.",
    ".SSSS.SSSSSmSSSSS.SSSSS.",
    ".SsSS.SSSSSSSSSSS.SSsSS.",
    ".SSSS.SSSSsSSSSSS.SSSSS.",
    "..dd..SSSSSSSSSSS..dd...",
    "..dd..SSSSSSSSSSS..dd...",
    "......SSSS...SSSS.......",
    "......SSSS...SSSS.......",
    ".....SSSSS...SSSSS......",
    ".....ddddd...ddddd......",
]
GOLEM_C = {'S': 'gray', 's': 'dgray', 'c': 'cyan', 'm': 'blue', 'd': 'dgray'}

DEMON = [
    "..hh..................hh..",
    "..hhh....RRRRRRRR....hhh..",
    "...hhh..RRRRRRRRRR..hhh...",
    "....hhRRRRRRRRRRRRRRhh....",
    "......RRRRRRRRRRYYRYY.....",
    "......RRRRRRRRRRRRRRRR....",
    ".......RRRRRRwRwRwRR......",
    "...WW....RRRRRRRRR....WW..",
    "..WWWW.RRRRRRRRRRRRR.WWWW.",
    ".WWWWWRRRRRDDDDDRRRRRWWWWW",
    ".WWWW.RRRRDDDDDDDRRRR.WWWW",
    ".WWW..RRRRDDDYDDDRRRR..WWW",
    ".WW...RRRRDDDDDDDRRRR...WW",
    ".W....RRRRRDDDDDRRRRR....W",
    "......RRRR.RRRRR.RRRR.....",
    "......ff...RRRRR...ff.....",
    "..........RRRRRRR.........",
    "..........RRR.RRR.........",
    ".........RRRR.RRRR........",
    ".........ffff.ffff........",
]
DEMON_C = {'h': 'sand', 'R': 'dred', 'Y': 'yellow', 'w': 'white', 'W': 'purple', 'D': 'red', 'f': 'black'}

ENEMY_SPRITES = {
    'slime': (SLIME, SLIME_C), 'rat': (RAT, RAT_C), 'goblin': (GOBLIN, GOBLIN_C), 'wolf': (WOLF, WOLF_C),
    'ironclad': (IRONCLAD, IRONCLAD_C), 'imp': (IMP, IMP_C), 'shaman': (SHAMAN, SHAMAN_C),
    'ogre': (OGRE, OGRE_C), 'slime_king': (SLIME_KING, SLIME_KING_C), 'golem': (GOLEM, GOLEM_C),
    'demon': (DEMON, DEMON_C),
}

# ---------------------------------------------------------------- DECOR
TREE = [
    "....gggggg....",
    "..ggGGGGGGgg..",
    ".gGGGGGGGGGGg.",
    "gGGGGGlGGGGGGg",
    "gGGlGGGGGGGlGg",
    "gGGGGGGGGGGGGg",
    "dGGGGGGGlGGGGd",
    ".dGGlGGGGGGGd.",
    "..ddGGGGGGdd..",
    "....ddddddd...",
    "......TT......",
    "......TT......",
    ".....TTTT.....",
]
TREE_C = {'g': 'lgreen', 'G': 'green', 'l': 'lgreen', 'd': 'dgreen', 'T': 'dbrown'}

BUSH = [
    "..gggg..",
    ".gGGGGg.",
    "gGGlGGGg",
    "gGGGGlGg",
    ".dddddd.",
]
BUSH_C = {'g': 'lgreen', 'G': 'green', 'l': 'lgreen', 'd': 'dgreen'}

ROCK = [
    "...llll...",
    "..lLLLLg..",
    ".lLLLLLLg.",
    "lLLLLLLLgg",
    "gggggggggg",
]
ROCK_C = {'l': 'lgray', 'L': 'gray', 'g': 'dgray'}

PINE = [
    "......g.......",
    ".....gGg......",
    "....gGGGg.....",
    "...gGGGGGd....",
    ".....GGG......",
    "...gGGGGGg....",
    "..gGGGGGGGd...",
    "....GGGGG.....",
    "..gGGGGGGGd...",
    ".gGGGGGGGGGd..",
    "gGGGGGGGGGGGd.",
    "......T.......",
    ".....TTT......",
]
PINE_C = {'g': 'green', 'G': 'dgreen', 'd': 'xdgreen', 'T': 'dbrown'}
SNOW_PINE_C = {'g': 'white', 'G': 'dgreen', 'd': 'xdgreen', 'T': 'dbrown'}

CACTUS = [
    "....gg....",
    "...gGGg...",
    "...gGGg.g.",
    "g..gGGg.Gg",
    "Gg.gGGg.Gg",
    "GgggGGgggg",
    ".gGGGGGG..",
    "...gGGg...",
    "...gGGg...",
    "...gGGg...",
    "..dddddd..",
]
CACTUS_C = {'g': 'lgreen', 'G': 'green', 'd': 'tan'}

SKULL = [
    ".wwww.",
    "wwwwww",
    "wbwwbw",
    "wwwwww",
    ".w.w..",
]
SKULL_C = {'w': 'sand', 'b': 'black'}

SNOWMAN = [
    "...hhh...",
    "..hhhhh..",
    ".hhhhhhh.",
    "..wwwww..",
    "..wbwbw..",
    "..wwoow..",
    "...www...",
    ".rrrrrrr.",
    ".wwwwwww.",
    "wwwwbwwww",
    "wwwwwwwww",
    "wwwwbwwww",
    ".wwwwwww.",
]
SNOWMAN_C = {'h': 'black', 'w': 'white', 'b': 'black', 'o': 'orange', 'r': 'red'}

ICE_BLOCK = [
    ".cccccc.",
    "cwwccccb",
    "cwccccbb",
    "cccccccb",
    "ccccccbb",
    ".bbbbbb.",
]
ICE_BLOCK_C = {'c': 'cyan', 'w': 'white', 'b': 'blue'}

PUMP = [
    "..RRRRRRR.",
    "..RwwwwwR.",
    "..RwBBBwR.",
    "..RwwwwwR.",
    "..RRRRRRRh",
    "..RyyyyyR.h",
    "..RRRRRRR.h",
    "..RRRRRRR.h",
    "..RRRRRRRh.",
    "..RRRRRRR..",
    ".ggggggggg.",
]
PUMP_C = {'R': 'red', 'w': 'white', 'B': 'navy', 'y': 'yellow', 'h': 'black', 'g': 'gray'}

BARREL = [
    ".bbbbbb.",
    "bBBBBBBb",
    "yyyyyyyy",
    "bBBBBBBb",
    "bBBBBBBb",
    "yyyyyyyy",
    ".bbbbbb.",
]
BARREL_C = {'b': 'dblue', 'B': 'blue', 'y': 'yellow'}

TIRES = [
    ".kkkkkk.",
    "kKggggKk",
    ".kkkkkk.",
    "kKggggKk",
    ".kkkkkk.",
    "kKggggKk",
    ".kkkkkk.",
]
TIRES_C = {'k': 'black', 'K': 'xdgray', 'g': 'dgray'}

CONE = [
    "..o..",
    "..o..",
    ".www.",
    ".ooo.",
    "ooooo",
]
CONE_C = {'o': 'orange', 'w': 'white'}

CAR_RED = [
    "......WWWWWWWWW.........",
    ".....WcccWccccWW........",
    "....WccccWcccccWW.......",
    "..BBBBBBBBBBBBBBBBBBBB..",
    ".BBBBBBBBBBBBBBBBBBBBBy.",
    "BBBBBBBBBBBBBBBBBBBBBBBy",
    "BrrBBkkkkBBBBBBBkkkkBBBB",
    ".rr.kkggkk.....kkggkk...",
    "....kkggkk.....kkggkk...",
    ".....kkkk.......kkkk....",
]
CAR_C = {'W': 'dred', 'c': 'cyan', 'B': 'red', 'y': 'yellow', 'r': 'dred', 'k': 'black', 'g': 'gray'}
CAR_BLUE_C = dict(CAR_C, W='dblue', B='blue', r='dblue')

LAVA_ROCK = [
    "...kkkk...",
    "..kKKoKk..",
    ".kKKKKoKk.",
    "kKoKKKKKKk",
    "kkkkkkkkkk",
]
LAVA_ROCK_C = {'k': 'black', 'K': 'xdgray', 'o': 'orange'}

CRYSTAL = [
    "...c....",
    "..cCc.c.",
    "..cCc.Cc",
    ".ccCcCc.",
    ".cCCcCc.",
    "ccCCCCcc",
    ".pppppp.",
]
CRYSTAL_C = {'c': 'magenta', 'C': 'pink', 'p': 'purple'}

DEAD_TREE = [
    "..b...b..",
    "..bb.bb..",
    "b..bbb..b",
    "bb..b..bb",
    ".bbbbbbb.",
    "....b....",
    "....b....",
    "....b....",
    "...bbb...",
]
DEAD_TREE_C = {'b': 'xdbrown'}

DECOR_SPRITES = {
    'tree': (TREE, TREE_C), 'bush': (BUSH, BUSH_C), 'rock': (ROCK, ROCK_C), 'pine': (PINE, PINE_C),
    'snow_pine': (PINE, SNOW_PINE_C), 'cactus': (CACTUS, CACTUS_C), 'skull': (SKULL, SKULL_C),
    'snowman': (SNOWMAN, SNOWMAN_C), 'ice_block': (ICE_BLOCK, ICE_BLOCK_C), 'pump': (PUMP, PUMP_C),
    'barrel': (BARREL, BARREL_C), 'tires': (TIRES, TIRES_C), 'cone': (CONE, CONE_C),
    'car_red': (CAR_RED, CAR_C), 'car_blue': (CAR_RED, CAR_BLUE_C), 'lava_rock': (LAVA_ROCK, LAVA_ROCK_C),
    'crystal': (CRYSTAL, CRYSTAL_C), 'dead_tree': (DEAD_TREE, DEAD_TREE_C),
}

# ---------------------------------------------------------------- ICONS (8x8, outlined -> 10x10)
ICONS = {
    'heart': ([
        ".RR.RR.",
        "RwRRRRR",
        "RRRRRRR",
        ".RRRRR.",
        "..RRR..",
        "...R...",
    ], {'R': 'red', 'w': 'white'}),
    'coin': ([
        ".yyyy.",
        "yYYYYy",
        "yYyYYy",
        "yYyYYy",
        "yYYYYy",
        ".yyyy.",
    ], {'y': 'gold', 'Y': 'yellow'}),
    'wave': ([
        "f......",
        "fRRRR..",
        "fRRRRR.",
        "fRRRR..",
        "f......",
        "f......",
    ], {'f': 'lgray', 'R': 'red'}),
    'lock': ([
        "..ggg..",
        ".g...g.",
        ".g...g.",
        "yyyyyyy",
        "yyYkYyy",
        "yyykyyy",
        "yyyyyyy",
    ], {'g': 'lgray', 'y': 'gold', 'Y': 'yellow', 'k': 'black'}),
    'star': ([
        "...y...",
        "..yYy..",
        "yyYYYyy",
        ".yYYYy.",
        ".yy.yy.",
    ], {'y': 'gold', 'Y': 'yellow'}),
    'star_off': ([
        "...g...",
        "..ggg..",
        "ggggggg",
        ".ggggg.",
        ".gg.gg.",
    ], {'g': 'xdgray'}),
    'play': ([
        "w....",
        "www..",
        "wwwww",
        "www..",
        "w....",
    ], {'w': 'white'}),
    'ff': ([
        "w...w...",
        "ww..ww..",
        "wwwwwwww",
        "ww..ww..",
        "w...w...",
    ], {'w': 'white'}),
    'pause': ([
        "ww.ww",
        "ww.ww",
        "ww.ww",
        "ww.ww",
        "ww.ww",
    ], {'w': 'white'}),
    'skull': ([
        ".wwww.",
        "wwwwww",
        "wkwwkw",
        "wwwwww",
        ".wkkw.",
    ], {'w': 'white', 'k': 'black'}),
    'shield': ([
        "ggggggg",
        "gBBwBBg",
        "gBBwBBg",
        "gwwwwwg",
        ".gBwBg.",
        "..gwg..",
        "...g...",
    ], {'g': 'gray', 'B': 'blue', 'w': 'white'}),
    'fire': ([
        "...r...",
        "..rr.r.",
        ".rroorr",
        "rrooyor",
        "royyyor",
        ".ryyyr.",
    ], {'r': 'red', 'o': 'orange', 'y': 'yellow'}),
    'boot': ([
        "..bbb.",
        "..bbb.",
        "..bbb.",
        "bbbbb.",
        "bbbbbb",
    ], {'b': 'brown'}),
    'sword': ([
        "......w",
        ".....w.",
        "....w..",
        "g..w...",
        ".gw....",
        ".bg....",
        "b..g...",
    ], {'w': 'white', 'g': 'gold', 'b': 'brown'}),
    'range': ([
        "..ggg..",
        ".g...g.",
        "g..w..g",
        "g.www.g",
        "g..w..g",
        ".g...g.",
        "..ggg..",
    ], {'g': 'cyan', 'w': 'white'}),
    'clock': ([
        ".wwww.",
        "wwkwww",
        "wwkwww",
        "wwkkww",
        "wwwwww",
        ".wwww.",
    ], {'w': 'white', 'k': 'black'}),
    'trophy': ([
        "yyyyyyy",
        "yYYYYYy",
        ".yYYYy.",
        "..yYy..",
        "...y...",
        "..yyy..",
        ".yyyyy.",
    ], {'y': 'gold', 'Y': 'yellow'}),
    'up': ([
        "...g...",
        "..ggg..",
        ".ggggg.",
        "ggggggg",
        "..ggg..",
        "..ggg..",
    ], {'g': 'lgreen'}),
    'target': ([
        "..rrr..",
        ".r...r.",
        "r..r..r",
        "r.rrr.r",
        "r..r..r",
        ".r...r.",
        "..rrr..",
    ], {'r': 'red'}),
    'heal': ([
        "..g..",
        "..g..",
        "ggggg",
        "..g..",
        "..g..",
    ], {'g': 'lgreen'}),
}

# ---------------------------------------------------------------- v0.1 additions
SOLDIER = [
    "................",
    ".....GGGG.......",
    "....GgGGGG......",
    "....GGGGGGG.....",
    "......SSSE......",
    "......SSSS......",
    ".....UUUUU......",
    "....UUUUUUUKKKKk",
    "....UUuUUUAKK...",
    "....UUuUUUU.....",
    "....UUuUUUU.....",
    ".....BBBBB......",
    ".....UU.UU......",
    ".....KK.KK......",
]
SOLDIER_C = {'G': 'dgreen', 'g': 'green', 'S': 'skin', 'E': 'black', 'U': 'green', 'u': 'dgreen',
             'K': 'xdgray', 'k': 'gray', 'A': 'skin', 'B': 'dbrown'}
SOLDIER_ELITE = dict(SOLDIER_C, G='black', g='xdgray', U='navy', u='black', K='gold', k='yellow', B='gold')

GARAGE = [
    "..RRRRRRRRRRRR..",
    ".RRRRRRRRRRRRRR.",
    "RrRRrRRrRRrRRrRR",
    "WWWWWWWWWWWWWWWW",
    "WWyyWWWWWWWWWWWW",
    "WDDDDDDDDDDDDDDW",
    "WddddddddddddddW",
    "WDDDDDDDDDDDDDDW",
    "WddddddddddddddW",
    "WDDDDDDDDDDDDDDW",
    "WddddddddddddddW",
    "WDDDDDDDDDDDDDDW",
    "gggggggggggggggg",
]
GARAGE_C = {'R': 'red', 'r': 'dred', 'W': 'lgray', 'y': 'gold', 'D': 'gray', 'd': 'dgray', 'g': 'xdgray'}
GARAGE_ELITE = dict(GARAGE_C, R='dblue', r='navy', W='sand', y='cyan', D='gold', d='lorange')

CAR_S = [
    "..rrrr....",
    ".rcccrr...",
    "rrrrrrrrry",
    "rkkrrrkkrr",
    ".kk...kk..",
]
CAR_S_C = {'r': 'red', 'c': 'cyan', 'y': 'yellow', 'k': 'black'}
PICKUP = [
    "..bbbb......",
    ".bccbb......",
    "bbbbbbbbbbbb",
    "bbbbbbbbbbby",
    "bkkbbbbbkkbb",
    ".kk.....kk..",
]
PICKUP_C = {'b': 'blue', 'c': 'cyan', 'y': 'yellow', 'k': 'black'}
TRUCK = [
    "BBBBBBBB......",
    "BBBBBBBB.oooo.",
    "BBBBBBBB.occoo",
    "BBBBBBBB.ooooo",
    "BBBBBBBBoooooy",
    "gggggggggggggg",
    ".kk.kk....kk..",
    ".kk.kk....kk..",
]
TRUCK_C = {'B': 'lgray', 'o': 'orange', 'c': 'cyan', 'y': 'yellow', 'g': 'dgray', 'k': 'black'}
ARMORED = [
    "....GGGGG.....",
    "...GGGGGGgggk.",
    "..AAAAAAAAAA..",
    ".AAAAaAAAAAAA.",
    "AAAAAAAAAAAAAy",
    "AAAAAAAAAAAAAA",
    ".kk.kk..kk.kk.",
    ".kk.kk..kk.kk.",
]
ARMORED_C = {'G': 'dgreen', 'g': 'gray', 'k': 'black', 'A': 'green', 'a': 'lgreen', 'y': 'yellow'}

VEHICLES = {'car': (CAR_S, CAR_S_C), 'pickup': (PICKUP, PICKUP_C), 'truck': (TRUCK, TRUCK_C),
            'armored': (ARMORED, ARMORED_C)}

UP_ICONS = {
    'quick_draw': ([
        "....yy",
        "...yy.",
        "..yy..",
        ".yyyyy",
        "...yy.",
        "..yy..",
        ".yy...",
    ], {'y': 'yellow'}),
    'hollow_points': ([
        "..s..",
        ".sss.",
        ".sss.",
        ".ooo.",
        ".ooo.",
        ".ooo.",
        ".ddd.",
    ], {'s': 'lgray', 'o': 'gold', 'd': 'lorange'}),
    'dual_pistols': ([
        "gggggg..",
        "gg.b....",
        "........",
        "..gggggg",
        "..gg.b..",
    ], {'g': 'lgray', 'b': 'brown'}),
    'sharpened_blade': ([
        "y.....w",
        "....ww.",
        "...ww..",
        "..ww...",
        "gww....",
        ".g.....",
        "b.g..y.",
    ], {'w': 'white', 'g': 'gold', 'b': 'brown', 'y': 'yellow'}),
    'cleave': ([
        "..www..",
        ".w...w.",
        "w.....w",
        "w.....w",
        ".......",
        "w.....w",
    ], {'w': 'white'}),
    'champion': ([
        "y..y..y",
        "yy.y.yy",
        "yyyyyyy",
        "yrybyry",
        "yyyyyyy",
    ], {'y': 'gold', 'r': 'red', 'b': 'cyan'}),
    'ap_rounds': ([
        "..r..",
        ".rrr.",
        ".sss.",
        ".ooo.",
        ".ooo.",
        ".ooo.",
        ".ddd.",
    ], {'r': 'red', 's': 'lgray', 'o': 'gold', 'd': 'lorange'}),
    'grenades': ([
        "..gg..",
        ".g..g.",
        ".GGGG.",
        "GGlGGG",
        "GGGGGG",
        "GlGGGG",
        ".GGGG.",
    ], {'g': 'lgray', 'G': 'green', 'l': 'lgreen'}),
    'machine_gun': ([
        "o.o.o.o",
        "o.o.o.o",
        "s.s.s.s",
        "kkkkkkk",
    ], {'o': 'gold', 's': 'lgray', 'k': 'xdgray'}),
    'bigger_tank': ([
        ".rrrr.",
        "rRrrrr",
        "rRrwwr",
        "rRrwkr",
        "rRrrrr",
        "rRrrrr",
        ".rrrr.",
    ], {'r': 'red', 'R': 'pink', 'w': 'white', 'k': 'black'}),
    'napalm': ([
        "..o..",
        "..o..",
        ".ooo.",
        "ooyoo",
        "oyyyo",
        "ooyoo",
        ".ooo.",
    ], {'o': 'orange', 'y': 'yellow'}),
    'blue_flame': ([
        "...b...",
        "..bb.b.",
        ".bbccbb",
        "bbccwcb",
        "bcwwwcb",
        ".bwwwb.",
    ], {'b': 'dblue', 'c': 'blue', 'w': 'cyan'}),
}

CURSOR_ARROW = [
    "w.......",
    "ww......",
    "wlw.....",
    "wllw....",
    "wlllw...",
    "wllllw..",
    "wlllllw.",
    "wllllllw",
    "wlllwww.",
    "wwlw....",
    "w..lw...",
    "...lw...",
    "....w...",
]
CURSOR_HAND = [
    "..ww....",
    "..wl....",
    "..wl....",
    "..wlwww.",
    "..wlllww",
    "wwwlllll",
    "wlllllll",
    ".wllllll",
    "..wlllll",
    "..wllll.",
    "...www..",
]
CURSOR_CROSS = [
    "yyy...yyy",
    "y.......y",
    "y.......y",
    ".........",
    "....w....",
    ".........",
    "y.......y",
    "y.......y",
    "yyy...yyy",
]
CURSOR_C = {'w': 'white', 'l': 'lgray', 'y': 'yellow'}
