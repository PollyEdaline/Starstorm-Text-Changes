local trackingAchievements = {}
for _, ac in ipairs(Achievement.findAll()) do
	if not ac:isComplete() then
		ac:addCallback("onIncrement", function()
			if trackingAchievements[ac] then
				local q
				for _, quest in pairs(Quest.getActive()) do
					if quest.name == "Achievement tracker" then
						for o, objective in pairs(quest.objectives) do
							if objective.title == ac.description then
								q = objective
								break
							end
						end
					end
				end
				Quest.setObjective("Achievement tracker", ac.description, q.progress + 1, nil, false)
			end
		end)
		ac:addCallback("onComplete", function()
			if trackingAchievements[ac] then
				Quest.setObjective("Achievement tracker", ac.description, ac.requirement, ac.requirement, true)
				trackingAchievements[ac] = nil
			end
		end)
	end
end
callback.register("onGameStart", function()
	for i, _ in pairs(trackingAchievements) do
			local acQuest = Quest.set("Achievement tracker")
			for achievement, _ in pairs(trackingAchievements) do
				Quest.setObjective(acQuest, achievement.description, 0, achievement.requirement, false)
			end
		break
	end
end)

local acList1 = {
	Achievement.find("unlock_gasoline", "vanilla"),
	Achievement.find("unlock_watch", "vanilla"),
	Achievement.find("unlock_doll", "vanilla"),
	Achievement.find("unlock_backup", "vanilla"),
	Achievement.find("unlock_hoof", "vanilla"),
	Achievement.find("unlock_clover", "vanilla"),
	Achievement.find("unlock_lopper", "vanilla"),
	Achievement.find("unlock_photon_jetpack", "vanilla"),
	Achievement.find("unlock_dios", "vanilla"),
	Achievement.find("unlock_foot", "vanilla"),
	Achievement.find("unlock_tooth", "vanilla"),
	Achievement.find("unlock_root", "vanilla"),
	Achievement.find("unlock_brooch", "vanilla"),
	Achievement.find("unlock_meteorite", "vanilla"),
	Achievement.find("unlock_imprinting", "vanilla"),
	Achievement.find("unlock_golden_gun", "vanilla"),
	Achievement.find("unlock_wicked_ring", "vanilla"),
	Achievement.find("unlock_scythe", "vanilla"),
	Achievement.find("unlock_snake_eyes", "vanilla")
}

local acList2 = {
	Achievement.find("unlock_syringe", "vanilla"),
	Achievement.find("unlock_threader", "vanilla"),
	Achievement.find("unlock_enforcer", "vanilla"),
	Achievement.find("unlock_spikestrip", "vanilla"),
	Achievement.find("unlock_prescriptions", "vanilla"),
	Achievement.find("unlock_bandit", "vanilla"),
	Achievement.find("unlock_pillaged", "vanilla"),
	Achievement.find("unlock_hitlist", "vanilla"),
	Achievement.find("unlock_huntress", "vanilla"),
	Achievement.find("unlock_scarf", "vanilla"),
	Achievement.find("unlock_instincts", "vanilla"),
	Achievement.find("unlock_hand", "vanilla"),
	Achievement.find("unlock_armsrace", "vanilla"),
	Achievement.find("unlock_shield_generator", "vanilla")
}

local acList3 = {
	Achievement.find("unlock_engineer", "vanilla"),
	Achievement.find("unlock_sticky_bomb", "vanilla"),
	Achievement.find("unlock_concussion", "vanilla"),
	Achievement.find("unlock_miner", "vanilla"),
	Achievement.find("unlock_panic_mine", "vanilla"),
	Achievement.find("unlock_justice", "vanilla"),
	Achievement.find("unlock_sniper", "vanilla"),
	Achievement.find("unlock_buddy", "vanilla"),
	Achievement.find("unlock_sight", "vanilla"),
	Achievement.find("unlock_acrid", "vanilla"),
	Achievement.find("unlock_centipede", "vanilla"),
	Achievement.find("unlock_leech", "vanilla"),
	Achievement.find("unlock_mercenary", "vanilla"),
	Achievement.find("unlock_chargefield", "vanilla"),
	Achievement.find("unlock_scepter", "vanilla")
}

local sprWatchButton = Sprite.load("WatchButton", "Misc/Menus/WatchButton", 3, 5, 3)

local drawAc = function()
	local statobj = obj.Highscore:find(1)
	if statobj and statobj:isValid() and statobj:get("page") == 2 then
		local _, h = graphics.getGameResolution()
		
		local page = statobj:get("ds_page")
		local pageMax = statobj:get("ds_page_max")
		if page == 0 or page >= pageMax - 1 then
			local imap = {[0] = {l = 18, t = acList1}, [pageMax - 1] = {l = 13, t = acList2}, [pageMax] = {l = 14, t = acList3}}
			for i = 0, imap[page].l do
				if not imap[page].t[i + 1]:isComplete() then
					graphics.color(Color.fromHex(0xD5D5D8))
					graphics.alpha(1)
					local xx = 35
					local yy = (h * 0.1) + 68 + 11 * i
					
					local mx, my = input.getMousePos(true)
					
					local subimage = 1
					if mx > xx - 8 and mx < xx + 7 and
					my > yy - 6 and my < yy + 6 then
						subimage = 3
						if input.checkMouse("left") == input.RELEASED then
							if trackingAchievements[imap[page].t[i + 1]] then
								trackingAchievements[imap[page].t[i + 1]] = nil
							else
								trackingAchievements[imap[page].t[i + 1]] = true
							end
						end
					end
					
					if trackingAchievements[imap[page].t[i + 1]] then
						subimage = math.min(subimage + 1, 3)
					end
					graphics.drawImage{
						image = sprWatchButton,
						x = xx,
						y = yy,
						subimage = subimage
					}
				end
			end
		elseif page == pageMax - 1 then
			
		elseif page == pageMax then
			
		end
	end
end

callback.register("globalRoomStart", function(room)
	if room == rm.Highscore then
		graphics.bindDepth(-9999, drawAc)
	end
end)