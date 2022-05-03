-- April Fools Event
global.aprilFools = false
local dateStr = os.date("%m-%d")
if not global.rormlflag.ss_disable_holidays then
	if dateStr == "04-01" or global.rormlflag.ss_april_fools then
		global.aprilFools = true
		if not global.rormlflag.ss_april_fools then
			print("HAPPY APRIL FOOLS' DAY!")
		end
	end
	if dateStr == "10-31" or global.rormlflag.ss_halloween then
		global.halloween = true
		if not global.rormlflag.ss_halloween then
			print("HAPPY HALLOWEEN!")
		end
	end
	if dateStr == "12-24" or dateStr == "12-25" or global.rormlflag.ss_christmas then
		global.christmas = true
		if not global.rormlflag.ss_christmas then
			print("MERRY CHRISTMAS!")
		end
	end
end
debugPrint("Today is "..dateStr)


if global.aprilFools then
	callback.register("postLoad", function()
		spr.sprTitle:replace(Sprite.load("Starstorm_AprilFools2", "Misc/Menus/Holidays/aprilFools2021", 1, 205, 44))
	end)
	table.insert(call.postStep, function()
		for _, actor in ipairs(pobj.enemies:findAll()) do
			--if not actor:getData().aprilFoolsChecked then
			--	actor:getData().aprilFoolsChecked = true
			--	actor.yscale = 0.5
			--end
			local player = obj.P:findNearest(actor.x, actor.y)
			if player and player:isValid() then
				--if player.x < actor.x + 10 and player.x > actor.x - 10 and player:get("pVspeed") > 1 and player.y < actor.y - 2 and player.y > actor.y - 15 then
				if player:get("pVspeed") > 1 and actor:collidesWith(player, actor.x, actor.y) then
					if not actor:getData().flattened then
						player:set("pVspeed", -4)
						actor:set("hp", actor:get("hp") - actor:get("maxhp") * 0.15)
						actor:setAlarm(6, 200)
						actor.yscale = actor.yscale * 0.5
						actor:getData().flattened = 60
						sfx.Squeaky:play(1.1)
						local image = actor.mask or actor.sprite
						actor.y = actor.y + (image.height - image.yorigin) * 0.5
					end
				end
			end
			if actor:getData().flattened then
				if actor:getData().flattened > 0 then
					actor:getData().flattened = actor:getData().flattened - 1
				else
					actor.yscale = actor.yscale * 2
					local image = actor.mask or actor.sprite
					actor.y = actor.y - (image.height - image.yorigin) * 0.5
					actor:getData().flattened = nil
				end
			end
		end
	end)
