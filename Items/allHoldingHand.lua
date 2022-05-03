local path = "Items/Resources/"

it.AllHoldingHand = Item.new("All-Holding Hand")
--local sAllHoldingHand = Sound.load("AllHoldingHand", path.."AllHoldingHand")
it.AllHoldingHand.pickupText = "It assists me." 
it.AllHoldingHand.sprite = Sprite.load("AllHoldingHand", path.."All-Holding Hand.png", 1, 14, 12)
itp.sibylline:add(it.AllHoldingHand)
it.AllHoldingHand.color = Color.fromHex(0xFFCCED)
it.AllHoldingHand:setLog{
	group = "end",
	description = "&y&Activate a random superbuff&!& on Teleporter charge,",
	story = "It arises, a vision. Or a delusion. An unlikely reflection of my own inabilities.",
	priority = "&"..it.AllHoldingHand.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
if obj.NemesisLoader then
	NPC.registerBossDrops(obj.NemesisLoader, 100)
	NPC.addBossItem(obj.NemesisLoader, it.AllHoldingHand)
end

local sprHand = Sprite.load("AllHoldingHandEf", path.."AllHoldingHandEf.png", 10, 25, 25)
local sprEf = Sprite.load("AllHoldingHandEf2", path.."AllHoldingHandEf2.png", 5, 20, 20)

local damageBuff = Buff.new("superDamage")
damageBuff.sprite = spr.Buffs
damageBuff.subimage = 4
damageBuff:addCallback("start", function(actor)
	actor:getData()._superDamageDif = actor:get("damage")
	actor:set("damage",  actor:get("damage") + actor:getData()._superDamageDif)
end)
damageBuff:addCallback("end", function(actor)
	actor:set("damage",  actor:get("damage") - actor:getData()._superDamageDif)
	actor:getData()._superDamageDif = nil
end)

local goldBuff = Buff.new("superGold")
goldBuff.sprite = spr.Buffs
goldBuff.subimage = 39
goldBuff:addCallback("start", function(actor)
	if actor:get("exp_worth") then
		actor:set("exp_worth",  actor:get("exp_worth") + 20)
	end
end)
goldBuff:addCallback("step", function(actor)
	if actor:get("hp") then
		if actor:getData().lastHp then
			if actor:get("hp") < actor:getData().lastHp then
				obj.EfGold:create(actor.x, actor.y)
			end
		end
		actor:getData().lastHp = actor:get("hp")
	end
end)
goldBuff:addCallback("end", function(actor)
	if actor:get("exp_worth") then
		actor:set("exp_worth",  actor:get("exp_worth") - 20)
	end
end)

local healBuff = Buff.new("healBuff")
healBuff.sprite = spr.Buffs
healBuff.subimage = 7
healBuff:addCallback("start", function(actor)
	if actor:get("hp_regen") then
		actor:set("hp_regen",  actor:get("hp_regen") + 0.7)
	end
end)
healBuff:addCallback("end", function(actor)
	if actor:get("hp_regen") then
		actor:set("hp_regen",  actor:get("hp_regen") - 0.7)
	end
end)

local shieldBuff = Buff.new("shieldBuff")
shieldBuff.sprite = spr.Buffs
shieldBuff.subimage = 31
shieldBuff:addCallback("start", function(actor)
	if actor:get("maxshield") then
		actor:getData()._superShieldDif = actor:get("maxhp") * 2
		actor:set("maxshield",  actor:get("maxshield") + actor:getData()._superShieldDif)
	end
end)
shieldBuff:addCallback("end", function(actor)
	if actor:get("maxshield") then
		actor:set("maxshield",  actor:get("maxshield") - actor:getData()._superShieldDif)
		actor:getData()._superShieldDif = nil
	end
end)

local cooldownBuff = Buff.new("cooldownBuff")
cooldownBuff.sprite = spr.Buffs
cooldownBuff.subimage = 45
cooldownBuff:addCallback("step", function(actor)
	actor:setAlarm(2, math.min(actor:getAlarm(2), 10))
	actor:setAlarm(3, math.min(actor:getAlarm(3), 30))
	actor:setAlarm(4, math.min(actor:getAlarm(4), 30))
	actor:setAlarm(5, math.min(actor:getAlarm(5), 1.5 * 60))
end)


local effects = {
	{
		color = Color.RED,
		subimage = 1,
		players = true,
		buff = damageBuff
	},
	{
		color = Color.YELLOW,
		subimage = 2,
		players = false,
		buff = goldBuff
	},
	{
		color = Color.GREEN,
		subimage = 3,
		players = true,
		buff = healBuff
	},
	{
		color = Color.fromHex(0x00FFA1),
		subimage = 4,
		players = true,
		buff = shieldBuff
	},
	{
		color = Color.WHITE,
		subimage = 5,
		players = true,
		buff = cooldownBuff
	}
}

local objBuffCircle = Object.new("BuffCircle")
objBuffCircle.sprite = sprEf
objBuffCircle.depth = -9
objBuffCircle:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 60 * 60
	selfData.notActivated = true
	self.alpha = 0
	self.spriteSpeed = 0
	selfData.team = "player"
	 selfData.range = 400
	 selfData.effect = effects[1]
end)
objBuffCircle:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		self.alpha = math.approach(self.alpha, math.min(selfData.life * 0.1, 1), 0.1)
		local r = selfData.range
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if selfData.effect.players and actor:get("team") == selfData.team or not selfData.effect.players and actor:get("team") ~= selfData.team then
				if not isaDrone(actor) then
					actor:applyBuff(selfData.effect.buff, 5)
				end
			end
		end
		selfData.life = selfData.life - 1
	else
		self:destroy()
	end
