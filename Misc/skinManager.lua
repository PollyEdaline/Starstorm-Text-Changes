
-- All Skin Manager data

-- I might rewrite parts of it someday.

local survivors = {}
local skins = {}
local info = {}

local defaultInfo = {
Commando = {"The &y&Commando&!& is one of the most balanced soldiers of his generation, allowing for adaptive strategies on the battleground.", {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 3}, {"Integrity", 5}}},
Enforcer = {"The &y&Enforcer&!& has one goal: to restore order. To do so, he wields a shotgun and a riot shield for self-defense.", {{"Strength", 5}, {"Vitality", 7}, {"Toughness", 7}, {"Agility", 3}, {"Difficulty", 4}, {"Lawfulness", 9}}},
Bandit = {"The &y&Bandit&!& is agile, precise and tricky. His abilities reward planning.", {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 4}, {"Odor", 4}}},
Huntress = {"While the &y&Huntress&!& is frail, her agility makes her a lethal threat.", {{"Strength", 6}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 7}, {"Difficulty", 6}, {"Precision", 7}}},
["HAN-D"] = {"&y&HAN-D&!& tackles obstacles with fortitude and a rigorous cleaning directive. Nothing is too much work for a janitor robot.", {{"Strength", 6}, {"Vitality", 8}, {"Toughness", 6}, {"Agility", 5}, {"Difficulty", 4}, {"Hygiene", 7}}},
Engineer = {"Turrets, mines and missiles are what make the &y&Engineer&!& a perfect fit for passive combat. It's better to have him on your side.", {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 4}, {"Will to move", 1}}},
Miner = {"The &y&Miner&!& is known to be extremely efficient with the right equipment. Aided by exceptional mobility and a pair of pickaxes, he makes his job seem like a walk in the park.", {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 5}, {"Scars", 8}}},
Sniper = {"Beware: the deadly &y&Sniper&!& is armed and ready to take out even the toughest opponents with a single pull of the trigger. They're a professional.", {{"Strength", 10}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 3}, {"Difficulty", 4}, {"Awareness", 7}}},
Acrid = {"Dangerous is the word that best describes the &y&Acrid&!&, due to its lethal fangs and acid spittle.", {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 6}, {"Agility", 6}, {"Difficulty", 5}, {"Hunger", 7}}},
Mercenary = {"Dignity and recognition are everything for the &y&Mercenary&!&, slashing through enemies like paper.", {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 4}, {"Charisma", 9}}},
Loader = {"The &y&Loader&!& excels at carrying the heaviest of packages, with the human care that machines lack.", {{"Strength", 6}, {"Vitality", 5}, {"Toughness", 7}, {"Agility", 7}, {"Difficulty", 5}, {"Reflex", 3}}},
CHEF = {"Excellence in cooking is the &y&CHEF&!&'s specialty. It can acquire the right ingredients even in the least familiar environments.", {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 5}, {"Cuisine", 8}}},
Executioner = {"The &y&Executioner&!&'s goal is to spill as much blood as possible in the shortest amount of time. Bullets loaded, ion manipulators charged.", {{"Strength", 9}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 6}, {"Difficulty", 4}, {"Emotion", 2}}},
MULE = {"The &y&MULE&!& used to be a disposable robot for the roughest tasks, until it started to be appreciated for its exceptional durability.", {{"Strength", 6}, {"Vitality", 7}, {"Toughness", 5}, {"Agility", 4}, {"Difficulty", 5}, {"Directive", 1}}},
Cyborg = {"Technology was to reach its moral bounds when the &y&Cyborg&!& was created. It's hard to know how much humanity is left inside them.", {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 4}, {"Efficiency", 7}}},
Technician = {"On the UES Contact Light, things can go wrong. Frequently The &y&Technician&!& might be able to fix problems, as long as he doesn't create more in the process.", {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 6}, {"Service", 7}}},
Nucleator = {"With a heavy suit and plenty of iridium, the &y&Nucleator&!&'s health is an impending issue, but it's the only way he'll survive.", {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 5.5}, {"Difficulty", 4}, {"Radiation", 8}}},
Baroness = {"Nobody dares to tell the &y&Baroness&!& right from wrong. That's for her to decide.", {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 8}, {"Difficulty", 4}, {"Versatility", 9}}},
Chirr = {"&y&Chirr&!& is a being of nature, seeking to alleviate the growing chaos on the planet.", {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 8}, {"Difficulty", 5}, {"Healing", 10}, {"Essence", 8}}},
Pyro = {"The &y&Pyro&!& doesn't need guns or blades. He already has the weapon he needs.", {{"Strength", 4}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 5}, {"Chill", 0}}},
["DU-T"] = {"&y&DU-T&!& charges up by consuming life force and using it to heal its allies.", {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 4}, {"Difficulty", 6}, {"Potential", 8}}},
Seraph = {"The &y&Seraph&!& arrives from beyond, with unknown power allowing it to manipulate the forces of gravity and time.", {{"Strength", 8}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 3}, {"Difficulty", 4}, {"Absolution", 6}}},
Knight = {"The &y&Knight&!& embraces honor as his only bidding, obligated to fight for the survival of himself and all his allies in the battlefield.", {{"Strength", 6}, {"Vitality", 4}, {"Toughness", 5}, {"Agility", 5}, {"Difficulty", 5}, {"Fealty", 8}}},
Random = {"I am not an actual survivor, this is a bug\nSend help :(", {{"HOW?", 99}, {"Oh", 0}, {"No", -8}}},
Spectator = {"Observant.", {{"Analysis", 10}, {"Perception", 10}, {"Fun", -5}}}
}

local defaultSprites = {}

local currentid = 1

do
	local pseudoid = 1
	for n, namespace in ipairs(namespaces) do
		for s, survivor in ipairs(Survivor.findAll(namespace)) do
			local sname = survivor:getName()
			skins[pseudoid] = {survivor = survivor, skinsData = {{id = 1, _internalid = currentid, _skinName = sname, displayName = sname, loadoutSprite = survivor.loadoutSprite, animations = nil, color = survivor.loadoutColor}}}
			info[sname] = {}
			currentid = currentid + 1
			pseudoid = pseudoid + 1
			if namespace == "vanilla" or namespace == "Starstorm" and defaultInfo[sname] then
				info[sname][1] = {description = defaultInfo[sname][1], stats = defaultInfo[sname][2], skills = {}, requirement = nil}
			else
				info[sname][1] = {description = "", stats = {}, skills = {}, requirement = nil}
			end
		end
	end
end

callback.register("onLoad", function()
	local currentid = 1
	local pseudoid = 1
	for n, namespace in ipairs(namespaces) do
		for s, survivor in ipairs(Survivor.findAll(namespace)) do
			local sname = survivor:getName()
			
			defaultSprites[survivor] = survivor.titleSprite
			
			if skins[pseudoid] == nil then skins[pseudoid] = {survivor = survivor, skinsData = {}} end
			
			
			skins[pseudoid].skinsData[1] = {id = 1, _internalid = currentid, _skinName = sname, displayName = sname, loadoutSprite = survivor.loadoutSprite, animations = nil, color = survivor.loadoutColor}
			
			if preid then skins[pseudoid].skinsData[1]._internalid = preid end
			
			if namespace ~= "vanilla" and namespace ~= "Starstorm" then
				info[sname] = {}
				info[sname][1] = {description = "", stats = {}, skills = {}, requirement = nil}
			end
			
			currentid = currentid + 1
			pseudoid = pseudoid + 1
		end
	end
end)

local AeonianSkins = {}

