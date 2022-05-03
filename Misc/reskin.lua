-- SPRITE REPLACEMENTS

stageGrounds = {
	[stg.DriedLake] = Sprite.load("Starstorm_GroundStripA", "Misc/Menus/grounds/groundStrip1", 2, 0, 0),
	[stg.MagmaBarracks] = Sprite.load("Starstorm_GroundStripB", "Misc/Menus/grounds/groundStrip2", 2, 0, 0),
	[stg.BoarBeach] = Sprite.load("Starstorm_GroundStripC", "Misc/Menus/grounds/groundStrip3", 2, 0, 0),
	[stg.SkyMeadow] = Sprite.load("Starstorm_GroundStripD", "Misc/Menus/grounds/groundStrip4", 2, 0, 0),
	[stg.DampCaverns] = Sprite.load("Starstorm_GroundStripF", "Misc/Menus/grounds/groundStrip6", 2, 0, 0),
	[stg.RiskofRain] = Sprite.load("Starstorm_GroundStripG", "Misc/Menus/grounds/groundStrip7", 2, 0, 0),
	[stg.SunkenTombs] = Sprite.load("Starstorm_GroundStripH", "Misc/Menus/grounds/groundStrip8", 2, 0, 0),
	[stg.DesolateForest] = Sprite.load("Starstorm_GroundStripI", "Misc/Menus/grounds/groundStrip9", 2, 0, 0),
	[stg.TempleoftheElders] = Sprite.load("Starstorm_GroundStripJ", "Misc/Menus/grounds/groundStrip10", 2, 0, 0),
	[stg.HiveCluster] = Sprite.load("Starstorm_GroundStripK", "Misc/Menus/grounds/groundStrip11", 2, 0, 0),
	[stg.AncientValley] = Sprite.load("Starstorm_GroundStripL", "Misc/Menus/grounds/groundStrip12", 2, 0, 0),
--Sprite.load("Starstorm_GroundStripE", "Misc/Menus/grounds/groundStrip5", 2, 0, 0),
}

local backupSprites = {
	bkg = Sprite.clone(spr.background38),
	storage1 = Sprite.clone(spr.Storage1),
	storage2 = Sprite.clone(spr.Storage2),
	storage3 = Sprite.clone(spr.Storage3)
}

local newSprite = Sprite.load("Starstorm_ItmBkg", "Misc/Menus/otherBackground", 1, 0, 0)

callback.register ("onLoad", function()
	if not global.rormlflag.ss_disable_reskin then
		-- MENU
		spr.Logos:replace(
		Sprite.load("Hopoo_Logo", "Misc/Menus/logo", 1, 219, 100))
		spr.Titlescreen:replace(
		Sprite.load("Starstorm_Bg", "Misc/Menus/background", 1, 0, 0))
		spr.sprTitle:replace(
		Sprite.load("Starstorm_Title", "Misc/Menus/title", 1, 205, 44))
		local artifacts = 0
		for _, namespace in ipairs(namespaces) do
			artifacts = artifacts + table.maxn(Artifact.findAll(namespace))
		end
		if artifacts > 20 then
			spr.Select:replace(
			Sprite.load("Starstorm_SelectPodLarger", "Misc/Menus/selectPodLarger", 5, 226, 0))
		elseif artifacts > 10 then
			spr.Select:replace(
			Sprite.load("Starstorm_SelectPod", "Misc/Menus/selectPod", 5, 226, 0))
		end
		spr.SelectMult:replace(
		Sprite.load("Starstorm_SelectMultiplayer", "Misc/Menus/selectMultiplayer", 2, 278, 79))
		spr.Boxshot:replace(
		Sprite.load("Starstorm_Boxshot", "Misc/Menus/Boxshot", 1, 0, 0))
		
		local ground = stageGrounds[stg.SkyMeadow]
		local save = save.read("lastStage")
		if save and type(save) == "string" then
			local stage = Stage.find(save)
			if stageGrounds[stage] then
				ground = stageGrounds[stage]
			end
		end
		spr.GroundStrip:replace(ground)
		
		-- HUD
		spr.HpBars:replace(
		Sprite.load("Starstorm_HpBars", "Gameplay/HUD/hpBars", 1, 0, 5))
		
		spr.HUDArtifactCrew:replace(
		Sprite.load("Starstorm_HUDKin", "Gameplay/HUD/hudKin", 2, 1, 1))
		spr.HUDOutline:replace(
		Sprite.load("Starstorm_HUD", "Gameplay/HUD/hud", 1, 7, 8))
		spr.HUDOutlineCoop:replace(
		Sprite.load("Starstorm_HUDCoop", "Gameplay/HUD/hudCoop", 1, 31, 8))

		spr.Difficulty:replace(
		Sprite.load("Starstorm_Difficulty", "Gameplay/HUD/difficulty", 2, 32, 1))
		spr.Money:replace(
		Sprite.load("Starstorm_Money", "Gameplay/HUD/money", 1, 19, 5))

		spr.Cursor:replace(
		Sprite.load("Starstorm_Cursor", "Gameplay/HUD/cursor", 1, 0, 0))
		
		-- ITEM LOG	
		spr.background38:replace(newSprite)
		spr.Storage1:replace(newSprite)
		spr.Storage2:replace(newSprite)
		spr.Storage3:replace(newSprite)
		
		spr.StorageCeiling:replace(newSprite)
		spr.StorageGround:replace(newSprite)
		spr.StorageHeight:replace(newSprite)
		spr.StorageTiles:replace(newSprite)
		
		-- MONSTER LOG
		spr.Scanline:replace(newSprite)
		spr.Binding:replace(spr.EfBlank)
		spr.BookCorner:replace(
		Sprite.load("Starstorm_LogBookCorner", "Misc/Menus/bookCorner", 1, 0, 0))
		spr.BookProj:replace(spr.Nothing)
		
		-- OTHER
		spr.Talking:replace(
		Sprite.load("Talking", "Gameplay/talking", 3, 12, 24))
	end
	
	spr.EfGold3:replace(Sprite.load("EfGold3", "Gameplay/EfGold3", 6, 6, 6))
end)

