local path = "Items/Resources/"

it.HazardousBarrel = Item.new("Hazardous Barrel")
it.HazardousBarrel.pickupText = "Place a barrel which explodes on hit." 
it.HazardousBarrel.sprite = Sprite.load("HazardousBarrel", path.."Hazardous Barrel.png", 2, 10, 13)
it.HazardousBarrel.isUseItem = true
it.HazardousBarrel.useCooldown = 7
it.HazardousBarrel:setTier("use")
itp.enigma:add(it.HazardousBarrel)
it.HazardousBarrel:setLog{
	group = "use",
	description = "Place a barrel which &y&explodes on hit for 450% damage&!&, plus &y&5x35% corrosive damage over time&!&.",
	story = "What a trope! Go pew pew and they go BOOM BOOM!!",
	priority = "&y&Volatile&!&",
	destination = "E1M3\nToxin Refinery,\nMars",
	date = "11/08/2056"
}

local objHazBarrel = Object.base("NPC", "HazBarrel")
objHazBarrel.sprite = Sprite.load("HazardousBarrelObj", path.."hazardousBarrelObj.png", 2, 3, 11)

objHazBarrel:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfData.timer = 30
	self.spriteSpeed = 0.1
	selfAc.maxhp = 1
	selfAc.hp = 1
	selfAc.lastHp = 1
	selfAc.team = "neutral"
	selfAc.name = "Barrel of Doom"
	selfAc.exp_worth = 0
	selfAc.damage = 10
	selfAc.m_id = 0
	
	local n = 0
	while not self:collidesMap(self.x, self.y + 1) and n < 800 do
		n = n + 1
		self.y = self.y + 1
	end
	selfAc.ghost_x = self.x
	selfAc.ghost_y = self.y
end)
objHazBarrel:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.timer > 0 then
		selfData.timer = selfData.timer - 1
		selfAc.hp = 1
	elseif selfAc.hp <= 0 then
		self:destroy()
		misc.shakeScreen(4)
	end
end)
objHazBarrel:addCallback("destroy", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	sfx.RiotGrenade:play(0.9 + math.random() * 0.2)
	
	if selfData.parent and selfData.parent:isValid() then
		local b = selfData.parent:fireExplosion(self.x, self.y, 45 / 19, 20 / 4, 4.5, spr.EfMineExplode, spr.Sparks7)
		DOT.addToDamager(b, DOT_CORROSION, selfAc.damage * 0.35, 5, "hazbarrel", true)
	else
		local b = misc.fireExplosion(self.x, self.y, 45 / 19, 20 / 4, selfAc.damage * 2, "player", spr.EfMineExplode, spr.Sparks7)
		DOT.addToDamager(b, DOT_CORROSION, selfAc.damage * 0.35, selfAc.damage, "hazbarrel", true)
	end
end)

it.HazardousBarrel:addCallback("use", function(player, embryo)
	--if net.host then

	if embryo then
		local barrel = objHazBarrel:create(player.x - 4, player.y + 3)
		barrel:getData().parent = player
		barrel:set("damage", player:get("damage"))
		
		local barrel = objHazBarrel:create(player.x + 4, player.y + 3)
		barrel:getData().parent = player
		barrel:set("damage", player:get("damage"))
	else
		local barrel = objHazBarrel:create(player.x, player.y + 3)
		barrel:getData().parent = player
		barrel:set("damage", player:get("damage"))
	end
	--end
end)