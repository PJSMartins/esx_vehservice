Config = {}

Config.Repair = {
    Locations = {
        vector3(-222.89, -1329.9, 30.89),
        vector3(1177.44, 2640.23, 37.75)
    },
    Blip = {
        sprite = 402, -- Ferramenta
        color = 1,    -- Vermelho
        scale = 0.8,
        label = "Reparação Grátis"
    },
    Marker = {
        type = 27,
        size = vector3(2.0, 2.0, 1.0),
        color = {r = 200, g = 50, b = 50, a = 100}
    }
}

Config.Wash = {
    Locations = {
        vector3(1777.94, 3335.22, 41.43),
        vector3(1693.21, 3582.33, 35.62)
    },
    Blip = {
        sprite = 100, -- Esponja/água
        color = 3,    -- Azul
        scale = 0.8,
        label = "Lavagem Grátis"
    },
    Marker = {
        type = 27,
        size = vector3(2.0, 2.0, 1.0),
        color = {r = 50, g = 150, b = 200, a = 100}
    }
}

Config.Progress = {
    repair = {duration = 10000, label = 'Reparando...'},
    clean  = {duration = 7000, label = 'Lavando...'}
}

Config.Keybinds = {
    repair = 38, -- E
    clean  = 38  -- G
}

Config.Notifications = {
    repair_success = '🛠️ Veículo reparado com sucesso!',
    clean_success  = '✨ Veículo lavado com sucesso!',
    not_in_vehicle = '❌ Precisas de estar dentro de um veículo.',
    cancelled      = '❌ Ação cancelada.'
}
