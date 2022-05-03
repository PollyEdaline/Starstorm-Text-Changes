-- Refabricator

local sprRefabricator = Sprite.load("Refabricator", "Interactables/Resources/Refabricator", 17, 20, 35)

obj.Refabricator = Object.base("MapObject", "Refabricator")
obj.Refabricator.sprite = sprRefabricator
obj.Refabricator.depth = -9

--itp.Refabricator = ItemPool.new("Refabricator")
--itp.Refabricator:add(item)

local droneItems = {
	[obj.Drone1] = {it.BarbedWire, it.Crowbar, it.StickyBomb, it.Taser, it.Fork, it.X4Stimulant, it.Needles},
	[obj.Drone2] = {it.RustyJetpack, it.PrisonShackles, it.EnergyCell, it.X4Stimulant, it.ArmBackpack},
	[obj.Drone3] = {it.MortarTube, it.RustyJetpack, it["AtGMissileMk.1"], it["AtGMissileMk.2"], it.EnergyCell, it.BrassKnuckles, it.ArmBackpack},
	[obj.Drone4] = {it.SoldiersSyringe, it.RustyJetpack, it.PrisonShackles, it.HarvestersScythe, it.EnergyCell, it.Fork},
	[obj.Drone5] = {it.ConcussionGrenade, it.PanicMines, it.LaserTurbine, it.GoldenGun, it.PrisonShackles, it.EnergyCell},
	[obj.Drone6] = {it.ConcussionGrenade, it.HottestSauce, it.FiremansBoots, it.RustyJetpack, it.PrisonShackles, it.EnergyCell},
	[obj.Drone7] = {it.HarvestersScythe, it.InterstellarDeskPlant, it.LeechingSeed, it.PhotonJetpack, it.EnergyCell, it.FieldAccelerator},
	[obj.DupDrone] = {it.ArmsRace, it.ConcussionGrenade, it.NkotaH, it.PortableReactor, it.EnergyCell, it.FieldAccelerator},
	[obj.HackDrone] = {it.ArmsRace, it.RustyJetpack, it.PrisonShackles, it.EnergyCell, it.VoltaicGauge},
	[obj.ShockDrone] = {it.RustyJetpack, it.Ukulele, it.TeslaCoil, it.CrypticSource, it.EnergyCell, it.VoltaicGauge, it.X4Stimulant}
}

obj.Refabricator:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0
	self:set("active", 0)
	if misc.director and misc.director:isValid() then
		self:set("cost", 0)
	end
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
end)

obj.Refabricator:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if not pobj.commandCrates:findRectangle(player.x - 3, player.y - 3, player.x + 3, player.y + 3) then
						if #pobj.drones:findMatching("master", player.id) > 0 then
							
							if net.online then
								if net.host then
									syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
								else
									syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
								end	
							end
							
							_newInteractables[obj.Refabricator].activation(self, player)
						else
							sfx.Error:play()
						end
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if global.quality > 1 and self.subimage >= 8 and self.subimage <= 11 then
			par.Spark:burst("middle", self.x + math.random(-4, 4), self.y - 11, 1)
		end
		if selfData.droneSelection then
			if self.subimage >= 11 then
				local sparks = obj.EfSparks:create(self.x, self.y - 11)
				sparks.sprite = spr.DroneDeath
				sparks.yscale = 1
				sparks.depth = self.depth - 1
				sfx.DroneDeath:play(1, 0.5)
				syncDestroy(selfData.droneSelection)
				selfData.droneSelection:destroy()
				selfData.droneSelection = nil
			else
				selfData.droneSelection.depth = self.depth - 1
				selfData.droneSelection.y = self.y - 15
				selfData.droneSelection.x = self.x
			end
		end
		if self.subimage >= 15 and selfData.awaitingItem then
			if ar.Command.active then
				table.irandom{itp.common, itp.uncommon}:getCrate():create(self.x, self.y - 20)
			else
				local items = droneItems[selfData.awaitingItem] or {it.BarbedWire, it.Crowbar, it.EnergyCell, it.Taser, it.Fork, it.X4Stimulant}
				local item = table.irandom(items) or it.Eggplant
				item:create(self.x, self.y - 30)
			end
			selfData.awaitingItem = nil
		end
		if self.subimage >= self.sprite.frames then
			self.spriteSpeed = 0
			self.subimage = 1
			selfAc.active = 0
		end
	end
end)

obj.Refabricator:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
	
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local costStr = " &y&(1 drone)"
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to refabricate into an item"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to refabricate into an item"..costStr
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 118, self.y - 57)
		end
	end
	
	if selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0x7BAEED))
		graphics.print("1 DRONE", self.x - 5, self.y + 6, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
	
	--[[if selfAc.active == 2 then
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else
			selfAc.active = 0
		end
	end]]
end)

return obj.Refabricator