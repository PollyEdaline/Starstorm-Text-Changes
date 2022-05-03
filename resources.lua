-- SET UP
-- Temporary callbacks
local tcallbacks = {onStep = {}, preStep = {}, postStep = {}, onDraw = {}, onHUDDraw = {}, preHUDDraw = {}, onPlayerHUDDraw = {}, onStageEntry = {}, onPlayerStep = {}, postPlayerStep = {}, onPlayerDraw = {}, onPlayerDrawBelow = {}, onPlayerDrawAbove = {}, onFire = {}, onFireSetProcs = {}, onHit = {}, preHit = {}, onImpact = {}, onNPCDeath = {}, onNPCDeathProc = {}, onDamage = {}, onActorStep = {}}

tcallback = {}
tcallback.register = function(name, func)
	--log(name, func)
	tcallbacks[name][func] = true
end
tcallback.unregister = function(name, func)
	tcallbacks[name][func] = nil
end

callback.register("onGameEnd", function()
	for callbackName, c in pairs(tcallbacks) do
		for e, _ in pairs(c) do
			tcallbacks[callbackName][e] = nil
		end
	end
	collectgarbage("collect")
end)
callback.register("onGameStart", function() --fallback in case onGameEnd doesn't trigger
	for callbackName, c in pairs(tcallbacks) do
		for e, _ in pairs(c) do
			tcallbacks[callbackName][e] = nil
		end
	end
end)

call = {onStep = {}, postStep = {}, onDraw = {}, onHUDDraw = {}, preHUDDraw = {}, onStageEntry = {}, onPlayerStep = {}, onPlayerDraw = {}, onFire = {}, onFireSetProcs = {}, onHit = {}, preHit = {}, onImpact = {}, onNPCDeath = {}, onNPCDeathProc = {}}
callback.register("postLoad", function()
	for callbackName, element in pairs(call) do
		callback.register(callbackName, function(a1, a2, a3, a4)
			for _, callb in pairs(element) do
				callb(a1, a2, a3, a4)
			end
		end)
	end
	for callbackName, element in pairs(tcallbacks) do
		callback.register(callbackName, function(a1, a2, a3, a4, a5)
			for callb, _ in pairs(element) do
				--print(callb)
				callb(a1, a2, a3, a4, a5)
			end
		end)
	end
end)

-- Resources

ar = setmetatable({}, { __index = function(t, k)
	return Artifact.find(k)
end})

buff = setmetatable({}, { __index = function(t, k)
	return Buff.find(k)
end})

obj = setmetatable({}, { __index = function(t, k)
	return Object.find(k)
end})

it = {}
for _, item in ipairs(Item.findAll("Vanilla")) do
	it[item:getName():gsub(" ", ""):gsub("'", "")] = item
end

itp = setmetatable({}, { __index = function(t, k)
	return ItemPool.find(k)
end})

pobj = setmetatable({}, { __index = function(t, k)
	return ParentObject.find(k)
end})

par = setmetatable({}, { __index = function(t, k)
	return ParticleType.find(k)
end})

sfx = setmetatable({}, { __index = function(t, k)
	local sound = Sound.find(k)
	return sound:getRemap() or sound
end})

spr = setmetatable({}, { __index = function(t, k)
	return Sprite.find(k)
end})

stg = {}
for _, stage in ipairs(Stage.findAll("Vanilla")) do
	stg[stage:getName():gsub(" ", "")] = stage
end

sur = {}
for _, survivor in ipairs(Survivor.findAll("Vanilla")) do
	sur[survivor:getName():gsub("-", "")] = survivor
end

dif = setmetatable({}, { __index = function(t, k)
	return Difficulty.find(k)
end})

elt = setmetatable({}, { __index = function(t, k)
	return EliteType.find(k)
end})

int = {}
for _, interactable in ipairs(Interactable.findAll("Vanilla")) do
	int[interactable:getName():gsub("-", "")] = interactable
end

mcard = {}
for _, monsterCard in ipairs(MonsterCard.findAll("Vanilla")) do
	mcard[monsterCard:getName():gsub("-", "")] = monsterCard
