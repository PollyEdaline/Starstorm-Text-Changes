local path = "Items/Resources/"

it.WhiteFlag = Item.new("White Flag")
local sWhiteFlag = Sound.load("WhiteFlag", path.."whiteFlag")
it.WhiteFlag.pickupText = "Place a white flag. Everyone around it is unable to attack." 
it.WhiteFlag.sprite = Sprite.load("WhiteFlag", path.."White Flag.png", 2, 15, 14)
it.WhiteFlag.isUseItem = true
it.WhiteFlag.useCooldown = 45
it.WhiteFlag:setTier("use")
it.WhiteFlag:setLog{
	group = "use_locked",
	description = "Place a white flag. &b&Everyone around it is unable to attack for 8 seconds&!&.",
	story = [[Save this for me until I get back home, I didn't need it. In fact, we became friends! I can't wait to tell you all about it soon. It's been a long trip and an unexpected series of events. I've told them about you and they want me to invite you over the next time. How's that, huh!? Love you.]],
	destination = "Room 2B,\nSomnus Hotel,\nEarth",
	date = "10/5/2056"
}
local buffPeace = Buff.new("peace")
buffPeace.sprite = Sprite.load("PeaceBuff", path.."PeaceBuff.png", 1, 9, 9)
buffPeace:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	actor:getData()._preTeam = actorAc.team
	actorAc.team = "enemy"
	if actorAc.target then
		actorAc.target = -4
	end
end)
buffPeace:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	if not isa(actor, "PlayerInstance") then
		actor:setAlarm(6, 100)
	end
	actor:setAlarm(2, math.max(2, actor:getAlarm(2)))
	actor:setAlarm(3, math.max(2, actor:getAlarm(3)))
	actor:setAlarm(4, math.max(2, actor:getAlarm(4)))
	actor:setAlarm(5, math.max(2, actor:getAlarm(5)))
end)
buffPeace:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	actorAc.team = actor:getData()._preTeam
	actor:getData()._preTeam = nil
	actorAc.target = -4
end)


local postStepCall = function()
	for _, actor in ipairs(pobj.actors:findAll()) do
		if actor:hasBuff(buffPeace) and actor:get("target") and actor:getData()._preTeam then
			actor:set("target", 0)
			actor:set("state", "idle")
		end
	end
end

local objWhiteFlag = Object.new("WhiteFlag")
objWhiteFlag.sprite = Sprite.load("WhiteFlagDis", path.."whiteFlagdis.png", 5, 7, 28)
objWhiteFlag:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 480
	selfData.range = 200
	self.spriteSpeed = 0.2
	
	for i = 1, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1
			break
		end
	end
	tcallback.register("postStep", postStepCall)
end)
objWhiteFlag:addCallback("step", function(self)
	local selfData = self:getData()
	
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
		self.subimage = self.sprite.frames
	end
	
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		local r = selfData.range
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if not isaDrone(actor) then
				actor:applyBuff(buffPeace, 10)
			end
		end
	else
		tcallback.unregister("postStep", postStepCall)
		self:destroy()
	end
end)
objWhiteFlag:addCallback("draw", function(self)
	local selfData = self:getData()
	
	local alpha = 0.4 + math.cos(global.timer * 0.02) * 0.2 
	
	graphics.color(Color.WHITE)
	graphics.alpha(alpha)
	graphics.circle(self.x, self.y, selfData.range, true)
end)

local sprSkillLock = Sprite.load("PeaceLock", path.."peaceLock.png", 1, 0, 0)

local onPlayerHUDDrawCall = function(player, x, y)
	if player:hasBuff(buffPeace) then 
		for i = 0, 3 do
			graphics.drawImage{
				image = sprSkillLock,
				y = y,
				x = x + (18 + 5) * i
			}
		end
	end
end

it.WhiteFlag:addCallback("use", function(player, embryo)
	tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
	local flag = objWhiteFlag:create(player.x, player.y)
	if embryo then
		flag:getData().life = 960
	end
	sWhiteFlag:play()
end)