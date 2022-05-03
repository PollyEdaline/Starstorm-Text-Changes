local path = "Items/Resources/"

it.Diary = Item.new("Diary")
local diaryDis = Sprite.load("DiaryDisplay", path.."diarydis.png", 5, 4, 4)
it.Diary.pickupText = "Earn experience over time." 
it.Diary.sprite = Sprite.load("Diary", path.."Diary.png", 1, 12, 13)
it.Diary:setTier("common")
it.Diary:setLog{
	group = "common",
	description = "Earn &b&experience&!& over time.",
	story = "Hey darling!\nI hope your trip is going OK. I saw that you forgot your diary so I'm sending it back to you. Just don't take it to the bathroom next time haha ;)\nTake care! I love you.",
	destination = "Sterrenstad,\nZondam,\nEarth",
	date = "06/12/2056"
}

local onPlayerStepCall = function(player)
	local diary = player:countItem(it.Diary)
	if diary > 0 then
		local playerAc = player:getAccessor()
		playerAc.expr = playerAc.expr + ((0.002 + 0.003 * (playerAc.level * 2.4)) * (diary * 1.2))
	end
end

local onPlayerDrawCall = function(player)
	local diary = player:countItem(it.Diary)
	local playerData = player:getData()
	if diary > 0 then
		if playerData.diaryCounter then
			graphics.drawImage{image = diaryDis, subimage = playerData.diaryCounter, x = player.x + 6, y = player.y - 14, alpha = 0.3}
			if playerData.diaryCounter > 4 then
				playerData.diaryCounter = 1
			else
				playerData.diaryCounter = playerData.diaryCounter + 0.05 + 0.05 * diary
			end
		else
			playerData.diaryCounter = 1
		end
	end
end

it.Diary:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)