if not global.rormlflag.ss_disable_reskin then
	callback.register("onStageEntry", function()
		local stage = Stage.getCurrentStage()
		if stageGrounds[stage] then
			save.write("lastStage", stage:getName())
			spr.GroundStrip:replace(stageGrounds[stage])
		end
	end)
end

if not global.rormlflag.ss_disable_reskin then
	table.insert(call.onHUDDraw, function()
		if misc.hud:get("show_gold") == 1 then
			local w,h = graphics.getGameResolution()
			local money = math.floor(misc.hud:get("gold"))
			local xOffset = 41
			local yOffset = 12
			
			graphics.color(Color.fromHex(0x1A1A1A))
			graphics.alpha(0.32)
			graphics.rectangle(xOffset, yOffset, xOffset + graphics.textWidth(tostring(money), graphics.FONT_MONEY) + 1, yOffset + 19)
			graphics.line(xOffset + graphics.textWidth(tostring(money), graphics.FONT_MONEY) + 3.5, yOffset + 1.5, xOffset + graphics.textWidth(tostring(money), graphics.FONT_MONEY) + 3.5, yOffset + 19.5, 1)
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.print(tostring(money), xOffset + 1, yOffset + 4, graphics.FONT_MONEY)
		end
	end)
	
	callback.register("onGameStart", function()
		spr.background38:replace(backupSprites.bkg)
		spr.Storage1:replace(backupSprites.storage1)
		spr.Storage2:replace(backupSprites.storage2)
		spr.Storage3:replace(backupSprites.storage3)
	end)
	callback.register("onGameEnd", function()
		spr.background38:replace(newSprite)
		spr.Storage1:replace(newSprite)
		spr.Storage2:replace(newSprite)
		spr.Storage3:replace(newSprite)
	end)
	
	callback.register("postLoad", function()
		obj.StartObjects:addCallback("create", function(self)
			if math.chance(25) then
				self.sprite = table.irandom({
					spr.FeralCage,
					Sprite.find("Activator", "Starstorm"),
					Sprite.find("Refabricator", "Starstorm"),
					Sprite.find("EscapePod", "Starstorm"),
					Sprite.find("SuiciderIdle", "Starstorm")
				}) or spr.Chest1
				self:set("y_offset", self.sprite.yorigin)
			end
		end)
	end)
	--[[callback.register("globalRoomStart", function(room)
		if room == rm.Book then
			local self = obj.Book:find(1)
			self:set("mons_color", 8880524)
			self:set("boss_color", 9922723)
		end
	end)]]
	--[[callback.register("globalRoomStart", function(room)
		if room == rm.Highscore then
			local self = obj.Highscore:find(1)
			if self:get("class_max_local") > 15 then
				self:set("class_max_local", 15)
			end
		end
	end)]]
end
spr.SelectArtifact7:replace(Sprite.load("SelectArtifact7", "Misc/Menus/sacrificeFix", 2, 18, 18))
obj.GeyserWeak.sprite = Sprite.load("GeyserSmall", "Gameplay/geyserSmall", 6, 9, 58)
obj.GeyserWeak:addCallback("create", function(self)
	self.mask = spr.Geyser
end)