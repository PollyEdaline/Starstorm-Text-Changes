local path = "Items/Resources/"

it.Deicide = Item.new("Deicide")
it.Deicide.pickupText = "Swing an anointed sword forward."
it.Deicide.sprite = Sprite.load("Deicide", path.."Deicide.png", 2, 15, 16)
it.Deicide.isUseItem = true
it.Deicide.useCooldown = 15
it.Deicide.color = "o"
if save.read("defeatedArraign") then
	it.Deicide:setTier("use")
end

local swordDamage = 10000000 / 20
local swordDamage2 = 10000000 / 5

local objSword2 = Object.new("UseBossSword2")
objSword2.sprite = Sprite.load("BossSwordSlash2", path.."bossSwordSlash2.png", 9, 26, 30)
objSword2:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.15
end)
objSword2:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.parent and selfData.parent:isValid() then
		self.x = selfData.parent.x
		self.y = selfData.parent.y
		if self.subimage >= 3 and not selfData.att then
			selfData.att = true
			if obj.Arraign1 then
				local arraign = obj.Arraign1:findRectangle(0,0,88888,88888) or obj.Arraign2:findRectangle(0,0,88888,88888)
				if arraign then
					arraign:set("invincible", 0)
					arraign:getData().noInvincible = true
				end
			end
			if selfData.anointed then
				local bullet = misc.fireExplosion(self.x + 14 * self.xscale, self.y, 34 / 19, 28 / 4, swordDamage2, selfData.parent:get("team")):set("damage_fake", swordDamage2):set("critical", 1)
				bullet:getData().canDamageArraign = true
				bullet:getData().parent = selfData.parent
			else
				local bullet = misc.fireExplosion(self.x + 14 * self.xscale, self.y, 34 / 19, 28 / 4, selfData.parent:get("damage") * 20, selfData.parent:get("team"))
				bullet:set("critical", 1)
				bullet:getData().canDamageArraign = true
				bullet:getData().isDeicide = true
				bullet:getData().parent = selfData.parent
			end
			local sound = Sound.find("ArraignShoot1_1b") or sfx.Boss1Shoot1
			sound:play(1.3)
		end
	end
	if self.subimage >= self.sprite.frames then
		selfData.destroy = true
	elseif selfData.destroy then
		self:destroy()
	end
end)

local preHitCall = function(damager, target)
	if target:getObject() == obj.Arraign1 and damager:getData().canDamageArraign then
		obj.EfFlash:create(0,0):set("parent", target.id):set("rate", 0.08)
		if damager:getData().isDeicide then
			damager:set("damage", swordDamage)
			damager:set("damage_fake", swordDamage)
		end
	end
end

it.Deicide:addCallback("use", function(player)
	local sword = objSword2:create(player.x, player.y)
	sword:getData().parent = player
	sword:getData().anointed = player:get("name"):find("Anointed")
	sword.xscale = player.xscale
	--sfx.Boss1Shoot2:play(2)
	
	tcallback.register("preHit", preHitCall)
end)