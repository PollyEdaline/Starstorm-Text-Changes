
-- go away! :)









































-- please?
















































-- :(

















































-- :((((((
























-- >:(




























































--uhhmmmm




















































-- :O







































































-- I'm disappointed















































-- :,(





















































--yep





























































--hi






































































--.............














































-- i cry















































-- poop


if not global.rormlflag.ss_disable_submenu and not global.rormlflag.ss_disable_skins then
-- Commando
local commando = sur.Commando
	
	-- Fatmando
	local fatmando = SurvivorVariant.find(commando, "Fatmando")
	local acFatmando = HiddenAchievement.new("Fatmando", fatmando)
	acFatmando.sprite = Sprite.find("FatmandoIdle", "Starstorm")
	acFatmando.requirement = 1
	acFatmando.deathReset = true
	acFatmando.description = "Commando: Reach a total of 5001 hp."

	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == commando and player:get("maxhp") >= 5001 then
				HiddenAchievement.increment(acFatmando, 1)
			end
		end
	end)	
	
-- Bandit
local bandit = sur.Bandit
	
	-- Reaper
	local reaper = SurvivorVariant.find(bandit, "Reaper")
	local acReaper = HiddenAchievement.new("Reaper", reaper)
	acReaper.sprite = Sprite.find("ReaperIdle", "Starstorm")
	acReaper.requirement = 1
	acReaper.deathReset = true
	acReaper.description = "Bandit: Obtain 'Harvester's Scythe', 'Golden Gun' and 'Wicked Ring' in the same run."
	
	if not acReaper:isComplete() then
		callback.register("onItemPickup", function(item, player)
			if not net.online or player == net.localPlayer then
				if player:getSurvivor() == bandit then
					if player:countItem(it.HarvestersScythe) > 0 and player:countItem(it.GoldenGun) > 0 and player:countItem(it.WickedRing) > 0 then
						HiddenAchievement.increment(acReaper, 1)
					end
				end
			end
		end)
	end

-- Engineer
local engineer = sur.Engineer
	
	-- Fungus Man
	local fungusman = SurvivorVariant.find(engineer, "Fungus Man")
	local acFungusMan = HiddenAchievement.new("Fungus Man", fungusman)
	acFungusMan.sprite = Sprite.find("FungusManIdle", "Starstorm")
	acFungusMan.requirement = 1
	acFungusMan.deathReset = true
	acFungusMan.description = "Engineer: Obtain 5 'Bustling fungus' in a single run."
	
	if not HiddenAchievement.isComplete(acFungusMan) then
		callback.register("onItemPickup", function(item, player)
			if not net.online or player == net.localPlayer then
				if player:getSurvivor() == engineer then
					if player:countItem(it.BustlingFungus) >= 5 then
						HiddenAchievement.increment(acFungusMan, 1)
					end
				end
			end
		end)
	end

-- Sniper
local sniper = sur.Sniper

	-- Hunter
	local hunter = SurvivorVariant.find(sniper, "Hunter")
	local acHunter = HiddenAchievement.new("Hunter", hunter)
	acHunter.sprite = Sprite.find("HunterIdle", "Starstorm")
	acHunter.requirement = 1
	acHunter.deathReset = true
	acHunter.description = "Sniper: Defeat Providence with the following items: Ol Lopper, Fireman's Boots, Heaven Cracker."
	
	if not HiddenAchievement.isComplete(acHunter) then
		callback.register("onProvidenceDefeat", function(player)
			for _, player in ipairs(obj.P:findAll()) do
				if not net.online or player == net.localPlayer then
					if player:getSurvivor() == sniper and player:countItem(it.TheOlLopper) > 0 and player:countItem(it.FiremansBoots) > 0 and player:countItem(it.HeavenCracker) > 0 then
						HiddenAchievement.increment(acHunter, 1)
					end
				end
			end
		end)
	end
	
-- Mercenary
local mercenary = sur.Mercenary

	-- Combatant
	local combatant = SurvivorVariant.find(mercenary, "Combatant")
	local acCombatant = HiddenAchievement.new("Combatant", combatant)
	acCombatant.sprite = Sprite.find("CombatantIdle", "Starstorm")
	acCombatant.requirement = 1
	acCombatant.deathReset = true
	acCombatant.description = "Mercenary: Defeat providence using Blinding Assault."
	
	if not HiddenAchievement.isComplete(acCombatant) then
		callback.register("onProvidenceDefeat", function(player)
			for _, player in ipairs(obj.P:findAll()) do
				if not net.online or player == net.localPlayer then
					if player:getSurvivor() == mercenary and player:get("activity") == 3 then
						HiddenAchievement.increment(acCombatant, 1)
					end
				end
			end
		end)
	end
	
-- Loader
local loader = sur.Loader

	-- Pirate
	local pirate = SurvivorVariant.find(loader, "Pirate")
	local acPirate = HiddenAchievement.new("Pirate", pirate)
	acPirate.sprite = Sprite.find("PirateIdle", "Starstorm")
	acPirate.requirement = 1
	acPirate.deathReset = true
	acPirate.description = "Loader: Beat the ethereal teleporter on Sunken Tombs."
	
	if not HiddenAchievement.isComplete(acPirate) then
		callback.register("onPlayerStep", function(player)
			if not net.online or net.localPlayer == player then
				if player:getSurvivor() == loader and runData.pendingEtheral and Stage.getCurrentStage() == stg.SunkenTombs then
					HiddenAchievement.increment(acPirate, 1)
				end
			end
		end)
	end
	
if not global.rormlflag.ss_disable_survivors then
-- Executioner
local executioner = Survivor.find("Executioner", "Starstorm")
	
	-- Templar
	local templar = SurvivorVariant.find(executioner, "Templar")
	local acTemplar = HiddenAchievement.new("Templar", templar)
	acTemplar.sprite = Sprite.find("TemplarIdle", "Starstorm")
	acTemplar.requirement = 1
	acTemplar.deathReset = true
	acTemplar.description = "Executioner: Enter The Unknown with a curse."
	
	if not HiddenAchievement.isComplete(acTemplar) then
		callback.register("onStageEntry", function()
			if Stage.getCurrentStage() == stg.Unknown then
				for _, player in ipairs(misc.players) do
					if not net.online or net.localPlayer == player then
						if player:getSurvivor() == executioner then
							for _, item in ipairs(itp.curse:toList()) do
								if player:countItem(item) > 0 then
									HiddenAchievement.increment(acTemplar, 1)
									break
								end
							end
						end
					end
				end
			end
		end)
	end

-- Baroness
local baroness = Survivor.find("Baroness", "Starstorm")
	
	-- Boaroness
	local boaroness = SurvivorVariant.find(baroness, "Boaroness")
	local acBoaroness = HiddenAchievement.new("Boaroness", boaroness)
	acBoaroness.sprite = Sprite.find("Boaroness_Idle", "Starstorm")
	acBoaroness.requirement = 1
	acBoaroness.deathReset = true
	acBoaroness.description = "Baroness: Collect a White Undershirt."
	
	if not HiddenAchievement.isComplete(acBoaroness) then
		callback.register("onItemPickup", function(item, player)
			if player:getSurvivor() == baroness and item:getItem() == it["WhiteUndershirt(M)"] then
				if not net.online or net.localPlayer == player then
					HiddenAchievement.increment(acBoaroness, 1)
				end
			end
		end)
	end

-- Knight
local knight = Survivor.find("Knight", "Starstorm")
	
	-- Crusader
	local crusader = SurvivorVariant.find(knight, "Crusader")
	local acCrusader = HiddenAchievement.new("Crusader", crusader)
	acCrusader.sprite = Sprite.find("Crusader_Idle", "Starstorm")
	acCrusader.requirement = 1
	acCrusader.deathReset = true
	acCrusader.description = "Knight: Defeat Providence with the following items: Ol Lopper, BrilliantBehemoth, Repulsion Armor."
	
	if not HiddenAchievement.isComplete(acCrusader) then
		callback.register("onProvidenceDefeat", function(player)
			for _, player in ipairs(obj.P:findAll()) do
				if not net.online or player == net.localPlayer then
					if player:getSurvivor() == knight and player:countItem(it.TheOlLopper) > 0 and player:countItem(it.BrilliantBehemoth) > 0 and player:countItem(it.RepulsionArmor) > 0 then
						HiddenAchievement.increment(acCrusader, 1)
					end
				end
			end
		end)
	end
end
end




















































-- nope



















































-- too far

















































-- is this hell
























































--maybe












































































--awkward.

































