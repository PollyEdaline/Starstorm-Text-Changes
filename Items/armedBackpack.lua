local path = "Items/Resources/"

it.ArmBackpack = Item.new("Armed Backpack")
local sArmBack = Sound.load("ArmedBackPack", path.."armedBackpack")
local sprArmBackSparks1 = Sprite.load("ArmedBackpack_Sparks1", path.."armbacksparks1", 4, 10, 8)
local sprArmBackSparks2 = Sprite.load("ArmedBackpack_Sparks2", path.."armbacksparks2", 4, 0, 8)
it.ArmBackpack.pickupText = "Chance of firing an additional bullet backwards." 
it.ArmBackpack.sprite = Sprite.load(path.."Armed Backpack.png", 1, 12, 14)
it.ArmBackpack:setTier("common")
it.ArmBackpack:setLog{
	group = "common",
	description = "&y&18.5%&!& chance of &y&firing an additional bullet&!& from your back.",
	story = "Being secure is always important, I don't want you to get in danger so please wear this whenever you go out, specially in the canyons, there's a lot of thieves there!\nI'll send you some extra ammunition later this year, alright?",
	priority = "&y&Volatile&!&",
	destination = "832B,\nHautenuit,\nEarth",
	date = "11/7/2056"
}
it.ArmBackpack:addCallback("pickup", function(player)
	player:set("gunBackpack", (player:get("gunBackpack") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.ArmBackpack then
		player:set("gunBackpack", player:get("gunBackpack") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	if parent and parent:isValid() then
		local parentAc = parent:getAccessor()
		
		local armBackPack = parentAc.gunBackpack
		if armBackPack then
			if armBackPack > 0 then
				if math.chance(12 + (6.5 * armBackPack)) then
					sArmBack:play(1 + math.random() * 0.2, 0.8)
					local armBackShoot = obj.EfSparks:create(parent.x, parent.y)
					armBackShoot.sprite = sprArmBackSparks2
					armBackShoot.spriteSpeed = 0.4
					parent:fireBullet(parent.x - 5, parent.y, parent:getFacingDirection() + 180, 250, 1.5, sprArmBackSparks1, DAMAGER_NO_PROC)
					armBackShoot.xscale = parent.xscale * -1
				end
			end
		end
	end
end)