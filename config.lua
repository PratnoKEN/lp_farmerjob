Config = {}

Config.Locale = 'en'

Config.CircleZones = {
	BatuField = {coords = vector3(2946.7392578125,2795.0068359375,40.665550231934), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	WeedField = {coords = vector3(-499.86, 5459.9, 80.13), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	CabeField = {coords = vector3(256.28, 6459.28, 31.42), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	CoklatField = {coords = vector3(-1604.13, 2205.93, 81.35), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	GaramField = {coords = vector3(446.52, 6728.89, 5.3), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	KopiField = {coords = vector3(-1604.13, 2205.93, 81.35), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	PadiField = {coords = vector3(643.03, 6474.95, 74.86), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	TebuField = {coords = vector3(694.12, 6468.17, 30.53), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
	TehField = {coords = vector3(-1604.13, 2205.93, 81.35), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 100.0},
}

Crafting = {}
-- You can configure locations here
Crafting.Locations = {
    [1] = {x = 433.48, y=6501.22, z=28.81},
}

Crafting.Items = {
    ["sambal"] = {
        label = "Sambal",
        needs = {                                           
            ["cabe"] = {label = "Cabe", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["beras"] = {
        label = "Beras",
        needs = {
            ["padi"] = {label = "Padi", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["gula"] = {
        label = "Gula",
        needs = {
            ["tebu"] = {label = "Tebu", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["bgaram"] = {
        label = "Garam Bungkusan",
        needs = {
            ["garam"] = {label = "Garam", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["teh_kantong"] = {
        label = "Teh",
        needs = {
            ["teh"] = {label = "Teh", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["serbuk_kopi"] = {
        label = "Serbuk Kopi",
        needs = {
            ["kopi"] = {label = "Kopi", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
    ["bubuk_coklat"] = {
        label = "Bubuk Coklat",
        needs = {
            ["coklat"] = {label = "Coklat", count = 4},
            ["fabric"] = {label = "Kain", count = 1},
        },
        threshold = 0,
    },
}