local path = "Items/Resources/"

it.ThrivingGrowth = Item.new("Thriving Growth")
it.ThrivingGrowth.pickupText = "The cycle continues." 
it.ThrivingGrowth.sprite = Sprite.load("ThrivingGrowth", path.."Thriving Growth.png", 1, 15, 15)
local sprFlower = Sprite.load("ThrivingGrowthFlower", path.."thrivingGrowthdis.png", 7, 7, 17)
itp.sibylline:add(it.ThrivingGrowth)
it.ThrivingGrowth.color = Color.fromHex(0xFFCCED)
it.ThrivingGrowth:setLog{
	group = "end",
	description = "Nearby enemy deaths sprout flowers which &g&heal &!&and &y&buff you temporarily.",
	story = "In given time, the cycle continues, giving to receive, losing to find, dying to live.",
	priority = "&"..it.ThrivingGrowth.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
if obj.NemesisJanitor then
	NPC.registerBossDrops(obj.NemesisJanitor, 100)
	NPC.addBossItem(obj.NemesisJanitor, it.ThrivingGrowth)
end

local buffFlower = Buff.new("flower")
buffFlower.subimage = 62
buffFlower:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.2)
	actor:set("attack_speed", actor:get("attack_speed") + 1)
end)
buffFlower:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.2)
	actor:set("attack_speed", actor:get("attack_speed") - 1)
end)

local objFlower = Object.new("ThrivingFlower")
objFlower.sprite = sprFlower

objFlower:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0
	
	selfData.team = "player"
	selfData.subimage = 1
	selfData.subimageTarget = self.sprite.frames
	selfData.life = 600
	selfData.range = 40
	self.xscale = table.irandom({1, -1})
	
	for i = 0, 100 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i
			break
		end
	end
end)
objFlower:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		
		if selfData.life == 30 then
			selfData.subimageTarget = 1
		end
		
		local r = selfData.range
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") == selfData.team and not isaDrone(actor) then
				actor:applyBuff(buffFlower, 100)
				if global.timer % 80 == 0 then
					local healVal = actor:get("maxhp") * 0.02
					if global.showDamage then
						misc.damage(healVal, actor.x, actor.y - 10, false, Color.DAMAGE_HEAL)
					end
					actor:set("hp", actor:get("hp") + healVal)
					if global.quality > 1 and math.chance(10) then
						par.Heal:burst("middle", actor.x, actor.y, 1)
					end
				end
			end
		end
		
		selfData.subimage = math.approach(selfData.subimage, selfData.subimageTarget, 0.2)
		
		self.subimage = selfData.subimage
	else
		self:destroy()
	end
end)

local onNPCDeathProcCall = function(actor, player)
	local count = player:countItem(it.ThrivingGrowth)
	if count > 0 then
		if player.x < actor.x + 200 and player.x > actor.x - 200 and
		player.y < actor.y + 200 and player.y > actor.y - 200 then
			objFlower:create(actor.x, actor.y)
		end
	end
end
it.ThrivingGrowth:addCallback("pickup", function(player)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)