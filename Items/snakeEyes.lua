if not global.rormlflag.ss_og_snakeeyes then
-- Better Snake Eyes
it.SnakeEyes.pickupText = "Gain increased Critical Strike chance and damage on failing a shrine, until you succeed."
it.SnakeEyes:setLog{description = "Failing a shrine increases Critical Strike chance by 5% and damage by 1. Stacks up to 6 times. Lost when you succeed."}

local dicebuffs = {buff.dice1, buff.dice2, buff.dice3, buff.dice4, buff.dice5, buff.dice6}
for i, dicebuff in ipairs(dicebuffs) do
	dicebuff:addCallback("start", function(actor)
		actor:set("damage", actor:get("damage") + (1 * actor:get("dice")))
		actor:getData().lastDiceBuff = dicebuff
	end)
	dicebuff:addCallback("step", function(actor)
		if actor:getData().lastDiceBuff ~= dicebuff then
			actor:set("damage", actor:get("damage") + (1 * actor:get("dice")))
			actor:getData().lastDiceBuff = dicebuff
		end
	end)
	dicebuff:addCallback("end", function(actor)
		actor:set("damage", actor:get("damage") - (1 * actor:get("dice")) * i)
		actor:getData().lastDiceBuff = nil
	end)
end
end