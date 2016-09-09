local player = nil
local handler = nil
local battle_music, battle_events = CreateFrame("Frame")

battle_events:RegisterEvent("PLAYER_REGEN_DISABLED")
battle_events:RegisterEvent("PLAYER_REGEN_ENABLED")

battle_music:SetScript("OnEvent", function(self, event, ...)
  battle_events[event](self, ...)
end)

function battle_events:PLAYER_REGEN_DISABLED(event)
  print("En batalla")
  player, handler = PlaySoundFile("Interface\\AddOns\\BGMusic\\song.mp3")
  print("Oyendo a balder")
end

function battle_events:PLAYER_REGEN_ENABLED(event)
  print("Sin batalla")
  StopMusic(handler)
end

