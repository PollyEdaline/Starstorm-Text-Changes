local path = "Items/Resources/"

it.MindshiftGas = Item.new("Mind-shift Gas")
local sMindshiftGas = Sound.load("MindshiftGas", path.."mindshiftGas")
it.MindshiftGas.pickupText = "Throw a gas canister. Enemies around it attack each other." 
it.MindshiftGas.sprite = Sprite.load("MindshiftGas", path.."Mind-shift Gas.png", 2, 17, 12)
it.MindshiftGas.isUseItem = true
it.MindshiftGas.useCooldown = 50
it.MindshiftGas:setTier("use")
itp.enigma:add(it.MindshiftGas)
it.MindshiftGas:setLog{
	group = "use_locked",
	description = "Throw a gas canister. &y&Enemies inside the gas attack each other for 10 seconds.",
	story = "I'm worried, Dom.\nThe universe we live in can be.. unforgiving, cruel. We all knew that.\nHowever.. I'm astounded.\nProgress, evolution, and our fight for technological supremacy gave us our reach for the stars, but it also gave us war. A silent one, in which our minds are simple contraptions to take a hold of.\nIt gave us this.",
	priority = "&y&Volatile&!&",
	destination = "Corridor A-LT,\nZeus Complex,\nEarth",
	date = "11/18/2056"
}

local objGrenade = Object.new("DukeGas")
objGrenade.sprite = spr.PartPixel

objGrenade:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.xspeed = 0
	selfData.gravity = 0.2
	selfData.yspeed = 0
	selfData.range = 65
	selfData.team = "player"
	selfData.count = 0
	selfData.life = 600
	self.blendColor = Color.fromHex(0xB75B5B)
	self.xscale = 2
	self.yscale = 2
end)
objGrenade:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.count < 3 then
		selfData.xspeed = math.approach(selfData.xspeed, 0, 0.04)
		self.y = self.y + selfData.yspeed
		self.x = self.x + selfData.xspeed
		selfData.yspeed = selfData.yspeed + selfData.gravity
	else
		if not self:collidesMap(self.x, self.y) then
			self.y = self.y + 1
		end
	end
	
	if self:collidesMap(self.x, self.y) then
			if selfData.life > 0 then
				selfData.life = selfData.life - 1
				local xx = math.random(-selfData.range, selfData.range)
				if math.chance(40) then
					par.Spore:burst("below", self.x + xx, self.y - 5, 1, Color.CORAL)
				end
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - 46, self.y - 25, self.x + 46, self.y + 25)) do
					if actor:get("team") ~= selfData.team and actor:isClassic() and not actor:isBoss() then
						actor:applyBuff(buff.noteam, 30)
					end
				end
			else
				self:destroy()
			end
		if selfData.count < 3 then
			local ysign = 1
			local xsign = 1
			if not self:collidesMap(self.x, self.y - 5) or not self:collidesMap(self.x, self.y + 5) then
				local n = 0
				while n < 20 and self:collidesMap(self.x, self.y) do
					n = n + 1
					self.y = self.y + math.sign(selfData.yspeed) * -1
				end
				ysign = -1
			elseif not self:collidesMap(self.x - 5, self.y) or not self:collidesMap(self.x + 5, self.y) then
				local n = 0
				while n < 20 and self:collidesMap(self.x, self.y) do
					n = n + 1
					self.x = self.x + math.sign(selfData.xspeed) * -1
				end
				xsign = -1
			end
			selfData.count = selfData.count + 1
			selfData.yspeed = selfData.yspeed * 0.2 * ysign
			selfData.xspeed = selfData.xspeed * 0.4 * xsign
			--sfx.Reflect:play(1.3 + math.random() * 0.2, 0.1)
		end
	end
end)

it.MindshiftGas:addCallback("use", function(player, embryo)
	local grenade = objGrenade:create(player.x, player.y)
	grenade:getData().team = player:get("team")
	grenade:getData().xspeed = (1.5 * player.xscale) + player:get("pHspeed")
	grenade:getData().yspeed = -2
	if embryo then
		grenade:getData().life = 1200
	end
	sMindshiftGas:play()
end)