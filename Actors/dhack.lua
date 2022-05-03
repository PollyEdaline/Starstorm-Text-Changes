-- Hacker Drone

local path = "Actors/Hacker Drone/"

local resources = {
	sprites = {
		item = Sprite.load("HackDroneItem", path.."Object", 1, 11, 20),
		idle = Sprite.load("HackDroneIdle", path.."Idle", 4, 5, 8),
		idle_cd = Sprite.load("HackDroneIdleCooldown", path.."Idle_cd", 4, 5, 8),
		shoot = Sprite.load("HackDroneShoot", path.."Shoot", 4, 5, 8),
		idle_broken = Sprite.load("HackDroneIdleBroken", path.."Idle_broken", 4, 5, 8),
		idle_broken_cd = Sprite.load("HackDroneIdleBrokenCooldown", path.."Idle_broken_cd", 4, 5, 8),
		shoot_broken = Sprite.load("HackDroneShootBroken", path.."Shoot_broken", 4, 5, 8),
	},
	sounds = {
		shoot = Sound.load("HackDroneShoot", path.."shoot")
	}
}

obj.HackDroneItem = Object.base("DroneItem", "Hacking Drone Item")
obj.HackDroneItem.sprite = resources.sprites.item

obj.HackDrone = Object.base("Drone", "Hacking Drone")
obj.HackDrone.sprite = resources.sprites.idle

int.HackDrone = Interactable.new(obj.HackDroneItem, "Hacking Drone")
int.HackDrone.spawnCost = 130

local efColor = Color.fromHex(0x4DF2B8)

local techInteractables = {pobj.droneItems, obj.Chest3, obj.Chest4}

obj.HackDroneItem:addCallback("create", function(self)
	self:set("child", obj.HackDrone.id)
	self:set("cost", math.ceil(110 * Difficulty.getScaling()))
	self:set("name", "hacking drone")
end)
obj.HackDrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.cooldown = 0
	selfData.anim = 0
	self:set("child", obj.HackDroneItem.id)
	self:set("range", 100)
	self:set("x_range", 0)
	self:set("y_range", 0)
	self:set("persistent", 1)
	self:setAnimation("idle", resources.sprites.idle)
	self:setAnimation("idle_broken", resources.sprites.idle_broken)
end)
obj.HackDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local nearInteractable
	local range = self:get("range")
	if selfData.cooldown <= 0 then
		for _, int in ipairs(techInteractables) do
			nearInteractable = int:findEllipse(self.x - range, self.y - range, self.x + range, self.y + range)
			
			if nearInteractable and nearInteractable:isValid() then
				if nearInteractable:getData()["hackedby"..self.id] or nearInteractable:get("active") > 0 then
					nearInteractable = nil 
				end
			end
			
			if nearInteractable then break end
		end
		if nearInteractable and nearInteractable:isValid() then
			selfData.target = nearInteractable
			selfData.cooldown = 1400
			selfData.anim = 60
			resources.sounds.shoot:play()
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
			if selfData.anim < 10 then
				if selfData.target:get("cost") > 0 and not selfData.target:getData()["hackedby"..self.id] then
					selfData.target:set("cost", math.ceil(selfData.target:get("cost") * 0.7))
				end
				selfData.target:getData()["hackedby"..self.id] = true
			end
			local difx = selfData.target.x - self.x
			self.x = math.approach(self.x, selfData.target.x, difx * 0.1)
			local dify = selfData.target.y - self.y
			self.y = math.approach(self.y, selfData.target.y, dify * 0.1)
			self:setAnimation("idle_broken", resources.sprites.shoot_broken)
			self:setAnimation("idle", resources.sprites.shoot)
		else
			selfData.anim = 0
		end
	end
end)

table.insert(call.onDraw, function()
	for _, drone in ipairs(obj.HackDrone:findAll()) do
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
	if obj.Activator then table.insert(techInteractables, obj.Activator) end
	stg.SkyMeadow.interactables:add(int.HackDrone)
	stg.HiveCluster.interactables:add(int.HackDrone)
	stg.AncientValley.interactables:add(int.HackDrone)
	if stg.UnchartedMountain then stg.UnchartedMountain.interactables:add(int.HackDrone) end
end)