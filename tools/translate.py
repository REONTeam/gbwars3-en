#!/usr/bin/env python3

charmap_main = {
    0x00: "[ED]",
    0x01: "[LF]",
    0x10: "•",
    0x11: "◀",
    0x12: "▶",
    0x13: "▼",
    0x14: "▲",
    0x15: "♪",
    0x16: "〇",
    0x17: "〜",
    0x18: "♥",
    0x19: "X",
    0x1a: "x",
    0x1b: "「",
    0x1c: "|",
    0x1d: "」",
    0x1e: "\\",
    0x20: " ",
    0x21: "!",
    0x22: "\"",
    0x23: "#",
    0x24: "$",
    0x25: "%",
    0x26: "&",
    0x27: "'",
    0x28: "(",
    0x29: ")",
    0x2a: "*",
    0x2b: "+",
    0x2c: ",",
    0x2d: "ー",
    0x2e: "。",
    0x2f: "/",
    0x30: "0",
    0x31: "1",
    0x32: "2",
    0x33: "3",
    0x34: "4",
    0x35: "5",
    0x36: "6",
    0x37: "7",
    0x38: "8",
    0x39: "9",
    0x3a: "=",
    0x3b: ";",
    0x3c: "<",
    0x3d: ":",
    0x3e: ">",
    0x3f: "?",
    0x40: "@",
    0x41: "A",
    0x42: "B",
    0x43: "C",
    0x44: "D",
    0x45: "E",
    0x46: "F",
    0x47: "G",
    0x48: "H",
    0x49: "I",
    0x4a: "J",
    0x4b: "K",
    0x4c: "L",
    0x4d: "M",
    0x4e: "N",
    0x4f: "O",
    0x50: "P",
    0x51: "Q",
    0x52: "R",
    0x53: "S",
    0x54: "T",
    0x55: "U",
    0x56: "V",
    0x57: "W",
    0x58: "X",
    0x59: "Y",
    0x5a: "Z",
    0x5b: "[",
    0x5c: "¥",
    0x5d: "]",
    0x5e: "^",
    0x5f: "_",
    0x60: "を",
    0x61: "あ",
    0x62: "い",
    0x63: "う",
    0x64: "え",
    0x65: "お",
    0x66: "か",
    0x67: "き",
    0x68: "く",
    0x69: "け",
    0x6a: "こ",
    0x6b: "さ",
    0x6c: "し",
    0x6d: "す",
    0x6e: "せ",
    0x6f: "そ",
    0x70: "た",
    0x71: "ち",
    0x72: "つ",
    0x73: "て",
    0x74: "と",
    0x75: "な",
    0x76: "に",
    0x77: "ぬ",
    0x78: "ね",
    0x79: "の",
    0x7a: "は",
    0x7b: "ひ",
    0x7c: "ふ",
    0x7d: "へ",
    0x7e: "ほ",
    0x7f: "ま",
    0x80: "み",
    0x81: "む",
    0x82: "め",
    0x83: "も",
    0x84: "や",
    0x85: "ゆ",
    0x86: "よ",
    0x87: "ら",
    0x88: "り",
    0x89: "る",
    0x8a: "れ",
    0x8b: "ろ",
    0x8c: "わ",
    0x8d: "ん",
    0x8e: "が",
    0x8f: "ぎ",
    0x90: "ぐ",
    0x91: "げ",
    0x92: "ご",
    0x93: "ざ",
    0x94: "じ",
    0x95: "ず",
    0x96: "ぜ",
    0x97: "ぞ",
    0x98: "だ",
    0x99: "ぢ",
    0x9a: "づ",
    0x9b: "で",
    0x9c: "ど",
    0x9d: "ば",
    0x9e: "び",
    0x9f: "ぶ",
    0xa0: "べ",
    0xa1: "ぼ",
    0xa2: "ぱ",
    0xa3: "ぴ",
    0xa4: "ぷ",
    0xa5: "ぺ",
    0xa6: "ぽ",
    0xa7: "ぁ",
    0xa8: "ぃ",
    0xa9: "ぅ",
    0xaa: "ぇ",
    0xab: "ぉ",
    0xac: "ゃ",
    0xad: "ゅ",
    0xae: "ょ",
    0xaf: "っ",
    0xb0: "ヲ",
    0xb1: "ア",
    0xb2: "イ",
    0xb3: "ウ",
    0xb4: "エ",
    0xb5: "オ",
    0xb6: "カ",
    0xb7: "キ",
    0xb8: "ク",
    0xb9: "ケ",
    0xba: "コ",
    0xbb: "サ",
    0xbc: "シ",
    0xbd: "ス",
    0xbe: "セ",
    0xbf: "ソ",
    0xc0: "タ",
    0xc1: "チ",
    0xc2: "ツ",
    0xc3: "テ",
    0xc4: "ト",
    0xc5: "ナ",
    0xc6: "ニ",
    0xc7: "ヌ",
    0xc8: "ネ",
    0xc9: "ノ",
    0xca: "ハ",
    0xcb: "ヒ",
    0xcc: "フ",
    0xcd: "ヘ",
    0xce: "ホ",
    0xcf: "マ",
    0xd0: "ミ",
    0xd1: "ム",
    0xd2: "メ",
    0xd3: "モ",
    0xd4: "ヤ",
    0xd5: "ユ",
    0xd6: "ヨ",
    0xd7: "ラ",
    0xd8: "リ",
    0xd9: "ル",
    0xda: "レ",
    0xdb: "ロ",
    0xdc: "ワ",
    0xdd: "ン",
    0xde: "ガ",
    0xdf: "ギ",
    0xe0: "グ",
    0xe1: "ゲ",
    0xe2: "ゴ",
    0xe3: "ザ",
    0xe4: "ジ",
    0xe5: "ズ",
    0xe6: "ゼ",
    0xe7: "ゾ",
    0xe8: "ダ",
    0xe9: "ヂ",
    0xea: "ヅ",
    0xeb: "デ",
    0xec: "ド",
    0xed: "バ",
    0xee: "ビ",
    0xef: "ブ",
    0xf0: "ベ",
    0xf1: "ボ",
    0xf2: "パ",
    0xf3: "ピ",
    0xf4: "プ",
    0xf5: "ペ",
    0xf6: "ポ",
    0xf7: "ァ",
    0xf8: "ィ",
    0xf9: "ゥ",
    0xfa: "ェ",
    0xfb: "ォ",
    0xfc: "ャ",
    0xfd: "ュ",
    0xfe: "ョ",
    0xff: "ッ"
}

