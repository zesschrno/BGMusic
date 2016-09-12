local song = {
  default = {
    path = "Interface\\AddOns\\BGMusic\\default.mp3",
    duration = 398
  },
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
    path = "Interface\\AddOns\\BGMusic\\cordana.mp3",
    duration = 336
  },
  default_boss = {
    path = "Interface\\AddOns\\BGMusic\\bosses.mp3",
    duration = 103
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

local is_played = nil
local id_handler = nil
local current_playing = false
local music_volume = GetCVar("Sound_MusicVolume")
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
  selecting_song()
end

function battle_events:PLAYER_REGEN_ENABLED(event)
  on_battle = false
  if current_playing == true then
    if id_handler ~= nil then
      StopSound(id_handler)
      current_playing = false
      SetCVar("Sound_MusicVolume", music_volume)
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

function selecting_song()
  --SendChatMessage("filtros")
  if boss_filter(boss.cordana.npc_id) then
    --SendChatMessage("filtro 1a")
    battle_play_file(song.cordana)
  elseif boss_filter(boss.archidruida_glaidalis.npc_id) then
    --SendChatMessage("filtro 1b")
    battle_play_file(song.archidruida_glaidalis)
  elseif boss_filter(boss.corazon_de_roble.npc_id) then
    --SendChatMessage("filtro 1c")
    battle_play_file(song.corazon_de_roble)
  elseif boss_filter(boss.dresaron.npc_id) then
    --SendChatMessage("filtro 1d")
    battle_play_file(song.dresaron)
  elseif boss_filter(boss.sombra_de_xavius.npc_id) then
    --SendChatMessage("filtro 1e")
    battle_play_file(song.sombra_de_xavius)
  elseif is_boss() then
    --SendChatMessage("filtro 2")
    battle_play_file(song.default_boss)
  else
    --SendChatMessage("filtro 3")
    battle_play_file(song.default)
  end
end

function boss_filter(boss_id)
  --SendChatMessage("boss_filter")
  for i = 1, 4 do
    --SendChatMessage("boss_filter conteo")
    local _, guid = pcall(UnitGUID, "boss" .. i)
    if guid ~= nil then
      --SendChatMessage("boss_filter guid")
      --SendChatMessage(guid)
      local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
      npc_id = tonumber(npc_id)
      --SendChatMessage("boss_filter npc")
      if boss_id == npc_id then
        --SendChatMessage("boss_filter igual")
        return true
      end
      --SendChatMessage("boss_filter continua")
    end
  end

  local _, guid = pcall(UnitGUID, "target")
  if guid ~= nil then
    --SendChatMessage("boss_filter guid")
    --SendChatMessage(guid)
    local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
    npc_id = tonumber(npc_id)
    --SendChatMessage("boss_filter npc")
    if boss_id == npc_id then
      --SendChatMessage("boss_filter igual")
      return true
    end
    --SendChatMessage("boss_filter continua")
  end

  for i = 1, 4 do
    --SendChatMessage("boss_filter conteo")
    local _, guid = pcall(UnitGUID, "party" .. i .. "target")
    if guid ~= nil then
      --SendChatMessage("boss_filter guid")
      --SendChatMessage(guid)
      local _type, _zero, _server_id, _instance_id, _zone_uid, npc_id, _spawn_uid = strsplit("-", guid)
      npc_id = tonumber(npc_id)
      --SendChatMessage("boss_filter npc")
      if boss_id == npc_id then
        --SendChatMessage("boss_filter igual")
        return true
      end
      --SendChatMessage("boss_filter continua")
    end
  end

  --SendChatMessage("boss_filter falso")
  return false
end

function is_boss()
  --SendChatMessage("is_boss")
  for i = 1, 4 do
    --SendChatMessage("is_boss conteo")
    local _, boss_detected = pcall(UnitExists, "boss" .. i)
    if boss_detected then
      --SendChatMessage("is_boss igual")
      return true
    end
  end
  --SendChatMessage("is_boss falso")
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
      SetCVar("Sound_MusicVolume", 0)
      time_now = time()
    end
  end
end

for k, _v in pairs(battle_events) do
  battle_music:RegisterEvent(k) -- Register all events for which handlers have been defined
end