end)
objBuffCircle:addCallback("draw", function(self)
	local selfData = self:getData()
	local sine = math.sin(selfData.life * 0.1) * 2
	graphics.alpha(self.alpha)
	graphics.color(selfData.effect.color)
	graphics.circle(self.x, self.y, selfData.range + sine, true)
end)

local circleFunc = setFunc(function(buffCircle, effIndex, team)
	local effect = effects[effIndex]
	buffCircle:getData().effect = effect
	buffCircle:getData().team = team
	buffCircle.subimage = effect.subimage
	buffCircle.blendColor = effect.color
end)

local objHHand = Object.new("HHand")
objHHand.sprite = sprHand
objHHand.depth = -2
objHHand:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 140
	selfData.notActivated = true
	selfData.team = "player"
end)
objHHand:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		if selfData.life > 60 then
			if selfData.life > 5 then
				if self.subimage < self.sprite.frames then
					self.spriteSpeed = 0.15
				else
					if selfData.notActivated then
						selfData.notActivated = nil
						
						local effectIndex = math.random(1, #effects)
						local effect = effects[effectIndex]
						
						local circle = obj.EfCircle:create(self.x, self.y)
						circle:set("radius", 350)
						circle:set("rate", 5)
						circle.blendColor = effect.color
						createSynced(objBuffCircle, self.x + 3, self.y - 16 - 18, circleFunc, effectIndex, selfData.team)
					end
					self.spriteSpeed = 0
				end
			end
		else
			if self.subimage > 1.9 then
				self.spriteSpeed = -0.15
			else
				self.spriteSpeed = 0
			end
		end
		self.alpha = selfData.life * 0.2
	else
		self:destroy()
	end
end)
local onStepCall = function()
	for _, tele in ipairs(obj.Teleporter:findMatching("active", 1)) do
		if not tele:getData().handCheck then
			tele:getData().handCheck = true
			for i, player in ipairs(misc.players) do
				if player:countItem(it.AllHoldingHand) > 0 then
					local xx = (i - 1) * 50 - ((50 / 2) * (#misc.players - 1))
					local hand = objHHand:create(tele.x + xx, tele.y - 80)
					hand:getData().team = player:get("team")
				end
			end
		end
	end
end
callback.register("onItemPickup", function(item, player)
	if item:getItem() == it.AllHoldingHand then
		tcallback.register("onStep", onStepCall)
	end
end)