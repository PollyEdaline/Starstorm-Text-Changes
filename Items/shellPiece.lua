local path = "Items/Resources/"

it.ShellPiece = Item.new("Shell Piece")
local sShellPiece = Sound.load("ShellPiece", path.."shellPiece")
it.ShellPiece.pickupText = "Gain temporary immunity near death (once per stage)." 
local sprShellPiece = Sprite.load("Shell Piece", path.."Shell Piece.png", 1, 14, 14)
local sprShellPieceUsed = Sprite.load("Shell Piece Used", path.."Shell Piece Used.png", 1, 14, 14)
it.ShellPiece.sprite = sprShellPiece
itp.legendary:add(it.ShellPiece)
it.ShellPiece.color = "y"
it.ShellPiece:setLog{
	group = "boss",
	description = "Gain &b&immunity for 3 seconds&!& when lethally hit (once per stage).",
	story = "And so I fought through. Its shell was solid as graphene; cutting through it, blasting it, nothing seemed to be enough until this piece fell off it, leaving the colossal creature exposed.\nNothing will compare to how glorious my victory was, all thanks to this unlikely event.",
	priority = "&b&Field-Found&!&",
	destination = "Menon Exhibit,\nPlora,\nEarth",
	date = "Unknown"
}
it.ShellPiece:addCallback("pickup", function(player)
	player:set("shellPiece", (player:get("shellPiece") or 0) + 1)
	player:setItemSprite(it.ShellPiece, sprShellPiece)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.ShellPiece then
		player:set("shellPiece", player:get("shellPiece") - amount)
	end
end)
if obj.SandCrabKing then
	NPC.registerBossDrops(obj.SandCrabKing)
	NPC.addBossItem(obj.SandCrabKing, it.ShellPiece)
end

function procShell(target, damage)
	local targetAc = target:getAccessor()
	local targetData = target:getData()
	if targetAc.shellPiece and targetAc.hp < damage then
		if not targetAc.invincible or targetAc.invincible and targetAc.invincible <= 0 then
			local activated
			if not targetData.shellPieceUse or targetData.shellPieceUse < targetAc.shellPiece then
				sShellPiece:play()
				DOT.removeFromActor(target)
				targetAc.hp = 1
				targetAc.lastHp = 1
				target:applyBuff(buff.shellPiece, 140)
				targetAc.invincible = targetAc.invincible + 1
				if isa(target, "PlayerInstance") and target:getSurvivor() == sur.Loader then
					targetAc.invincible = 3002
				end
				activated = true
			end
			if targetData.shellPieceUse then
				targetData.shellPieceUse = targetData.shellPieceUse + 1
			else
				targetData.shellPieceUse = 1
			end
			if isa(target, "PlayerInstance") and targetData.shellPieceUse and targetData.shellPieceUse >= targetAc.shellPiece then
				target:setItemSprite(it.ShellPiece, sprShellPieceUsed)
			end
			if activated then
				return true
			end
		end
	end
end

callback.register("onDamage", function(target, damage, source)
	local targetAc = target:getAccessor()
	
	return procShell(target, damage or 0)
end)

table.insert(call.onStageEntry, function()
	for _, actor in ipairs(pobj.actors:findAll()) do
		if actor:getData().shellPieceUse and actor:getData().shellPieceUse > 0 then
			actor:getData().shellPieceUse = 0
			if isa(actor, "PlayerInstance") then
				actor:setItemSprite(it.ShellPiece, sprShellPiece)
			end
		end
	end
end)