export("SurvivorVariant")
function SurvivorVariant.new(survivor, skinName, loadoutSprite, animations, color)
	if type(survivor) ~= "Survivor" then error("Argument 1: Survivor expected, got "..type(survivor), 2) end

	-- I hate this next chunk
	-- Seriously
	
	-- But it's either this or forcing everyone to place starstorm as the last mod on the load order
	-- UGH.
	
			-- Hi from the future, you're dumb, Neik.
			
					--- Hi from further into the future, I fixed this, poopyhead.
							
							-- hi from further (further) into the future, i forgot what i even did here... i probably did some hacky (dumb) workaround................
							
								-- dont be so mean to neik
	
	local pseudoid = 1
	for n, namespace in ipairs(namespaces) do
		for s, survivor in ipairs(Survivor.findAll(namespace)) do
			local sname = survivor:getName()
			if skins[pseudoid] == nil then skins[pseudoid] = {survivor = survivor, skinsData = {}} end
			skins[pseudoid].skinsData[1] = {id = 1, _internalid = currentid, _skinName = sname, displayName = sname, loadoutSprite = survivor.loadoutSprite, animations = nil, color = survivor.loadoutColor}
			if namespace ~= "vanilla" and namespace ~= "Starstorm" and not info[sname] then
				info[sname] = {}
				info[sname][1] = {description = "", stats = {}, skills = {}, requirement = nil}
			end
			pseudoid = pseudoid + 1
		end
	end
	
	for s, skin in ipairs(skins) do
		if skin.survivor == survivor then
			local sName = skinName or "Skin"
			local sSprite = loadoutSprite or survivor.loadoutSprite
			local sAnims = animations or {}
			local sColor = color or survivor.loadoutColor
			
			local id = table.maxn(skins[s].skinsData) + 1
			table.insert(skins[s].skinsData, {id = id, _internalid = currentid, _skinName = sName, displayName = sName, loadoutSprite = sSprite, animations = sAnims, color = sColor})
			currentid = currentid + 1
			
			local surName = survivor:getName() 
			
			if not info[surName] then
				info[surName] = {}
			end
			
			if not info[surName][id] then
				info[surName][id] = {description = nil, stats = {}, skills = {}, requirement = nil}
			end
			
			local finalSkin = skins[s].skinsData[#skins[s].skinsData]
			
			if sName:find("Anointed ") then
				table.insert(AeonianSkins, finalSkin)
			end
			
			return finalSkin
		end
	end
end

function SurvivorVariant.find(survivor, skinName)
	if type(survivor) ~= "Survivor" then
		error("Argument 1: Survivor expected, got "..type(survivor), 2)
	end
	if type(skinName) ~= "string" then
		error("Argument 2: string expected, got "..type(skinName), 2)
	end
	for su, survivorr in ipairs(skins) do
		if survivorr.survivor == survivor then
			for s, skin in ipairs(survivorr.skinsData) do
				if skin._skinName == skinName then
					return skin
				end
			end
		end
	end
	
	return nil
end

function SurvivorVariant.getSurvivorDefault(survivor)
	if type(survivor) ~= "Survivor" then
		error("Argument 1: Survivor expected, got "..type(survivor), 2)
	end
	return SurvivorVariant.find(survivor, survivor:getName())
end

function SurvivorVariant.findAll(survivor)
	if type(survivor) ~= "Survivor" then
		error("Argument 1: Survivor expected, got "..type(survivor), 2)
	end
	for su, survivorr in ipairs(skins) do
		if survivorr.survivor == survivor then
			local allSkins = {}
			for _, skin in ipairs(survivorr.skinsData) do
				table.insert(allSkins, skin)
			end
			return(allSkins)
		end
	end
end

function SurvivorVariant.getActive(playerInstance)
	if type(playerInstance) ~= "PlayerInstance" then
		error("PlayerInstance expected, got "..type(playerInstance), 2)
	end
	for s, survivor in ipairs(skins) do
		if survivor.survivor == playerInstance:getSurvivor() then
			local id = playerInstance:getModData("Starstorm").skin_id
			return survivor.skinsData[id]
		end
	end
end

function SurvivorVariant.setDescription(skin, txt)
	if skin and skin._internalid then
		if type(txt) == "string" then
			for su, survivor in ipairs(skins) do
				for s, sskin in ipairs(survivor.skinsData) do
					if sskin == skin then
						info[survivor.survivor:getName()][skin.id].description = txt
						break
					end
				end
			end
		else
			error("Argument 2: string expected, got "..type(txt), 2)
		end
	else
		error("Argument 1: Skin expected, got "..type(skin), 2)
	end
end

function SurvivorVariant.setLoadoutSkill(skin, name, description, image, subimage)
	if not subimage then subimage = 1 end
	if not name then name = "Skill" end
	if not description then description = "" end
	if skin and skin._internalid then
		if type(name) == "string" then
			if type(description) == "string" then
				if type(image) == "Sprite" then
					if type(subimage) == "number" then
						for su, survivor in ipairs(skins) do
							for s, sskin in ipairs(survivor.skinsData) do
								if sskin == skin then
									table.insert(info[survivor.survivor:getName()][skin.id].skills, {name, description, image, subimage})
									break
								end
							end
						end
					else
						error("Argument 5: Number expected, got "..type(subimage), 2)
					end
				else
					error("Argument 4: Sprite expected, got "..type(image), 2)
				end
			else
				error("Argument 3: string expected, got "..type(description), 2)
			end
		else
			error("Argument 2: string expected, got "..type(name), 2)
		end
	else
		error("Argument 1: Skin expected, got "..type(skin), 2)
	end
end

function SurvivorVariant.setInfoStats(skin, stats)
	if skin and skin._internalid then
		if type(stats) == "table" then
			for su, survivor in ipairs(skins) do
				for s, sskin in ipairs(survivor.skinsData) do
					if sskin == skin then
						info[survivor.survivor:getName()][skin.id].stats = stats 
						break
					end
				end
			end
		else
			error("Argument 2: Table expected, got "..type(stats), 2)
		end
	else
		error("Argument 1: Skin expected, got "..type(skin), 2)
	end
end

function SurvivorVariant.setRequirement(skin, achievement)
	if skin and skin._internalid then
		if isa(achievement, "Achievement") then
			for su, survivor in ipairs(skins) do
				for s, sskin in ipairs(survivor.skinsData) do
					if sskin == skin then
						if skin.animations[idle] then
							achievement.sprite = skin.animations[idle]
						elseif skin.animations[idle_1] then
							achievement.sprite = skin.animations[idle_1]
						end
						achievement.unlockText = "This skin is now available."
						achievement.highscoreText = "'"..skin.displayName.."' Unlocked"
						info[survivor.survivor:getName()][skin.id].requirement = achievement 
						break
					end
				end
			end
		else
			error("Argument 2: Achievement expected, got "..type(achievement), 2)
		end
	else
		error("Argument 1: Skin expected, got "..type(skin), 2)
	end
end

local variantSkills = {}

function SurvivorVariant.setSkill(skin, skillIndex, func)
	if skin and skin._internalid then
		if not variantSkills[skin] then
			variantSkills[skin] = {}
		end
		variantSkills[skin][skillIndex] = func
	else
		error("Argument 1: Skin expected, got "..type(skin), 2)
	end
end

function SurvivorVariant.activityState(player, index, sprite, speed, scaleSpeed, resetHSpeed)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	local iindex = index + 0.01
	
	if playerAc.dead == 0 then
		if playerAc.activity >= math.floor(index) and playerAc.activity < math.ceil(index + 0.001) then
			playerAc.activity = iindex
			playerAc.activity_type = 1
			
			playerData.variantSkillUse = {index = index, sprite = sprite, speed = speed, scaleSpeed = scaleSpeed, resetHSpeed = resetHSpeed}--, frame = 1}
			
			player.sprite = sprite
			player.subimage = 1
			
			if resetHSpeed and playerAc.free == 0 then
				playerAc.pHspeed = 0
			end
		end
	end
