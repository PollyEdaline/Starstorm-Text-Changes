local path = "Items/Resources/"

it.DivineRight = Item.new("Divine Right")
it.DivineRight.pickupText = table.irandom({"Not quite a crown...", "Heavier than it looks...", "Belongs to a savior..."})
it.DivineRight.sprite = Sprite.load("DivineRight", path.."Divine Right.png", 2, 15, 16)
it.DivineRight.isUseItem = true
it.DivineRight.useCooldown = 15
it.DivineRight.color = "y"

local swordDamage = 10000000 / 5

local objSword = Object.new("UseBossSword")
objSword.sprite = Sprite.load("BossSwordSlash", path.."bossSwordSlash.png", 9, 26, 30)
objSword:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.15
end)
objSword:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.parent and selfData.parent:isValid() then
		self.x = selfData.parent.x
		self.y = selfData.parent.y
		if self.subimage >= 3 and not selfData.att then
			selfData.att = true
			--selfData.parent:fireExplosion(self.x + 14 * self.xscale, self.y, 34 / 19, 28 / 4, 15)
			if obj.Arraign1 then
				local arraign = obj.Arraign1:findRectangle(0,0,88888,88888) or obj.Arraign2:findRectangle(0,0,88888,88888)
				if arraign then
					arraign:set("invincible", 0)
					arraign:getData().noInvincible = true
					--print("IT WORKS!!!!!!")
				end
			end
			local bullet = misc.fireExplosion(self.x + 14 * self.xscale, self.y, 34 / 19, 28 / 4, swordDamage, selfData.parent:get("team")):set("damage_fake", swordDamage):set("critical", 1)
			bullet:getData().canDamageArraign = true
			bullet:getData().parent = selfData.parent
			sfx.Boss1Shoot1:play()
		end
	end
	if self.subimage >= self.sprite.frames then
		selfData.destroy = true
	elseif selfData.destroy then
		self:destroy()
	end
end)

local preHitCall = function(damager, target)
	if target:getObject() == obj.Arraign2 and damager:getData().canDamageArraign then
		damager:set("damage", 1)
		damager:set("damage_fake", 1)
	end
end

it.DivineRight:addCallback("use", function(player)
	local sword = objSword:create(player.x, player.y)
	sword:getData().parent = player
	sword.xscale = player.xscale
	--sfx.Boss1Shoot2:play(2)
	tcallback.register("preHit", preHitCall)
end)
callback.register("onPlayerDeath", function(player)
	if player.useItem == it.DivineRight or player:getData().mergedItems and contains(player:getData().mergedItems, it.DivineRight)then
		player.useItem = nil
		if net.host then
			it.DivineRight:getObject():create(player.x, player.y - 6)
		end
	end
end)

callback.register("onProvidenceDefeat", function(actor)
	for _, player in ipairs(misc.players) do
		local count = player:countItem(it.GildedOrnament)
		if count > 0 then
			player:removeItem(it.GildedOrnament, count)
			if net.host then
				it.DivineRight:create(actor.x, actor.y - 10)
			end
			break
		end
	end
end)