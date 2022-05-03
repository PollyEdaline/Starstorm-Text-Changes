-- MUSIC

	-- Menu
if not modloader.checkMod("CustomMusic") then
if not global.rormlflag.ss_disable_menu_music_remix then
	sfx.musicTitle:setRemap(Sound.load("MusicTitle", "Misc/Music/musicTitle"))
end
	-- Stages
	local music = {}
	music.Stage1 = {music = sfx.musicStage1, remix = Sound.load("MusicStage1", "Misc/Music/musicStage1")}
	music.Stage2 = {music = sfx.musicStage2, remix = Sound.load("MusicStage2", "Misc/Music/musicStage2")}
	--music.Stage11 = {music = sfx.musicStage11, remix = Sound.load("MusicStage11", "Misc/Music/musicStage11")} yeet what a bad remix
	table.insert(call.onStep, function()
		if getRule(5, 16) == true and global.gamestarted then
			for _, stage in pairs(music) do
				local currentMusic = Sound.getMusic()
				if currentMusic and currentMusic == stage.music then
					Sound.setMusic(stage.remix)
				end
			end
		end
	end)
end