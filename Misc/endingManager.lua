-- END GAME

local specialEndingText = nil
specialEndingMusic = nil
specialEndingSound = nil
local awaitingCommandF = false

local replaceEndingScene = nil

local ogQuotes = {}

local vanillaEndType = {
	name = "Vanilla",
}

local postStepCall = function()
	local fObj = obj.CommandFinal:find(1)
	if fObj and fObj:isValid() then
		if awaitingCommandF then
			fObj:set("active", 1)
			awaitingCommandF = false
		elseif fObj:get("active") >= 1 and not fObj:getData()._end then
			fObj:getData()._end = true
			if Stage.getCurrentStage() == stg.RiskofRain then
				onGameBeatCallback(vanillaEndType)
			end
		end
	end
end

callback.register("onStageEntry", function()
	local stage = Stage.getCurrentStage()
	if stage == stg.RiskofRain then
		tcallback.register("postStep", postStepCall)
	end
end)

local onStepCall = function()
	if specialEndingSound and sfx.CutsceneJet:isPlaying() then
		sfx.CutsceneJet:stop()
	end
end

function endGame(endType)
	tcallback.register("postStep", postStepCall)
	local fObj = obj.CommandFinal:find(1)
	if not fObj then
		local e = obj.Spawn:create(0, 0)
		e:set("child", 278)
		e.sprite = spr.Nothing
	end
	awaitingCommandF = true
	if endType then
		Sound.setMusic(nil)
		misc.setTimeStop(999)
		replaceEndingScene = endType.draw
		specialEndingMusic = endType.music
		specialEndingSound = endType.sound
		specialEndingText = endType.quote
		
		tcallback.register("onStep", onStepCall)
	end
	
	if specialEndingSound then
		specialEndingSound:play()
	end
	onGameBeatCallback(endType)
	
	if specialEndingText then
		for _, namespace in ipairs(namespaces) do
			for _, survivor in ipairs(Survivor.findAll(namespace)) do
				ogQuotes[survivor] = survivor.endingQuote
				survivor.endingQuote = specialEndingText
			end
		end
	end
end

callback.register("globalRoomStart", function(room)
	if room == rm["2Cutscene2"] then
		if replaceEndingScene then
			graphics.bindDepth(-1000, replaceEndingScene)
		end
	end
end)
callback.register("onGameStart", function()
	replaceEndingScene = nil
	if specialEndingText then	
		for survivor, text in pairs(ogQuotes) do
			survivor.endingQuote = text
		end
		specialEndingText = nil
	end
	specialEndingMusic = nil
	specialEndingSound = nil
end)

-- SECRET ENDING???

local friendProvi = {speech = {"W-what...", "What did you do to me?", "...", "F-friend?"}, portraits = {{spr.ProvidencePortrait, 4}}}
local friendProviEndType = {name = "Friend Providence", quote = "..and so they left, holding hands, forever joyful."}
function friendProvidence(providence)
	createDialogue(friendProvi.speech, friendProvi.portraits, {cameraCutscene, providence.x, providence.y}, {endGame, "friendProvidence"}, true)
end