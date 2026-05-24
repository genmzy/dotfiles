from os import path
import fontforge

## usage: fontforge -script ./main.py

target_family_members = [
    "/home/genmzy/.local/share/fonts/LigaSFMono-Medium.otf",
]

source_family_members = [
    "./LigaSFMono-Regular.otf",
]

glyphs_to_copy = [
    #     "exclam",
    #     "quotedbl",
    #     "quotesingle",
    #     "asterisk",
    #     "comma",
    #     "period",
    #     "colon",
    #     "semicolon",
    #     "less",
    #     "greater",
    #     "at",
    #     # "asciicricum",
    #     "grave",
    #
    "parenleft",
    "parenright",
    "bracketleft",
    "bracketright",
    "braceleft",
    "braceright",
]

# glyphs_to_copy = [
#     "a",
#     "b",
#     "c",
#     "d",
#     "e",
#     "f",
#     "g",
#     "h",
#     "i",
#     "j",
#     "k",
#     "l",
#     "m",
#     "n",
#     "o",
#     "p",
#     "q",
#     "r",
#     "s",
#     "t",
#     "u",
#     "v",
#     "w",
#     "x",
#     "y",
#     "z",
#     "A",
#     "B",
#     "C",
#     "D",
#     "E",
#     "F",
#     "G",
#     "H",
#     "I",
#     "J",
#     "K",
#     "L",
#     "M",
#     "N",
#     "O",
#     "P",
#     "Q",
#     "R",
#     "S",
#     "T",
#     "U",
#     "V",
#     "W",
#     "X",
#     "Y",
#     "Z",
#     "zero",
#     "one",
#     "two",
#     "three",
#     "four",
#     "five",
#     "six",
#     "seven",
#     "eight",
#     "nine",
# ]

# glyphs_to_copy = ["f"]

# 2. Define the list of characters (by Unicode or glyph name)
# You can use ranges like ("ranges", None, 0x0021, 0x007E) or a list of specific glyphs

for i in range(len(source_family_members)):
    # 1. Open the source and destination fonts
    tname = path.basename(target_family_members[i])
    print(
        "Handling open file " + source_family_members[i] + " and " + tname + " now..."
    )
    source_font = fontforge.open(source_family_members[i])
    dest_font = fontforge.open(target_family_members[i])

    for item in glyphs_to_copy:
        source_font.selection.select(item)
        source_font.copy()
        dest_font.selection.select(item)
        dest_font.paste()
    # 3. Save the modified font
    # dest_font.save("merged_font.sfd")
    # Or generate a new binary font file
    dest_font.generate(tname)