end
if global.rormlflag.ss_april_fools_2020 then
	callback.register("postLoad", function()
		spr.sprTitle:replace(Sprite.load("Starstorm_AprilFools", "Misc/Menus/Holidays/aprilFools2020", 1, 205, 44))
		--spr.Titlescreen:replace(obj.BoarM.sprite)
	end)
	it["WhiteUndershirt(M)"].pickupText = "Shirt time!"
	local baseElites = {
		elt.Blazing,
		elt.Overloading,
		elt.Frenzied,
		elt.Leeching,
		elt.Volatile
	}
	
	mcard.Boarlit = MonsterCard.new("Boarlit", obj.BoarM)
	mcard.Boarlit.cost = 6
	mcard.Boarlit.sprite = obj.BoarM.sprite
	mcard.Boarlit.sound = sfx.BoarMDeath
	for _, eliteType in ipairs(baseElites) do
		mcard.Boarlit.eliteTypes:add(eliteType)
	end
	mcard.Boarlit.canBlight = true
	
	mcard.IronBoarlit = MonsterCard.new("Iron Boarlit", obj.BoarMS)
	mcard.IronBoarlit.cost = 30
	mcard.IronBoarlit.sprite = obj.BoarMS.sprite
	mcard.IronBoarlit.sound = sfx.BoarMDeath
	for _, eliteType in ipairs(baseElites) do
		mcard.IronBoarlit.eliteTypes:add(eliteType)
	end
	mcard.IronBoarlit.canBlight = true
	
	local boarNames = {"Tobby", "Michael", "John", "Monica", "Rodger", "Tebas", "Joseph", "Tommy", "Sebastian", "Sarah", "Anne", "Robert", "Steve", "Mr. Smiles", "Edgar", "Cammie", "Rikka", "Joshie", "Iris", "Niek", "Porter", "Madis", "Klori", "Lissie", "Emily", "Marcus", "Flo", "Blu", "Red", "Stephen", "Felix", "Zoe", "Joe", "Remmie"}
	local boars = {obj.BoarMS, obj.BoarM, obj.Boar}
	
	callback.register("postLoad", function()
		for _, namespace in ipairs(namespaces) do
			for _, stage in ipairs(Stage.findAll(namespace)) do
				for _, nnamespace in ipairs(namespaces) do
					for _, monsterCard in ipairs(MonsterCard.findAll(nnamespace)) do
						stage.enemies:remove(monsterCard)
					end
				end
				stage.enemies:add(mcard.Boarlit)
				stage.enemies:add(mcard.IronBoarlit)
				stage.enemies:add(mcard["Toxic Beast"])
			end
			for _, monsterLog in ipairs(MonsterLog.findAll(namespace)) do
				if monsterLog.displayName ~= "Toxic Beast" then
					local boarName = table.irandom(boarNames)
					monsterLog.displayName = boarName
					monsterLog.story = boarName.." is the boarest Boar, all hail "..boarName.."."
					local boar = table.irandom(boars)
					monsterLog.sprite = boar.sprite
					monsterLog.portrait = boar.sprite
				end
			end
		end
	end)
	table.insert(call.onStep, function()
		for _, chest in ipairs(obj.Chest3:findAll()) do
			if not chest:getData().aprilFoolsChecked or chest:getData().aprilFoolsChecked < 2 then
				if not chest:getData().aprilFoolsChecked then chest:getData().aprilFoolsChecked = 0 end
				chest:getData().aprilFoolsChecked = chest:getData().aprilFoolsChecked + 1
				local object = boars[math.round(chest.x % 2) + 1]
				chest:set("sprite_id", object.sprite.id)
				chest:set("item_id", object.id)
				chest:set("cost", 0)
			end
		end
	end)
end
if global.halloween then
	save.write("hday1", true)
	callback.register("postLoad", function()
		spr.sprTitle:replace(Sprite.load("Starstorm_Halloween", "Misc/Menus/Holidays/halloween2020", 1, 205, 44))
	end)
	
	local sprHats = Sprite.load("Hats", "Gameplay/hats", 24, 5, 6)
	local sprHatsBoss = Sprite.load("HatsBoss", "Gameplay/hatsBoss", 10, 7, 15)
	
	local names = {
		[obj.Lizard] = "Spooky Lemurian",
		[obj.LizardG] = "Very Spooky Lemurian",
		[obj.LizardF] = "Spooky Flying Lemurian",
		[obj.LizardFG] = "Spooky Flying Lemurian",
		[obj.Jelly] = "Scary Jelly",
		[obj.JellyG2] = "Very Scary Jelly",
		[obj.Golem] = "Frightening Golem",
		[obj.GolemS] = "F-f-frightening g-golem",
		[obj.Crab] = "Mysterious Crab",
		[obj.Naut] = "Ghostly Whorl",
		[obj.Wisp] = "Devilish Wisp",
		[obj.WispG] = "Very Devilish Wisp",
		[obj.WispG2] = "Very Very Devilish Wisp",
		[obj.Mush] = "Ugly Mushrum",
		[obj.Spitter] = "Nasty Spitter",
		[obj.Child] = "Creepy Child",
		[obj.ChildG] = "Creepy Parent",
		[obj.Imp] = "Gruesome Imp",
		[obj.ImpS] = "Gruesomer Imp",
		[obj.ImpM] = "Gruesome Baby Imp",
		[obj.Clay] = "Thing Man",
		[obj.Bison] = "Horrible Bison",
		[obj.Spider] = "Haunting Spider",
		[obj.Slime] = "Grimmy Slime",
		[obj.Bug] = "Strange Bug",
		[obj.Guard] = "Intimidating Guard",
		[obj.GuardG] = "Very Intimidating Guard",
		[obj.BoarM] = "Pig",
		[obj.BoarMS] = "Cute Pig",
		[obj.GolemG] = "Macabre Colossus",
		[obj.GiantJelly] = "Super Scary Jelly",
		[obj.Worm] = "Fire Snake",
		[obj.WispB] = "Wisp Man",
		[obj.Boar] = "Big Scary Pig",
		[obj.ImpG] = "Terrifying Imp",
		[obj.ImpGS] = "Very Terrifying Imp",
		[obj.Turtle] = "Morbid Cremator",
		[obj.Ifrit] = "My Friend Ifrit",
		[obj.Scavenger] = "Bogeyman",
		[obj.LizardGS] = "That Guy",
		[obj.Acrid] = "My Favorite Dog",
		[obj.Boss1] = "The Nefarious Providence",
		[obj.Boss3Fake] = "The Nefarious Providence",
		[obj.Boss3] = "The Nefarious Providence",
		[obj.Boss2Clone] = "Not The Real Providence"
	}
	
	for obj, name in pairs(names) do
		obj:addCallback("create", function(actor)
			actor:set("name", name)
		end)
	end
	
	local drawHatFunc = function()
		for _, actor in ipairs(pobj.enemies:findAll()) do
			if actor.visible and actor.alpha > 0 then
				local sprite = sprHats
				if actor:isBoss() then
					sprite = sprHatsBoss
				end
				
				if not actor:getData().hatIndex then
					actor:getData().hatIndex = math.random(1, sprite.frames)
				end
				local index = actor:getData().hatIndex
				local image = actor.mask or actor.sprite
				local yy = actor.y - image.yorigin + 1 
				
				graphics.drawImage{
					x = actor.x,
					y = yy,
					xscale = actor.xscale,
					yscale = actor.yscale,
					alpha = actor.alpha,
					image = sprite,
					subimage = index,
					angle = actor.angle
				}
			end
		end
	end
	
	table.insert(call.onStageEntry, function()
		graphics.bindDepth(0.5, drawHatFunc)
	end)