charmap_unit = {
    0x00: "[ED]",
    0x01: "ヲ",
    0x02: "ア",
    0x03: "イ",
    0x04: "ウ",
    0x05: "エ",
    0x06: "オ",
    0x07: "カ",
    0x08: "キ",
    0x09: "ク",
    0x0A: "ケ",
    0x0B: "コ",
    0x0C: "サ",
    0x0D: "シ",
    0x0E: "ス",
    0x0F: "セ",
    0x10: "ソ",
    0x11: "タ",
    0x12: "チ",
    0x13: "ツ",
    0x14: "テ",
    0x15: "ト",
    0x16: "ナ",
    0x17: "ニ",
    0x18: "ヌ",
    0x19: "ネ",
    0x1A: "ノ",
    0x1B: "ハ",
    0x1C: "ヒ",
    0x1D: "フ",
    0x1E: "ヘ",
    0x1F: "ホ",
    0x20: "マ",
    0x21: "ミ",
    0x22: "ム",
    0x23: "メ",
    0x24: "モ",
    0x25: "ヤ",
    0x26: "ユ",
    0x27: "ヨ",
    0x28: "ラ",
    0x29: "リ",
    0x2A: "ル",
    0x2B: "レ",
    0x2C: "ロ",
    0x2D: "ワ",
    0x2E: "ン",
    0x2F: "ガ",
    0x30: "ギ",
    0x31: "グ",
    0x32: "ゲ",
    0x33: "ゴ",
    0x34: "ザ",
    0x35: "ジ",
    0x36: "ズ",
    0x37: "ゼ",
    0x38: "ゾ",
    0x39: "ダ",
    0x3A: "ヂ",
    0x3B: "ヅ",
    0x3C: "デ",
    0x3D: "ド",
    0x3E: "バ",
    0x3F: "ビ",
    0x40: "ブ",
    0x41: "ベ",
    0x42: "ボ",
    0x43: "パ",
    0x44: "ピ",
    0x45: "プ",
    0x46: "ペ",
    0x47: "ポ",
    0x48: "ァ",
    0x49: "ィ",
    0x4A: "ゥ",
    0x4B: "ェ",
    0x4C: "ォ",
    0x4D: "ャ",
    0x4E: "ュ",
    0x4F: "ョ",
    0x50: "ッ",
    0x51: "―",
    0x52: "LV",
    0x53: "",
    0x54: "<",
    0x55: ">",
    0x56: "?",
    0x57: "。",
    0x58: "",
    0x59: "",
    0x5A: "",
    0x5B: "",
    0x5C: "",
    0x5D: "",
    0x5E: "",
    0x5F: "",
    0x60: "を",
    0x61: "あ",
    0x62: "い",
    0x63: "う",
    0x64: "え",
    0x65: "お",
    0x66: "か",
    0x67: "き",
    0x68: "く",
    0x69: "け",
    0x6A: "こ",
    0x6B: "さ",
    0x6C: "し",
    0x6D: "す",
    0x6E: "せ",
    0x6F: "そ",
    0x70: "た",
    0x71: "ち",
    0x72: "つ",
    0x73: "て",
    0x74: "と",
    0x75: "な",
    0x76: "に",
    0x77: "ぬ",
    0x78: "ね",
    0x79: "の",
    0x7A: "は",
    0x7B: "ひ",
    0x7C: "ふ",
    0x7D: "へ",
    0x7E: "ほ",
    0x7F: "ま",
    0x80: " ",
    0x81: "0",
    0x82: "1",
    0x83: "2",
    0x84: "3",
    0x85: "4",
    0x86: "5",
    0x87: "6",
    0x88: "7",
    0x89: "8",
    0x8A: "9",
    0x8B: "A",
    0x8C: "B",
    0x8D: "C",
    0x8E: "D",
    0x8F: "E",
    0x90: "F",
    0x91: "G",
    0x92: "H",
    0x93: "I",
    0x94: "J",
    0x95: "K",
    0x96: "L",
    0x97: "M",
    0x98: "N",
    0x99: "O",
    0x9A: "P",
    0x9B: "Q",
    0x9C: "R",
    0x9D: "S",
    0x9E: "T",
    0x9F: "U",
    0xA0: "V",
    0xA1: "W",
    0xA2: "X",
    0xA3: "Y",
    0xA4: "Z",
    0xA5: ".",
    0xA6: "/",
    0xA7: "-",
    0xA8: "[DAY]",
    0xB1: "[G]",
    0xB2: "[M]",
    0xB3: "[R]",
    0xB4: "[m]",
    0xB5: "[T]",
    0xB6: "[E]",
    0xB7: "[ET]",
    0xB8: "[ク]",
    0xB9: "[ケ]",
    0xBA: "[コ]",
    0xBB: "[サ]",
    0xBC: "[シ]",
    0xBD: "[ス]",
    0xBE: "[セ]",
    0xBF: "[ソ]",
    0xC0: "[タ]",
    0xC1: "[チ]",
    0xC2: "[ツ]",
    0xC3: "[テ]",
    0xC4: "[ト]",
    0xC5: "[ナ]",
    0xC6: "[ニ]",
    0xC7: "[ヌ]",
    0xC8: "[ネ]",
    0xC9: "[ノ]",
    0xCA: "[ハ]",
    0xCB: "[ヒ]",
    0xCC: "[フ]",
    0xCD: "[ヘ]",
    0xCE: "[ホ]",
    0xCF: "[マ]",
    0xD0: "み",
    0xD1: "む",
    0xD2: "め",
    0xD3: "も",
    0xD4: "や",
    0xD5: "ゆ",
    0xD6: "よ",
    0xD7: "ら",
    0xD8: "り",
    0xD9: "る",
    0xDA: "れ",
    0xDB: "ろ",
    0xDC: "わ",
    0xDD: "ん",
    0xDE: "が",
    0xDF: "ぎ",
    0xE0: "ぐ",
    0xE1: "げ",
    0xE2: "ご",
    0xE3: "ざ",
    0xE4: "じ",
    0xE5: "ず",
    0xE6: "ぜ",
    0xE7: "ぞ",
    0xE8: "だ",
    0xE9: "ぢ",
    0xEA: "づ",
    0xEB: "で",
    0xEC: "ど",
    0xED: "ば",
    0xEE: "び",
    0xEF: "ぶ",
    0xF0: "べ",
    0xF1: "ぼ",
    0xF2: "ぱ",
    0xF3: "ぴ",
    0xF4: "ぷ",
    0xF5: "ぺ",
    0xF6: "ぽ",
    0xF7: "ぁ",
    0xF8: "ぃ",
    0xF9: "ぅ",
    0xFA: "ぇ",
    0xFB: "ぉ",
    0xFC: "ゃ",
    0xFD: "ゅ",
    0xFE: "ょ",
    0xFF: "っ"
}

