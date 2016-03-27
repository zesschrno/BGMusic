local get_loop_music = select(2, pcall(GetCVar, "Sound_ZoneMusicNoDelay"))

local battle_music = CreateFrame("Frame")

  battle_music:RegisterEvent("PLAYER_REGEN_DISABLED")
  battle_music:RegisterEvent("PLAYER_REGEN_ENABLED")
  
  battle_music:SetScript("OnEvent", function(self, event, ...)
    if(self[event]) then
      self[event](self, event, ...)
    end
  end)
  
  function battle_music:PLAYER_REGEN_DISABLED(event)
    if get_loop_music == "0" or get_loop_music == nil then
      SetCVar("Sound_ZoneMusicNoDelay", "1")
    end
    PlayMusic("Interface\\AddOns\\BGMusic\\song.mp3");
  end
  
  function battle_music:PLAYER_REGEN_ENABLED(event)
    StopMusic();
    if get_loop_music == "0" or get_loop_music == nil then
      SetCVar("Sound_ZoneMusicNoDelay", "0")
    end
  end