end

--

local sprites = {}
local selectionAnim = {}

local syncSelection
syncSelection = net.Packet.new("SSSkinSelection", function(player, player, data, value)
	if player and player:resolve() and data then
		local playerInstance = player:resolve()
		if data == "skins_Selection" then
			local skin = SurvivorVariant.find(playerInstance:getSurvivor(), value)
			if skin then
				if playerInstance:getModData("Starstorm").skins_Selection ~= skin then
					if sprites[playerInstance] and sprites[playerInstance][skin._skinName] then
						sprites[playerInstance][skin._skinName].sprite.subimage = 3
					end
					if selectionAnim[playerInstance] then
						selectionAnim[playerInstance] = 3
					end
				end
				playerInstance:getModData("Starstorm").skins_Selection = skin
			else
				error(playerInstance:get("user_name").."'s selected skin could not be found! Do we have the same mod versions?", 0)
			end
		elseif data == "skins_Ready" then
			playerInstance:getModData("Starstorm").skins_Ready = value
		end
		if net.host then
			syncSelection:sendAsHost(net.ALL, nil, player, data, value)
		end
	end
end)

local sprBlankSlot = Sprite.load("SelectBlank", "Misc/Menus/selectEmpty", 1, 0, 0)
local sprBackground = Sprite.load("SkinSelectBack", "Misc/Menus/selectSkin", 4, 34, 12)

selectionMenu = {}
selectionMenu.active = false
selectionMenu.onSubMenu = false
selectionMenu.selection = nil
selectionMenu.lastSelection = nil

local statdraw = {}

local saveSelect = {}

local selectables = {}

local firstStep = nil
local firstStepB = nil

local music = nil

local reference = nil
local returnedToMenu = true

callback.register("onGameEnd", function()
	reference = os.time()
end)

callback.register("globalRoomStart", function(room)
	if room == rm.Start then
		returnedToMenu = true
	end
end)

callback.register("onGameStart", function()
	global.gamestarted = false
	-- The following enables the menu if the game is not being started as part of a "retry"
	local timefrom = nil
	
	if reference then
		timefrom = os.difftime(os.time(), reference)
	end
	if global.rormlflag.ss_disable_submenu then
		timefrom = 0 --cringe code
	end
	if returnedToMenu and not global.rormlflag.ss_disable_submenu or timefrom and timefrom > 1 or not timefrom then
		selectionMenu.active = true
	else
		startGame()
	end
	firstStep = nil
	firstStepB = nil
	selectionAnim = {}
	
	returnedToMenu = false
end)

table.insert(call.onStep, function()
	if not firstStepB then
		firstStepB = true -- ugly code is ugly
		for p, player in ipairs(misc.players) do
			local index = p
			
			if net.online and player == net.localPlayer then index = 1 end
			
			local survivor = player:getSurvivor()
			local survivorSkin = nil
			
			if not net.online or player == net.localPlayer then
				
				local saveFile = save.read(index.."_"..survivor:getName().."_lastSkin")
				
				if saveFile and SurvivorVariant.find(survivor, saveFile) and not SurvivorVariant.find(survivor, saveFile).hidden then
					survivorSkin = SurvivorVariant.find(survivor, saveFile)
					player:getData().skins_Selection = survivorSkin
				else
					survivorSkin = SurvivorVariant.find(survivor, survivor:getName())
					player:getData().skins_Selection = survivorSkin
				end
			end
			if net.online and player == net.localPlayer then
				if net.host then
					syncSelection:sendAsHost(net.ALL, nil, player:getNetIdentity(), "skins_Selection", survivorSkin._skinName)
				else
					syncSelection:sendAsClient(player:getNetIdentity(), "skins_Selection", survivorSkin._skinName)
				end	
			end

			if not net.online or net.localPlayer == player then 
				selectionMenu.lastSelection = {survivor:getName(), survivorSkin}
			end
		end
	end
end)

table.insert(call.onPlayerStep, function(player)
	
	if selectionMenu.active then
		player:set("activity", 44)
		player:setAlarm(2, 2)
		player:setAlarm(3, 2)
		player:setAlarm(4, 2)
		player:setAlarm(5, 2)
		player:setAlarm(7, 2)
	elseif player:get("activity") == 44 then
		player:set("activity", 0)
	end
end)

table.insert(call.onStep, function()
	if selectionMenu.active then
		if Sound.getMusic() and Sound.getMusic() ~= sfx.musicTitle then
			music = Sound.getMusic()
			Sound.setMusic(sfx.musicTitle)
		end
		if sfx.Teleporter:isPlaying() then sfx.Teleporter:stop() end
		misc.hud:set("show_level_name", 0)
		misc.setTimeStop(2)
	else
		misc.hud:set("show_level_name", 1)
		if music and Sound.getMusic() ~= music then
			Sound.setMusic(music)
			music = nil
		end
	end
end)

function startGame()
	for p, player in ipairs(misc.players) do
		if not net.online or player == net.localPlayer then
			saveSelect[p] = {player:getSurvivor(), player:getData().skins_Selection._skinName}
		end
	end
	for s, saveSel in ipairs(saveSelect) do
		if saveSel[1] and saveSel[2] then
			save.write(s.."_"..saveSel[1]:getName().."_lastSkin", saveSel[2])
			if s == 1 then
				save.write("LastSurvivor", saveSel[1]:getName())
			end
		end
	end
	
	obj.Black:create(0, 0)
	selectionMenu.active = false
	global.gamestarted = true
	if misc.hud and misc.hud:isValid() then
		misc.hud:set("title_alpha", 5)
	end
	if misc.director and misc.director:isValid() then
		misc.director:setAlarm(1, 600)
	end
	global.inGame = true
end

local syncGameStart = net.Packet.new("SSSkinGameStart", function(player)
	startGame()
end)

showRuleset = false

local statsPolygonSize = 5

local shakex = 0
local shakey = 0
local shakeTimer = 0
local shakeTimer2 = 0

local lastMx = 0
local lastMy = 0

onHold = false

table.insert(call.postStep, function()
	if selectionMenu.active then
		for _, portal in ipairs(obj.ImpPortal:findAll()) do
			portal:delete()
		end
		for _, flash in ipairs(obj.WhiteFlash:findAll()) do
			flash:delete()
		end
	end
end)

callback.register("preStep", function()
	if selectionMenu.active then
		global.inGame = false
	end
end)