charmap_news = {
    0x01: "!",
    0x08: "(",
    0x09: ")",
    0x0C: ",",
    0x0D: "ー",
    0x0E: ".",
    0x11: "A",
    0x12: "B",
    0x13: "C",
    0x14: "D",
    0x15: "E",
    0x16: "F",
    0x17: "G",
    0x18: "H",
    0x19: "I",
    0x1A: "J",
    0x1B: "K",
    0x1C: "L",
    0x1D: "M",
    0x1E: "N",
    0x1F: "O",
    0x20: "P",
    0x21: "Q",
    0x22: "R",
    0x23: "S",
    0x24: "T",
    0x25: "U",
    0x26: "V",
    0x27: "W",
    0x28: "X",
    0x29: "Y",
    0x2A: "Z",
    0x2B: "[",
    0x2D: "]",
    0x30: "0",
    0x31: "1",
    0x32: "2",
    0x33: "3",
    0x34: "4",
    0x35: "5",
    0x36: "6",
    0x37: "7",
    0x38: "8",
    0x39: "9",
    0x3A: ":",
    0x3B: ";",
    0x3C: "<",
    0x3D: "=",
    0x3E: ">",
    0x3F: "?",
    0x40: "@",
    0x41: "a",
    0x42: "b",
    0x43: "c",
    0x44: "d",
    0x45: "e",
    0x46: "f",
    0x47: "g",
    0x48: "h",
    0x49: "i",
    0x4a: "j",
    0x4b: "k",
    0x4c: "l",
    0x4d: "m",
    0x4e: "n",
    0x4f: "o",
    0x50: "p",
    0x51: "q",
    0x52: "r",
    0x53: "s",
    0x54: "t",
    0x55: "u",
    0x56: "v",
    0x57: "w",
    0x58: "x",
    0x59: "y",
    0x5a: "z",
    0x5C: "¥",
    0x5E: "^",
    0x5F: " ",
    0x60: "ぁ",
    0x61: "あ",
    0x62: "い",
    0x63: "ぃ",
    0x64: "う",
    0x65: "ぅ",
    0x66: "え",
    0x67: "ぇ",
    0x68: "お",
    0x69: "ぉ",
    0x6A: "か",
    0x6B: "が",
    0x6C: "き",
    0x6D: "ぎ",
    0x6E: "く",
    0x6F: "ぐ",
    0x70: "け",
    0x71: "げ",
    0x72: "こ",
    0x73: "ご",
    0x74: "さ",
    0x75: "ざ",
    0x76: "し",
    0x77: "じ",
    0x78: "す",
    0x79: "ず",
    0x7A: "せ",
    0x7B: "ぜ",
    0x7C: "そ",
    0x7D: "ぞ",
    0x7E: "た",
    0x7F: "だ",
    0x80: "ち",
    0x81: "ぢ",
    0x82: "っ",
    0x83: "つ",
    0x84: "づ",
    0x85: "て",
    0x86: "で",
    0x87: "と",
    0x88: "ど",
    0x89: "な",
    0x8A: "に",
    0x8B: "ぬ",
    0x8C: "ね",
    0x8D: "の",
    0x8E: "は",
    0x8F: "ば",
    0x90: "ぱ",
    0x91: "ひ",
    0x92: "び",
    0x93: "ぴ",
    0x94: "ふ",
    0x95: "ぶ",
    0x96: "ぷ",
    0x97: "へ",
    0x98: "べ",
    0x99: "ぺ",
    0x9A: "ほ",
    0x9B: "ぼ",
    0x9C: "ぽ",
    0x9D: "ま",
    0x9E: "み",
    0x9F: "む",
    0xA0: "め",
    0xA1: "も",
    0xA2: "ゃ",
    0xA3: "や",
    0xA4: "ゅ",
    0xA5: "ゆ",
    0xA6: "ょ",
    0xA7: "よ",
    0xA8: "ら",
    0xA9: "り",
    0xAA: "る",
    0xAB: "れ",
    0xAC: "ろ",
    0xAD: "わ",
    0xAE: "を",
    0xAF: "ん",
    0xB0: "ァ",
    0xB1: "ア",
    0xB2: "ィ",
    0xB3: "イ",
    0xB4: "ゥ",
    0xB5: "ウ",
    0xB6: "ェ",
    0xB7: "エ",
    0xB8: "ォ",
    0xB9: "オ",
    0xBA: "カ",
    0xBB: "ガ",
    0xBC: "キ",
    0xBD: "ギ",
    0xBE: "ク",
    0xBF: "グ",
    0xC0: "ケ",
    0xC1: "ゲ",
    0xC2: "コ",
    0xC3: "ゴ",
    0xC4: "サ",
    0xC5: "ザ",
    0xC6: "シ",
    0xC7: "ジ",
    0xC8: "ス",
    0xC9: "ズ",
    0xCA: "セ",
    0xCB: "ゼ",
    0xCC: "ソ",
    0xCD: "ゾ",
    0xCE: "タ",
    0xCF: "ダ",
    0xD0: "チ",
    0xD1: "ヂ",
    0xD2: "ッ",
    0xD3: "ツ",
    0xD4: "ヅ",
    0xD5: "テ",
    0xD6: "デ",
    0xD7: "ト",
    0xD8: "ド",
    0xD9: "ナ",
    0xDA: "ニ",
    0xDB: "ヌ",
    0xDC: "ネ",
    0xDD: "ノ",
    0xDE: "ハ",
    0xDF: "バ",
    0xE0: "パ",
    0xE1: "ヒ",
    0xE2: "ビ",
    0xE3: "ピ",
    0xE4: "フ",
    0xE5: "ブ",
    0xE6: "プ",
    0xE7: "ヘ",
    0xE8: "べ",
    0xE9: "ぺ",
    0xEA: "ホ",
    0xEB: "ボ",
    0xEC: "ポ",
    0xED: "マ",
    0xEE: "ミ",
    0xEF: "ム",
    0xF0: "メ",
    0xF1: "モ",
    0xF2: "ャ",
    0xF3: "ヤ",
    0xF4: "ュ",
    0xF5: "ユ",
    0xF6: "ョ",
    0xF7: "ヨ",
    0xF8: "ラ",
    0xF9: "リ",
    0xFA: "ル",
    0xFB: "レ",
    0xFC: "ロ",
    0xFD: "ワ",
    0xFE: "ヲ",
    0xFF: "ン"
}

def translate(map, bytes):
    new = ""
    cur = ""
    def commit():
        nonlocal cur, new
        if not cur:
            return
        if new:
            new += ", "
        new += "\"%s\"" % cur
        cur = ""
    for char in bytes:
        if char in map:
            if map[char] == "[ED]" and char == 0:
                commit()
                if new:
                    new += ", "
                new += "0"
            else:
                cur += map[char]
        else:
            commit()
            if new:
                new += ", "
            new += "$%02x" % char
    commit()
    return new

if __name__ == "__main__":
    from sys import argv
    bank = int(argv[1], 0)
    addr = int(argv[2], 0)
    size = int(argv[3], 0)

    rom = open("baserom.gbc", "rb").read()
    pos = bank * 0x4000 + addr % 0x4000
    print(translate(charmap_main, rom[pos:pos+size]))
