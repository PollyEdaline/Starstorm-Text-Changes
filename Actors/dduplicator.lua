-- Duplicator Drone

local path = "Actors/Duplicator Drone/"

local resources = {
	sprites = {
		item = Sprite.load("DupDroneItem", path.."Object", 1, 11, 20),
		idle = Sprite.load("DupDroneIdle", path.."Idle", 4, 7, 10),
		idle_cd = Sprite.load("DupDroneIdleCooldown", path.."Idle_cd", 4, 7, 10),
		shoot = Sprite.load("DupDroneShoot", path.."Shoot", 25, 11, 13),
		idle_broken = Sprite.load("DupDroneIdleBroken", path.."Idle_broken", 4, 7, 10),
		idle_broken_cd = Sprite.load("DupDroneIdleBrokenCooldown", path.."Idle_broken_cd", 4, 7, 10)
	},
	sounds = {
		shoot = Sound.load("DupDroneShoot", path.."shoot")
	}
}

obj.DupDroneItem = Object.base("DroneItem", "Duplicator Drone Item")
obj.DupDroneItem.sprite = resources.sprites.item

obj.DupDrone = Object.base("Drone", "Duplicator Drone")
obj.DupDrone.sprite = resources.sprites.idle

int.DupDrone = Interactable.new(obj.DupDroneItem, "Duplicator Drone")
int.DupDrone.spawnCost = 195 --165

local efColor = Color.fromHex(0xF4F3B7)

obj.DupDroneItem:addCallback("create", function(self)
	self:set("child", obj.DupDrone.id)
	self:set("cost", math.ceil(180 * Difficulty.getScaling()))
	self:set("name", "duplicator drone")
end)
obj.DupDrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.cooldown = 0
	selfData.anim = 0
	self:set("child", obj.DupDroneItem.id)
	self:set("range", 80)
	self:set("x_range", 0)
	self:set("y_range", 0)
	self:set("persistent", 1)
	self:setAnimation("idle", resources.sprites.idle)
	self:setAnimation("idle_broken", resources.sprites.idle_broken)
end)
local bannedItems = {
	[it.Keycard] = true,
	[it.VoidKey] = true
}
callback.register("postLoad", function()
	if itp.relic then
		for _, item in ipairs(itp.relic:toList()) do
			bannedItems[item] = true
		end
	end
	if itp.sibylline then
		for _, item in ipairs(itp.sibylline:toList()) do
			bannedItems[item] = true
		end
	end
	if itp.curse then
		for _, item in ipairs(itp.curse:toList()) do
			bannedItems[item] = true
		end
	end
	bannedItems[it.PeculiarRock] = true
end)
local cooldowns = {
	["w"] = 4700,
	["g"] = 5900,
	["r"] = 7000
}
obj.DupDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local nearItem
	local range = self:get("range")
	if selfData.cooldown <= 0 and self:get("hp") > self:get("maxhp") * 0.5 then
		nearItem = pobj.items:findEllipse(self.x - range, self.y - range, self.x + range, self.y + range)
		if nearItem and nearItem:isValid() then
			if nearItem:getData()._duplicating or nearItem:get("is_use") == 1 or bannedItems[Item.fromObject(nearItem:getObject())] then
				nearItem = nil
			end
		end
		if nearItem and nearItem:isValid() then
			selfData.target = nearItem
			selfData.cooldown = cooldowns[nearItem:getItem().color] or 5300
			selfData.anim = 80
			nearItem:getData()._duplicating = true
			nearItem:set("pGravity", 0)
			self.subimage = 1
			resources.sounds.shoot:play(1.2)
		end
		self:setAnimation("idle_broken", resources.sprites.idle_broken)
		self:setAnimation("idle", resources.sprites.idle)
	else
		self:setAnimation("idle_broken", resources.sprites.idle_broken_cd)
		self:setAnimation("idle", resources.sprites.idle_cd)
		selfData.cooldown = selfData.cooldown - 1
	end
	if selfData.anim > 0 then
		selfData.anim = selfData.anim - 1
		if selfData.target and selfData.target:isValid() then
			if selfData.target.x > self.x then
				self.xscale = 1
			else
				self.xscale = -1
			end
			if selfData.anim == 10 then
				if net.host then 
					local obj = selfData.target:getObject()
					obj:create(self.x + 2, self.y)
				end
				selfData.target:set("pGravity", 1)
				selfData.target:getData()["hackedby"..self.id] = true
				selfData.target:getData()._duplicating = nil
			end
			local difx = self.x - selfData.target.x
			selfData.target.x = math.approach(selfData.target.x, self.x, difx * 0.1)
			local dify = self.y - selfData.target.y
			selfData.target.y = math.approach(selfData.target.y, self.y, dify * 0.1)
			--self:setAnimation("idle_broken", resources.sprites.shoot_broken)
			self:setAnimation("idle", resources.sprites.shoot)
		else
			selfData.anim = 0
		end
	end
end)

table.insert(call.onDraw, function()
	for _, drone in ipairs(obj.DupDrone:findAll()) do
		local droneData = drone:getData()
		if droneData.anim > 0 and droneData.target and droneData.target:isValid() then
			local random = math.random(-20, 20) / 100
			local top = droneData.target.y - droneData.target.sprite.yorigin
			local bottom = droneData.target.y - droneData.target.sprite.yorigin + droneData.target.sprite.height
			graphics.color(efColor)
			graphics.alpha(0.2 + random)
			graphics.triangle(drone.x, drone.y, droneData.target.x, top, droneData.target.x, bottom, false)
			graphics.drawImage{
				image = droneData.target.sprite,
				x = droneData.target.x,
				y = droneData.target.y,
				alpha = 0.4 + random,
				solidColor = efColor,
				xscale = droneData.target.xscale,
				yscale = droneData.target.yscale,
				angle = droneData.target.angle
			}
		end
	end
end)

callback.register("postLoad", function()
	--stg.DampCaverns.interactables:add(int.DupDrone)
	stg.MagmaBarracks.interactables:add(int.DupDrone)
	--stg.TempleoftheElders.interactables:add(int.DupDrone)
	if stg.Overgrowth then stg.Overgrowth.interactables:add(int.DupDrone) end
end)