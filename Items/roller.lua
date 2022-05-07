local path = "Items/Resources/"

it.Roller = Item.new("Roller")
local sRoller = Sound.load("RollerUse", path.."roller")
it.Roller.pickupText = "Flatten your enemies, immobilizing them temporarily." 
it.Roller.sprite = Sprite.load("Roller", path.."Roller.png", 2, 15, 15)
it.Roller.isUseItem = true
it.Roller.useCooldown = 40
it.Roller:setTier("use")
itp.enigma:add(it.Roller)
it.Roller:setLog{
	group = "use_locked",
	description = "Launch a flattening roller, &y&immobilizing enemies on contact for 6 seconds&!&.",
	story = "Pretty old school, but pretty useful! It's been a while since I last used this, so make sure it's all correct.\nIt's not like it can be broken anyways..",
	destination = "377.14.33,\nStrongstone,\nNeptune",
	date = "10/5/2056"
}
local buffBury = Buff.new("bury")
buffBury.sprite = Sprite.load("BuryBuff", path.."RollerBuff", 1, 9, 9)
buffBury:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	actor:set("activity", 52)
	actor:getData()._preDepth = actor.depth
	
	local image = actor.mask or actor.sprite
	local h = image.height * 0.5
	
	actor:getData()._overrideY = actor.y + h
	actor.y = actor.y + h
	actor.depth = 13
end)
buffBury:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	actor:setAlarm(7, 100)
	actor:set("activity", 52)
	if actor:getAnimation("idle") then
		actor.sprite = actor:getAnimation("idle")
	end
	actor.y = actor:getData()._overrideY
end)
buffBury:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	actor:set("activity", 0)
	actor:set("activity_type", 0)
	actor.depth = actor:getData()._preDepth
	actor:getData()._preDepth = nil
	
	local image = actor.mask or actor.sprite
	local h = image.height * 0.5
	
	actor.y = actor.y - h
end)

objRoller = Object.new("Roller")
objRoller.sprite = Sprite.load("RollerDisplay", path.."RollerDis.png", 1, 7, 7)
local sprMask = Sprite.load("RollerDisplayMask", path.."RollerDisMask.png", 1, 5, 5)
objRoller:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 300
	selfData.yspeed = 0
	selfData.dt = 0
	selfData.team = "player"
	self.mask = sprMask
end)
objRoller:addCallback("step", function(self)
	local selfData = self:getData()
	local nextPosX = self.x + 2 * self.xscale
	if selfData.life > 0 then
		if self:collidesMap(nextPosX, self.y) then
			if selfData.dt == 3 then
				selfData.life = 0
			else
				selfData.dt = selfData.dt+ 1
			end
		end
		local r = 15
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") ~= selfData.team and actor:isClassic() and not actor:isBoss() and not actor:hasBuff(buffBury) then
				actor:applyBuff(buffBury, 360)
				par.Rubble:burst("middle", actor.x, actor.y, 1 * global.quality)
				sRoller:play(0.9 + math.random() * 0.2)
			end
		end
		selfData.life = selfData.life - 1
		self.x = nextPosX
		
		self.angle = self.angle + 15 * self.xscale * -1
		
		if self:collidesMap(self.x, self.y + 1) then
			selfData.yspeed = 0
			if self:collidesMap(self.x, self.y) then
				self.y = self.y - 1
			end
		else
			selfData.yspeed = selfData.yspeed + 0.1
			self.y = self.y + selfData.yspeed
		end
	else
		self:destroy()
	end
end)
objRoller:addCallback("destroy", function(self)
	par.Rubble:burst("middle", self.x, self.y, 3 * global.quality)
end)

it.Roller:addCallback("use", function(player, embryo)
	local roller = objRoller:create(player.x, player.y - 4)
	roller.xscale = player.xscale
	roller:getData().team = player:get("team")
	if embryo then
		local roller = objRoller:create(player.x, player.y)
		roller.xscale = player.xscale * -1
		roller:getData().team = player:get("team")
	end	
end)