local path = "Items/Resources/"

it.GHook = Item.new("G-Hook")
--local sStickyBattery = Sound.load("G-Hook", path.."")
it.GHook.pickupText = "Launch a climbable rope above you."
it.GHook.sprite = Sprite.load("G-Hook", path.."G-Hook.png", 2, 15, 15)
it.GHook:setTier("use")
it.GHook.isUseItem = true
it.GHook.useCooldown = 45
it.GHook:setLog{
	group = "use",
	description = "Launch a &b&climbable rope&!& above you.",
	story = "They really don’t work like movie producers think they do, but whatever.\nYou want to throw it ABOVE where you’re trying to grapple, and then yank it back. It’ll land straight on your head if you aren’t careful.\n\nHave fun!",
	destination = "Green Tower: 35,\nEdinburgh,\nEarth",
	date = "10/13/2056"
}

local hookTime = 20

local objGHook = Object.new("GHook")
objGHook.sprite = spr.Pixel
objGHook:addCallback("create", function(self)
	self:getData().startY = self.y
	self:getData().timer = hookTime
	self:getData().length = 0
end)
objGHook:addCallback("step", function(self)
	local data = self:getData()
	if data.timer then
		if data.timer > 0 then
			if data.timer == hookTime then
				local rope = obj.Rope:create(self.x, self.y):set("height_box", data.length)
				rope.yscale = data.length
			end
			data.timer = data.timer - 1
		else
			data.timer = nil
		end
	end
end)
objGHook:addCallback("draw", function(self)
	if self.x < camera.x + camera.width and self.x > camera.x then
		local data = self:getData()
		local t = data.timer or 0
		graphics.alpha(1)
		graphics.color(Color.fromHex(0x604C40))
		local dif = data.startY - self.y
		local newY = data.startY - dif * (t / hookTime)
		graphics.line(self.x + 1, self.y - 1, self.x + 1, newY - 4, 2)
	end
end)

it.GHook:addCallback("use", function(player, embryo)
	local startX = math.round(player.x / 4) * 4
	local startY = math.round(player.y / 16) * 16
	
	local endY
	local length
	
	if not obj.Rope:findPoint(startX, startY) then
		for i = 1, 100 do
			local yy = startY - i * 16
			if Stage.collidesPoint(startX, yy + 8) and not obj.Rope:findPoint(startX, yy + 8) then
				if obj.B:findPoint(startX, yy) then
					endY = yy
					length = i
					break
				elseif obj.BNoSpawn:findPoint(startX, yy) then
					endY = startY - (i - 1) * 16
					length = (i - 1)
					break
				end
			end
		end
	end
	
	if endY then
		local hook = objGHook:create(startX, endY)
		hook:getData().length = length
		hook:getData().startY = startY
		player:getData().falseUseItem = nil
	elseif player.useItem == it.GHook then
		if not player:getData().mergedItems or #player:getData().mergedItems == 0 then
			sfx.Pickup:stop()
			if not net.online or net.localPlayer == player then
				sfx.Error:play()
			end
			player:setAlarm(0, 5)
			player:getData().falseUseItem = true
		end
	end
end)