table.insert(call.onStep, function() -- absolutely retarded fix for an issue i caused.
	if selectionMenu.active then
		local w, h = graphics.getGameResolution()
		local ww = w / 2
		local hh = h / 2
		local www = (w * 0.75)
		local mx, my = input.getMousePos(true)
		local mlclick = {}
		local infohover = {}
		local players = misc.players
		if net.online and #misc.players > 4 then players = {net.localPlayer} end
		
		local playersReady = 0
		
		-- SKINS
		for p, player in ipairs(players) do
			local playerData = player:getData()
			playerData.hover = nil
			
			if selectionMenu.onSubMenu then
				mlclick[player] = nil
				playerData.mx, playerData.my = 0, 0
			else
				mlclick[player] = input.checkMouse("left")
				playerData.mx, playerData.my = input.getMousePos(true)
			end
			
			local width = 23
			local height = 72
			local heightOffset = height + 15
			local survivor = player:getSurvivor()
			local wide = false
			
			if survivor.loadoutWide then
				width = 47
				wide = true
			end
			
			local yOffset = (((heightOffset * (p - 1))) + (p - 1)) - ((heightOffset / 2) * #players)
			
			-- CONTROL
			local gamepad = input.getPlayerGamepad(player)
			
			local ssprites = {}
			local current = nil
			
			if not playerData.skins_rowsel then
				playerData.skins_rowsel = 1
			end
			local row = playerData.skins_rowsel
			
			for ss, ssurvivor in ipairs(skins) do
				if survivor == ssurvivor.survivor then
					for s, skin in ipairs(ssurvivor.skinsData) do
						if sprites[player] and sprites[player][skin._skinName] and sprites[player][skin._skinName].sprite then
							table.insert(ssprites, sprites[player][skin._skinName].sprite)
							if playerData.skins_Selection and playerData.skins_Selection == skin then
								current = s
							end
						end
					end
				end
			end
			
			if playerData.skins_presel then
				current = playerData.skins_presel
			end
			
			local sel = current
			
			local oncooldown = playerData.skins_preselcd
			
			if playerData.altControl then
				if playerData.mx ~= lastMx or playerData.my ~= lastMy then
					playerData.altControl = nil
				end
			end
			
			lastMx = playerData.mx
			lastMy = playerData.my
			
			if ssprites and current and sel and not selectionMenu.onSubMenu then
				if not oncooldown then
					if gamepad == nil then
						-- KEYBOARD
						if row == 1 then
							if player:control("left") == input.HELD then
								sel = sel - 1
								playerData.altControl = true
							elseif player:control("right") == input.HELD then
								sel = sel + 1
								playerData.altControl = true
							end
						end
						if player:control("up") == input.HELD then
							row = row - 1
							playerData.altControl = true
							playerData.skins_preselcd = 13
						elseif player:control("down") == input.HELD then
							row = row + 1
							playerData.altControl = true
							playerData.skins_preselcd = 13
						end
						if player:control("enter") == input.PRESSED then
							playerData.altControl = true
						end
					else
						
						-- DPAD
						if row == 1 then
							if input.checkGamepad("padl", gamepad) == input.HELD  then
								sel = sel - 1
								playerData.altControl = true
							elseif input.checkGamepad("padr", gamepad) == input.HELD  then
								sel = sel + 1
								playerData.altControl = true
							end
						end
						if input.checkGamepad("padu", gamepad) == input.HELD  then
							row = row - 1
							playerData.altControl = true
							playerData.skins_preselcd = 13
						elseif input.checkGamepad("padd", gamepad) == input.HELD  then
							row = row + 1
							playerData.altControl = true
							playerData.skins_preselcd = 13
						end
						-- L JOYSTICK
						if row == 1 then
							if math.round(input.getGamepadAxis("lh", gamepad)) ~= 0 then
								sel = math.round(sel + 1 * input.getGamepadAxis("lh", gamepad))
								playerData.altControl = true
								playerData.skins_preselcd = 13
							end
						end
						if math.round(input.getGamepadAxis("lv", gamepad)) ~= 0 then
							row = math.round(row + 1 * input.getGamepadAxis("lv", gamepad))
							playerData.altControl = true
							playerData.skins_preselcd = 13
						end
						if input.checkGamepad("face1", gamepad) == input.PRESSED then
							playerData.altControl = true
						end
					end
				end
				
				if playerData.altControl then
					if gamepad == nil then
						mlclick[player] = player:control("enter")
					else
						mlclick[player] = input.checkGamepad("face1", gamepad)
					end
					if playerData.availableSkins then
						if sel > playerData.availableSkins then
							sel = 1
						elseif sel < 1 then
							sel = playerData.availableSkins
						end
					end
					if row > 3 then
						row = 3
					elseif row < 1 then
						row = 1
					end
					if p > 1 then
						row = 1
					end
					playerData.skins_presel = sel
					playerData.skins_rowsel = row
					if row == 1 and ssprites[sel] then
						playerData.mx = ssprites[sel].x
						playerData.my = ssprites[sel].y
					elseif row == 2 then
						playerData.mx = ww
						playerData.my = h - 60
					else
						playerData.mx = ww
						playerData.my = h - 20
					end
				end
			end
			
			if sel ~= current then
				playerData.skins_preselcd = 13
			end
			if playerData.skins_preselcd then
				if playerData.skins_preselcd > 0 then
					playerData.skins_preselcd = playerData.skins_preselcd - 1
				else
					playerData.skins_preselcd = nil
				end
			end
			
			for su, ssurvivor in ipairs(skins) do
				if ssurvivor.survivor == survivor then
					local availableSkins = {}
					
					for _, skin in ipairs(ssurvivor.skinsData) do
						if not skin.hidden or playerData.skins_Selection == skin then
							table.insert(availableSkins, skin)
						end
					end
					for s, skin in ipairs(availableSkins) do
						local xOffset = (((width * (s - 1))) + (s - 1)) - ((width / 2) * #availableSkins)
						if not selectionAnim[player] then
							selectionAnim[player] = 1
						end
						
						if not sprites[player] then
							sprites[player] = {}
						end
						if not sprites[player][skin._skinName] then
							sprites[player][skin._skinName] = {}
						end
						
						sprites[player][skin._skinName].sprite = {image = skin.loadoutSprite, x = xOffset + www, y = yOffset + hh, subimage = 2}
						
						local sprite = sprites[player][skin._skinName].sprite
						if playerData.skins_Selection and playerData.skins_Selection == skin then
							if selectionAnim[player] > sprite.image.frames then selectionAnim[player] = 1 end
							selectionAnim[player] = math.approach(selectionAnim[player], sprite.image.frames, 0.2)
						end
						
						local locked = nil
						
						if info[survivor:getName()][skin.id] and info[survivor:getName()][skin.id].requirement and not info[survivor:getName()][skin.id].requirement:isComplete() then
							locked = true
						end
						
						if not locked then
							if not net.online or player == net.localPlayer then
								if not playerData.skins_Ready then
									if playerData.mx >= sprite.x and playerData.mx <= sprite.x + width
									and playerData.my >= sprite.y and playerData.my <= sprite.y + height and not playerData.altControl or playerData.altControl and playerData.skins_presel == s and playerData.skins_rowsel == 1 then
										playerData.skins_presel = s
										playerData.hover = skin
										if playerData.skins_Selection and playerData.skins_Selection ~= skin then
											sprite.subimage = 3
										end
									end
								end
							end
						else
							if playerData.mx >= sprite.x and playerData.mx <= sprite.x + width
							and playerData.my >= sprite.y and playerData.my <= sprite.y + height and not playerData.altControl or playerData.altControl and playerData.skins_presel == s and playerData.skins_rowsel == 1 then
								if not net.online or player == net.localPlayer then
									playerData.skins_presel = s
								end
							end
							sprite.subimage = 1
						end
					end
				end
			end

			if playerData.hover and playerData.hover._internalid then
				if mlclick[player] == input.PRESSED then
					selectionMenu.lastSelection = {survivor:getName(), playerData.hover}
					player:getData().skins_Selection = playerData.hover
					sprites[player][playerData.hover._skinName].sprite.subimage = 4
					selectionAnim[player] = 2
					if net.online and net.localPlayer == player then
						if net.host then
							syncSelection:sendAsHost(net.ALL, nil, player:getNetIdentity(), "skins_Selection", playerData.hover._skinName)
						else
							syncSelection:sendAsClient(player:getNetIdentity(), "skins_Selection", playerData.hover._skinName)
						end	
					end
					
					if net.online and net.localPlayer == player or not net.online and p == 1 then
						saveSelect[p] = {player:getSurvivor(), playerData.hover._skinName}
					end
				end
			end
			
		end
		for _, player in ipairs(misc.players) do
			if player:getData().skins_Ready then
				playersReady = playersReady + 1
			end
		end
		
		local alpha = 0.5
		local alpha2 = 0.5
		local text = "READY"
		local txtHeight = graphics.textHeight(text, 2)
		local yOffset = 40
		
		local player = misc.players[1]
		if net.online then
			player = net.localPlayer
			
			if playersReady == #misc.players and net.host then
				text = "LAUNCH"
			elseif net.localPlayer:getData().skins_Ready then
				text = "UNREADY"
			end
		else
			text = "LAUNCH"
		end
		if player:getData().my >= h - yOffset - (txtHeight / 2) - 5 and player:getData().my <= h and not onHold then
			player:getData().hover = text
			alpha = 1
		end
		
		-- Ruleset
		if player:getData().my >= h - yOffset - 20 - (txtHeight / 2) and player:getData().my <= h - yOffset - (txtHeight / 2) - 6 and not onHold then
			player:getData().hover = "ruleset"
			alpha2 = 1
		end
		
		if mlclick[misc.players[1]] == input.PRESSED then
			if misc.players[1]:getData().hover then
				if misc.players[1]:getData().hover == "READY" then
					if not net.online then
						for _, player in ipairs(misc.players) do
							player:getData().skins_Ready = true
						end
					else
						-- Weird code to make sure the skin is passed, for some reason it isn't in some situations.
						for _, player in ipairs(misc.players) do
							if player == net.localPlayer then
								if net.host then
									syncSelection:sendAsHost(net.ALL, nil, player:getNetIdentity(), "skins_Selection", player:getData().skins_Selection._skinName)
								else
									syncSelection:sendAsClient(player:getNetIdentity(), "skins_Selection", player:getData().skins_Selection._skinName)
								end	
							end
						end
						
						if net.host then
							syncSelection:sendAsHost(net.ALL, nil, net.localPlayer:getNetIdentity(), "skins_Ready", true)
						else
							syncSelection:sendAsClient(net.localPlayer:getNetIdentity(), "skins_Ready", true)
						end	
						net.localPlayer:getData().skins_Ready = true
					end
				elseif misc.players[1]:getData().hover == "UNREADY" then
					if net.online then
						if net.host then
							syncSelection:sendAsHost(net.ALL, nil, net.localPlayer:getNetIdentity(), "skins_Ready", false)
						else
							syncSelection:sendAsClient(net.localPlayer:getNetIdentity(), "skins_Ready", false)
						end	
						net.localPlayer:getData().skins_Ready = false
					end
				elseif misc.players[1]:getData().hover == "LAUNCH" then
					syncGameStart:sendAsHost(net.ALL, nil)
					startGame()
				elseif misc.players[1]:getData().hover == "ruleset" then
					if net.host then
						selectionMenu.onSubMenu = true
					end
				end
			end
		end
		
	end
end)

table.insert(call.onHUDDraw, function() -- I am an absolute piece of ham for doing all of this in the HUDDraw, I wish I hadn't been so naive
	
	if selectionMenu.active then
		
		local w, h = graphics.getGameResolution()
		local ww = w / 2
		local hh = h / 2
		local www = (w * 0.75)
		local mx, my = input.getMousePos(true)
		local mlclick = {}
		local infohover = {}
		local players = misc.players
		if net.online and #misc.players > 4 then players = {net.localPlayer} end
		
		
		-- BACKGROUND
		graphics.color(Color.fromHex(0x0A0505))
		graphics.rectangle(0, 0, w, h, false)
		
		-- TITLE
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("SELECT A VARIANT", w / 2, 20, 2, 1, 2)
		
		local playersReady = 0
		
		local infoText = nil
		local skills = nil
		local stats = nil
			
		if players then
			for p, player in ipairs(players) do
				local height = 72
				local heightOffset = height + 15
				local yOffset = (((heightOffset * (p - 1))) + (p - 1)) - ((heightOffset / 2) * #players)
				
				-- BACKGROUND 2
				graphics.color(Color.fromHex(0x1E1111))
				graphics.drawImage{
				image = sprBackground,
				x = www - 175 + shakex,
				y = hh + yOffset - 15 + shakey,
				subimage = p
				}
				--graphics.rectangle(www - 175, hh + yOffset - 15, www + 175, hh + yOffset + 80, false)
			end
		end
		
		-- SKINS
		for p, player in ipairs(players) do
			local playerData = player:getData()
			
			local width = 23
			local height = 72
			local heightOffset = height + 15
			local survivor = player:getSurvivor()
			
			if survivor.loadoutWide then
				width = 47
			end
			
			local yOffset = (((heightOffset * (p - 1))) + (p - 1)) - ((heightOffset / 2) * #players)

			-- PLAYER NAMES
			if #players > 1 then
				local playerName = "Player "..p
				if net.online then
					playerName = player:get("user_name")
				end
				
				graphics.color(playerColor(player, p))
				graphics.print(playerName, www - 168, hh + yOffset + (height / 2), 1, 0, 2)
			end
			
			for su, ssurvivor in ipairs(skins) do
				if ssurvivor.survivor == survivor then
					--[[playerData.availableSkins = #ssurvivor.skinsData
					if playerData.availableSkins == 1 and not net.online then
						playerData.skins_Ready = true
					end]]
					local availableSkins = {}
					
					for _, skin in ipairs(ssurvivor.skinsData) do
						if not skin.hidden or playerData.skins_Selection == skin then
							table.insert(availableSkins, skin)
						end
					end
					for s, skin in ipairs(availableSkins) do
						
						local sprite = sprites[player][skin._skinName].sprite
						
						if playerData.skins_Selection and playerData.skins_Selection == skin then
							sprite.subimage = selectionAnim[player]
							graphics.color(Color.fromHex(0xEFD27B))
							graphics.print(skin.displayName, sprite.x + (width / 2) + 3 + shakex, sprite.y + shakey, 1, 1, 2)
						end
						
						local locked = nil
						
						if info[survivor:getName()][skin.id] and info[survivor:getName()][skin.id].requirement and not info[survivor:getName()][skin.id].requirement:isComplete() then
							locked = true
						end
						
						if locked then
							if playerData.mx >= sprite.x and playerData.mx <= sprite.x + width
							and playerData.my >= sprite.y and playerData.my <= sprite.y + height and not playerData.altControl or playerData.altControl and playerData.skins_presel == s and playerData.skins_rowsel == 1 then
								local name = nil
								if not net.online or player == net.localPlayer then
									local prefix = survivor:getName()..": "
									name = string.gsub(info[survivor:getName()][skin.id].requirement.description, prefix, "")
								else
									name = info[survivor:getName()][skin.id].requirement.description
								end
								infohover[player] = name
							end
						end
						
						local draws = 3
						local wwidth = 23
						for i = 1, draws do
							if s == 1 then
								graphics.drawImage{
									image = sprBlankSlot,
									alpha = 1 / (i + 1),
									x = (sprite.x - wwidth * i) + shakex,
									y = sprite.y + shakey
								}
							end
							if s == #availableSkins then
								graphics.drawImage{
									image = sprBlankSlot,
									alpha = 1 / (i + 1),
									x = (sprite.x + width + wwidth * (i - 1)) + shakex,
									y = sprite.y + shakey
								}
							end
						end
						
						if skin ~= playerData.skins_Selection then		
							graphics.drawImage{
								image = sprite.image,
								subimage = sprite.subimage,
								alpha = 1,
								x = sprite.x + shakex,
								y = sprite.y + shakey,
								scale = 1
							}
						end

					end
					break
				end
			end
			for su, ssurvivor in ipairs(skins) do
				if ssurvivor.survivor == survivor then
					local availableSkins = {}
					
					for _, skin in ipairs(ssurvivor.skinsData) do
						if not skin.hidden or playerData.skins_Selection == skin then
							table.insert(availableSkins, skin)
						end
					end
					for s, skin in ipairs(availableSkins) do
						local sprite = sprites[player][skin._skinName].sprite
						
						if skin == playerData.skins_Selection then						
							graphics.drawImage{
								image = sprite.image,
								subimage = sprite.subimage,
								alpha = 1,
								x = sprite.x + shakex,
								y = sprite.y + shakey,
								scale = 1
							}
						end
					end
					break
				end
			end
			
			local selectedSkin = player:getData().skins_Selection
			
			if selectedSkin then
				--selectionMenu.selection = selectedSkin
				
				graphics.color(playerColor(player, p))
				local sprite = sprites[player][selectedSkin._skinName].sprite
				if #players > 1 then
					graphics.rectangle(sprite.x, sprite.y, sprite.x + width, sprite.y + height, true)
				end
			end
		end
		for _, player in ipairs(misc.players) do
			if player:getData().skins_Ready then
				playersReady = playersReady + 1
			end
		end
		
		for p, player in ipairs(misc.players) do
			if not net.online or player == net.localPlayer then
				local lastSel = selectionMenu.lastSelection
				
				if net.online then
					lastSel = {player:getSurvivor():getName(), player:getData().skins_Selection}
				end
				
				if lastSel and lastSel[1] and lastSel[2] then
					if info[lastSel[1]][lastSel[2].id] then
						infoText = info[lastSel[1]][lastSel[2].id].description
						skills = info[lastSel[1]][lastSel[2].id].skills
						stats = info[lastSel[1]][lastSel[2].id].stats
					end
				end
				
				-- DESCRIPTION
				if infoText then
					local threshold = w * 0.8
					if net.online then threshold = w * 0.3 end
					
					local count = string.len(infoText)
					local twidth = graphics.textWidth(infoText, 1)
					local ncount = count / (twidth / threshold)
					
					for i = 1, math.floor(twidth / threshold) do
						local place = string.find(infoText, " ", i * ncount)
						if place then
							infoText = string.sub(infoText, 0, place).."\n"..string.sub(infoText, place + 1)
						end
					end
					graphics.color(Color.WHITE)
					graphics.printColor(infoText, 16, 42, 1)
				end
				
				-- SKILLS
				if skills then
					for s, skill in ipairs(skills) do
						local threshold = w * 0.5
						local description = skill[2]
						
						local count = string.len(description)
						local twidth = graphics.textWidth(description, 1)
						local ncount = count / (twidth / threshold)
						local lastColor
						
						if description then
							for i = 1, math.floor(twidth / threshold) do
								
								local ssstring = string.sub(description, 0, i * ncount)
								local sstring = string.reverse(ssstring)
								
								lastColor = string.match(sstring, "&..?&")
								-- nice code, neik...
								local place = string.find(description, " ", i * ncount)
								if place then
									if lastColor then
										description = string.sub(description, 0, place).."\n"..string.reverse(lastColor)..string.sub(description, place + 1)
									else
										description = string.sub(description, 0, place).."\n"..string.sub(description, place + 1)
									end
								end
							end
						end
						
						
						graphics.color(lastSel[2].color)
						graphics.print(skill[1], 40, 220 - 105 + (41 * (s - 1)), 1)
						
						graphics.color(Color.WHITE)
						graphics.printColor(description, 46, 220 - 95 + (41 * (s - 1)), 1)
						
						graphics.drawImage{
							image = skill[3],
							subimage = skill[4],
							x = 16,
							y = 220 - 105 + (41 * (s - 1))
						}
					end
				end
				
				-- STATS
				if stats and not net.online then
					local amount = #stats
					local xorigin = 110
					local yorigin = h - 92
					for i, stat in ipairs(stats) do
						if statdraw[i] then
							statdraw[i] = math.approach(statdraw[i], stat[2], (stat[2] - statdraw[i]) * (0.1 / #misc.players))
						else
							statdraw[i] = 0
						end
						local aa = (i/amount) * (math.pi * 2)
						local xx = math.cos(aa)
						local yy = math.sin(aa)
						
						local statx = xx * (statsPolygonSize * statdraw[i])
						local staty = yy * (statsPolygonSize * statdraw[i])
						
						local last = nil
						local xxx = 0
						local yyy = 0
						local lastx = 0
						local lasty = 0
						
						if i == 1 then last = amount else last = i - 1 end
						if last and statdraw[last] then
							local aaa = (last/amount) * (math.pi * 2)
							xxx = math.cos(aaa)
							yyy = math.sin(aaa)
							lastx = xxx * (statsPolygonSize * statdraw[last])
							lasty = yyy * (statsPolygonSize * statdraw[last])
						end
						
						graphics.color(Color.DARK_GRAY)
						graphics.line(xorigin + 2, yorigin + 2, xorigin + (xx * 50) + 2, yorigin + (yy * 50 + 2))
						graphics.line(xorigin + (xxx * 50) + 2, yorigin + (yyy * 50) + 2, xorigin + (xx * 50) + 2, yorigin + (yy * 50) + 2)
					end
					for i, stat in ipairs(stats) do
						local aa = (i/amount) * (math.pi * 2)
						local xx = math.cos(aa)
						local yy = math.sin(aa)
						
						local statx = xx * (statsPolygonSize * statdraw[i])
						local staty = yy * (statsPolygonSize * statdraw[i])
						
						local last = nil
						local xxx = 0
						local yyy = 0
						local lastx = 0
						local lasty = 0
						
						if i == 1 then last = amount else last = i - 1 end
						if last and statdraw[last] then
							local aaa = (last/amount) * (math.pi * 2)
							xxx = math.cos(aaa)
							yyy = math.sin(aaa)
							lastx = xxx * (statsPolygonSize * statdraw[last])
							lasty = yyy * (statsPolygonSize * statdraw[last])
						end
						
						graphics.color(lastSel[2].color)
						graphics.triangle(xorigin, yorigin, xorigin + statx, yorigin + staty, xorigin + lastx, yorigin + lasty, false)
						
						graphics.color(Color.WHITE)
						graphics.print(stat[1], xorigin + (xx * 65) + 2, yorigin + (yy * 65) + 3, 1, 1, 1)
					end
				end
			end
		end
		
		for player, info in pairs(infohover) do
			local txt = "&r&-LOCKED-&!&\n"..info
			local off = 2
			local off2 = 4
			local off3 = 6
			local twidth = graphics.textWidth(txt, graphics.FONT_DEFAULT)
			local theight = graphics.textHeight(txt, graphics.FONT_DEFAULT)
			local xx = math.min(player:getData().mx - twidth, w - twidth - 6)
			local yy = player:getData().my - theight
			graphics.color(Color.BLACK)
			graphics.alpha(0.85)
			graphics.rectangle(xx - off, yy - off, xx + twidth + off2, yy + theight + off2, false)
			graphics.rectangle(xx - off2, yy - off2, xx + twidth + off3, yy + theight + off3, true)
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(txt, xx + off2, yy + off2 - 1, graphics.FONT_DEFAULT)
			-- "-1" Fuck displacement
		end
		
		
		-- READY
		local alpha = 0.5
		local alpha2 = 0.5
		local text = "READY"
		local txtWidth = graphics.textWidth(text, 2)
		local txtHeight = graphics.textHeight(text, 2)
		local yOffset = 40
		
		if net.online then
			local count = 0
			for p, player in ipairs(misc.players) do
				if not player:getData().skins_Ready then
					count = count + 1
					local www = (p - 1) * 60 - (30 * (#misc.players - 1))
					local name = player:get("user_name")
					if player == net.localPlayer then
						name = "You"
					end
					graphics.color(playerColor(player, p))
					graphics.print(name, ww + www, h - 10, 1, 1, 2)
				end
			end
			
			graphics.color(Color.GRAY)
			if count == 0 and not net.host then
				graphics.print("Awaiting Host", ww, h - 20, 1, 1, 2)
			elseif count > 0 then
				graphics.print("Awaiting:", ww, h - 20, 1, 1, 2)
			end
			if playersReady == #misc.players and net.host then
				text = "LAUNCH"
			elseif net.localPlayer:getData().skins_Ready then
				text = "UNREADY"
			end
			
			
		else
			--[[ Since the inclusion of rulesets we dont want to skip this menu
			local pskip = 0
			for _, player in ipairs(misc.players) do
				if player:getData().availableSkins == 1 then
					pskip = pskip + 1
				end
			end
			if pskip == #misc.players then
				startGame()
			else
				text = "LAUNCH"
			end]] 
			text = "LAUNCH"
		end
		
		local player = misc.players[1]
		if net.online then
			player = net.localPlayer
		end
		if player:getData().my >= h - yOffset - (txtHeight / 2) - 5 and player:getData().my <= h and not onHold then
			player:getData().hover = text
			alpha = 1
		end
		
		-- Ruleset
		if player:getData().my >= h - yOffset - 20 - (txtHeight / 2) and player:getData().my <= h - yOffset - (txtHeight / 2) - 6 and not onHold then
			player:getData().hover = "ruleset"
			alpha2 = 1
		end
		
		graphics.color(Color.WHITE)
		graphics.alpha(alpha2)
		if global.activeRuleset then
			if net.host then
				if global.activeRuleset == 1 then
					graphics.print("Default Ruleset", ww, h - yOffset - 20, 1, 1, 1)
				else
					graphics.print("Ruleset "..global.activeRuleset - 1, ww, h - yOffset - 20, 1, 1, 1)
				end
			else
				graphics.print("Show Ruleset", ww, h - yOffset - 20, 1, 1, 1)
			end
		end
		
		showRuleset = false
		
		
		local player = misc.players[1]
		if net.online then
			player = net.localPlayer
		end
		
		if misc.players[1]:getData().hover then
			if misc.players[1]:getData().hover == "ruleset" then
				if not net.host then
					showRuleset = true
				end
			end
		end
		
		local hover = player:getData().my >= h - yOffset - (txtHeight / 2) - 5 and player:getData().my <= h and not onHold and player:getData().hover == "READY"
		
		if player:getData().hover == "LAUNCH" then graphics.color(Color.fromHex(0xEFD27B)) end
		graphics.alpha(alpha)
		graphics.print(text, ww, h - yOffset, 2, 1, 1)
		
		if math.chance(1) and math.chance(shakeTimer2) then shakeTimer = math.random(7, 13) end
		if shakeTimer > 0 then
			shakex = math.random(-1.5, 1.5)
			shakey = math.random(-1.5, 1.5)
			shakeTimer = shakeTimer - 1
			shakeTimer2 = 0
		else
			shakex = 0
			shakey = 0
			shakeTimer2 = shakeTimer2 + 0.2
		end
	end
end)

local iterations = {"Idle_1", "idle_1", "Idle", "idle"}

table.insert(call.onStep, function()
	if not selectionMenu.active and not firstStep then
		for p, player in ipairs(misc.players) do
			--print(player:getData().skins_Selection)
			local id = player:getData().skins_Selection.id
			if id ~= 1 then
				for _, survivor in ipairs(skins) do
					if player:getSurvivor() == survivor.survivor then
						if survivor.skinsData[id] then
							player:set("name", survivor.skinsData[id].displayName)
							if not survivor.skinsData[id].forceApply then
								if survivor.skinsData[id].animations ~= nil then
									player:getData().skin_id = id
									player:setAnimations(survivor.skinsData[id].animations)
								end
							else
								if survivor.skinsData[id].animations.death then
									player:setAnimation("death", survivor.skinsData[id].animations.death)
								end
								if survivor.skinsData[id].animations.decoy then
									player:setAnimation("decoy", survivor.skinsData[id].animations.decoy)
								end
								if survivor.skinsData[id].animations then
									player:getData().skin_id = id
								end
								if player:getSurvivor() == sur.Huntress then
									player:setAnimation("shoot1", survivor.skinsData[id].animations.shoot1)
									player:setAnimation("shoot2", survivor.skinsData[id].animations.shoot2)
									player:setAnimation("shoot4", survivor.skinsData[id].animations.shoot4)
									player:setAnimation("shoot5", survivor.skinsData[id].animations.shoot5)
								--elseif player:getSurvivor() == sur.HAND then
									--player:setAnimation("climb", survivor.skinsData[id].animations.climb)
									--player:setAnimation("climbhot", survivor.skinsData[id].animations.climbhot)
								end
								local spriteAnim = "idle"
								for _, iteration in ipairs(iterations) do
									if player:getAnimation(iteration) then
										spriteAnim = iteration
										break
									end
								end
								local sprite = player:getAnimation(spriteAnim):getName()
								
								for _, iteration in ipairs(iterations) do
									if string.find(sprite, iteration) then
										spriteAnim = string.sub(sprite, string.find(sprite, iteration), -1)
										break
									end
								end
								
								local temp = nil
								if sprite then
									temp = string.gsub(sprite, spriteAnim, "")
									player:getData().skin_namePrefix = temp
								end
								
								if survivor.skinsData[id].animations.idle then
									player:setAnimation("idle", survivor.skinsData[id].animations.idle)
								end
							end
						end
					end
				end
			end
			
			local skin = SurvivorVariant.getActive(player)
			skinInitCallback(player, skin)
			
		end
		postSelectInitCallback()
		firstStep = true
	end
end)

callback.register("postPlayerStep", function(player)
	local spritePrefix = player:getData().skin_namePrefix
	local skin = SurvivorVariant.getActive(player)
	if skin then
		--player:setAnimations(skin.animations)
		if spritePrefix then
			if string.find(player.sprite:getName(), spritePrefix) == 1 then
				local animation = string.lower(string.gsub(player.sprite:getName(), spritePrefix, ""))
				if skin.animations[animation] and skin.forceApply then
					player.sprite = skin.animations[animation]
				end
				if global.rormlflag.ss_skins_helper then
					print("[Skin Animation Helper]: "..animation)
				end
			end
		end
		if player:get("activity") == 30 and player:getSurvivor() == sur.HAND and skin.animations.climbhot then
			local gauge = Object.findInstance(player:get("gauge"))
			if gauge and gauge:isValid() then
				player.sprite = skin.animations.climbhot
			else
				player.sprite = skin.animations.climb
			end
		end
		
		if not player:getData().skin_sc and player:countItem(it.AncientScepter) > 0 then
			player:getData().skin_sc = true
			if skin.animations.shoot5_1 then
				player:setAnimation("shoot4_1", skin.animations.shoot5_1)
			end
			if skin.animations.shoot5_2 then
				player:setAnimation("shoot4_2", skin.animations.shoot5_2)
			end
			if skin.animations.shoot5 then
				player:setAnimation("shoot4", skin.animations.shoot5)
			end
		end
	end
end)

callback.register("onPlayerDeath", function(player)
	local skin = SurvivorVariant.getActive(player)
	if skin and skin.forceApply then
		if skin.animations.idle then
			player:setAnimations(skin.animations)
			player:setAnimation("idle", skin.animations.idle)
		elseif skin.animations.idle_1 then
			player:setAnimation("idle", skin.animations.idle_1)
		end
	end
end)
table.insert(call.postStep, function()
	for _, body in ipairs(obj.Body:findAll()) do
		if not body:getData()._skinChecked then
			body:getData()._skinChecked = true
			if body.sprite == spr.JanitorDeath then
				local instance = obj.P:findNearest(body.x, body.y)
				if instance and instance:isValid() then
					if instance:getSurvivor() == sur.HAND then
						local skin = SurvivorVariant.getActive(instance)
						if skin and skin.animations and skin.animations.death_2 then
							body.sprite = skin.animations.death_2
						end
					end
				end
			end
		end
	end
end)

-- menu

local function setTitleScreenSkin()
	local survivorName = save.read("LastSurvivor")
	if survivorName then
		local skinName = save.read("1_"..survivorName.."_lastSkin")
		if skinName then
			for s, ssurvivor in ipairs(skins) do
				if ssurvivor.survivor:getName() == survivorName then
					for ss, skin in ipairs(ssurvivor.skinsData) do
						if skin._skinName == skinName then
							if skin._skinName == ssurvivor.survivor:getName() then
								ssurvivor.survivor.titleSprite = defaultSprites[ssurvivor.survivor]
							else
								if skin.animations then
									if skin.animations.walk then
										ssurvivor.survivor.titleSprite = skin.animations.walk
									elseif skin.animations.walk_1 then
										ssurvivor.survivor.titleSprite = skin.animations.walk_1
									end
								end
							end
							break
						end
					end
				end
			end
		end
	end
end

callback.register("postLoad", function()
	setTitleScreenSkin()
end)

callback.register("onGameEnd", function()
	setTitleScreenSkin()
end)

function skinFireHeavenCracker(player, damage)
	local bulletDamage = damage or 1
	local heavenCracker = player:countItem(it.HeavenCracker)
	if heavenCracker > 0 then
		if not player:getData().skinHeavenCracker then player:getData().skinHeavenCracker = 1 end
		local preVal = player:getData().skinHeavenCracker
		local fired = false
		if preVal >= 5 - heavenCracker then
			player:getData().skinHeavenCracker = 0
			local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 500, bulletDamage, spr.Sparks3, DAMAGER_NO_PROC + DAMAGER_BULLET_PIERCE)
			bullet:getData().skin_newDamager = true
			fired = true
		end
		player:getData().skinHeavenCracker = player:getData().skinHeavenCracker + 1
		return fired
	end
	return false
end

callback.register("postLoad", function()
	if global.lastVersion == nil or global.lastVersion < 186 then
		for su, survivorr in ipairs(skins) do
			for s, skin in ipairs(survivorr.skinsData) do
				save.write("skin_achievement_"..skin._skinName:lower(), nil)
			end
		end
	end
end)

local endQuotes = {}
local modifiedSurvivor

callback.register("postLoad", function()
	for _, survivor in ipairs(Survivor.findAll()) do
		endQuotes[survivor] = survivor.endingQuote
	end
end)
callback.register("onGameStart", function()
	if modifiedSurvivor then
		modifiedSurvivor.endingQuote = endQuotes[modifiedSurvivor]
	end
end)
callback.register("onGameBeat", function(endType)
	if not endType.quote then
		local player
		if net.online then
			player = net.localPlayer
		else
			player = misc.players[1]
		end
		local survivor = player:getSurvivor()
		local skin = SurvivorVariant.getActive(player)
		
		if skin and skin.endingQuote then
			modifiedSurvivor = survivor
			survivor.endingQuote = skin.endingQuote
		end
	end
end)
callback.register("postLoad", function()
	for _, survivor in ipairs(Survivor.findAll()) do
		survivor:addCallback("useSkill", function(player, skillIndex)
			local skin = SurvivorVariant.getActive(player)
			if skin and variantSkills[skin] and not player:getData().variantSkillUse then
				local skill = variantSkills[skin][skillIndex]
				if skill then
					skill(player)
				end
			end
		end)
	end
end)
	--survivor:addCallback("step", function(player)
	callback.register("postPlayerStep", function(player)
		local playerData = player:getData()
		
		local skill = playerData.variantSkillUse
		if skill then
			if skill.resetHSpeed then
				if player:get("free") == 0 and not skill.firstFrame then
					skill.firstFrame = true
					player:set("pHspeed", 0)
				end
				if player:getSurvivor():getOrigin() == "Vanilla" then
					player:set("activity_type", 1)
				end
			end
			
			player.sprite = skill.sprite
			local mult = 1
			
			--if player:get("activity") == 0 and player.subimage < skill.sprite.frames then
			--	player:set("activity", skill.index + 0.01)
			--	player:set("activity_type", 1)
			--end
			
			if skill.scaleSpeed then mult = player:get("attack_speed") end
			player.spriteSpeed = math.min(skill.speed * mult, 1)
			if player.subimage >= player.sprite.frames then
				if player:get("activity") == skill.index + 0.01 then
					player:set("activity", 0)
					player:set("activity_type", 0)
				end
				playerData.variantSkillUse = nil
			end
			if player:get("activity") ~= skill.index + 0.01 then
				player:set("activity", 0)
				player:set("activity_type", 0)
				playerData.variantSkillUse = nil
			end
		end
	end)
--end

local onSkinSkillCallback = callback.create("onSkinSkill")

callback.register("postLoad", function()
	for _, survivor in ipairs(Survivor.findAll()) do
		survivor:addCallback("onSkill", function(player, skill, relevantFrame)
			local data = player:getData()
			
			local trueSkill = math.floor(skill * 10) / 10
			local trueRelevantFrame = 0
			
			if survivor:getOrigin() == "Vanilla" then
				if not data._lastRFrame or data._lastRFrame ~= relevantFrame then
					trueRelevantFrame = relevantFrame
					data._lastRFrame = relevantFrame
				end
			else
				trueRelevantFrame = relevantFrame
			end
			
			local variant = SurvivorVariant.getActive(player)
			if variant then
				onSkinSkillCallback(player, trueSkill, trueRelevantFrame, variant)
			end
		end)
	end
end)

callback.register("onPlayerDeath",function(player) -- wew this sucks
	player:set("z_skill", 0)
	player:set("x_skill", 0)
	player:set("c_skill", 0)
	player:set("v_skill", 0)
end)

callback.register("postLoad", function()
	for _, data in ipairs(skins) do
		local name = data.survivor:getName()
		for _, skin in ipairs(data.skinsData) do
			if skin._skinName == "Anointed "..data.survivor.displayName then
				local save = save.read("judgement_"..name)
				if not save then
					skin.hidden = true -- oh hello, you aren't here to cheat, are you?
				end
				break
			end
		end
	end
end)