-- Shocker Drone

local path = "Actors/Shocker Drone/"

local resources = {
	sprites = {
		item = Sprite.load("ShockDroneItem", path.."Object", 1, 11, 20),
		idle = Sprite.load("ShockDroneIdle", path.."Idle", 4, 6, 10),
		--shoot = Sprite.load("ShockDroneShoot", path.."Shoot", 25, 11, 13),
		idle_broken = Sprite.load("ShockDroneIdleBroken", path.."Idle_broken", 4, 6, 10),
	},
	sounds = {
		--shoot = Sound.load("ShockDroneShoot", path.."shoot")
	}
}

obj.ShockDroneItem = Object.base("DroneItem", "Shocker Drone Item")
obj.ShockDroneItem.sprite = resources.sprites.item

obj.ShockDrone = Object.base("Drone", "Shocker Drone")
obj.ShockDrone.sprite = resources.sprites.idle

int.ShockDrone = Interactable.new(obj.ShockDroneItem, "Shocker Drone")
int.ShockDrone.spawnCost = 110

obj.ShockDroneItem:addCallback("create", function(self)
	self:set("child", obj.ShockDrone.id)
	self:set("cost", math.ceil(110 * Difficulty.getScaling()))
	self:set("name", "Shocker Drone")
end)
obj.ShockDrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.cooldown = 10
	self:set("child", obj.ShockDroneItem.id)
	self:set("persistent", 1)
	self:set("maxhp", 80 * Difficulty.getScaling("hp"))
	self:set("hp", self:get("maxhp"))
	self:setAnimations(resources.sprites)
end)

obj.ShockDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	local target = Object.findInstance(selfAc.target)
	
	if target and target:isValid() and selfAc.state == "chase" then
		local ty = target.y - 25
		local difx = self.x - target.x
		local dify = self.y - ty
		
		self.x = math.approach(self.x, target.x, difx * 0.1)
		self.y = math.approach(self.y, ty, dify * 0.1)
		
		if selfData.cooldown > 0 then
			selfData.cooldown = selfData.cooldown - 1
		else
			
			local lightning = obj.ChainLightning:create(self.x, self.y + 15)
			lightning:set("parent", self.id)
			lightning:set("damage", math.ceil(selfAc.damage * 2.5))
			lightning:set("bounce", 3)
			
			self:fireBullet(target.x - 2, target.y, 0, 4, 0.2, nil):set("specific_target", target.id):set("stun", 1)
			selfData.cooldown = 100
			
			if selfAc.mortar > 0 then
				for i = 1, selfAc.mortar do
					obj.EfMissileSmall:create(self.x, self.y):set("parent", self.id):set("damage", selfAc.damage)
				end
			end
		end
	end
end)

callback.register("postLoad", function()
	stg.SkyMeadow.interactables:add(int.ShockDrone)
	stg.AncientValley.interactables:add(int.ShockDrone)
	if stg.UnchartedMountain then stg.UnchartedMountain.interactables:add(int.ShockDrone) end
	if stg.Overgrowth then stg.Overgrowth.interactables:add(int.ShockDrone) end
end)