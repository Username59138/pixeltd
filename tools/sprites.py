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


# shaded tones used by the detailed (v0.1) characters
C['skin_l'] = (246, 214, 180)
C['skin_d'] = (194, 133, 105)
C['skin_dd'] = (150, 95, 80)
C['hat_l'] = (184, 111, 80)
C['hat'] = (138, 78, 62)
C['hat_d'] = (92, 48, 48)
C['den_l'] = (60, 120, 190)
C['den'] = (36, 82, 150)
C['den_d'] = (26, 52, 100)
C['stl_l'] = (232, 238, 248)
C['stl'] = (176, 188, 210)
C['stl_d'] = (116, 130, 160)
C['stl_dd'] = (70, 80, 112)
C['blu_l'] = (60, 170, 230)
C['blu'] = (24, 112, 190)
C['blu_d'] = (18, 70, 130)
C['gld_l'] = (255, 236, 120)
C['gld'] = (240, 180, 50)
C['gld_d'] = (180, 110, 40)
C['olv_l'] = (150, 170, 80)
C['olv'] = (100, 125, 60)
C['olv_d'] = (62, 82, 46)
C['olv_dd'] = (40, 52, 36)
C['tan_l'] = (220, 196, 140)
C['tan_m'] = (176, 150, 100)
C['tan_d'] = (124, 100, 70)
C['org_l'] = (255, 170, 70)
C['org'] = (240, 120, 30)
C['org_d'] = (180, 70, 30)
C['red_l'] = (240, 90, 90)
C['red_m'] = (200, 45, 55)
C['red_d'] = (130, 30, 45)
C['gun_l'] = (200, 210, 225)
C['gun'] = (110, 120, 145)
C['gun_d'] = (60, 66, 90)
C['wd'] = (130, 80, 50)
C['wd_d'] = (85, 50, 35)
C['glass'] = (120, 230, 245)
C['glass_d'] = (40, 140, 180)


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
    "....................",
    "........hhh.........",
    ".......hHHHH........",
    "......hHHHHHd.......",
    "......HHHHHHd.......",
    "......rrrrrrd.......",
    "...BBBBBBBBBBBBB....",
    "....ddddddddddd.....",
    "......kfFFFFF.......",
    "......kFFFFeF.......",
    "......kFFFFFFn......",
    "......kfzFFFz.......",
    ".......fzzzz........",
    "......RRRRRRR.......",
    ".....wVVRRRVVv......",
    "....wwVVWWWVvFFlgggG",
    "....wWVVWWWVvFFGGgg.",
    "....FfVVWWWVv...G...",
    ".....vVVWWWVV.......",
    ".....LLLLyLLLx......",
    ".....jjJ..jjJx......",
    ".....jjJ..jjJ.......",
    ".....oooO.oooO......",
    "....ooooy.ooooy.....",
]
GUNNER_C = {'h': 'hat_l', 'H': 'hat', 'd': 'hat_d', 'r': 'red_m', 'B': 'hat', 'k': 'xdbrown', 'F': 'skin', 'f': 'skin_d', 'e': 'black', 'n': 'skin_d', 'z': 'skin_dd', 'R': 'red_l', 'V': 'hat_l', 'v': 'hat_d', 'w': 'sand', 'W': 'tan_l', 'l': 'gun_l', 'g': 'gun', 'G': 'gun_d', 'L': 'xdbrown', 'y': 'gld', 'x': 'hat', 'j': 'den', 'J': 'den_d', 'o': 'hat', 'O': 'hat_d'}
GUNNER_ELITE = {'h': 'xdgray', 'H': 'navy', 'd': 'black', 'r': 'gld', 'B': 'navy', 'k': 'xdbrown', 'F': 'skin', 'f': 'skin_d', 'e': 'black', 'n': 'skin_d', 'z': 'skin_dd', 'R': 'gld_l', 'V': 'purple', 'v': 'black', 'w': 'sand', 'W': 'tan_l', 'l': 'gld_l', 'g': 'gld', 'G': 'gld_d', 'L': 'xdbrown', 'y': 'gld', 'x': 'navy', 'j': 'den', 'J': 'den_d', 'o': 'navy', 'O': 'black'}

KNIGHT = [
    "........RR..........",
    ".......RrRR.....w...",
    ".......Rr.......wW..",
    "......aaaa......wW..",
    ".....aAAAAs.....wW..",
    ".....AAAAAAs....wW..",
    ".....AAAvvvs....wW..",
    ".....AAAAAAs....wW..",
    "......sAAAs.....wW..",
    "....pPPgggPPp...wW..",
    "..ccc.TTTTTPPp..wW..",
    ".cCCCc.TTyTTPaGYYYG.",
    "cCCyCCcTyyyTPaQAAb..",
    "cCyyyCcTTyTTPa..b...",
    "cCCyCCcTTTTTt.......",
    ".cCCCc.TTTTTt.......",
    "..ccc..MMMMMM.......",
    ".......mMmMmM.......",
    ".......LLl.LLl......",
    ".......LLl.LLl......",
    ".......LLl.LLl......",
    "......DDDd.DDDd.....",
    "......DDDd.DDDd.....",
    "....................",
]
KNIGHT_C = {'R': 'red_m', 'r': 'red_l', 'w': 'stl_l', 'W': 'stl', 'a': 'stl_l', 'A': 'stl', 's': 'stl_d', 'v': 'black', 'p': 'stl_l', 'P': 'stl_d', 'g': 'stl_dd', 'c': 'gld_d', 'C': 'blu', 'y': 'gld_l', 'T': 'blu', 't': 'blu_d', 'G': 'gld_d', 'Y': 'gld', 'Q': 'stl', 'b': 'wd', 'M': 'stl_d', 'm': 'stl_dd', 'L': 'stl', 'l': 'stl_d', 'D': 'stl_d', 'd': 'stl_dd'}
KNIGHT_ELITE = {'R': 'glass', 'r': 'red_l', 'w': 'glass', 'W': 'blu_l', 'a': 'gld_l', 'A': 'gld', 's': 'gld_d', 'v': 'black', 'p': 'gld_l', 'P': 'gld_d', 'g': 'stl_dd', 'c': 'gld_d', 'C': 'red_m', 'y': 'gld_l', 'T': 'red_m', 't': 'red_d', 'G': 'gld_d', 'Y': 'gld', 'Q': 'stl', 'b': 'wd', 'M': 'gld_d', 'm': 'stl_dd', 'L': 'gld', 'l': 'gld_d', 'D': 'gld_d', 'd': 'hat_d'}

