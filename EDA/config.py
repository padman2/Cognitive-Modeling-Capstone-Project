"""
EDA/config.py
Shared paths and constants used by all EDA scripts.
"""

from pathlib import Path


# Paths

PROJECT_ROOT = Path(__file__).resolve().parent.parent

SHUTTLESET_PATH = PROJECT_ROOT / "data" / "CoachAI-Projects" / "ShuttleSet" / "set"

OUTPUT_DIR = Path(__file__).resolve().parent / "data"
OUTPUT_DIR.mkdir(exist_ok=True)

# Stroke Threshold

MIN_STROKES = 200

# Shot type translation (Chinese → English)

SHOT_TYPE_MAP = {
    "放小球":   "net shot",
    "擋小球":   "return net",
    "殺球":     "smash",
    "點扣":     "wrist smash",
    "挑球":     "lob",
    "防守回挑": "defensive return lob",
    "長球":     "clear",
    "平球":     "drive",
    "小平球":   "driven flight",
    "後場抽平球": "back-court drive",
    "切球":     "drop",
    "過渡切球": "passive drop",
    "推球":     "push",
    "撲球":     "rush",
    "防守回抽": "defensive return drive",
    "勾球":     "cross-court net shot",
    "發短球":   "short service",
    "發長球":   "long service",
}

# Tournament keywords used to split player names from folder names

TOURNAMENT_KEYWORDS = {
    "TOYOTA", "YONEX", "DAIHATSU", "HSBC", "PERODUA", "FUZHOU",
    "INDONESIA", "JAPAN", "WORLD", "KOREA", "CHINA", "DENMARK",
    "FRENCH", "GERMAN", "SWISS", "INDIA", "MALAYSIA", "SINGAPORE",
    "THAILAND", "TAIWAN", "OPEN", "SUPERSERIES", "FINALS", "TOUR",
    "QuarterFinals", "SemiFinals", "Final", "RoundOf16", "RoundOf32",
    "BWF", "ALL", "ENGLAND", "CANADIAN", "SPANISH", "DUTCH",
    "BADMINTON", "ASIA", "OLYMPIC", "GAMES", "CHAMPIONSHIP",
    "SUDIRMAN", "MASTERS", "GROUP", "CUP"
}

# Known players in the dataset — used for exact name matching from folder names
PLAYERS = [
    "An Se Young",
    "Pornpawee Chochuwong",
    "Ratchanok Intanon",
    "Anders Antonsen",
    "Jonatan Christie",
    "Sameer Verma",
    "Viktor Axelsen",
    "Anthony Sinisuka Ginting",
    "Lee Zii Jia",
    "Rasmus Gemke",
    "Chen Long",
    "Chou Tien Chen",
    "Ng Ka Long Angus",
    "Carolina Marin",
    "Neslihan Yigit",
    "Supanida Katethong",
    "Evgeniya Kosetskaya",
    "Hans-Kristian Solberg Vittinghus",
    "Lee Cheuk Yiu",
    "Kento Momota",
    "Mia Blichfeldt",
    "Busanan Ongbamrungphan",
    "Shi Yu Qi",
    "Kidambi Srikanth",
    "Pusarla V. Sindhu",
    "Liew Daren",
    "Michelle Li"
]

# Folder name typos
FOLDER_TYPOS = {
    "lee_cheuk_yu":                            "Lee Cheuk Yiu",
    "hans-kristian_solberg_viittinghus":        "Hans-Kristian Solberg Vittinghus",
    "jonatan_christie_sudirman_cup":            "Jonatan Christie",
    "ng_ka_long_angus_sudirman_cup":            "Ng Ka Long Angus",
}

# Player gender mapping

PLAYER_GENDER = {
    "An Se Young":                    "Female",
    "Pornpawee Chochuwong":            "Female",
    "Ratchanok Intanon":               "Female",
    "Carolina Marin":                  "Female",
    "Neslihan Yigit":                  "Female",
    "Supanida Katethong":              "Female",
    "Evgeniya Kosetskaya":             "Female",
    "Mia Blichfeldt":                  "Female",
    "Busanan Ongbamrungphan":          "Female",
    "Pusarla V. Sindhu":               "Female",
    "Michelle Li":                     "Female",
    "Anders Antonsen":                 "Male",
    "Jonatan Christie":                "Male",
    "Sameer Verma":                    "Male",
    "Viktor Axelsen":                  "Male",
    "Anthony Sinisuka Ginting":        "Male",
    "Lee Zii Jia":                     "Male",
    "Rasmus Gemke":                    "Male",
    "Chen Long":                       "Male",
    "Chou Tien Chen":                  "Male",
    "Ng Ka Long Angus":                "Male",
    "Hans-Kristian Solberg Vittinghus": "Male",
    "Lee Cheuk Yiu":                    "Male",
    "Kento Momota":                    "Male",
    "Shi Yu Qi":                       "Male",
    "Kidambi Srikanth":                "Male",
    "Liew Daren":                      "Male"
}