end
if global.christmas then
	save.write("hday2", true)
	callback.register("postLoad", function()
		spr.sprTitle:replace(Sprite.load("Starstorm_Christmas", "Misc/Menus/Holidays/christmas2021", 1, 205, 44))
		spr.Titlescreen:replace(Sprite.load("Starstorm_BgChristmas", "Misc/Menus/Holidays/backgroundChristmas2021", 0, 0, 0))
		spr.Chest1:replace(Sprite.load("ChestFestive1", "Interactables/Resources/christmasChest1", 8, 18, 13))
		spr.Chest2:replace(Sprite.load("ChestFestive2", "Interactables/Resources/christmasChest2", 9, 22, 24))
		spr.Barrel1:replace(Sprite.load("BarrelFestive1", "Interactables/Resources/christmasBarrel1", 6, 6, 11))
		spr.Barrel2:replace(Sprite.load("BarrelFestive2", "Interactables/Resources/christmasBarrel2", 5, 9, 14))
	end)
	
	local sprHats = Sprite.load("Hats", "Gameplay/hats2", 2, 5, 6)
	local sprHatsBoss = Sprite.load("HatsBoss", "Gameplay/hatsBoss2", 2, 7, 15)
	
	local names = {
		[obj.Acrid] = "Santa's Favorite"
	}
	
	for obj, name in pairs(names) do
		obj:addCallback("create", function(actor)
			actor:set("name", name)
		end)
	end
	
	local drawHatFunc = function()
		for _, actor in ipairs(pobj.enemies:findAll()) do
			if actor.visible and actor.alpha > 0 then
				local sprite = sprHats
				if actor:isBoss() then
					sprite = sprHatsBoss
				end
				
				if not actor:getData().hatIndex then
					actor:getData().hatIndex = math.random(1, sprite.frames)
				end
				local index = actor:getData().hatIndex
				local image = actor.mask or actor.sprite
				local yy = actor.y - image.yorigin + 1 
				
				graphics.drawImage{
					x = actor.x,
					y = yy,
					xscale = actor.xscale,
					yscale = actor.yscale,
					alpha = actor.alpha,
					image = sprite,
					subimage = index,
					angle = actor.angle
				}
			end
		end
	end
	
	table.insert(call.onStageEntry, function()
		graphics.bindDepth(0.5, drawHatFunc)
	end)
end