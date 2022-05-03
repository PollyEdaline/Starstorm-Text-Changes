local path = "Items/Resources/"

it.ToxicTail = Item.new("Toxic Tail")
it.ToxicTail.pickupText = "Obtain two friendly boars." 
it.ToxicTail.sprite = Sprite.load("Toxic Tail", path.."Toxic Tail.png", 1, 15, 15)
itp.legendary:add(it.ToxicTail)
it.ToxicTail.color = "y"
it.ToxicTail:setLog{
	group = "boss",
	description = "Obtain two &y&friendly boars.",
	story = "Wiggle wiggle.",
	priority = "&b&Field-Found&!&",
	destination = "My room,\nHome,\nEarth",
	date = "Unknown"
}
NPC.addBossItem(obj.Boar, it.ToxicTail)
local sprTTBoarIdle = Sprite.load("TTBoarIdle", "Actors/Item Boarlit/idle.png", 1, 9, 6)
local TTBoarSprites = {
	idle = sprTTBoarIdle,
	jump = sprTTBoarIdle,
	walk = Sprite.load("TTBoarWalk", "Actors/Item Boarlit/walk.png", 4, 9, 6),
	death = Sprite.load("TTBoarDeath", "Actors/Item Boarlit/death.png", 7, 13, 8)
}
local toxicTailFunc = setFunc(function(actor, player)
	local pData = player:getData()
	local pAc = player:getAccessor()
	local aAc = actor:getAccessor()
	if not pData.toxicTailChildren then
		pData.toxicTailChildren = {}
	end
	table.insert(pData.toxicTailChildren, actor)
	aAc.team = pAc.team
	aAc.persistent = 1
	aAc.toxicTail = 1
	aAc.maxhp = pAc.maxhp * 0.2
	aAc.hp = aAc.maxhp
	aAc.damage = pAc.damage * 0.8
	aAc.hp_regen = pAc.hp_regen
	aAc.exp_worth = 0
	actor:getData().ttparent = player
	actor:getData()._ttzcd = 0
	actor:getData()._tttpcd = 0
	aAc.prefix_type = 0
	aAc.elite_type = -1
	actor:setAnimations(TTBoarSprites)
	obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.08).alpha = 0.75
	if onScreen(actor) then
		sfx.BoarMDeath:play(1.2, 0.5)
	end
	local i = 0
	while actor:collidesMap(actor.x, actor.y) and i < 20 do
		actor.y = actor.y - 2
		i = i + 1
	end
end)
local onStepCall = function()
	for _, actor in ipairs(obj.BoarM:findMatching("toxicTail", 1)) do
		local data = actor:getData()
		local ac = actor:getAccessor()
		
		local parent = data.ttparent
		if parent and parent:isValid() then
			if ac.target == parent.id then
				ac.target = -4
			end
			if parent.x > actor.x + 150 then
				ac.moveRight = 1
				ac.moveLeft = 0
				if actor:collidesMap(actor.x + 1, actor.y) then
					ac.moveUp = 1
				end
			elseif parent.x < actor.x - 150 then
				ac.moveRight = 0
				ac.moveLeft = 1
				if actor:collidesMap(actor.x - 1, actor.y) then
					ac.moveUp = 1
				end
			end
			if distance(actor.x, actor.y, parent.x, parent.y) > 280 then
				if data._tttpcd > 140 then
					actor.x = parent.x
					actor.y = parent.y
					
					obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.08).alpha = 0.75
					
					local i = 0
					while actor:collidesMap(actor.x, actor.y) and i < 20 do
						actor.y = actor.y - 2
						i = i + 1
					end
					
					actor:set("ghost_x", actor.x)
					actor:set("ghost_y", actor.y)
					data._tttpcd = 0
				else
					data._tttpcd = data._tttpcd + 1
				end
			end
		end
		
		local tInst = Object.findInstance(ac.target)
		
		if tInst and tInst:isValid() then
			if distance(actor.x, actor.y, tInst.x, tInst.y) < 150 then
				if data._ttzcd == 0 and actor:collidesWith(tInst, actor.x, actor.y) then
					data._ttzcd = 40
					actor:fireBullet(tInst.x - 2, actor.y, 0, 4, 1, spr.Sparks2)
					
				elseif data._ttzcd > 0 then
					data._ttzcd = data._ttzcd - 1
				end
			else
				ac.target = -4
			end
		else
			local newTarget = nearestMatchingOp(actor, pobj.actors, "team", "~=", ac.team)
			if newTarget then newTarget = newTarget.id end
			ac.target = newTarget or -4
		end
		
		local tpr = false
		for _, tp in ipairs(obj.Teleporter:findMatchingOp("active", ">", 1)) do
			tpr = true
			break
		end
		if tpr then
			ac.ghost = 1
		elseif ac.ghost == 1 then
			ac.ghost = 0
		end
	end
end

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	
	local ttc = playerData.toxicTailChildren
	if ttc then
		for i, inst in pairs(ttc) do
			if not inst:isValid() then
				table.remove(ttc, i)
			end
		end
	end
	
	local toxicTail = player:countItem(it.ToxicTail)
	if toxicTail > 0 then
		if not playerData.toxicTailcd then
			playerData.toxicTailcd = 40
		end
		if playerData.toxicTailcd > 0 then
			playerData.toxicTailcd = playerData.toxicTailcd - 1
		else
			if not playerData.toxicTailChildren or #playerData.toxicTailChildren < toxicTail * 2 then
				createSynced(obj.BoarM, player.x, player.y - 1, toxicTailFunc, player)
			end
			playerData.toxicTailcd = 300
		end
	end
end

it.ToxicTail:addCallback("pickup", function(player)
	tcallback.register("onStep", onStepCall)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)