FLAMER = [
    "....................",
    "....................",
    ".......HHHHH........",
    "......HhHHHHH.......",
    ".....HhHHHHHHd......",
    ".....HHHmmmHHd......",
    ".nn..HHmgGmgGd......",
    "tTTt.HHmGgmGgd......",
    "tTTt.HHHmmmmHd......",
    "tTTt..dHmffmd.......",
    "tYYt.SSSSccSSS......",
    "tYYtSSsSSSSSSSs.....",
    "tTTtSSsSSSSSSAAnnnnq",
    "tTTtSSsSSSSSSAAnNNNQ",
    "tTTt.SskykykyS......",
    ".tt..SsSSSSSSs......",
    ".....WWWWWWWWW......",
    ".....SSS..SSS.......",
    ".....SSs..SSs.......",
    ".....SSs..SSs.......",
    ".....BBB..BBB.......",
    "....BBBBb.BBBBb.....",
    "....................",
    "....................",
]
FLAMER_C = {'H': 'org', 'h': 'org_l', 'd': 'org_d', 'm': 'gun_d', 'g': 'glass', 'G': 'glass_d', 'f': 'gun', 't': 'red_d', 'T': 'red_m', 'S': 'org', 's': 'org_d', 'c': 'gld', 'A': 'xdbrown', 'n': 'gun', 'N': 'gun_d', 'W': 'xdbrown', 'B': 'xdbrown', 'b': 'black', 'Y': 'gld', 'q': 'yellow', 'Q': 'org_l', 'k': 'black', 'y': 'gld'}
FLAMER_ELITE = {'H': 'stl', 'h': 'stl_l', 'd': 'stl_d', 'm': 'gun_d', 'g': 'org_l', 'G': 'org_d', 'f': 'gun', 't': 'blu_d', 'T': 'blu', 'S': 'stl', 's': 'stl_d', 'c': 'glass', 'A': 'xdbrown', 'n': 'gun', 'N': 'gun_d', 'W': 'xdbrown', 'B': 'xdbrown', 'b': 'black', 'Y': 'glass', 'q': 'glass', 'Q': 'blu_l', 'k': 'black', 'y': 'gld'}

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
    'gear': ([
        "..g.g..",
        ".ggggg.",
        "ggg.ggg",
        ".g...g.",
        "ggg.ggg",
        ".ggggg.",
        "..g.g..",
    ], {'g': 'lgray'}),
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
    "....................",
    "....................",
    "........hhhh........",
    "......hhHHHHH.......",
    ".....hHHHnHHHd......",
    ".....HHHHqQqQd......",
    ".....dddddddddd.....",
    "......kFFFFFF.......",
    "......kFFFeFF.......",
    "......kfFFFFFn......",
    ".......fzzzf........",
    "....BBOOOOOOO.......",
    "...BBbOoOOOoO.......",
    "...BBbOoOOOOOFtGGGGl",
    "...BBbOoOPPOOttGGG..",
    "...BBbOOOPPOOO..G...",
    "....bbOOOOOOOO......",
    ".....wwwwywwww......",
    ".....OOO..OOO.......",
    ".....OOo..OOo.......",
    ".....OOo..OOo.......",
    ".....KKK..KKK.......",
    "....KKKKk.KKKKk.....",
    "....................",
]
SOLDIER_C = {'q': 'glass', 'Q': 'glass_d', 'e': 'black', 'h': 'olv_l', 'H': 'olv', 'n': 'olv_l', 'd': 'olv_d', 'k': 'xdbrown', 'F': 'skin', 'f': 'skin_d', 'z': 'skin_dd', 'g': 'glass', 'G': 'gun_d', 'B': 'tan_m', 'b': 'tan_d', 'O': 'tan_l', 'o': 'tan_m', 'P': 'olv', 't': 'wd', 'T': 'wd_d', 'l': 'gun_l', 'w': 'olv_dd', 'y': 'gld', 'K': 'xdbrown'}
SOLDIER_ELITE = {'q': 'red_l', 'Q': 'red_d', 'e': 'black', 'h': 'xdgray', 'H': 'navy', 'n': 'xdgray', 'd': 'black', 'k': 'xdbrown', 'F': 'skin', 'f': 'skin_d', 'z': 'skin_dd', 'g': 'glass', 'G': 'gun_d', 'B': 'gun_d', 'b': 'black', 'O': 'gun', 'o': 'gun_d', 'P': 'navy', 't': 'gld', 'T': 'gld_d', 'l': 'gld_l', 'w': 'black', 'y': 'gld', 'K': 'xdbrown'}

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