end

mlog = {}
for _, monsterLog in ipairs(MonsterLog.findAll("Vanilla")) do
	mlog[monsterLog:getName():gsub("-", "")] = monsterLog
end

rm = {}
for _, room in ipairs(Room.findAll("Vanilla")) do
	rm[room:getName():gsub("-", "")] = room
end

-- GLOBAL
global = {}
global.quality = misc.getOption("video.quality")
global.showDamage = misc.getOption("video.show_damage")
global.scale = misc.getOption("video.scale")
global.lastVersion = save.read("lastRanVersion")
global.version = modloader.getModVersion("Starstorm")
global.timer = 0

global.rormlflag = {}
for _, i in ipairs(modloader.getFlags()) do
	global.rormlflag[i] = true
end

local versionNoDash = global.version
local dash = global.version:find("-")
if dash then
	versionNoDash = global.version:sub(0, dash - 1)
end
versionNoDash = (versionNoDash:gsub("%.", "")) + 0 -- pfft.
global.version = versionNoDash
save.write("lastRanVersion", versionNoDash)

global.currentStageHeight = 0
table.insert(call.onStageEntry, function()
	local _, h = Stage.getDimensions()
	global.currentStageHeight = h
end)

callback.register("globalStep", function()
	global.timer = global.timer + 1
end)

global.itemAchievements = {}

callback.register("postLoad", function()
	local items = Item.findAll()
	for _, achievement in ipairs(Achievement.findAll()) do
		for _, item in ipairs(items) do
			if achievement.sprite == item.sprite then
				global.itemAchievements[item] = achievement
				break
			end
		end
	end
end)


runData = {}

getRunData = function()
	return runData
end
export("getRunData")

callback.register("onGameStart", function()
	runData = {}
end)

callback.register("globalStep", function()
	global.quality = misc.getOption("video.quality")
	global.showDamage = misc.getOption("video.show_damage")
	global.scale = misc.getOption("video.scale")
end)

namespaces = {"vanilla"}
for k, v in pairs(modloader.getMods()) do namespaces[k + 1] = v end

-- EXTENDED CALLBACKS
local postPlayerStep = callback.create("postPlayerStep")
local onActorStep = callback.create("onActorStep")
local postStageEntry = callback.create("postStageEntry")
local onTrueActorInit = callback.create("onTrueActorInit") -- Looking at you, Saturnyoshi
onSSInteractableAction = callback.create("onSSInteractableAction")
skinInitCallback = callback.create("onSkinInit")
postSelectInitCallback = callback.create("postSelection")
extraDifficultyUpdateCallback = callback.create("onExtraDifficultyUpdate")
onStrangerTradeCallback = callback.create("onStrangerTrade")
onGameBeatCallback = callback.create("onGameBeat")
onProvidenceDefeatCallback = callback.create("onProvidenceDefeat")
global.inGame = true -- now rorml has an alternative for this but uhhhh

callback.register("onGameStart", function()
	global.inGame = true
end)
callback.register("onGameEnd", function()
	global.inGame = false
end)
table.insert(call.onStageEntry, function()
	runData.entered = true
end)
table.insert(call.postStep, function()
	for _, player in ipairs(misc.players) do
		if player:isValid() then
			postPlayerStep(player)
		end
	end
	for _, actor in ipairs(pobj.actors:findAll()) do
		if not actor:getData()._initCallback then
			if actor:getObject() ~= obj.Slime or actor:get("size_s") == 1 then
				onTrueActorInit(actor)
			end
			actor:getData()._initCallback = true
		end
	end
end)
obj.Worm:addCallback("create", function(actor)
	onTrueActorInit(actor) -- odd exception...?
end)
table.insert(call.onStep, function()
	if runData.entered then
		runData.entered = nil
		postStageEntry(Stage.getCurrentStage())
	end
	for _, actor in ipairs(pobj.actors:findAll()) do
		if actor:isValid() then
			onActorStep(actor)
		end
	end
end)