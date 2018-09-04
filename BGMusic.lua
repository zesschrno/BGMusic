local song = {
  default = {
    path = "Interface\\AddOns\\BGMusic\\Energy_Zone.mp3",
    duration = 87
  },
  boss = {
    -- legion boss
    archidruida_glaidalis = {
      path = "Interface\\AddOns\\BGMusic\\arboleda_corazon_oscuro.mp3",
      duration = 139
    },
    corazon_de_roble = {
      path = "Interface\\AddOns\\BGMusic\\arboleda_corazon_oscuro.mp3",
      duration = 139
    },
    dresaron = {
      path = "Interface\\AddOns\\BGMusic\\arboleda_corazon_oscuro.mp3",
      duration = 139
    },
    sombra_de_xavius = {
      path = "Interface\\AddOns\\BGMusic\\arboleda_corazon_oscuro.mp3",
      duration = 139
    },
    cordana = {
      path = "Interface\\AddOns\\BGMusic\\moon_river.mp3",
      duration = 510
    },

    --bfa dungeon
    mansion_tarjasenda = {
      path = "Interface\\AddOns\\BGMusic\\song(xepher).mp3",
      duration = 216
    },
    filon = {
      path = "Interface\\AddOns\\BGMusic\\l4d_concert.mp3",
      duration = 265
    },
    templo_sethraliss = {
      path = "Interface\\AddOns\\BGMusic\\bioinformatics.mp3",
      duration = 128
    },
    bardoma = {
      path = "Interface\\AddOns\\BGMusic\\windowless_building.mp3",
      duration = 262
    },
    puerto_libre = {
      path = "Interface\\AddOns\\BGMusic\\Lets_Battle_Mix.mp3",
      duration = 245
    },
    santuario_tormenta = {
      path = "Interface\\AddOns\\BGMusic\\underground_cave.mp3",
      duration = 153
    },


    default_boss = {
      path = "Interface\\AddOns\\BGMusic\\bosses.mp3",
      duration = 103
    }
  },
  instance = {
    -- bfa dungeon
    mansion_tarjasenda = {
      path = "Interface\\AddOns\\BGMusic\\mansion_tarjasenda.mp3",
      duration = 143
    },
    filon = {
      path = "Interface\\AddOns\\BGMusic\\lili_club.mp3",
      duration = 271
    },
    templo_sethraliss = {
      path = "Interface\\AddOns\\BGMusic\\bacterion.mp3",
      duration = 106
    },
    bardoma = {
      path = "Interface\\AddOns\\BGMusic\\cenotaph.mp3",
      duration = 119
    },
    puerto_libre = {
      path = "Interface\\AddOns\\BGMusic\\Karakuri_Defense_System_Activate.mp3",
      duration = 204
    }
  }
}

local boss = {
  cordana = {
    npc_id = 95888
  },
  archidruida_glaidalis = {
    npc_id = 96512
  },
  corazon_de_roble = {
    npc_id = 103344
  },
  dresaron = {
    npc_id = 99200
  },
  sombra_de_xavius = {
    npc_id = 99192
  }
}

local instance = {
  ataldazar = {
    instanceID = 1763
  },
  puerto_libre = {
    instanceID = 1754
  },
  descanso_reyes = {
    instanceID = 1762
  },
  santuario_tormenta = {
    instanceID = 1864
  },
  boralus = {
    instanceID = 1822
  },
  templo_sethraliss = {
    instanceID = 1877
  },
  filon = {
    instanceID = 1594
  },
  bardoma = {
    instanceID = 1841
  },
  mansion_tarjasenda = {
    instanceID = 1862
  },
  uldir = {
    instanceID = 1861
  }
}

local is_played = nil
local id_handler = nil
local current_playing = false
local current_song = {
  path = nil,
  duration = 0
}
local time_now = nil
local on_battle = false
local battle_music, battle_events = CreateFrame("Frame"), {}

battle_music:SetScript("OnEvent", function(self, event, ...)
  battle_events[event](self, ...)
end)

