local path = "Items/Resources/"

it.GreaterWarbanner = Item.new("Greater Warbanner")
it.GreaterWarbanner.pickupText = "Place a warbanner for great buffs." 
it.GreaterWarbanner.sprite = Sprite.load("GreaterWarbanner", path.."Greater Warbanner.png", 2, 15, 16)
it.GreaterWarbanner.isUseItem = true
it.GreaterWarbanner.useCooldown = 80
it.GreaterWarbanner:setTier("use")
itp.enigma:add(it.GreaterWarbanner)
it.GreaterWarbanner:setLog{
	group = "use",
	description = "Place a warbanner which &y&increases Critical Strike chance&!& and &g&health&!&, and &b&decreases skill cooldowns&!&.",
	story = "Strength my children, strength! We are closer to the armageddon. We must fight, or else we will succumb. This is a gift from the elders, to aid you in your future confrontations.",
	destination = "L2,\nNorthern Outpost,\nEarth",
	date = "03/01/2056"
}

local sprGreaterWarbanner = Sprite.load("GreaterWarbannerDis", path.."greaterWarbannerdis.png", 5, 9, 28)

local buffWarbannerG = Buff.new("warbannerG")
buffWarbannerG.sprite = spr.Buffs
buffWarbannerG.subimage = 58
buffWarbannerG:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base  = actorAc.maxhp_base + 100
	else
		actorAc.maxhp = actorAc.maxhp + 100
	end
	actorAc.pHmax = actorAc.pHmax + 0.6
	if actorAc.critical_chance then
		actorAc.critical_chance = actorAc.critical_chance + 20
	end
end)
buffWarbannerG:addCallback("step", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		
		actor:setAlarm(3, math.max(actor:getAlarm(3) - 1, -1))
		actor:setAlarm(4, math.max(actor:getAlarm(4) - 1, -1))
		actor:setAlarm(5, math.max(actor:getAlarm(5) - 1, -1))
	end
end)
buffWarbannerG:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base  = actorAc.maxhp_base - 100
	else
		actorAc.maxhp = actorAc.maxhp - 100
	end
	actorAc.pHmax = actorAc.pHmax - 0.6
	actorAc.critical_chance = actorAc.critical_chance - 20
end)

local objWarbannerG = Object.new("WarbannerG")
objWarbannerG.sprite = sprGreaterWarbanner
objWarbannerG.depth = 9

local range = 200

objWarbannerG:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	self.subimage = 1
	
	local n = 0
	while not self:collidesMap(self.x, self.y + 1) and n < 200 do
		self.y = self.y + 2
		n = n + 1
	end
	if n == 200 then
		self:destroy()
	end
end)
objWarbannerG:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.team then
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
			if actor:get("team") == selfData.team and not isaDrone(actor) then
				actor:applyBuff(buffWarbannerG, 60)
			end
		end
	end
	if self.subimage >= 5 then
		self.spriteSpeed = 0
		self.subimage = 5
	end
end)
objWarbannerG:addCallback("draw", function(self)
	graphics.color(Color.fromHex(0xEF8340))
	local sine = math.sin(global.timer * 0.08) * 0.2
	graphics.alpha(0.6 + sine)
	graphics.circle(self.x, self.y, range, true)
end)

it.GreaterWarbanner:addCallback("use", function(player, embryo)
	--sGreaterWarbanner:play()
	
	local o = objWarbannerG:create(player.x, player.y)
	o:getData().team = player:get("team")
end)