function battle_events:PLAYER_REGEN_DISABLED(event)
  on_battle = true
  PlaySoundFile("Sound/Creature/Jaraxxus/Cr_Jaraxxus_Aggro01.ogg", 'Dialog')
  selecting_song()
end

function battle_events:PLAYER_REGEN_ENABLED(event)
  on_battle = false
  if current_playing == true then
    if id_handler ~= nil then
      StopSound(id_handler)
      current_playing = false
      current_song.path = nil
      current_song.duration = 0
    end
  end
end

function battle_events:UNIT_AURA(unit)
  if on_battle then
    if unit == "player" then
      local time_added = time_now + current_song.duration
      local time_temp = time()
      if time_temp >= time_added then
        current_playing = false
        selecting_song()
      end
    end
  end
end

-- UNIT_SPELLCAST_START

function selecting_song()
  if boss_filter(boss.cordana.npc_id) then
    battle_play_file(song.boss.cordana)
  elseif boss_filter(boss.archidruida_glaidalis.npc_id) then
    battle_play_file(song.boss.archidruida_glaidalis)
  elseif boss_filter(boss.corazon_de_roble.npc_id) then
    battle_play_file(song.boss.corazon_de_roble)
  elseif boss_filter(boss.dresaron.npc_id) then
    battle_play_file(song.boss.dresaron)
  elseif boss_filter(boss.sombra_de_xavius.npc_id) then
    battle_play_file(song.boss.sombra_de_xavius)

  elseif instance_filter(instance.mansion_tarjasenda.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.mansion_tarjasenda)
    else
      battle_play_file(song.instance.mansion_tarjasenda)
    end
  elseif instance_filter(instance.filon.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.filon)
    else
      battle_play_file(song.instance.filon)
    end
  elseif instance_filter(instance.templo_sethraliss.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.templo_sethraliss)
    else
      battle_play_file(song.instance.templo_sethraliss)
    end
  elseif instance_filter(instance.bardoma.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.bardoma)
    else
      battle_play_file(song.instance.bardoma)
    end
  elseif instance_filter(instance.puerto_libre.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.puerto_libre)
    else
      battle_play_file(song.instance.puerto_libre)
    end
  elseif instance_filter(instance.santuario_tormenta.instanceID) then
    if is_boss() then
      battle_play_file(song.boss.santuario_tormenta)
    else
      battle_play_file(song.default)
    end

  elseif is_boss() then
    battle_play_file(song.boss.default_boss)

  else
    battle_play_file(song.default)
  end
end

function instance_filter(instance_id)
  local _, _name, _instanceType, _difficultyIndex, _difficultyName, _maxPlayers, _dynamicDifficulty, _isDynamic, instanceMapId, _instanceGroupSize = pcall(GetInstanceInfo)
  if instance_id == instanceMapId then
    return true
  end
  return false
end

function boss_filter(boss_id)
  for i = 1, 4 do
    local _, guid = pcall(UnitGUID, "boss" .. i)
    if guid ~= nil then
      local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
      npc_id = tonumber(npc_id)
      if boss_id == npc_id then
        return true
      end
    end
  end

  local _, guid = pcall(UnitGUID, "target")
  if guid ~= nil then
    local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
    npc_id = tonumber(npc_id)
    if boss_id == npc_id then
      return true
    end
  end

  for i = 1, 4 do
    local _, guid = pcall(UnitGUID, "party" .. i .. "target")
    if guid ~= nil then
      local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
      npc_id = tonumber(npc_id)
      if boss_id == npc_id then
        return true
      end
    end
  end

  return false
end

function is_boss()
  for i = 1, 4 do
    local _, boss_detected = pcall(UnitExists, "boss" .. i)
    if boss_detected then
      return true
    end
  end

  return false
end

function battle_play_file(song)
  if current_playing == false then
    is_played, id_handler = PlaySoundFile(song.path, "Ambience")
    if is_played ~= true then
      id_handler = nil
    else
      current_playing = true
      current_song.path = song.path
      current_song.duration = song.duration
      time_now = time()
    end
  end
end

for k, _v in pairs(battle_events) do
  battle_music:RegisterEvent(k) -- Register all events for which handlers have been defined
end
