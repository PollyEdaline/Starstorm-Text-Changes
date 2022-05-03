-- All Settings Manager stuff (rulesets)
-- i hate my code for this, i cant add more categories without breaking everything
-- rewrite when???????????

global.rules = {
	{
		name = "Global",
		content = 
		{
			{displayName = "Difficulty Scaling", type = "choice", options = {0, 25, 50, 75, 100, 125, 150, 200, 500, 1000}, default = 100, suffix = "%", tooltip = "The rate at which the world's difficulty will increase."},
			{displayName = "Gravity", type = "choice", options = {0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5}, default = 1, suffix = "x", tooltip = "The fall acceleration affecting players and enemies."},
			{displayName = "Disable Water", type = "checkbox", default = false, tooltip = "Whether water is removed from stages."},
			{displayName = "Base Teleporter Charge Time", type = "choice", options = {15, 30, 60, 90, 120, 150, 180, 240, 300}, default = 90, suffix = "s", tooltip = "The base time required to fully charge the teleporter."},
			{displayName = "Bypass 'Kill Remaining Enemies'", type = "checkbox", default = false, tooltip = "Disable the requirement of killing all enemies before teleporting."},
			{displayName = "Head Start", type = "checkbox", default = false, tooltip = "Whether players start with items and added Difficulty."},
			{displayName = "Shared Items", type = "checkbox", default = false, tooltip = "[Multiplayer] Whether items are shared between players."},
			{displayName = "Item amount", type = "choice", options = {1, 2, 3, 4, 5, 10, 20, 50, 100, 150, 200}, default = 1, isSub = 6, tooltip = "The amount of starting items."},
			{displayName = "Shared Spawn", type = "checkbox", default = true, tooltip = "[Online Multiplayer] Whether players spawn together."},
			{displayName = "Added Difficulty", type = "choice", options = {0, 15, 30, 60, 120, 180, 240, 300, 360, 480, 600, 1200}, prefix = "+", suffix = "s", isSub = 6, default = 15, tooltip = "Added difficulty at beginning of the game."},
			{displayName = "Glass Opt-out", type = "checkbox", default = false, tooltip = "[Multiplayer] Whether players can individually opt-out of the Glass Artifact (if active)."},
			{displayName = "Boar Beach", type = "checkbox", default = true, tooltip = "Whether the Boar Beach stage can be entered."},
			{displayName = "Log Drops", type = "checkbox", default = true, tooltip = "Whether enemies can drop monster logs on death."},
			{displayName = "Artifact Pickups", type = "checkbox", default = true, tooltip = "Whether artifact pickups will be available."},
			{displayName = "Interactables", type = "checkbox", default = true, tooltip = "Whether chests, shrines and other map objects spawn naturally."},
			{displayName = "Base Interactable Cost", type = "choice", options = {0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 100, 200}, prefix = "$", default = 25, isSub = 15, tooltip = "The base scaling cost of chests, shrines, etc."},
			{displayName = "Barrels", type = "checkbox", default = true, isSub = 15, tooltip = "Whether barrels should spawn naturally."},
			{displayName = "Chests", type = "checkbox", default = true, isSub = 15, tooltip = "Whether chests should spawn naturally."},
			{displayName = "Shrines", type = "checkbox", default = true, isSub = 15, tooltip = "Whether shrines should spawn naturally."},
			{displayName = "Drones", type = "checkbox", default = true, isSub = 15, tooltip = "Whether drones should spawn naturally."},
			{displayName = "Teleporters", type = "checkbox", default = true, isSub = 15, tooltip = "Whether teleporters should spawn naturally."},
			{displayName = "Use Item Timeout", type = "checkbox", default = false, tooltip = "Whether Use items despawn after 45 seconds."},
			{displayName = "Item Blacklist", type = "submenu", page = 3, default = {}, tooltip = "Select items to disable from spawning in the run."},
			{displayName = "Reroll Blacklist Tiers", type = "checkbox", default = true, isSub = 23, tooltip = "Whether blacklisted items reroll into other tiers when the entire tier is disabled."},
			{displayName = "Eggplants", type = "checkbox", default = false, isSub = 23, tooltip = "Whether empty item tiers spawn eggplants."},
			{displayName = "Artifact of Sacrifice Drones", type = "checkbox", default = true, tooltip = "Whether drones will spawn with the Artifact of Sacrifice."}
		}
	},
	{
		name = "Players",
		content = 
		{
			{displayName = "Initial HP", type = "choice", options = {0.1, 1, 10, 100, 200, 500, 1000}, default = 100, suffix = "%", tooltip = "The amount of health players begin with."},
			{displayName = "HP Multiplier", type = "choice", options = {0.1, 0.25, 0.5, 0.75, 1, 1.5, 2, 5, 10, 25, 50, 100}, default = 1, suffix = "x", tooltip = "The amount health is multiplied by at all times."},
			{displayName = "Initial Regeneration", type = "choice", options = {0, 10, 50, 100, 150, 200, 500, 1000, 10000}, default = 100, suffix = "%", tooltip = "The amount of health regeneration players begin with."},
			{displayName = "HP Cap", type = "choice", options = {1, 99, 999, 9999, 99999, math.huge}, default = 9999, tooltip = "The maximum amount of health obtainable."},
			{displayName = "Initial Speed", type = "choice", options = {0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5}, default = 1, suffix = "x", tooltip = "The speed of horizontal movement players begin with."},
			{displayName = "Initial Gold", type = "choice", options = {0, 5, 15, 25, 50, 100, 200, 500, 1000}, default = 15, prefix = "$", tooltip = "The amount of gold players begin with."},
			{displayName = "Initial Jump Height", type = "choice", options = {0.85, 1, 1.25, 1.5, 2, 3, 4}, default = 1, suffix = "x", tooltip = "The speed of vertical movement players begin with."},
			{displayName = "Initial Damage", type = "choice", options = {0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5, 10, 50, 100}, default = 1, suffix = "x", tooltip = "The amount of damage players deal on start."},
			{displayName = "Initial Attack Speed", type = "choice", options = {0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5}, default = 1, suffix = "x", tooltip = "The speed of attacks players begin with."},
			{displayName = "Initial Critical Strike Chance", type = "choice", options = {0, 1, 5, 10, 25, 50, 75, 100}, default = 1, suffix = "%", tooltip = "The chance for critical strikes on start."},
			{displayName = "Initial Armor", type = "choice", options = {-500, -100, -50, -25, 0, 25, 50, 100, 500}, default = 0, sign = true, tooltip = "The amount of additional armor players begin with."},
			{displayName = "Skill Cooldowns", type = "choice", options = {1, 25, 50, 75, 100, 125, 150, 175, 200, 250}, default = 100, suffix = "%", tooltip = "The time it takes for skills to become usable after activation."},
			{displayName = "Level Up Auto-Balance", type = "checkbox", default = true, tooltip = "[Multiplayer] Whether dead players automatically level up to stay scaled."},
			{displayName = "Leveling Bias", type = "choice", options = {"Below Average", "Average", "Above Average", "Highest"}, default = "Average", isString = true, isSub = 13, tooltip = "Defines how dead players level up on revival.\nBelow Average: Level is based on the lower average level of all players.\nAverage: Level is based on the average level of all players.\nAbove Average: Level is based on the higher average level of all players.\nHighest: Level is based on the highest leveled player in the team."},
			{displayName = "PVP", type = "checkbox", default = false, tooltip = "[Multiplayer] Whether players can damage each other."},
			{displayName = "Versus Mode", type = "checkbox", default = false, tooltip = "[Multiplayer] Whether players have to compete against each other."},
			{displayName = "Teams", type = "choice", isString = true, options = {"Free for All", "2 Teams", "3 Teams", "4 Teams", "5 Teams", "6 Teams"}, default = "Free for All", isSub = 16, tooltip = "[Multiplayer] Decides how players are grouped."},
			{displayName = "Objective", type = "choice", isString = true, options = {"Last Standing", "5 Kills", "10 Kills", "15 Kills", "20 Kills", "50 Kills", "100 Kills"}, default = "Last Standing", isSub = 16, tooltip = "[Multiplayer] The game's objective to win."},
			{displayName = "Drop Items on Disconnect", type = "checkbox", default = true, tooltip = "[Online Multiplayer] Whether players drop all their items when disconnecting."},
			{displayName = "Low Health Warning", type = "checkbox", default = true, tooltip = "[Online Multiplayer] Whether other players display a warning at low health."}
		}
	},
	{
		name = "Enemies",
		content = 
		{
			{displayName = "HP", type = "choice", options = {0.01, 0.1, 1, 10, 50, 100, 150, 200, 500, 1000, 10000}, default = 100, suffix = "%", tooltip = "The health enemies have on spawn."},
			{displayName = "Speed", type = "choice", options = {0, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 5}, default = 1, suffix = "x", tooltip = "The horizontal speed enemies move at."},
			{displayName = "Spawn Rate", type = "choice", options = {0, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5, 10}, default = 1, suffix = "x", tooltip = "The frequency of natural enemy spawns."},
			{displayName = "Director Budget", type = "choice", options = {0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5, 10, 100}, default = 1, suffix = "x", tooltip = "The amount of points the director earns to spawn enemies, more means stronger enemy types"},
			{displayName = "Can Jump", type = "choice", options = {"None", "Classic", "All"}, default = "Classic", isString = true, tooltip = "Determines the enemies that can jump over ledges."},
			{displayName = "Jump Height", type = "choice", options = {0.85, 1, 1.25, 1.5, 2, 5, 10}, default = 1, suffix = "x", tooltip = "The speed at which enemies jump, if applicable."},
			{displayName = "High Difficulty Elite Attacks", type = "checkbox", default = true, tooltip = "Whether elite enemies can do special attacks on Monsoon and Typhoon."},
			{displayName = "Damage", type = "choice", options = {0.01, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5, 10, 50, 100, 1000}, default = 1, suffix = "x", tooltip = "The amount of damage enemies deal."},
			{displayName = "Critical Strike Chance", type = "choice", options = {0, 1, 5, 10, 25, 50, 75, 100}, default = 0, prefix = "+", suffix = "%", tooltip = "The added chance for dealing critical strikes."},
			{displayName = "Armor", type = "choice", options = {-1000, -500, -100, -50, -25, 0, 25, 50, 100, 500, 1000}, default = 0, sign = true, tooltip = "The amount of added armor enemies have on spawn."},
			{displayName = "Worth Value", type = "choice", options = {0, 25, 50, 75, 100, 125, 150, 175, 200, 500, 1000}, default = 100, suffix = "%", tooltip = "The base value in experience and gold enemies are worth."},
		}
	},
	{
		name = "Misc",
		content = 
		{
			{displayName = "Show HUD", type = "checkbox", default = true, tooltip = "Whether to show the Heads Up Display."},
			{displayName = "Show Gold", type = "checkbox", default = true, isSub = 1, tooltip = "Whether to show the gold counter on the screen."},
			{displayName = "Show Items", type = "checkbox", default = true, isSub = 1, tooltip = "Whether to show the collected items on the screen."},
			{displayName = "Show Time", type = "checkbox", default = true, isSub = 1, tooltip = "Whether to show the time counter on the screen."},
			{displayName = "Show Skills", type = "checkbox", default = true, isSub = 1, tooltip = "Whether to show the skills on the screen."},
			{displayName = "Show '56 Leaf Clover' Percentage", type = "checkbox", default = false, isSub = 1, tooltip = "Whether to show the stacked percentage of '56 Leaf Clover's effect."},
			{displayName = "Screen Shake Multiplier", type = "choice", options = {0, 0.5, 1, 2, 5, 10}, default = 1, prefix = "x", tooltip = "The intensity of the screen shake effect."},
			{displayName = "Screen Flashes", type = "checkbox", default = true, tooltip = "Whether screen flash effects occur."},
			{displayName = "Ruleset Icon", type = "submenu", page = 4, default = 1, tooltip = "Select an icon to identify this ruleset."},
		}
	},
	{
		name = "Starstorm",
		content = 
		{
			{displayName = "Events", type = "checkbox", default = true, tooltip = "Whether random world events occur."},
			{displayName = "New Elites", type = "checkbox", default = true, tooltip = "Whether Weakening, Dazing and Poisoning elites spawn."},
			{displayName = "Event Rate", type = "choice", options = {0.1, 0.25, 0.5, 1, 1.5, 2, 5, 10}, default = 1, suffix = "x", isSub = 1, tooltip = "The frequency of world events."},
			{displayName = "Ethereal Teleporters", type = "checkbox", default = true, tooltip = "Whether Ethereal Teleporters Spawn Naturally."},
			{displayName = "Event Intensity", type = "choice", options = {0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 5, 10}, default = 1, suffix = "x", isSub = 1, tooltip = "The multiplier for the effect events will have."},
			{displayName = "Ultra Enemies", type = "checkbox", default = true, tooltip = "Whether Ultra enemies can be created."},
			{displayName = "Stats Menu", type = "checkbox", default = true, tooltip = "Whether the Stats menu (Binded to Tab by default) can be used."},
			{displayName = "Ultras Before Ethereal", type = "checkbox", default = false, isSub = 6, tooltip = "Whether Ultra enemies can spawn before activating an Ethereal Teleporter."},
			{displayName = "Stackable Unstackables", type = "checkbox", default = true, tooltip = "Whether Red Whip and Dio's Friend can be stacked."},
			{displayName = "Ultra Spawn Rate", type = "choice", options = {0, 0.25, 0.5, 1, 1.5, 2, 5, 10, 50, 100, 1000}, default = 1, suffix = "x", isSub = 6, tooltip = "The frequency of Ultra enemy spawns."},
			{displayName = "New Interactables", type = "checkbox", default = true, tooltip = "Whether Starstorm's new interactables can spawn naturally."},
			{displayName = "Providence Rework", type = "checkbox", default = true, tooltip = "Whether the Providence Rework is enabled.\nThis naturally makes Providence a higher threat during the final battle."},
			{displayName = "Relic Shrines", type = "checkbox", default = true, isSub = 11, tooltip = "Whether Relic Shrines can spawn naturally."},
			{displayName = "Glass Rebalance", type = "checkbox", default = true, tooltip = "Whether the Artifact of Glass rebalance for Infusion, Ceremonial Dagger and drones is enabled."},
			{displayName = "Activators", type = "checkbox", default = true, isSub = 11, tooltip = "Whether 'Activator' interactables spawn naturally."},
			{displayName = "Soundtrack Remix", type = "checkbox", default = true, tooltip = "Whether the remixed soundtrack will be played."},
			{displayName = "Shrines of Trial", type = "checkbox", default = true, isSub = 11, tooltip = "Whether Shrines of Trial spawn naturally."},
			{displayName = "Story Dialogue", type = "checkbox", default = false, tooltip = "[Singleplayer] Whether dialogue textboxes appear during the game."},
			{displayName = "Broken Escape Pods", type = "checkbox", default = true, isSub = 11, tooltip = "Whether Broken Escape Pods spawn naturally."},
			{displayName = "New Stages", type = "checkbox", default = true, tooltip = "Whether new stages are eligible by the game."},
			{displayName = "Sword Shrines", type = "checkbox", default = true, isSub = 11, tooltip = "Whether Sword Shrines spawn naturally."},
			{displayName = "Void Portals", type = "checkbox", default = true, isSub = 20, tooltip = "Whether Void Portals can spawn naturally."}, --22
			{displayName = "Refabricators", type = "checkbox", default = true, isSub = 11, tooltip = "Whether Refabricators spawn naturally."},
			{displayName = "Void Hideout", type = "checkbox", default = true, isSub = 22, tooltip = "Whether Void Hideout Portals can spawn naturally after Ethereal teleporters charge."},
			{displayName = "Void Catalysts", type = "checkbox", default = true, isSub = 22, tooltip = "Whether Void Catalysts spawn naturally, allowing you to reach the Void Gates."},
			{displayName = "Void Portal Spawn Rate", type = "choice", options = {0.1, 0.25, 0.5, 1, 1.5, 2, 5, 10, 50, 75, 100}, default = 1, suffix = "x", isSub = 22, tooltip = "Controls how early a Void Portal can spawn."},
			{displayName = "Portal Arrows", type = "checkbox", default = false, isSub = 22, tooltip = "Whether an arrow pointing towards existing Void and Void Hideout portals is displayed."},
			{displayName = "Relic of Extinction Friendly Fire", type = "checkbox", default = false, tooltip = "Whether allies receive damage from the relic of Extinction."}
		}
	},
	--[[{
		name = "Other Mods",
		content = 
		{
			{displayName = "Useless Test", type = "choice", options = {"ah", "oh"}, isString = true, default = "oh", tooltip = "debug."},
		}
	},]]
}

--local addedRules = {}

local id = 1

export("Rule")
function Rule.new(name)
	if type(name) == "string" then
		local newRule = {displayName = name, type = "checkbox", default = true, id = id}
		
		id = id + 1
		
		if not global.rules[6] then
			global.rules[6] = {
				name = "Other Mods",
				content = {}
			}
		end		
		
		local category = global.rules[6]
		
		table.insert(category.content, newRule)
		
		return category.content[#category.content]
	else
		error("string expected, got "..type(name), 2)
	end
end

function Rule.find(name, category)
	if type(name) == "string" then
		if category then
			if type(category) == "string" then
				for _, c in ipairs(global.rules) do
					if string.lower(c.name) == string.lower(category) then
						for _, rule in ipairs(c.content) do
							if rule.displayName == name then
								return rule
							end
						end
					end
				end
			else
				error("Argument 2: string expected, got "..type(category), 2)
			end
		else
			for _, c in ipairs(global.rules) do
				for _, rule in ipairs(c.content) do
					if rule.displayName == name then
						return rule
					end
				end
			end
		end
	else
		error("Argument 1: string expected, got "..type(name), 2)
	end
end

function Rule.getSetting(rule)
	if type(rule) == "table" and rule.displayName ~= nil and rule.type ~= nil then -- It's not an actual class, I'm such a cheater :(
		local ruleset = global.activeRules
		
		if ruleset and global.activeRuleset ~= 1 and not net.online or net.online and ruleset then
			local cindex = 0
			local rindex = 0
			local found = false
			
			for cc, c in ipairs(global.rules) do
				for rr, r in ipairs(c.content) do
					if r.id == rule.id then
						cindex = cc
						rindex = rr
						found = true
						break
					end
				end
			end
			
			if found and cindex > 0 and rindex > 0 and ruleset[cindex][rindex] ~= nil then
				return ruleset[cindex][rindex]
			else
				return rule.default
			end
		else
			return rule.default
		end
		
	else
		error("Rule expected, got "..type(rule), 2)
	end
end


local icons = {spr.EfBlank}
for i = 1, 26 do
	table.insert(icons, Sprite.load("RulesetIcon"..i, "Misc/Menus/icons/icon"..i, 1, 15, 0))
end

local customIcons = require("Misc.Menus.icons.customIcons")
if customIcons then
	for _, name in ipairs(customIcons) do
		if name ~= "" then
			table.insert(icons, Sprite.load("CustomIcon"..name, "Misc/Menus/icons/"..name..".png", 1, 14, 0))
		end
	end
end

local sprLock = Sprite.load("RuleLock", "Misc/Menus/ruleLock.png", 1, 9, 9)


local items = {}
local itemAchievements = global.itemAchievements
local itemPools = {}

global.currentlyRemovedItems = {}

global.activeRules = nil

local onlineRuleset = nil

function resetOnlineRuleset()
	onlineRuleset = {
		name = "Online",
		rules = {
		{}, {}, {}, {}, {}, {},
		},
		icon = icons[1]
	}

	for c, category in ipairs(global.rules) do
		if not onlineRuleset.rules[c] then
			onlineRuleset.rules[c] = {}
		end
		for s, setting in ipairs(category.content) do
			if not onlineRuleset.rules[c][s] then
				--onlineRuleset.rules[c][s] = global.rules[c].content[s].default
			end
		end
	end
	global.activeRules = onlineRuleset.rules
end

resetOnlineRuleset()

local syncResetRuleset = net.Packet.new("SSResetRuleset", function(player)
	resetOnlineRuleset()
end)

local syncBlacklistItem = net.Packet.new("SSSettingBlacklistItem", function(player, item)
	if item then
		if not onlineRuleset.rules[1][23] then
			onlineRuleset.rules[1][23] = {}
		end
		table.insert(onlineRuleset.rules[1][23], item)
		debugPrint("received blacklist item: "..item.displayName)
	end
end)

local syncRule = net.Packet.new("SSSettingRule", function(player, category, rule, value)
	debugPrint("Syncing "..category.." "..rule.." "..tostring(value))
	if not onlineRuleset.rules[category] then
		onlineRuleset.rules[category] = {}
	end
	onlineRuleset.rules[category][rule] = value
end)

local function syncRuleset(ruleset)
	syncResetRuleset:sendAsHost(net.ALL, nil)
	for c, category in ipairs(ruleset.rules) do
		for s, setting in pairs(category) do
			if c == 1 and s == 23 then 
				for i, item in pairs(setting) do
					syncBlacklistItem:sendAsHost(net.ALL, nil, item)
				end
			else
				debugPrint(c, s, tostring(setting))
				syncRule:sendAsHost(net.ALL, nil, c, s, setting)
			end
		end
	end
end

global.rulesets = {
	{
		name = "Default",
		rules = {
		{}, {}, {}, {}, {}, {},
		},
		icon = icons[1]
	}
}

for i = 1, 10 do
	local nameString = "Empty Slot"
	table.insert(global.rulesets, {name = nameString, rules = {}, icon = icons[1]})
end 

local itemExceptions = {it.Eggplant, it.ArtifactofEnigma, it.ActiveCarraraMarble, it.SmallEnigma, it.PaulTape, it.PeculiarRock, it.GildedOrnament, it.DivineRight, it.DummyItem, it.BlackMarketContact, it.VoidKey}
if not save.read("defeatedArraign") then
	table.insert(itemExceptions, it.Deicide)
end
if Item.find("Relic of uuuh") then
	table.insert(itemExceptions, Item.find("Relic of uuuh"))
end
for _, item in ipairs(itp.curse:toList()) do
	table.insert(itemExceptions, item)
end

local statBlacklist = {
	[obj.LizardFG] = true,
	[obj.LizardF] = true
}

callback.register("postLoad", function()
	for _, item in ipairs(Item.findAll()) do
		if not contains(itemExceptions, item) then
			table.insert(items, item)
		end
	end
	for _, itemPool in ipairs(ItemPool.findAll()) do
		if itemPool ~= itp.npc and itemPool ~= itp.curse then
			table.insert(itemPools, itemPool)
		end
	end
	for iter2 = 1, #items do
		local sort_func = function( a,b ) return getRarityString(a) < getRarityString(b) end
		table.sort(items, sort_func)
	end
	
	local savedRulesetSel = save.read("savedRuleset")
	
	if savedRulesetSel then
		global.activeRuleset = savedRulesetSel
	end
	
	for rs = 1, 10 do
		local ruleset = global.rulesets[rs + 1]
		
		local rulesetSave = save.read("ruleset_"..rs)
		
		if rulesetSave then
			if type(rulesetSave) == "string" then
				ruleset.name = rulesetSave
			else
				ruleset.name = "Ruleset "..rs
			end
			
			debugPrint("Loaded Ruleset: "..rs)
		
			local iconSave = save.read(rs.."_icon")
			
			if iconSave then
				ruleset.icon = icons[iconSave]
			end
			
			local savedRulesString = save.read(rs.."_rules")
			
			if savedRulesString then
				local savedRules = {}
				local temp = {}
				
				--debugPrint(savedRulesString)
				for str in string.gmatch(savedRulesString, "([^".."/".."]+)") do
					str = string.sub(str, 2)
					table.insert(temp, str)
				end
				--debugPrint(temp)
				
				for s, strr in ipairs(temp) do
					savedRules[s] = {}
					for str in string.gmatch(strr, "([^".."&&".."]+)") do
						local tt = {}
						for str2 in string.gmatch(str, "([^".."=".."]+)") do
							table.insert(tt, str2)
						end
						if not (string.match(tt[2], "%a")) then
						  tt[2] = tonumber(tt[2])
						end
						if tt[2] == "inf" then tt[2] = math.huge end
						if tt[2] == "false" then tt[2] = false end
						if tt[2] == "true" then tt[2] = true end
						debugPrint("loaded: "..tt[1], tt[2], type(tt[2]))
						savedRules[s][tt[1]] = tt[2]
					end
				end
				--debugPrint(savedRules)
				
				for c, _ in ipairs(global.rules) do
					ruleset.rules[c] = {}
				end
				
				for c, category in ipairs(savedRules) do
					if global.rules[c] then
						local intCategory = global.rules[c].content
						
						for rule, ruleVal in pairs(category) do
							for r, intRule in ipairs(intCategory) do
								if rule == intRule.displayName then
									ruleset.rules[c][r] = ruleVal
								end
							end
						end
					end
				end
				
				local savedItemsString = save.read(rs.."_itemBlacklist")
				
				if savedItemsString then
					local savedItems = {}
					for str in string.gmatch(savedItemsString, "([^".."/".."]+)") do
						table.insert(savedItems, str)
					end
					
					for _, itemName in ipairs(savedItems) do
						for i, item in ipairs(items) do
							if itemName == item.displayName then
								if not ruleset.rules[1][23] then
									ruleset.rules[1][23] = {}
								end
								
								ruleset.rules[1][23][i] = item
							end
						end
					end
				end
				
			else -- removing old version's data
			
				for c, category in ipairs(global.rules) do
					for r, rule in pairs(category.content) do
						if c == 1 and r == 23 then
							for i, item in ipairs(items) do
								local ssave = save.read(rs.."_"..category.name.."_"..rule.displayName.."_"..item.displayName)
								if ssave ~= nil then
									debugPrint("Loaded Blacklist Item: "..item.displayName)
									
									if not ruleset.rules[c][r] then
										ruleset.rules[c][r] = {}
									end
									
									--table.insert(ruleset.rules[c][r], item)
									save.write(rs.."_"..category.name.."_"..rule.displayName.."_"..item.displayName, nil)
								end
							end
						else
							local ssave = save.read(rs.."_"..category.name.."_"..rule.displayName)
							if ssave ~= nil then
								debugPrint("Loaded Setting: "..rule.displayName)
								
								if not ruleset.rules[c] then
									ruleset.rules[c] = {}
								end
								
								--ruleset.rules[c][r] = save
								save.write(rs.."_"..category.name.."_"..rule.displayName, nil)
							end
						end
					end
				end
				
				local saveString = ""
				local saveStringItems = ""
				for c, category in ipairs(global.rules) do
					saveString = saveString.."c"
					for r, rule in pairs(category.content) do
						if not ruleset.rules[c] then
							ruleset.rules[c] = {}
						end
						local ruleVal = ruleset.rules[c][r]
						local categoryName = global.rules[c].name
						local ruleName = global.rules[c].content[r].displayName
						if ruleVal ~= nil then
							if type(ruleVal) == "table" then
								for i, item in ipairs(items) do
									saveStringItems = saveStringItems..item.displayName.."/"
								end
							elseif type(ruleVal) == "number" or type(ruleVal) == "string" or type(ruleVal) == "boolean" then
								if ruleVal ~= nil then
									saveString = saveString..ruleName.."="..tostring(ruleVal).."&&"
								end
							end
						end
					end
					if c < #global.rules then
						saveString = saveString.."/"
					end
				end
				
				if saveString == "" then saveString = nil end
				if saveStringItems == "" then saveStringItems = nil end
				save.write(rs.."_rules", saveString)
				save.write(rs.."_itemBlacklist", saveStringItems)
			end
			
			for c, category in ipairs(global.rules) do
			
				if not ruleset.rules[c] then
					ruleset.rules[c] = {}
				end
				
				for i, rule in ipairs(category) do
					if ruleset.rules[c][i] == nil then
					end
				end
			end
			
		end
	end
	local keys = save.getKeys("starstorm")
	--for _, v in ipairs(keys) do
	--	debugPrint(v, save.read(v))
	--end
end)

local currentRules = nil
local currentItemBlacklist = nil
local currentIcon = nil

local rulesetMenu = {}
rulesetMenu.page = 1
rulesetMenu.blacklistPage = 1
rulesetMenu.blacklistRowsPage = 1
--[[
	1 - Ruleset Selection
	-- Rules --
	2 - Content
	3 - Item Blacklist
	4 - Icons
]]

global.activeRuleset = 1
local currentlyEditing = nil

local selectedCategory = 1

local lastSentOnline = nil

local buttons = {}

local row = 1
local lastRow = 1
local sel = 1
local lastSel = 1
local hovering = nil

local tooltip = nil

local okButton = nil

local mx, my = nil
local lastMx, lastMy = nil

local oncooldown = false
local altControl = false

local function loadrules(ruleset)
	currentRules = table.clone(ruleset.rules)
	for c, category in ipairs(global.rules) do
		if currentRules[c] == nil then
			currentRules[c] = {}
		end
		
		for i, rule in ipairs(category.content) do
			if currentRules[c][i] == nil then
				currentRules[c][i] = rule.default
			end
		end
	end
end

local function saverules(ruleset)
	local crules = table.clone(currentRules)
	
	local rs = nil
	
	for c, category in ipairs(currentRules) do
	
		if not ruleset.rules[c] then
			ruleset.rules[c] = {}
		end
		
		for i, rule in ipairs(category) do
			if rule ~= global.rules[c].content[i].default then
				ruleset.rules[c][i] = rule
			else
				ruleset.rules[c][i] = nil
			end
		end
	end
	for r, rruleset in ipairs(global.rulesets) do
		if rruleset == ruleset then
			rs = r - 1
			ruleset.name = "Ruleset "..rs
			break
		end
	end 
	if currentRules[4][9] then
		ruleset.icon = icons[currentRules[4][9]]
	end
	
	currentRules = nil
	
	save.write("ruleset_"..rs, ruleset.name)
	debugPrint("Saved Ruleset: "..rs)
	
	if ruleset.icon == nil then
		ruleset.icon = icons[1]
	end
	
	if ruleset.icon ~= icons[1] then
		local iconIndex = nil
		
		for i, icon in ipairs(icons) do
			if icon == ruleset.icon then
				iconIndex = i
				break
			end
		end
		
		save.write(rs.."_icon", iconIndex)
		debugPrint("Saved Icon index: "..iconIndex)
	end
	
	local saveString = ""
	local saveStringItems = ""
	for c, category in ipairs(global.rules) do
		saveString = saveString.."c"
		for r, rule in pairs(category.content) do
			local ruleVal = ruleset.rules[c][r]
			local categoryName = global.rules[c].name
			local ruleName = global.rules[c].content[r].displayName
			
			if type(ruleVal) == "table" then
				for i, item in pairs(ruleVal) do
					saveStringItems = saveStringItems..item.displayName.."/"
				end
			elseif type(ruleVal) == "number" or type(ruleVal) == "string" or type(ruleVal) == "boolean" then
				if ruleVal ~= nil then
					saveString = saveString..ruleName.."="..tostring(ruleVal).."&&"
				end
			end
		end
		if c < #global.rules then
			saveString = saveString.."/"
		end
	end
	debugPrint(saveString)
	debugPrint(saveStringItems)
	
	if saveString == "" then saveString = nil end
	if saveStringItems == "" then saveStringItems = nil end
	save.write(rs.."_rules", saveString)
	save.write(rs.."_itemBlacklist", saveStringItems)
	
	global.activeRuleset = rs + 1
end
local function deleterules(ruleset, index)
	iindex = index - 1
	
	if global.activeRuleset == index then global.activeRuleset = 1 end
	
	if save.read("savedRuleset") == index then
		save.write("savedRuleset", 1)
	end
		
	save.write("ruleset_"..iindex, nil)
	debugPrint("Saved Ruleset: "..iindex)
	
	if ruleset.icon == nil then
		ruleset.icon = icons[1]
	end
	
	if ruleset.icon ~= icons[1] then
		local iconIndex = nil
		
		for i, icon in ipairs(icons) do
			if icon == ruleset.icon then
				iconIndex = i
				break
			end
		end
		
		save.write(iindex.."_icon", nil)
		debugPrint("Saved Icon index: "..iconIndex)
	end
	
	save.write(iindex.."_rules", nil)
	save.write(iindex.."_itemBlacklist", nil)
	
	table.remove(global.rulesets[index], rules)

	global.rulesets[index] = {name = "Empty Slot", rules = {}, icon = icons[1]}
end

callback.register("onGameStart", function()
	selectionMenu.onSubMenu = false
	rulesetMenu.page = 1
end)

local player = nil
local gamepad = nil

table.insert(call.onStep, function()
	if selectionMenu.active and selectionMenu.onSubMenu then
		local w, h = graphics.getGameResolution()
		
		hovering = nil
		
		for i, pplayer in ipairs(misc.players) do
			if net.online then
				if net.localPlayer == pplayer then
					player = pplayer
					break
				end
			else
				if i == 1 then
					player = pplayer
					break
				end
			end
		end
		
		gamepad = input.getPlayerGamepad(player)
		
		mx, my = input.getMousePos(true)
		
		if altControl then
			if mx ~= lastMx or my ~= lastMy then
				altControl = nil
			end
		end
		
		lastMx = mx
		lastMy = my
		
		if not oncooldown then
			if gamepad == nil then
				-- KEYBOARD
				if player:control("left") == input.HELD then
					sel = sel - 1
					altControl = true
				elseif player:control("right") == input.HELD then
					sel = sel + 1
					altControl = true
				end
				if player:control("up") == input.HELD then
					row = row - 1
					altControl = true
				elseif player:control("down") == input.HELD then
					row = row + 1
					altControl = true
				end
				if player:control("enter") == input.PRESSED then
					altControl = true
				end
			else
				
				-- DPAD
				if input.checkGamepad("padl", gamepad) == input.HELD  then
					sel = sel - 1
					altControl = true
				elseif input.checkGamepad("padr", gamepad) == input.HELD  then
					sel = sel + 1
					altControl = true
				end
				if input.checkGamepad("padu", gamepad) == input.HELD  then
					row = row - 1
					altControl = true
				elseif input.checkGamepad("padd", gamepad) == input.HELD  then
					row = row + 1
					altControl = true
				end
				-- L JOYSTICK
				if math.round(input.getGamepadAxis("lh", gamepad)) ~= 0 then
					sel = math.round(sel + 1 * input.getGamepadAxis("lh", gamepad))
					altControl = true
				end
				if math.round(input.getGamepadAxis("lv", gamepad)) ~= 0 then
					row = math.round(row + 1 * input.getGamepadAxis("lv", gamepad))
					altControl = true
				end
				if input.checkGamepad("face1", gamepad) == input.PRESSED then
					altControl = true
				end
			end
		end
		
		if lastRow ~= row then
			oncooldown = 12
			if rulesetMenu.page == 1 then
				sel = 1
			end
		end
		if lastSel ~= sel then
			oncooldown = 12
		end
		if oncooldown then
			if oncooldown > 0 then
				oncooldown = oncooldown - 1
			else
				oncooldown = nil
			end
		end

		if buttons then
			if row > #buttons then
				row = #buttons
			elseif row < 1 then
				row = 1
			end
			if buttons[row] then
				if sel > #buttons[row] then
					sel = #buttons[row]
				elseif sel < 1 then
					sel = 1
				end
			end
		end
		
		if altControl then
			hovering = true
		else
			for r, rrow in ipairs(buttons) do
				for b, button in ipairs(rrow) do
					if mx >= button.x1 and mx <= button.x2
					and my >= button.y1 and my <= button.y2 then
						row = r
						sel = b
						hovering = true
					end
				end
			end		
		end
		
		if buttons[row] and buttons[row][sel] and buttons[row][sel].tooltip then
			tooltip = buttons[row][sel].tooltip
		else
			tooltip = nil
		end
		
		lastSel = sel
		lastRow = row
		
		if altControl then
			if gamepad == nil then
				okButton = player:control("enter")
			else
				okButton = input.checkGamepad("face1", gamepad)
			end
		else
			okButton = input.checkMouse("left")
		end
		
		if okButton == input.PRESSED and hovering then
			if rulesetMenu.page == 1 then
				for i, ruleset in ipairs(global.rulesets) do
					if row == i then
						if sel == 1 then
							if #ruleset.rules ~= 0 then
								global.activeRuleset = i
							end
						elseif sel == 2 and row > 1 then
							row = 1
							sel = 1
							currentlyEditing = i
							rulesetMenu.page = 2
							loadrules(ruleset)
						elseif sel == 3 and row > 1 then
							deleterules(ruleset, i)
							debugPrint("deleted "..ruleset.name)
						end
					end
				end
				if row == #buttons then
					onHold = true
					selectionMenu.onSubMenu = false
					save.write("savedRuleset", global.activeRuleset)
					
					if net.online and net.host then
						if lastSentOnline and lastSentOnline ~= global.activeRuleset then
							syncResetRuleset:sendAsHost(net.ALL, nil)
						elseif not lastSentOnline then
							syncResetRuleset:sendAsHost(net.ALL, nil)
						end
						lastSentOnline = global.activeRuleset
						
						syncRuleset(global.rulesets[global.activeRuleset])
					end
					
				end
				
			elseif rulesetMenu.page == 2 then
				for c, category in ipairs(global.rules) do
					if row == 1 then
						if sel == c then
							selectedCategory = c
						end
					end
				end
				for i, setting in ipairs(global.rules[selectedCategory].content) do
					local rrow = math.floor(((i + 1) / 2))
					local column = 1
					if i % 2 == 0 then column = 2 end
					if rrow + 1 == row and sel == column then
						local parentRule = global.rules[selectedCategory].content[setting.isSub]
						local parentValue = currentRules[selectedCategory][setting.isSub]
						if type(parentValue) == "table" then
							local empty = true
							for _, _ in pairs(parentValue) do
								empty = false
								break
							end
							if empty then parentValue = false end
						end
						if parentRule and parentRule.isSub then
							local subSub = currentRules[selectedCategory][parentRule.isSub]
							if subSub == false then parentValue = false end
						end
						if not setting.isSub or setting.isSub and parentValue then
							if not setting.parentAchievement or setting.parentAchievement:isComplete() then
							local value = currentRules[selectedCategory][i]
							if setting.type == "choice" then
									local valid = false
									for o, option in ipairs(setting.options) do
										if option == value then
											if setting.options[o + 1] then
												currentRules[selectedCategory][i] = setting.options[o + 1]
											else
												currentRules[selectedCategory][i] = setting.options[1]
											end
											valid = true
											break
										end
									end
									if not valid then
										currentRules[selectedCategory][i] = setting.default
									end
								elseif setting.type == "checkbox" then
									if value == true then
										currentRules[selectedCategory][i] = false
									else
										currentRules[selectedCategory][i] = true
									end
								elseif setting.type == "submenu" then
									row = 1
									sel = 1
									rulesetMenu.page = setting.page
									if setting.page == 3 then
										if currentRules[1][23] == {} then
											currentItemBlacklist = {}
										else
											currentItemBlacklist = table.clone(currentRules[1][23])
										end
									elseif setting.page == 4 then
										local iconIndex = nil
										for i, icon in ipairs(icons) do
											if icon == global.rulesets[currentlyEditing].icon then
												iconIndex = i
												break
											end
										end
										currentIcon = iconIndex
									end
								end
							end
						end
					end
				end
				if row == #buttons then
					if sel == 1 then
						saverules(global.rulesets[currentlyEditing])
						currentRules = nil
						currentlyEditing = nil
						rulesetMenu.page = 1
					elseif sel == 2 then
						currentRules = nil
						currentlyEditing = nil
						rulesetMenu.page = 1
					end
				end
			elseif rulesetMenu.page == 3 then
				if row == 1 and rulesetMenu.blacklistPages > 1 then
					if sel == 1 then
						rulesetMenu.blacklistPage = rulesetMenu.blacklistPage - 1
					elseif sel == 2 then
						rulesetMenu.blacklistPage = rulesetMenu.blacklistPage + 1
					end
				elseif row == #buttons then
					if sel == 1 then
					
						row = 12
						sel = 1
						rulesetMenu.page = 2
						currentRules[1][23] = table.clone(currentItemBlacklist)
						currentItemBlacklist = nil
						
					elseif sel == 2 then
					
						local desel = false
						local blacklistedTotal = 0
						for i, item in ipairs(items) do
							for c, citem in pairs(currentItemBlacklist) do
								if item == citem then
									blacklistedTotal = blacklistedTotal + 1
									break
								end
							end
						end
						
						if blacklistedTotal == #items then
							desel = true
						end
						
						for i, item in ipairs(items) do
							if desel then
								currentItemBlacklist[i] = nil
							else
								currentItemBlacklist[i] = item
							end
						end
					end
					
				else
				
					local selItem = nil
					
					local xOffset = 16
					
					local itemSize = 32
					local itemsInRow = math.floor((w - xOffset * 2) / itemSize)
					
					local haspages = 0
					if rulesetMenu.blacklistPages > 1 then haspages = 1 end
					
					for i, item in ipairs(items) do
						local rrow = math.floor((i - 1) / itemsInRow)
						
						if math.ceil((rrow + 1) / rulesetMenu.blacklistRowsPage) ==  rulesetMenu.blacklistPage then
							local ii = (i - 1) % itemsInRow
							local rrrow = rrow % rulesetMenu.blacklistRowsPage
							
							if row == rrrow + 1 + haspages and sel == ii + 1 then
								selItem = {obj = item, index = i}
								break
							end
						end
					end
					if currentItemBlacklist[selItem.index] then
						currentItemBlacklist[selItem.index] = nil
					else
						currentItemBlacklist[selItem.index] = selItem.obj
					end
				end
				
			elseif rulesetMenu.page == 4 then

				if row == #buttons then
					if sel == 1 then
					
						row = 5
						sel = 2
						rulesetMenu.page = 2
						currentRules[4][9] = currentIcon
						currentIcon = nil
						
					end
					
				else
					
					local xOffset = 16
					
					local iconSize = 34
					local itemsInRow = math.floor((w - xOffset * 2) / iconSize)
					
					for i, icon in ipairs(icons) do
						local rrow = math.floor(((i - 1) / itemsInRow))
						local ii = (i - 1) % itemsInRow
						
						if row == rrow + 1 and sel == ii + 1 then
							currentIcon = i
							break
						end
					end
				end
				
			end
		elseif input.checkMouse("right") == input.PRESSED and hovering and rulesetMenu.page == 2 then
			for i, setting in ipairs(global.rules[selectedCategory].content) do
				local rrow = math.floor(((i + 1) / 2))
				local column = 1
				if i % 2 == 0 then column = 2 end
				if rrow + 1 == row and sel == column then
					local parentRule = global.rules[selectedCategory].content[setting.isSub]
					local parentValue = currentRules[selectedCategory][setting.isSub]
					if type(parentValue) == "table" then
						local empty = true
						for _, _ in pairs(parentValue) do
							empty = false
							break
						end
						if empty then parentValue = false end
					end
					if parentRule and parentRule.isSub then
						local subSub = currentRules[selectedCategory][parentRule.isSub]
						if subSub == false then parentValue = false end
					end
					if not setting.parentAchievement or setting.parentAchievement:isComplete() then
						if not setting.isSub or setting.isSub and parentValue then
							local value = currentRules[selectedCategory][i]
							if setting.type == "choice" then
								for o, option in ipairs(setting.options) do
									if option == value then
										if setting.options[o - 1] then
											currentRules[selectedCategory][i] = setting.options[o - 1]
										else
											currentRules[selectedCategory][i] = setting.options[#setting.options]
										end
										break
									end
								end
							end
						end
					end
				end
			end
			if row == #buttons then
				if sel == 1 then
					saverules(global.rulesets[currentlyEditing])
					currentRules = nil
					currentlyEditing = nil
					rulesetMenu.page = 1
				elseif sel == 2 then
					currentRules = nil
					currentlyEditing = nil
					rulesetMenu.page = 1
				end
			end
		end
	end
	if onHold then
		if altControl then
			if gamepad == nil then
				okButton = player:control("enter")
			else
				okButton = input.checkGamepad("face1", gamepad)
			end
		else
			okButton = input.checkMouse("left")
		end
		
		if okButton == input.HELD then
			onHold = false
		end
	end
end)

function drawStylizedRectangle(x1, y1, x2, y2, highlighted)
	local ol = 2 -- Outline
	
	local colors = nil
	
	if highlighted then
		colors = {Color.fromHex(0x674E4E), Color.fromHex(0x867272), Color.fromHex(0x5B4444)}
	else
		colors = {Color.fromHex(0x3A2C2C), Color.fromHex(0x5F5151), Color.fromHex(0x271D1D)}
	end
	
	graphics.color(colors[1])
	graphics.rectangle(x1 - ol, y1 - ol, x2 + ol, y2 + ol, false)
	graphics.color(colors[2])
	local mid = x1 + ((x2 - x1) / 2)
	graphics.triangle(x1 - ol - 1, y1 - ol - 1, x2 + ol + 0.5, y1 - ol - 1, mid, y2, false)
	graphics.color(colors[3])
	graphics.rectangle(x1, y1, x2, y2, false)
end

table.insert(call.onHUDDraw, function()
	if selectionMenu.active then
	
		local w, h = graphics.getGameResolution()
		local ww = w / 2
		
		if selectionMenu.onSubMenu then
			
			buttons = {}
			
			-- Background
			graphics.color(Color.BLACK)
			graphics.alpha(1)
			graphics.rectangle(0, 0, w, h, false)
			
			if rulesetMenu.page == 1 then
				local yOffset = 25

				-- Title
				graphics.alpha(1)
				graphics.color(Color.fromHex(0xEFD27B))
				graphics.print("RULESETS", ww, 20, 2, 1, 2)
				
				for i, ruleset in ipairs(global.rulesets) do
					local yy = i * 28
					if yy + yOffset + 20 > h - 50 then
						break
					end
					
					local xl = ww - 65
					local xr = ww + 65
					
					local padding = 4.5
					
					local hovered = false
					local highlighted = false
					
					buttons[i] = {}
					buttons[i][1]= {x1 = xl, y1 = yOffset + yy - 4, x2 = xr, y2 = yOffset + yy + 20 + 4}
					
					if i ~= 1 then
						buttons[i][2] = {x1 = xr, y1 = yOffset + yy - 4, x2 = xr + 50, y2 = yOffset + yy + 40 + 4}
						
						if #ruleset.rules > 0 then
						
							buttons[i][3] = {x1 = xr + 50, y1 = yOffset + yy - 4, x2 = xr + 50 + 55, y2 = yOffset + yy + 40 + 4}
						end
					end
					
					if row == i and hovering then
						hovered = true
					end
					if global.activeRuleset == i then
						highlighted = true
					end
					
					local alpha = 0.6
					if hovered or highlighted then
						alpha = 1
						
						if hovered then
							-- Backdrop
							graphics.alpha(0.15)
							graphics.color(Color.WHITE)
							graphics.rectangle(0, yOffset + yy - 2, w, yOffset + yy + 20 + 2)
							
							if ruleset ~= global.rulesets[1] then
								local alpha = 0.5
								if sel == 2 then
									alpha = 1
								end
								
								graphics.alpha(alpha)
								graphics.print("Edit", xr + padding * 3, yOffset + yy + padding, 2, 0, 0)
								
								if #ruleset.rules > 0 then
								
									local alpha = 0.5
									if sel == 3 then
										alpha = 1
									end
									
									graphics.color(Color.fromHex(0xED7B7B))
									graphics.alpha(alpha)
									graphics.print("Delete", xr + 50 + padding * 3, yOffset + yy + padding, 2, 0, 0)
								end
							end
						end
					end
					if #ruleset.rules == 0 then
						alpha = alpha - 0.4
					end
					
					-- Rectangle
					graphics.alpha(1)
					drawStylizedRectangle(xl, yOffset + yy, xr, yOffset + yy + 20, highlighted)
					
					-- Text
					graphics.color(Color.WHITE)
					graphics.alpha(alpha)
					graphics.print(ruleset.name, xl + padding, yOffset + yy + padding, 2, 0, 0)
					
					-- Icon
					if ruleset.icon then
						graphics.drawImage{
							image = ruleset.icon,
							x = xr - padding + 0.5,
							y = yOffset + yy + padding - 0.5,
							alpha = alpha
						}
					end
					
					if highlighted then
						-- Outline
						graphics.alpha(1)
						graphics.color(Color.WHITE)
						graphics.rectangle(xl - 2, yOffset + yy - 2, xr + 2, yOffset + yy + 20 + 2, true)
					end
				end
				
				-- Accept
				local yy = h - 50
				table.insert(buttons, {{x1 = 0, y1 = yy - 10, x2 = w, y2 = h}})
				
				local alpha = 0.5
				if row == #buttons and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				graphics.print("ACCEPT", ww, yy + 1, 2, 1, 0)
				
			elseif rulesetMenu.page == 2 then
				local yOffset = 25
				local xOffset = 16
				
				buttons = {}
				
				-- Title
				graphics.alpha(1)
				graphics.color(Color.fromHex(0xEFD27B))
				graphics.print("RULES", ww, 20, 2, 1, 2)
				
				buttons[1] = {}
				
				for c, category in ipairs(global.rules) do
				
					-- Title
					local spacing = (w / #global.rules)
					local www = (c - 1) * spacing - ((spacing / 2) * (#global.rules - 1))
					local title = category.name
					local color = Color.WHITE
					local highlighted = false
					local hovered = false
					
					if row == 1 and sel == c and hovering then
						hovered = true
					end

					if selectedCategory == c then
						highlighted = true
						color = Color.fromHex(0xEFD27B)
					end
					
					local halfSpacing = spacing / 2
					
					-- Button
					graphics.alpha(1)
					drawStylizedRectangle(ww + www - halfSpacing, yOffset, ww + www + halfSpacing - 4, yOffset + 9, highlighted)
					
					local alpha = 0.6
					if hovered or highlighted then alpha = 1 end
					graphics.color(color)
					graphics.alpha(alpha)
					graphics.print(string.upper(title), ww + www, yOffset + 1, 1, 1, 0)
					
					buttons[1][c] = {x1 = ww + www - halfSpacing, y1 = yOffset - 2, x2 = ww + www + halfSpacing, y2 = yOffset + 9 + 2}
					
					if selectedCategory == c then
						for i, setting in ipairs(global.rules[selectedCategory].content) do
							-- Setting
							local rrow = math.floor(((i + 1) / 2))
							local xx = xOffset
							local xxx = ww
							local yy = yOffset + rrow * 20
							local outOffset = 8
							local column = 1
							
							if i % 2 == 0 then
								column = 2
								xx = ww + xOffset
								xxx = w
							end
							
							if not buttons[rrow + 1] then
								buttons[rrow + 1] = {}
							end
							
							local tooltip = setting.tooltip
							if setting.parentAchievement and not setting.parentAchievement:isComplete() then
								tooltip = "&r&-LOCKED-&!&\n&w&"..setting.parentAchievement.description
							end
							
							buttons[rrow + 1][column] = {x1 = xx - outOffset, y1 = yy, x2 = xxx - outOffset, y2 = yy + 9 + outOffset, tooltip = tooltip}
							
							local alpha = 0.5
							if hovering and row == rrow + 1 and sel == column then
								alpha = 1
								graphics.alpha(0.15)
								graphics.color(Color.WHITE)
								graphics.rectangle(xx - outOffset, yy, xxx - outOffset, yy + 9 + outOffset, false)
							end
							
							if setting.isSub then
								xx = xx + 15
								local parentRule = global.rules[selectedCategory].content[setting.isSub]
								local parentValue = currentRules[selectedCategory][setting.isSub]
								if type(parentValue) == "table" then
									local empty = true
									for _, _ in pairs(parentValue) do
										empty = false
										break
									end
									if empty then parentValue = false end
								end
								if parentRule and parentRule.isSub then
									local subSub = currentRules[selectedCategory][parentRule.isSub]
									if subSub == false then parentValue = false end
								end
								
								if not parentValue then
									alpha = 0.25
								end
							end
							if setting.parentAchievement and not setting.parentAchievement:isComplete() then
								alpha = 0.25
							end
							
							graphics.alpha(alpha)
							graphics.color(Color.WHITE)
							graphics.print(setting.displayName, xx, yy + 5, 1, 0, 0)
							
							local value = currentRules[selectedCategory][i]
							
							local prefix = ""
							local suffix = ""
							local sign = ""
							
							if setting.prefix then
								prefix = setting.prefix
							end
							if setting.suffix then
								suffix = setting.suffix
							end
							if setting.sign then
								if value > 0 then
									sign = "+"
								end
							end
							
							if setting.type == "choice" then
								-- nice magic numbers, neik
								
								--local amount = (value / setting.options[#setting.options]) * 49
								
								local align = 1
								local xOffset2 = - 10
								
								if not setting.isString then
									local index = nil
									for v, vvalue in ipairs(setting.options) do
										if vvalue == value then
											index = v
											break
										end
									end
									if index == nil then
										index = 1
									end
									
									local amount = math.max(((index - 1) / (#setting.options - 1)) * 49, 1.5)
									
									graphics.line(xxx - outOffset - 35 - 1, yy + 10, xxx - outOffset - 85 + amount, yy + 10, 1)
									graphics.line(xxx - outOffset - 35, yy + 5, xxx - outOffset - 35, yy + 14, 1)
									graphics.rectangle(xxx - outOffset - 85, yy + 4.5, xxx - outOffset - 86.5 + amount , yy + 12.5, false)
								else
									align = 2
									xOffset2 = 0
								end
								
								graphics.print(prefix..sign..value..suffix, xxx - outOffset + xOffset2, yy + 5, 1, align, 0)
								
							elseif setting.type == "checkbox" then
								local subimg = 1
								local imgalpha = 1
								
								if value == true then
									subimg = 3
								else
									subimg = 1
								end
								
								if alpha == 1 then
									subimg = subimg + 1
								end
								
								if setting.isSub then
									local parentRule = global.rules[selectedCategory].content[setting.isSub]
									local parentValue = currentRules[selectedCategory][setting.isSub]
									if type(parentValue) == "table" then
										local empty = true
										for _, _ in pairs(parentValue) do
											empty = false
											break
										end
										if empty then parentValue = false end
									end
									if parentRule and parentRule.isSub then
										local subSub = currentRules[selectedCategory][parentRule.isSub]
										if subSub == false then parentValue = false end
									end
									
									if not parentValue then
										imgalpha = 0.25
									end
								end
								if setting.parentAchievement and not setting.parentAchievement:isComplete() then
									imgalpha = 0.25
								end
								
								graphics.drawImage{
									image = spr.Checkbox,
									x = xxx - 10 - outOffset,
									y = yy + 9,
									subimage = subimg,
									alpha = imgalpha
								}
							end
							if setting.parentAchievement and not setting.parentAchievement:isComplete() then
								local x = xx
								if setting.isSub then x = x - 7.5 end
								graphics.drawImage{
									image = sprLock,
									x = x + (((xxx - 10 - outOffset) - xx) / 2),
									y = yy + 9,
									subimage = 1,
									alpha = 1
								}
							end
						end
					end
				end
				
				-- Save
				local yy = h - 50
				local www = ww
				table.insert(buttons, {{x1 = 0, y1 = yy - 10, x2 = www, y2 = h}})
				
				local alpha = 0.5
				if row == #buttons and sel == 1 and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				graphics.print("SAVE", www - (ww / 2), yy + 1, 2, 1, 0)
				
				-- Cancel
				local wwww = w
				buttons[#buttons][2] = {x1 = www, y1 = yy - 10, x2 = wwww, y2 = h}
				
				local alpha = 0.5
				if row == #buttons and sel == 2 and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.fromHex(0xED7B7B))
				graphics.print("CANCEL", wwww - (ww / 2), yy + 1, 2, 1, 0)
				
			elseif rulesetMenu.page == 3 then
			
				-- Title
				graphics.alpha(1)
				graphics.color(Color.fromHex(0xEFD27B))
				graphics.print("ITEM BLACKLIST", ww, 20, 2, 1, 2)
				
				local yOffset = 25
				local xOffset = 16
				
				buttons = {}
				
				local itemSize = 32
				local halfisize = (itemSize / 2)
				local itemsInRow = math.floor((w - xOffset * 2) / itemSize)
				
				local blacklistedTotal = 0
				local deselAll = false
				
				local trows = math.ceil(#items / itemsInRow)
				
				local trowsh = trows * itemSize -- trowsh stands for total-rows-height ok? ok
				
				local icantcode = (h * 0.775) / itemSize
				
				rulesetMenu.blacklistPages = math.ceil(trows / icantcode)
				
				rulesetMenu.blacklistPage = math.clamp(rulesetMenu.blacklistPage, 1, rulesetMenu.blacklistPages)
				
				rulesetMenu.blacklistRowsPage = math.floor(icantcode)
				
				local haspages = 0
				if rulesetMenu.blacklistPages > 1 then
					haspages = 1
					
					-- Pages
					local boxSize = 20
					local hboxSize = 20 * 0.5
					local yy = 36
					local www = xOffset
					table.insert(buttons, {{x1 = www, y1 = yy - boxSize, x2 = www + boxSize, y2 = yy}, {x1 = www + 2 + boxSize, y1 = yy - boxSize, x2 = www + boxSize + 2 + boxSize, y2 = yy}})
					
					local alpha = 0.5
					if rulesetMenu.blacklistPage == 1 then  alpha = 0.25
					elseif row == 1 and sel == 1 and hovering then alpha = 1 end
					graphics.alpha(alpha)
					graphics.color(Color.WHITE)
					graphics.rectangle(www, yy - boxSize, www + boxSize, www + 2 + boxSize, true)
					graphics.print("<", xOffset + hboxSize, yy - hboxSize + 1, 2, 1, 1)
					
					alpha = 0.5
					if rulesetMenu.blacklistPage == rulesetMenu.blacklistPages then  alpha = 0.25
					elseif row == 1 and sel == 2 and hovering then alpha = 1 end
					graphics.alpha(alpha)
					graphics.color(Color.WHITE)
					graphics.rectangle(www + 2 + boxSize, yy - boxSize, www + boxSize + 2 + boxSize, www + 2 + boxSize, true)
					graphics.print(">", xOffset + hboxSize + 2 + boxSize, yy - hboxSize + 1, 2, 1, 1)
				end
				
				local rowsperpage = rulesetMenu.blacklistRowsPage
				
				for i, item in ipairs(items) do
					
					local rrow = math.floor((i - 1) / itemsInRow)
					--print(math.ceil((rrow + 1) / rowsperpage),  rulesetMenu.blacklistPage)
					if math.ceil((rrow + 1) / rowsperpage) ==  rulesetMenu.blacklistPage then
						
						local rrrow = rrow % rowsperpage -- AAAAAAA I AM SO DUMBBB
						
						local ii = (i - 1) % itemsInRow
						
						local hovered = false
						local alpha = 0.25
						local imgalpha = 1
						local image = item.sprite
						local tooltip = item.displayName
						
						if itemAchievements[item] and not itemAchievements[item]:isComplete() then
							image = spr.Random
							tooltip = "-LOCKED-"
						end
						
						if not buttons[rrrow + 1 + haspages] then
							buttons[rrrow + 1 + haspages] = {}
						end
						
						local itemX = xOffset + halfisize + (itemSize * ii)
						local itemY = yOffset + itemSize + (itemSize * rrrow)
						
						buttons[rrrow + 1 + haspages][ii + 1] = {x1 = itemX - halfisize, y1 = itemY - halfisize, x2 = itemX + halfisize, y2 = itemY + halfisize, tooltip = tooltip}
						
						if hovering and row == rrrow + 1 + haspages and sel == ii + 1 then
							hovered = true
						end
						
						local blacklisted = false
						
						for c, citem in pairs(currentItemBlacklist) do
							if item == citem then
								blacklistedTotal = blacklistedTotal + 1
								blacklisted = true
								break
							end
						end
						
						if blacklisted then
							imgalpha = 0.35
						end
						
						graphics.drawImage{
							image = image,
							x = itemX,
							y = itemY,
							subimage = 2,
							alpha = imgalpha
						}
						
						local o = 1 -- weird offset
						
						if hovered then
							alpha = 1
							o = 0
						end
						
						graphics.color(Color.WHITE)
						graphics.alpha(alpha)
						graphics.rectangle(itemX - halfisize + o, itemY - halfisize + o, itemX + halfisize - o, itemY + halfisize - o, true)
					end
				end
				
				-- Accept
				local yy = h - 50
				local www = ww
				table.insert(buttons, {{x1 = 0, y1 = yy - 10, x2 = www, y2 = h}})
				
				local alpha = 0.5
				if row == #buttons and sel == 1 and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				graphics.print("ACCEPT", www - (ww / 2), yy + 1, 2, 1, 0)
				
				-- Select / Deselect All
				
				if blacklistedTotal == #items then
					deselAll = true
				end
				
				local txt = "DISABLE ALL"
				
				if deselAll then
					txt = "ENABLE ALL"
				end
				
				local wwww = w
				buttons[#buttons][2] = {x1 = www, y1 = yy - 10, x2 = wwww, y2 = h}
				
				local alpha = 0.5
				if row == #buttons and sel == 2 and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				graphics.print(txt, wwww - (ww / 2), yy + 1, 2, 1, 0)
				
			elseif rulesetMenu.page == 4 then
			
				-- Title
				graphics.alpha(1)
				graphics.color(Color.fromHex(0xEFD27B))
				graphics.print("ICON SELECTION", ww, 20, 2, 1, 2)
				
				local yOffset = 25
				local xOffset = 16
				
				buttons = {}
				
				local iconSize = 34
				local halfisize = (iconSize / 2)
				local itemsInRow = math.floor((w - xOffset * 2) / iconSize)
				
				for i, icon in ipairs(icons) do
					local rrow = math.floor(((i - 1) / itemsInRow))
					local ii = (i - 1) % itemsInRow
					
					local hovered = false
					local alpha = 0.25
					local imgalpha = 0.4
					
					if not buttons[rrow + 1] then
						buttons[rrow + 1] = {}
					end
					
					local iconX = xOffset + halfisize + (iconSize * ii)
					local iconY = yOffset + iconSize + (iconSize * rrow)
					
					buttons[rrow + 1][ii + 1] = {x1 = iconX - halfisize, y1 = iconY - halfisize, x2 = iconX + halfisize, y2 = iconY + halfisize}
					
					if hovering and row == rrow + 1 and sel == ii + 1 then
						hovered = true
					end
					
					if i == currentIcon then
						imgalpha = 1
					end
					
					local iconimg = icon
					if icon == spr.EfBlank then
						graphics.color(Color.WHITE)
						graphics.alpha(imgalpha)
						graphics.print("NONE", iconX + 3, iconY - 3, 1, 1, 0)
					else
						graphics.drawImage{
							image = icon,
							x = iconX + halfisize - 1.5,
							y = iconY - halfisize + 2.5,
							scale = 2,
							alpha = imgalpha
						}
					end
					
					local o = 1 -- weird offset
					
					if hovered then
						alpha = 1
						o = 0
					end
					
					graphics.color(Color.WHITE)
					graphics.alpha(alpha)
					graphics.rectangle(iconX - halfisize + o, iconY - halfisize + o, iconX + halfisize - o, iconY + halfisize - o, true)
				end
				
				-- Accept
				local yy = h - 50
				table.insert(buttons, {{x1 = 0, y1 = yy - 10, x2 = w, y2 = h}})
				
				local alpha = 0.5
				if row == #buttons and sel == 1 and hovering then alpha = 1 end
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				graphics.print("ACCEPT", w - ww, yy + 1, 2, 1, 0)
			end
			
			-- Tooltips
			if hovering and tooltip then			
				local txt = tooltip
				local off = 2
				local off2 = 4
				local off3 = 6
				local twidth = graphics.textWidth(txt, graphics.FONT_DEFAULT)
				local theight = graphics.textHeight(txt, graphics.FONT_DEFAULT)
				local xx = 0
				local yy = 0
				
				if altControl then
					xx = math.min(buttons[row][sel].x1 + 2, w - twidth - 6)
					yy = buttons[row][sel].y2 + 3
				else	
					xx = math.min(mx + 10, w - twidth - 6)
					yy = my + 13
				end
				
				graphics.color(Color.fromHex(0x272626))
				graphics.alpha(1)
				graphics.rectangle(xx - off, yy - off, xx + twidth + off2, yy + theight + off2, false)
				graphics.color(Color.fromHex(0xFFECBF))
				graphics.alpha(0.8)
				graphics.printColor(txt, xx + off2, yy + off2 - 1, graphics.FONT_DEFAULT)
			end
		elseif net.online then
		
			if global.activeRules and showRuleset then
				local ruleStrings = {}
				--buttons = {{x1 = ww - 50, y1 = yy - 60, x2 = ww + 50, y2 = h - 20}}
				for c, category in ipairs(global.activeRules) do
					local categoryString = ""
					local categoryStrings = {}
					local contains = false
					
					for r, rule in pairs(category) do
						if rule ~= global.rules[c].content[r].default then
							if c == 4 and r == 9 then
								--pew
							else
								local ruleName = global.rules[c].content[r].displayName
								debugPrint(ruleName)
								local ruleVal = tostring(rule)
								local finalString = ""
								
								if type(rule) == "boolean" then
									if rule == true then
										finalString = ruleName
									else
										finalString = "No "..ruleName
									end
								elseif c == 1 and r == 23 then
									if #rule > 1 then
										finalString = ruleName..": "..#rule.." items"
									else
										finalString = ruleName..": "..#rule.." item"
									end
								else
									if global.rules[c].content[r].prefix then
										ruleVal = global.rules[c].content[r].prefix..ruleVal
									end
									
									if global.rules[c].content[r].suffix then
										ruleVal = ruleVal..global.rules[c].content[r].suffix
									end
									
									finalString = ruleVal.." "..ruleName
								end
								
								contains = true
								table.insert(categoryStrings, finalString)
							end
						end
					end
					
					if contains then
						local amount = 3
						
						for i = 1, math.ceil(#categoryStrings / amount) do
							if i > 1 then categoryString = categoryString..",\n" end
							categoryString = categoryString..table.concat(categoryStrings, ", ", (i * amount) - (amount - 1), math.min(i * amount, #categoryStrings))
						end
						
						table.insert(ruleStrings, string.upper(global.rules[c].name)..":\n"..categoryString)
					end
				end
				
				local finalString = ""
				
				if #ruleStrings > 0 then
					finalString = table.concat(ruleStrings, "\n")
				else
					finalString = "DEFAULT"
				end
				
				local strWidth = graphics.textWidth(finalString, 3) / 2
				local strHeight = graphics.textHeight(finalString, 3)
				
				graphics.alpha(0.75)
				graphics.color(Color.BLACK)
				graphics.rectangle(ww - strWidth, h - 70, ww + strWidth, h - 70 - strHeight, false)
				
				graphics.alpha(0.4)
				graphics.color(Color.WHITE)
				graphics.print(finalString, ww, h - 70, 3, 1, 2)
			end
		end
	end
	--debugPrint(global.rulesets[2])
	--debugPrint(row, sel)
end)

-- SETTING EFFECTS

-- GLOBAL
local awaitingFirstStep2 = true

local resetGlassOnEnd = false

local barrels = {obj.Barrel1, obj.Barrel2}
local chests = {obj.Chest1, obj.Chest2, obj.Chest3, obj.Chest4, obj.Chest5}
local shrines = {obj.Shrine1, obj.Shrine2, obj.Shrine3, obj.Shrine4, obj.Shrine5}
--local drones = {obj.Drone1Item, obj.Drone2Item, obj.Drone3Item, obj.Drone4Item, obj.Drone5Item, obj.Drone6Item, obj.Drone7Item}

local allInteractables = {}
--for _, i in ipairs(barrels) do table.insert(allInteractables, i) end
--for _, i in ipairs(chests) do table.insert(allInteractables, i) end
--for _, i in ipairs(shrines) do table.insert(allInteractables, i) end
--for _, i in ipairs(drones) do table.insert(allInteractables, i) end

callback.register("onGameStart", function()
	awaitingFirstStep2 = true
	
	for _, item in ipairs(global.currentlyRemovedItems) do
		item.pool:add(item.obj)
	end
	global.currentlyRemovedItems = {}
	allInteractables = {pobj.mapObjects}
end)

table.insert(call.postStep, function()
	if awaitingFirstStep2 then
		if net.online and net.host then
			syncRuleset(global.rulesets[global.activeRuleset])
		end
		awaitingFirstStep2 = false
	end
end)

callback.register("onGameEnd", function()
	if resetGlassOnEnd then
		ar.Glass.active = true
		resetGlassOnEnd = false
	end
end)

local syncSpawn = net.Packet.new("SSSettingPlayerSpawn", function(player, player, x, y)
	if player and player:resolve() then
		local playerInstance = player:resolve()
		playerInstance.x = x
		playerInstance.y = y  
	end
end)

local toDelete = {}

callback.register("onItemRoll", function(pool, item)
	if global.activeRules[1][23] then
		if global.activeRules[1][24] ~= false then
			local blacklist = global.activeRules[1][23]
			if item == it.Eggplant then
				if pool ~= itp.activator then
					local newItem = nil
					for _, itemPool in ipairs(itemPools) do
						if itemPool ~= pool then
							local poolList = itemPool:toList()
							local amount = #poolList
							if amount > 0 then
								newItem = itemPool:roll()
								break
							end
						end
					end
				end
				return newItem
			end
		end
	end
end)
it.Eggplant:getObject():addCallback("create", function(self)
	if global.activeRules[1][25] ~= true then
		self:destroy()
	end
end)

callback.register("onItemInit", function(item)
	if global.activeRules[1][22] ~= true then
		if item:get("is_use") then
			item:set("do_despawn", 0)
		end
	end
end)

callback.register("postSelection", function()
	toDelete = {}
	
	if global.activeRules[5][13] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.RelicShrine) 
	--else
		--table.insert(allInteractables, obj.RelicShrine)
	end
	if global.activeRules[5][15] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.Activator) 
	--else
		--table.insert(allInteractables, obj.Activator)
	end
	if global.activeRules[5][17] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.QuestShrine) 
	--else
		--table.insert(allInteractables, obj.QuestShrine)
	end
	if global.activeRules[5][19] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.EscapePod) 
	--else
		--table.insert(allInteractables, obj.EscapePod)
	end
	if global.activeRules[5][21] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.SwordShrine) 
	--else
		--table.insert(allInteractables, obj.SwordShrine)
	end
	if global.activeRules[5][23] == false or global.activeRules[5][11] == false then
		table.insert(toDelete, obj.Refabricator) 
	end
	if global.activeRules[5][25] == false or global.activeRules[5][20] == false then
		table.insert(toDelete, obj.VoidCatalyst) 
	end
	--table.insert(allInteractables, obj.Refabricator)
	
	if global.rormlflag.ss_disable_enemies or global.rormlflag.ss_stable then
		table.insert(toDelete, obj.mimicChest) 
	else
		table.insert(allInteractables, obj.mimicChest)
	end	
	
	if global.activeRules[1][23] then
		local blacklist = global.activeRules[1][23]
		
		for _, item in pairs(blacklist) do
			for _, itemPool in ipairs(itemPools) do
				if itemPool:contains(item) then
					table.insert(global.currentlyRemovedItems, {obj = item, pool = itemPool})
					itemPool:remove(item)
				end
			end
		end
	end
	
	if global.activeRules[1][11] and ar.Glass.active then
		local base = obj.Base:find(1)
		if base then
			obj.Deglassifier:create(base.x + 15, base.y)
		end
	end
	
	if global.activeRules[2][6] then
		local setting = global.activeRules[2][6]
		
		misc.setGold(setting)
	end
	
	if global.activeRules[5][2] ~= false then
		toggleElites(newBaseElites, true)
	else
		toggleElites(newBaseElites, false)
	end
	
	if #misc.players > 0 then
		if global.activeRules[2][15] or global.activeRules[2][16] then
			local pvp = global.activeRules[2][15]
			local versus = global.activeRules[2][16]
			local teams = "Free-For-All"
			
			if versus then
				teams = global.activeRules[2][17] or "Free-For-All"
			end
			
			if teams == "Free-For-All" then
				for i, player in ipairs(misc.players) do
					local team = i
					if net.online then team = player:get("m_id") end
					if pvp then
						player:set("team", "team "..team)
					end
					player:getData().versusTeam = team
				end
				global.teams = 0
			else
				local teamAmount = 2
				if teams == "3 Teams" then teamAmount = 3
				elseif teams == "4 Teams" then teamAmount = 4
				elseif teams == "5 Teams" then teamAmount = 5
				elseif teams == "6 Teams" then teamAmount = 6
				end
				
				global.teams = teamAmount
				
				--local playerAmount = math.floor(#misc.players / teamAmount)
				
				for i, player in ipairs(misc.players) do
					local index = i
					if net.online then index = player:get("m_id") end
					local team = math.ceil((index / #misc.players) * teamAmount)
					if pvp then
						player:set("team", "team "..team)
					end
					player:getData().versusTeam = team
				end
			end
		end
	end
end)

table.insert(call.preHUDDraw, function()
	if global.versus then
		teams = global.activeRules[2][17] or "Free-For-All"
		
		if teams ~= "Free-For-All" then
			for _, player in ipairs(misc.players) do
				local team = player:getData().versusTeam
				
				if team then
					local camx, camy = misc.camera.x, misc.camera.y
					
					local color = playerTeamColors[team]
					
					if player:get("dead") == 0 then
						if net.online then
							graphics.color(color)
							graphics.alpha(1)
							graphics.print(player:get("user_name"), math.round(player.x - camx + 1), math.round(player.y - camy + 9), 1, 1, valign)
						end
						if not player:getData().versusOutline or not player:getData().versusOutline:isValid() then
							local outline = obj.EfOutline:create(0, 0)
							outline:set("rate", 0)
							outline:set("parent", player.id)
							outline.blendColor = color
							outline.alpha = 0.9
							outline.depth = player.depth + 2
							player:getData().versusOutline = outline
						end
						
					elseif player:getData().versusOutline and player:getData().versusOutline:isValid() then
						player:getData().versusOutline:destroy()
					end
				end
			end
		end
	end
end)
table.insert(call.onHUDDraw, function()
	if global.versus then
		teams = global.activeRules[2][17] or "Free-For-All"
		
		if teams ~= "Free-For-All" then
			for _, player in ipairs(misc.players) do
				local team = player:getData().versusTeam
				
				if team then
					if player:get("dead") == 0 then
						
						graphics.color(playerTeamColors[team])
						
						if not onScreen(player) then
							local camera = misc.camera
							local camerax = misc.camera.x + (misc.camera.width / 2)
							local cameray = misc.camera.y + (misc.camera.height / 2)
							
							local w, h = graphics.getGameResolution()
							local sw, sh = Stage.getDimensions()
							local border = 8
							local ox, oy = player.x - camerax + (w * 0.5), player.y - cameray + (h * 0.5)
							local xx = math.clamp(ox, border, w - border)			
							local yy = math.clamp(oy, border, h - border)	
							
							local sprite = player:getAnimation("idle") or player.mask
							local size = sprite.height
							
							graphics.circle(xx, yy, 8, true)
							
							if txt then
								local border = 29
								local mid = graphics.textWidth(txt, graphics.FONT_SMALL) / 2
								local xx = math.clamp(ox, border + mid, w - (border + mid))			
								local yy = math.clamp(oy, border, h - border)
								graphics.print(txt, xx, yy, graphics.FONT_SMALL, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
							end
						end
						
					end
				end
			end
		end
	end
end)

callback.register("postSelection", function()
	for _, player in ipairs(misc.players) do
		syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "m_id", player:get("m_id"))
	end
end)

local npcDummies = {}
local versusData = {}
versusData.countDown = 0
versusData.winner = nil
versusData.displayPostGame = false
versusData.endType = 0
versusData.safeTime = 0
versusData.leaderBoard = {}
global.pvpKills = {}
local lastpvpKills = {}
local killDisplayTimer = 0
local killDisplayTimer2 = 0

local vState = {endRound = 1, endGame = 2}
local versusStates = {
	{
		
	},
	{
		
	}
}

table.insert(call.onStageEntry, function()
	versusData.countDown = 0
	versusData.winner = nil
	versusData.displayPostGame = false
	versusData.endType = 0
	versusData.leaderBoard = {}
	versusData.safeTime = 100
	global.pvpKills = {}
	lastpvpKills = {}
	
	for _, player in ipairs(misc.players) do
		player:set("hp", player:get("maxhp"))
		player:set("dead", 0)
	end
end)
callback.register("onGameEnd", function()
	versusData.displayPostGame = false
	versusData.endType = 0
	versusData.leaderBoard = {}
	global.pvpKills = {}
	lastpvpKills = {}
end)

table.insert(call.onPlayerStep, function(player)
	if global.pvp then
		if player:get("dead") == 1 then player:set("hp", player:get("maxhp")) end
		if versusData.safeTime >= 0 then
			player:set("invincible", versusData.safeTime)
		end
		
		if player:get("dead") == 0 then
			if versusData.safeTime <= 0 then
				player.mask = spr.PMask
				local child = player:getData()._pvpDummy
				if not child or not child:isValid() and player:get("invincible") <= 0 then
					player:getData()._pvpDummy = obj.actorDummy:create(player.x, player.y)
					player:getData()._pvpDummy:getData().parent = player
					npcDummies[player:getData()._pvpDummy.id] = player
				elseif child and child:isValid() then
					if misc.director:getAlarm(0) == 1 then
						if net.online and player == net.localPlayer then
							if net.host then
								syncInstanceVar:sendAsHost(net.ALL, nil, child:getNetIdentity(), "hp", child:get("hp"))
							else
								syncInstanceVar:sendAsClient(child:getNetIdentity(), "hp", child:get("hp"))
							end
						end
					end
				end
			end
		else
			player.mask = spr.Nothing
		end
	else
		if misc.director:getAlarm(0) == 1 and misc.director:get("time_start") % 1 == 0 then
			if net.online and player == net.localPlayer then
				if net.host then
					syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "hp", player:get("hp"))
				else
					syncInstanceVar:sendAsClient(player:getNetIdentity(), "hp", player:get("hp"))
				end
			end
		end
	end
end)
table.insert(call.onFire, function(damager)	
	if global.pvp then
		local tid = damager:get("specific_target")
		local tinst = npcDummies[tid]
		if tinst and tinst:isValid() then
			damager:set("specific_target", tinst.id)
		end
	end
end)
table.insert(call.preHit, function(damager, hit)
	if global.pvp then
		damager:getData().lastHit = hit
		local dummyPlayer = npcDummies[hit.id]
		if damager:getParent() == dummyPlayer or damager:getParent() == hit or hit:get("dead") == 1 or hit:getData().noDamage then
			damager:set("damage", 0)
		end
	end
end)
table.insert(call.onHit, function(damager, hit)
	local dummyPlayer = npcDummies[hit.id]
	if dummyPlayer and dummyPlayer:isValid() then
		--dummyPlayer:set("hp", hit:get("hp") - damager:get("damage"))
	end
end)

local vanillaProjectiles = {obj.CowboyDynamite, obj.HuntressBoomerang, obj.HuntressBolt1, obj.HuntressBolt2, obj.HuntressBolt3, obj.HuntressGrenade, obj.EngiGrenade, obj.EngiMine, obj.EngiHarpoon, obj.EngiTurret, obj.PoisonTrail, obj.RiotGrenade, obj.ConsRod, obj.JanitorBaby, obj.EfLantern, obj.EfMissile, obj.EfMissileSmall, obj.EfMissileMagic, obj.EfMissileBox, obj.EfSpikestrip, obj.EfBomb, obj.EfMine, obj.EfPoisonMine}
local specialProjectiles = {obj.HuntressBoomerang, obj.ChefKnife, obj.FeralDisease, obj.FeralDisease2, obj.EfSawmerang}
local vanillaChildren = {obj.ImpFriend, obj.EngiTurret, obj.JellyMissileFriendly, obj.DroneDisp, obj.Drone1, obj.Drone2, obj.Drone3, obj.Drone4, obj.Drone5, obj.Drone6, obj.Drone7}

local function endVersusRound()
	versusData.endType = vState.endRound
	versusData.countDown = 120
	versusData.displayPostGame = true
end

local function endVersusGame(winner)
	versusData.endType = vState.endGame
	versusData.countDown = 250
	if winner then
		if isa(winner, "ActorInstance") and winner:isValid() then
			if net.online then
				versusData.winner = winner:get("user_name")
			else
				versusData.winner = winner:get("name")
			end
		elseif type(winner) == "string" then
			versusData.winner = winner
		end
	else
		versusData.winner = nil
	end
	versusData.displayPostGame = true
	sfx.Shrine1:play()
end

local syncVersusState = net.Packet.new("SSVersus State", function(player, state, player)
	if state and player then
		local playerRes = nil
		if type(player) == "string" then
			if player ~= "Nothing" then
				playerRes = player
			end
		else
			playerRes = player:resolve()
		end
		if state == vState.endRound then
			endVersusRound()
		elseif state == vState.endGame then
			endVersusGame(playerRes)
		end
	end
end)

local function changeState(state, data)
	if state == vState.endRound then
		endVersusRound()
		if net.online then
			syncVersusState:sendAsHost(net.ALL, nil, vState.endRound, "Nothing")
		end
	elseif state == vState.endGame then
		endVersusGame(data)
		if net.online then
			local toSend = "Nothing"
			if data then
				if isa(data, "Instance") then
					toSend = data:getNetIdentity()
				else
					toSend = data
				end
			end
			syncVersusState:sendAsHost(net.ALL, nil, vState.endGame, toSend)
		end
	end
end

table.insert(call.onPlayerStep, function(player)
	if global.pvp and global.gamestarted then
		if versusData.displayPostGame and versusData.countDown <= 0 then
			player:getData().lastHit = nil
		end
		if net.online and player ~= net.localPlayer then
			player:set("name", player:get("user_name"))
		end
		--if player:get("")
		if player:getAlarm(7) > 60 then
			player:setAlarm(7, 60)
		end
		for _, object in ipairs(specialProjectiles) do
			for _, instance in ipairs(object:findAll()) do
				if instance:get("parent") and Object.findInstance(instance:get("parent")) and Object.findInstance(instance:get("parent")):get("team") ~= player:get("team") then
					if player:collidesWith(instance, player.x, player.y) and instance:get("parent") ~= player.id then
						--instance:set("rebound", player.id)
						--instance:set("target", player.id)
						if instance:get("parent") then
							local parent = Object.findInstance(instance:get("parent"))
							if parent and parent:isValid() then
								player:getData().lastHit = parent
							end
						end
						local dummyEnemy = obj.actorDummy:create(player.x, player.y)
						dummyEnemy:set("team", "enemy")
						dummyEnemy:getData().fake = true
						dummyEnemy:getData().life = 6
						if object == obj.FeralDisease or object == obj.FeralDisease2 then 
							dummyEnemy:getData().life = 220
						end
						dummyEnemy:getData().parent = player
						dummyEnemy:set("maxhp", player:get("maxhp"))
						dummyEnemy:set("hp", player:get("hp"))
						npcDummies[dummyEnemy.id] = player
						dummyEnemy:getData().initHp = player:get("hp")
					end
				end
			end
		end
	end
end)

local teamStrings = {"Red", "Blue", "Yellow", "Green", "Orange", "Purple"}

sur.Mercenary:addCallback("onSkill", function(player, skill, frame)
	if global.pvp and skill == 4 then
		
		if frame == 1 then
			for _, pplayer in ipairs(obj.P:findAllRectangle(player.x -100, player.y - 100, player.x + 100, player.y + 100)) do
				if pplayer:get("dead") == 0 and pplayer ~= player and pplayer:get("team") ~= player:get("team") then
					local dummyEnemy = obj.actorDummy:create(pplayer.x, pplayer.y)
					dummyEnemy:set("team", "enemy")
					dummyEnemy:getData().fake = true
					dummyEnemy:getData().life = 120
					dummyEnemy:getData().parent = pplayer
					dummyEnemy:set("maxhp", pplayer:get("maxhp"))
					dummyEnemy:set("hp", pplayer:get("hp"))
					npcDummies[dummyEnemy.id] = pplayer
					dummyEnemy:getData().initHp = pplayer:get("hp")
				end
			end
		end
	end
end)
sur.Sniper:addCallback("useSkill", function(player, skill)
	if global.pvp and skill == 4 then
		
		for _, pplayer in ipairs(obj.P:findAllRectangle(player.x -500, player.y - 500, player.x + 500, player.y + 500)) do
			if pplayer:get("dead") == 0 and pplayer ~= player then
				player:set("tskill_change", 1)
				local droneid = player:get("drone")
				local drone = Object.findInstance(droneid)
				if drone and drone:isValid() then
					drone:set("tt", pplayer.id)
				end
			end
		end
	end
end)
--[[
callback.register("onNPCDeath", function(npc)
	if npc and npc:isValid() and npc:getObject() == obj.actorDummy and npc:getData().parent and npc:getData().parent:isValid() and not npc:getData().fake then
		if npc:getData().parent:getData()._pvpDummy == npc then
			if versusData.safeTime <= 0 then
				--npc:getData().parent:kill()
			end
		end
	end
end)]]

callback.register("onDamage", function(target, damage, source)
	if global.pvp and source then
		local sparent = source
		if isa(source, "DamagerInstance") then source:getParent() end
		
		if target and sparent then
			if sparent == npcDummies[target.id] or sparent == target then
				return true
			end
		end
	end
end)

table.insert(call.postStep, function()
	if global.gamestarted then
		if versusData.safeTime > 0 then
			versusData.safeTime = versusData.safeTime - 1
		end
		
		if global.versus then
		
			if versusData.countDown > -1 then
				versusData.countDown = versusData.countDown - 1
			end
			if versusData.countDown == 0 then
				if versusData.endType == 1 then
					local tele = obj.Teleporter:find(1)
					if not tele then tele = obj.Teleporter:create(0, 0) end
					tele:set("active", 4)
					for _, player in ipairs(obj.P:findAll()) do
						player:set("ready", 1)
					end
				elseif versusData.endType == 2 then
					for _, player in ipairs(misc.players) do
						player:getData().lastHit = nil
						if player:get("dead") == 0 then
							player:kill()
						end
						--print("ENDTYPE")
					end
				end
			end
			
			local leaderBoard = {}
			
			local teams = global.activeRules[2][17] or "Free-For-All"
			
			local currentTeams = {}
			
			for _, player in ipairs(misc.players) do
				local val = nil
				if global.pvp then
					val = player:getData().totalPlayerKills
				else
					val = player:getData().totalKills
				end
				
				local name = ""
				if teams == "Free-For-All" then
					if net.online then
						name = player:get("user_name")
					else
						name = player:get("name")
					end
					
					table.insert(leaderBoard, {name = name, val = val})
				else
					if currentTeams[player:getData().versusTeam] then
						currentTeams[player:getData().versusTeam] = currentTeams[player:getData().versusTeam] + val
					else
						currentTeams[player:getData().versusTeam] = val
					end
				end
			end
			
			for team, points in pairs(currentTeams) do
				table.insert(leaderBoard, {name = teamStrings[team], val = points})
			end
			
			table.sort(leaderBoard, function(a, b) return a.val > b.val end)
			
			versusData.leaderBoard = leaderBoard
			
		end
		if #misc.players > 1 then
			if global.pvp then
				
				if #global.pvpKills > 0 and #global.pvpKills ~= #lastpvpKills then
					--if versusData.displayPostGame then
					--	global.pvpKills = {}
					--	for _, kill in ipairs(lastpvpKills) do
					--		table.insert(global.pvpKills, kill)
					--	end
					--else
						lastpvpKills = {}
						for _, kill in ipairs(global.pvpKills) do
							table.insert(lastpvpKills, kill)
						end
						killDisplayTimer = 100
						killDisplayTimer2 = 1200
					--end
				end
				if killDisplayTimer > 0 then
					killDisplayTimer = math.approach(killDisplayTimer, 0, (killDisplayTimer * 0.1) + 0.1)
				end
				if killDisplayTimer2 > 0 then
					killDisplayTimer2 = math.approach(killDisplayTimer2, 0, (killDisplayTimer2 * 0.03) + 0.1)
				end
				
				for _, object in ipairs(vanillaProjectiles) do
					for _, instance in ipairs(object:findAll()) do
						if not instance:getData().pvp_checked then
							local pid = instance:get("parent")
							if object == obj.FeralDisease or object == obj.FeralDisease2 then
								pid = instance:get("master")
							end
							local parent = nil
							if pid then
								parent = Object.findInstance(pid)
							else
								parent = obj.P:findNearest(instance.x, instance.y)
							end
							
							if parent and parent:isValid() then
								local target = instance:get("target")
								if target then
									instance:getData().pvp_checked = true
									local dummyParent = npcDummies[target]
									--print(dummyParent, target, npcDummies,  parent)
									--if dummyParent and dummyParent == parent then
										local nearestActor = nil
										for _, actor in ipairs(pobj.actors:findAll()) do
											if actor:get("team") ~= parent:get("team") and actor ~= parent:getData()._pvpDummy and actor ~= dummyParent then
												if not actor:get("dead") or actor:get("dead") == 0 then
													local dis = distance(instance.x, instance.y, actor.x, actor.y)
													if not nearestActor or dis < nearestActor.dis then
														nearestActor = {dis = dis, inst = actor}
													end
												end
											end
										end
										if nearestActor then
											if instance:get("targetx") then
												instance:set("targetx", nearestActor.x)
												instance:set("targety", nearestActor.y)
											end
											if object == obj.EngiHarpoon then
												if nearestActor.inst:get("dead") == 0 then
													local dummyEnemy = obj.actorDummy:create(nearestActor.inst.x, nearestActor.inst.y)
													dummyEnemy:set("team", "enemy")
													dummyEnemy:getData().fake = true
													dummyEnemy:getData().noDamage = true
													dummyEnemy:getData().life = 110
													dummyEnemy:getData().parent = nearestActor.inst
												end
											end
											instance:set("target", nearestActor.inst.id)
											if instance:get("target_x") then
												instance:set("target_x", nearestActor.inst.x)
												instance:set("target_y", nearestActor.inst.y)
											end
										end
									--end
								end
								instance:set("team", parent:get("team"))
							end
						end
					end
				end
				for _, object in ipairs(vanillaChildren) do
					for _, instance in ipairs(object:findAll()) do
						if object == obj.EngiTurret then instance.mask = spr.Nothing end
							
						local pid = instance:get("parent")
						if pid == nil then
							pid = instance:get("master")
						end
						local parent = nil
						if pid then
							parent = Object.findInstance(pid)
						end
						
						if parent and parent:isValid() then
							instance:set("team", parent:get("team"))
							local target = instance:get("target")
							
							if target then
								local dummyParent = npcDummies[target]
								--print(dummyParent, target, npcDummies,  parent)
								if dummyParent and dummyParent == parent then
									local nearestActor = nil
									for _, actor in ipairs(pobj.actors:findAll()) do
										if actor:get("team") ~= parent:get("team") and actor ~= parent:getData()._pvpDummy and actor ~= instance then
											local dis = distance(instance.x, instance.y, actor.x, actor.y)
											if not nearestActor or dis < nearestActor.dis then
												nearestActor = {dis = dis, inst = actor}
											end
										end
									end
									if nearestActor then
										instance:set("target", nearestActor.inst.id)
									end
								end
							end
						end
					end
				end
			end
			
			if global.versus and not versusData.displayPostGame then
				local objectiveRule = global.activeRules[2][18]
				local teams = global.activeRules[2][17] or "Free-For-All"
				
				local objectiveAmount = 0
				if objectiveRule == "Last Standing" then
					objectiveAmount = 0
				elseif objectiveRule == "5 Kills" then
					objectiveAmount = 5
				elseif objectiveRule == "10 Kills" then
					objectiveAmount = 10
				elseif objectiveRule == "15 Kills" then
					objectiveAmount = 15
				elseif objectiveRule == "20 Kills" then
					objectiveAmount = 20
				elseif objectiveRule == "50 Kills" then
					objectiveAmount = 50
				elseif objectiveRule == "100 Kills" then
					objectiveAmount = 100
				end
				
				local players = obj.P:findAll()
				local alivePlayers = {}
				local teamsPoints = {}
				
				local winnerPlayer = nil
				
				for _, player in ipairs(players) do
					if player:get("dead") == 0 then
						table.insert(alivePlayers, player)
						
						local team = player:getData().versusTeam
						
						local points = player:getData().totalKills
						if global.pvp then points = player:getData().totalPlayerKills end
						
						if objectiveAmount > 0 then
							if teams == "Free-For-All" then
								if points >= objectiveAmount then
									if not winnerPlayer then
										winnerPlayer = player
									else
										winnerPlayer = "Draw"
									end
								end
								
							else
								if teamsPoints[team] then
									teamsPoints[team] = teamsPoints[team] + points
								else
									teamsPoints[team] = points
								end
								
							end
						end
					end
					
					if net.host then
						if teams == "Free-For-All" then
							if winnerPlayer then
								if winnerPlayer ~= "Draw" then
									changeState(vState.endGame, winnerPlayer)
								else
									changeState(vState.endGame, "DRAW")
								end
							end
							
						else
							local winnerTeam = nil
							
							for team, points in pairs(teamsPoints) do 
								if points >= objectiveAmount then
									if not winnerTeam then
										winnerTeam = team
									else
										winnerTeam = "Draw"
									end
								end
							end
							
							if winnerTeam then
								if winnerTeam ~= "Draw" then
									changeState(vState.endGame, teamStrings[winnerTeam].." Team")
								else
									changeState(vState.endGame, "DRAW")
								end
							end
							
						end
					end
				end
				if versusData.safeTime <= 0 then
					if teams == "Free-For-All" then
						if #alivePlayers <= 1 then
							versusData.safeTime = 300
							if net.host then
								if objectiveAmount == 0 then
									local lastPlayer = alivePlayers[1]
									changeState(vState.endGame, lastPlayer)
								elseif not versusData.displayPostGame then
									changeState(vState.endRound)
								end
							end
						end
					else
						local singleTeam = true
						local aliveTeam = nil
						for _, player in ipairs(alivePlayers) do
							if not aliveTeam then
								aliveTeam = player:getData().versusTeam
							elseif player:getData().versusTeam ~= aliveTeam then
								singleTeam = false
							end
						end
						
						if singleTeam then
							versusData.safeTime = 300
							if net.host then
								if objectiveAmount == 0 then
									changeState(vState.endGame, teamStrings[aliveTeam].." Team")
								elseif not versusData.displayPostGame then
									changeState(vState.endRound)
								end
							end
						end
					end
				end
				
			end
			
		end
	end
	
	if versusData.safeTime > 0 and not global.pvp then
		for _, dummy in ipairs(obj.actorDummy:findAll()) do
			dummy:delete()
		end
	end
end)

local sprVersusTime = Sprite.load("VersusHUD", "Gameplay/HUD/versus", 1, 86, 0)
local teamStringColors = {"&r&", "&b&", "&y&", "&g&", "&or&", "&p&"}

table.insert(call.onHUDDraw, function()
	if global.inGame then
		
		local w, h = graphics.getHUDResolution()
		local ww = w / 2
		local hh = h / 2
		
		local addedSpace = 0
		
		if global.versus then
			graphics.alpha(1)
			
			local objectiveRule = global.activeRules[2][18] or "Last Standing"
			
			graphics.color(Color.fromHex(0xC0C0C0))
			
			if global.pvp then
				misc.hud:set("show_time", 0)
				local timeString1 = misc.hud:get("sminute")
				local timeString2 = misc.hud:get("ssecond")
				
				graphics.drawImage{
					image = sprVersusTime,
					x = w - 20,
					y = 15
				}
				graphics.print(objectiveRule, w - 20, 46, 1, 2, 0)
				
				graphics.print(timeString1, w - 39, 18, 2, 2, 0)
				graphics.print(timeString2, w - 22, 20, 1, 2, 0)
				graphics.print(":", w - 35, 20, 1, 2, 0)
			else
				graphics.print(objectiveRule, w - 100, 20, 1, 2, 0)
			end
			
			if objectiveRule ~= "Last Standing" then
				graphics.color(Color.fromHex(0xC0C0C0))
				
				for i, entry in ipairs(versusData.leaderBoard) do
					if global.pvp then
						if i == # versusData.leaderBoard then
							addedSpace = 9 * i
						end
						graphics.print(entry.name.." - "..entry.val, w - 20, 48 + (9 * i), 1, 2, 0)
					else
						graphics.print(entry.name.." - "..entry.val, w - 100, 23 + (9 * i), 1, 2, 0)
					end
				end
			end
			
			misc.hud:set("objective_text", "")
			
			if versusData.displayPostGame and versusData.endType == 2 then
				
				local winner = versusData.winner or "Nobody"
				local finalString = ""
				
				if versusData.winner == "DRAW" then
					finalString = "Draw!"
				else
					finalString = winner.." Won!"
				end
				
				graphics.print(finalString, ww, hh - 27, 2, 1, 1)
				graphics.print(objectiveRule, ww, hh - 9, 1, 1, 1)
			end
		end
		if global.pvp then
			local toDraw = {}
			local begin = math.max(#global.pvpKills - 6, 1)
			for i, kill in ipairs(global.pvpKills) do
				if i >= begin then
					table.insert(toDraw, kill)
				end
			end
			
			graphics.color(Color.WHITE)
			for i, kill in ipairs(toDraw) do
				local pinst, kinst = kill.pinst, kill.kinst
				local t1, t2
				if pinst then t1 = pinst:getData().versusTeam end
				if kinst then t2 = kinst:getData().versusTeam end
				local col1, col2 = "", ""
				
				if global.teams > 0 then
					if t1 then col1 = teamStringColors[t1] end
					if t2 then col2 = teamStringColors[t2] end
				end
				
				local suicide = nil
				if pinst == kinst then
					suicide = true
				end
				
				local killStringRaw = kill.player.." killed "..kill.killed.."!"
				if suicide then killStringRaw = kill.player.." commited suicide." end
				local killString = col1..kill.player.."&!& killed "..col2..kill.killed.."&!&!"
				if suicide then killString = col1..kill.player.."&!& commited suicide&!&!"end
				local stringWidth = graphics.textWidth(killStringRaw, 1)
				
				local add = 0
				if i == #toDraw then add = killDisplayTimer end
				local alpha = ((100 - add) / 100) * ((killDisplayTimer2 + 350) / 500)
				local xx = w - 20 - stringWidth
				local yy = 55 + addedSpace + (9 * i) + add 
				
				graphics.alpha(alpha)
				graphics.printColor(killString, xx, yy, 1)
			end
		end
	end
end)

obj.WhiteFlash:addCallback("create", function(self)
	if global.activeRules[4][8] == false then
		self.alpha = 0
	end
end)
obj.GiantJelly:addCallback("create", function(self)
	if global.activeRules[4][8] == false then
		self:set("white_alpha", 0)
	end
end)

local lastEB = nil
local lastPoints = nil

local syncItem
syncItem = net.Packet.new("SSSettingItem", function(player, player, item, add)
	if player and player:resolve() and item then
		local playerInstance = player:resolve()
		if item.isUseItem then
			playerInstance.useItem = item
		else
			playerInstance:giveItem(item)
			if add == true then
				playerInstance:set("item_count_total", playerInstance:get("item_count_total") + 1)
			end
		end
	end
	if net.host then
		syncItem:sendAsHost(net.EXCLUDE, sender, player, item, add)
	end
end)

table.insert(call.onStep, function()

	global.activeRules = global.rulesets[global.activeRuleset].rules
	
	if net.online and not net.host then
		global.activeRules = onlineRuleset.rules
	end
	
	--debugPrint(global.activeRules)
		
	if global.inGame then
		local dir = misc.director
		local dirAc = dir:getAccessor()
		
		if global.activeRules[1][1] then
			local setting = global.activeRules[1][1] / 100
			
			if not lastEB then
				lastEB = dirAc.enemy_buff
			end
			if dirAc.enemy_buff ~= lastEB then
				if dirAc.enemy_buff > lastEB then
					local dif = dirAc.enemy_buff - lastEB
					local newVal = dif * setting
					dirAc.enemy_buff = dirAc.enemy_buff - dif + newVal
				end
				lastEB = dirAc.enemy_buff
			end
		end
		
		if global.activeRules[1][2] then
			local setting = global.activeRules[1][2]
			
			for _, actor in ipairs(pobj.actors:findAll()) do
				if not actor:getData().setting_checked then
					actor:getData().setting_checked = true
					local currentVal1 = actor:get("pGravity1")
					actor:set("pGravity1", currentVal1 * setting)
					local currentVal2 = actor:get("pGravity2")
					actor:set("pGravity2", currentVal2 * setting)
				end
			end
		end
		
		if global.activeRules[1][3] then
			for _, water in ipairs(obj.Water:findAll()) do
				water:destroy()
			end
			for _, waterfall in ipairs(obj.Waterfall:findAll()) do -- lol
				waterfall:destroy()
			end
		end
		
		if global.activeRules[1][4] then
			local setting = global.activeRules[1][4]
			
			for _, tele in ipairs(obj.Teleporter:findAll()) do
				if not tele:getData().setting_checked then
					tele:getData().setting_checked = true
					local currentVal = tele:get("maxtime")
					if currentVal > 0 then
						local newVal = ((setting * 60) / currentVal) * currentVal
						
						tele:set("maxtime", newVal)
					end
				end
			end
		end
		
		if global.activeRules[1][5] then
			local setting = global.activeRules[1][5]
			
			for _, tele in ipairs(obj.Teleporter:findAll()) do
				local currentVal = tele:get("active")
				if currentVal == 2 then
					tele:set("active", 3)
				end
			end
		end
		
		if global.activeRules[1][6] then
			
			local val1 = global.activeRules[1][8]
			if val1 == nil then val1 = 1 end
			local val2 = global.activeRules[1][10]
			if val2 == nil then val2 = 15 end
			
			local savItems = {}
			
			local shared = global.activeRules[1][7]
			
			for p, player in ipairs(misc.players) do
				if not player:getData().setting6_checked then
					
					if net.host then
						if not shared or shared and p == 1 then
							for i = 1, val1 do
								local item = nil
								
								if math.chance(1) then
									item = itp.rare
								elseif math.chance(15) and not player.useItem then
									item = itp.use
								elseif math.chance(30) then
									item = itp.uncommon
								else
									item = itp.common
								end  
								item = item:roll()
								
								if item ~= it.Eggplant or global.activeRules[1][25] == true then
									table.insert(savItems, item)
									if item.isUseItem then
										player.useItem = item
									else
										player:giveItem(item, 1)
									end
									
									if net.online and net.host then
										syncItem:sendAsHost(net.ALL, nil, player:getNetIdentity(), item, false)
									end
								end
							end
						else
							for _, item in ipairs(savItems) do
								
								if item.isUseItem then
									player.useItem = item
								else
									player:giveItem(item, 1)
								end
								
								if net.online and net.host then
									syncItem:sendAsHost(net.ALL, nil, player:getNetIdentity(), item, false)
								end
							end
						end
					end
					
					player:set("item_count_total", val1)
					
					player:getData().setting6_checked = true
				end
			end
			
			if not dir:getData().setting6_checked then
				dirAc.time_start = dirAc.time_start + val2
				dirAc.enemy_buff = dirAc.enemy_buff + (math.floor(val2 / 60) * Difficulty.getActive().scale)
				dir:getData().setting6_checked = true
			end
		end
		
		if global.activeRules[1][11] and ar.Glass.active then
		
			local deglassed = 0
			
			for _, player in ipairs(misc.players) do
				if player:getData().setting_deglassified then
					deglassed = deglassed + 1
					if not player:getData().setting_lastlvlinfo then
						player:getData().setting_lastlvlinfo = {
							level = player:get("level"),
							hp = player:get("maxhp_base"),
							damage = player:get("damage")
						}
					elseif player:getData().setting_lastlvlinfo.level ~= player:get("level") then
						local data = player:getData().setting_lastlvlinfo
						
						local newhp = data.hp + ((player:get("maxhp_base") - data.hp) * 4)
						local newdamage = data.damage + ((player:get("damage") - data.damage) / 5)
						player:set("maxhp_base", newhp)
						player:set("damage", newdamage)
						
						player:getData().setting_lastlvlinfo = {
							level = player:get("level"),
							hp = player:get("maxhp_base"),
							damage = player:get("damage")
						}
					end
				end
			end
			
			if deglassed == #misc.players then
				resetGlassOnEnd = true
				ar.Glass.active = false
			end
		end
		
		if global.activeRules[1][12] == false then
			for _, entrance in ipairs(obj.Pigbeach:findAll()) do
				entrance:destroy()
			end
		end
		
		if global.activeRules[1][13] == false then
			for _, logBook in ipairs(obj.BookDrop:findAll()) do
				logBook:destroy()
			end
		end
		
		if global.activeRules[1][14] == false then
			for _, artifact in ipairs(pobj.artifacts:findAll()) do
				artifact:destroy()
			end
		end
		
		for _, obj in ipairs(toDelete) do
			for _, inst in ipairs(obj:findAll()) do
				inst:destroy()
			end
		end
		
		if global.activeRules[1][15] == false then
			for _, interactable in ipairs(pobj.mapObjects:findAll()) do
				local intObj = interactable:getObject()
				if intObj ~= obj.Geyser and intObj ~= obj.GeyserWeak and intObj ~= obj.TeleporterFake then
					if intObj ~= obj.Teleporter or global.versus then
						interactable:destroy()
					end
				end
			end
			
		else
		
			if global.activeRules[1][16] ~= nil then
				local setting = global.activeRules[1][16]
				
				for _, interactableType in ipairs(allInteractables) do
					for _, interactable in ipairs(interactableType:findAll()) do
						if not interactable:getData().setting16_checked then
							if interactable:get("cost") and interactable:get("cost") > 0 then
								local originalCost = interactable:get("cost")
								local multiplier = setting / 25
								local newCost = math.ceil(originalCost * multiplier)
								
								interactable:set("cost", newCost)
							end
							interactable:getData().setting16_checked = true
						end
					end
				end
			end
			
			if global.activeRules[1][17] == false then
				for _, barrelType in ipairs(barrels) do
					for _, barrel in ipairs(barrelType:findAll()) do
						barrel:destroy()
					end
				end
			end
			
			if global.activeRules[1][18] == false then
				for _, chestType in ipairs(chests) do
					for _, chest in ipairs(chestType:findAll()) do
						chest:destroy()
					end
				end
			end
			
			if global.activeRules[1][19] == false then
				for _, shrineType in ipairs(shrines) do
					for _, shrine in ipairs(shrineType:findAll()) do
						shrine:destroy()
					end
				end
			end
			
			if global.activeRules[1][20] == false then
				for _, drone in ipairs(pobj.droneItems:findAll()) do
					drone:destroy()
				end
			end
			
			if global.activeRules[1][21] == false then
				for _, teleporter in ipairs(obj.Teleporter:findAll()) do
					if teleporter:get("active") < 4 then
						teleporter:destroy()
					end
				end
			end
		end
		
		if global.activeRules[1][23] then
			local blacklist = global.activeRules[1][23]
			
			for _, item in pairs(blacklist) do
				for _, instance in ipairs(item:getObject():findAll()) do
					instance:destroy()
				end
			end
			
			if net.host then
				for _, multishop in ipairs(obj.Chest3:findAll()) do
					if not multishop:getData().setting23_checked then
						
						local object = Object.fromID(multishop:get("item_id"))
						
						if object then
							local item = Item.fromObject(object)
							
							if contains(blacklist, item) then
								local pool = nil
								
								for _, itemPool in ipairs(itemPools) do
									if itemPool:contains(item) then
										pool = itemPool
										break
									end
								end
								
								local newItem = nil
								if pool == nil then
									if global.activeRules[1][25] == true then
										newItem = it.Eggplant
									else
										newItem = nil
									end
								else
									newItem = pool:roll()
								end
								if newItem then
									multishop:set("item_id", newItem:getObject().id)
									multishop:set("sprite_id", newItem.sprite.id)
								else
									multishop:set("item_id", obj.EfOutline.id)
									multishop:set("sprite_id", spr.Nothing.id)
								end
							end
						end
							
						multishop:getData().setting23_checked = true
					end
					if not multishop:getData().setting25_checked then
						local object = Object.fromID(multishop:get("item_id"))
						
						if object then
							local item = Item.fromObject(object)
							
							if item == it.Eggplant and global.activeRules[1][25] ~= true then
								local pool
								if math.chance(10) then
									pool = itp.use
								else
									pool = itp.uncommon
								end
								local newItem = pool:roll()
								multishop:set("item_id", newItem:getObject().id)
								multishop:set("sprite_id", newItem.sprite.id)
								if net.online then
									syncInstanceVar:sendAsHost(net.ALL, nil, multishop:getNetIdentity(), "item_id", newItem:getObject().id)
									syncInstanceVar:sendAsHost(net.ALL, nil, multishop:getNetIdentity(), "sprite_id", newItem.sprite.id)
								end
							end
						end
							
						multishop:getData().setting25_checked = true
					end
				end
			end
		end
		
		for _, player in ipairs(misc.players) do
			local playerAc = player:getAccessor()
			if not player:getData().setting2_checked then
			
				if global.activeRules[2][1] then
					local setting = global.activeRules[2][1] / 100
					
					playerAc.maxhp_base = math.ceil(playerAc.maxhp_base * setting)
					playerAc.maxhp = playerAc.maxhp_base
					playerAc.hp = playerAc.maxhp
					playerAc.hud_hp_last = playerAc.hp
				end
				
				if global.activeRules[2][2] then
					local setting = global.activeRules[2][2]
					
					playerAc.percent_hp = playerAc.percent_hp * setting
				end
				
				if global.activeRules[2][3] then
					local setting = global.activeRules[2][3] / 100
					
					playerAc.hp_regen = playerAc.hp_regen * setting
				end
				
				if global.activeRules[2][4] then
					local setting = global.activeRules[2][4]
					
					playerAc.maxhpcap = setting
				end
				
				if global.activeRules[2][5] then
					local setting = global.activeRules[2][5]
					
					playerAc.pHmax = playerAc.pHmax * setting
				end
				
				if global.activeRules[2][7] then
					local setting = global.activeRules[2][7]
					
					playerAc.pVmax = playerAc.pVmax * setting
				end
				
				if global.activeRules[2][8] then
					local setting = global.activeRules[2][8]
					
					playerAc.damage = playerAc.damage * setting
				end
				
				if global.activeRules[2][9] then
					local setting = global.activeRules[2][9]
					
					playerAc.attack_speed = playerAc.attack_speed * setting
				end
				
				if global.activeRules[2][10] then
					local setting = global.activeRules[2][10] - 1
					
					playerAc.critical_chance = playerAc.critical_chance + setting
				end
				
				if global.activeRules[2][11] then
					local setting = global.activeRules[2][11]
					
					playerAc.armor = playerAc.armor + setting
				end
				
				if global.activeRules[2][12] then
					local setting = (global.activeRules[2][12] - 100) / 100
					
					playerAc.cdr = (setting * - 1)
				end
			
				player:getData().setting2_checked = true
			end
		end
		
		for _, enemy in ipairs(pobj.enemies:findAll()) do
			local enemyAc = enemy:getAccessor()
			local enemyObj = enemy:getObject()
			if not enemy:getData().setting2_checked then
			
				if global.activeRules[3][1] then
					if not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][1] / 100
						
						enemyAc.maxhp = enemyAc.maxhp * setting
						enemyAc.hp = enemyAc.maxhp
						enemyAc.hud_hp_last = enemyAc.hp
					end
				end
				
				if global.activeRules[3][2] then
					if not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][2]
						
						enemyAc.pHmax = enemyAc.pHmax * setting
					end
				end
				
				if global.activeRules[3][5] then
					local setting = global.activeRules[3][5]
					
					if setting == "All" then
						enemyAc.can_jump = 1
						enemyAc.can_drop = 1
					else
						enemyAc.can_jump = 0
						enemyAc.can_drop = 0
					end
				end
				
				if global.activeRules[3][6] then
					if not statBlacklist[enemyObj] then
						if enemyAc.pVmax then
							local setting = global.activeRules[3][6]
						
							enemyAc.pVmax = enemyAc.pVmax * setting
						end
					end
				end
				
				if global.activeRules[3][7] == false then
					enemyAc.elite_is_hard = 0
				end
				
				if global.activeRules[3][8] then
					if enemyAc.damage and not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][8]
						
						enemyAc.damage = enemyAc.damage * setting
					end
				end
				
				if global.activeRules[3][9] then
					if not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][9]
						
						if enemyAc.critical_chance then
							enemyAc.critical_chance = enemyAc.critical_chance + setting
						end
					end
				end
				
				if global.activeRules[3][10] then
					if not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][10]
						
						enemyAc.armor = enemyAc.armor + setting
					end
				end
				
				if global.activeRules[3][11] then
					if not statBlacklist[enemyObj] then
						local setting = global.activeRules[3][11] / 100
						
						enemyAc.exp_worth = enemyAc.exp_worth * setting
					end
				end
			
				enemy:getData().setting2_checked = true
			end
		end
		
		if global.activeRules[3][3] then
			local spawn = true
			for _, tele in ipairs(obj.Teleporter:findAll()) do
				if tele:get("active") and tele:get("active") > 2 then
					spawn = false
				end
			end
			
			if spawn then
				local setting = global.activeRules[3][3] - 1
				
				local currentVal = dir:getAlarm(1)
				
				dir:setAlarm(1, math.max(currentVal - setting, 1))
			end
		end
		
		if global.activeRules[3][4] then
			local setting = global.activeRules[3][4]
			
			if not lastPoints then
				lastPoints = dirAc.points
			end
			if dirAc.points ~= lastPoints then
				if dirAc.points > lastPoints then
					local dif = dirAc.points - lastPoints
					local newVal = dif * setting
					dirAc.points = dirAc.points - dif + newVal
				end
				lastPoints = dirAc.points
			end
		end
		
		if global.activeRules[4][1] == false then
			local hud = misc.hud
			
			hud:set("show_gold", 0)
			hud:set("show_items", 0)
			hud:set("show_time", 0)
			hud:set("show_skills", 0)
			hud:set("objective_text", "")
		else
			local hud = misc.hud
			
			if global.activeRules[4][2] == false then
				hud:set("show_gold", 0)
			end
			
			if global.activeRules[4][3] == false then
				hud:set("show_items", 0)
			end
			
			if global.activeRules[4][4] == false then
				hud:set("show_time", 0)
			end
			
			if global.activeRules[4][4] == false then
				hud:set("show_skills", 0)
			end
		end
		
		if global.activeRules[4][7] then
			if misc.hud:getData().lastShake then
				if misc.hud:getAlarm(0) > misc.hud:getData().lastShake then
					local dif = misc.hud:getAlarm(0) - misc.hud:getData().lastShake
					
					misc.hud:setAlarm(0, misc.hud:getAlarm(0) + (dif * (global.activeRules[4][7] - 1)))
				end
			end
			misc.hud:getData().lastShake = misc.hud:getAlarm(0)
			
			if misc.hud:getAlarm(0) > 0 then
				misc.hud:set("speed", math.min((misc.hud:getAlarm(0) * 0.05) * global.activeRules[4][7], 15))
				misc.hud:set("direction", misc.hud:getAlarm(0) * (math.random(360) * global.activeRules[4][7]))
			else
				misc.hud:set("speed", 0)
			end
		end
		
		if net.online and net.host and global.activeRules[2][19] ~= false then
			if runData.lastFramePlayerData then
				if #obj.P:findAll() ~= #runData.lastFramePlayerData and #obj.P:findAll() < #runData.lastFramePlayerData then
					local toRemove = {}
					for i, playerData in ipairs(runData.lastFramePlayerData) do
						if not playerData.instance:isValid() then
							for _, itemData in ipairs(playerData.items) do
								itemData.item:getObject():create(playerData.x, playerData.y)
							end
							if playerData.useItem then
								playerData.useItem:getObject():create(playerData.x, playerData.y)
							end
							table.insert(toRemove, i)
						end
					end
					for _, i in ipairs(toRemove) do
						table.remove(runData.lastFramePlayerData, i)
					end
				else
					for i, player in ipairs(obj.P:findAll()) do
						runData.lastFramePlayerData[i] = {instance = player, x = player.x, y = player.y, items = player:getData().items, useItem = player.useItem}
					end
				end
			else
				runData.lastFramePlayerData = {}
				for i, player in ipairs(obj.P:findAll()) do
					runData.lastFramePlayerData[i] = {instance = player, x = player.x, y = player.y, items = player:getData().items, useItem = player.useItem}
				end
			end
		end
	end
end)
callback.register("postSelection", function()

	global.activeRules = global.rulesets[global.activeRuleset].rules
	
	if net.online and not net.host then
		global.activeRules = onlineRuleset.rules
	end
	
	--debugPrint(global.activeRules)
	
	if net.host and global.activeRules[1][7] then
		if #misc.players > 1 then
			local mult = math.floor(#misc.players * 0.6 * 4)
			local mapObjs = {}
			for _, interactable in ipairs(pobj.mapObjects:findAll()) do
				local intObj = interactable:getObject()
				if intObj ~= obj.Geyser and intObj ~= obj.GeyserWeak and intObj ~= obj.Teleporter and intObj ~= obj.TeleporterFake then
					table.insert(mapObjs, interactable)
				end
			end
			
			for i = 1, mult do
				local rand = math.random(1, #mapObjs)
				local inst = mapObjs[rand]
				if inst and inst:isValid() then
					if pcall(inst.getNetIdentity, inst) then
						syncDestroy(inst)
						inst:destroy()
					end
					table.remove(mapObjs, rand)
				end
			end
		end
	end
	
	if global.activeRules[1][9] == false then
		if net.online and #misc.players > 1 then
			local w, h = Stage.getDimensions()
			local teams = global.activeRules[2][17] or "Free-For-All"
			
			local amount = global.teams
			if not amount or amount <= 0 then amount = #misc.players end
			
			local ww = w / amount
			
			for _, player in ipairs(misc.players) do
				local p = player:get("m_id")
				if teams ~= "Free-For-All" then
					p = player:getData().versusTeam
				end
				
				local x = (p * ww) - (ww / 2)
				local y = math.random(100, h)
				
				local nearestGround = obj.B:findNearest(x, y)
				
				if nearestGround then
					local groundL = nearestGround.x - (nearestGround.sprite.boundingBoxLeft * nearestGround.xscale)
					local groundR = nearestGround.x + (nearestGround.sprite.boundingBoxRight * nearestGround.xscale)
					local xx = math.random(groundL, groundR)
					local yy = nearestGround.y
					
					player.x = xx
					player.y = yy
					
					player:set("moveRight", 1) -- Cute Sync
					
					--syncSpawn:sendAsHost(net.ALL, nil, player:getNetIdentity(), xx, yy)
				end
			end
		end
	end
end)

local targetLevel = nil
table.insert(call.postStep, function()
	if global.activeRules[2][13] ~= false then
		--local option = global.activeRules[2][14] or "Average"
		--if option == nil then option = "Average" end
		if global.timer % 2 == 0 then
			for _, player in ipairs(obj.P:findAll()) do
				local playerAc = player:getAccessor()
				
				if playerAc.dead == 1 then
					player:getData().died = true
				elseif player:getData().died then
					local level = player:getData().trueLevel or playerAc.level
					if level < targetLevel then
						playerAc.expr = playerAc.maxexp
					else
						player:getData().died = nil
					end
				end
			end
		end
	end
end)
table.insert(call.onStageEntry, function()
	targetLevel = nil
	local sum = 0
	local option = global.activeRules[2][14] or "Average"
	--if option == nil then option = "Average" end
	
	for _, player in ipairs(misc.players) do
		local level = player:getData().trueLevel or player:get("level")
		if option == "Highest Player" then
			if not targetLevel or level > targetLevel then
				targetLevel = level
			end
		else
			sum = sum + level
		end
	end
	
	if option ~= "Highest Player" then
		if option == "Average" then
			targetLevel = sum / #misc.players
		elseif option == "Below Average" then
			targetLevel = (sum * 0.75) / #misc.players
		else
			targetLevel = (sum * 1.25) / #misc.players
		end
	end
	if targetLevel then targetLevel = math.floor(targetLevel) end
end)

table.insert(call.onHUDDraw, function()
	if global.activeRules[4][6] == true and global.inGame then
		local percent = 0
		
		for _, player in ipairs(misc.players) do
			if player:get("dead") <= 0 then
				local amount = player:countItem(it["56LeafClover"])
				
				if amount > 0 then
					amount = math.min((amount * 1.5) + 2.5, 100)
				end
				
				percent = percent + amount
			end
		end
		
		local w, h = graphics.getHUDResolution()
		
		local xx = w / 2
		
		local barPercent = percent
		
		graphics.alpha(0.8)
		customBar(xx - 81, h - 16, xx + 81, h - 10, barPercent, 100, true, Color.fromHex(0x0B9D1D), Color.fromHex(0x8BE292))
		graphics.alpha(1)
		graphics.color(Color.WHITE)
		graphics.print(percent.."%", xx, h - 12, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
	end
end)

local sprPortalArrow = Sprite.load("PortalArrows", "Gameplay/portalArrow", 2, 0, 6)
callback.register("onPlayerDrawAbove", function(player)
	if global.activeRules[5][27] then
		for _, portal in ipairs(obj.VoidPortal:findAll()) do
			local angle = posToAngle(player.x, player.y, portal.x, portal.y)
			local angle2 = math.rad(posToAngle(player.x, portal.y, portal.x, player.y))
			if portal.sprite == spr.VoidPortal then
				graphics.drawImage{
					image = sprPortalArrow,
					x = player.x + math.cos(angle2) * 11,
					y = player.y + math.sin(angle2) * 11,
					angle = angle,
					subimage = 1,
					scale = 0.7
				}
			elseif portal.sprite == spr.VoidPortal2 then
				graphics.drawImage{
					image = sprPortalArrow,
					x = player.x + math.cos(angle2) * 11,
					y = player.y + math.sin(angle2) * 11,
					angle = angle,
					subimage = 2,
					scale = 0.7
				}
			elseif portal.sprite == spr.VoidPortalBig then
				graphics.drawImage{
					image = sprPortalArrow,
					x = player.x + math.cos(angle2) * 11,
					y = player.y + math.sin(angle2) * 11,
					angle = angle,
					subimage = 1,
					scale = 1
				}
			end
		end
	end
end)

local shareBlacklist = {
	[it.Keycard] = true,
	[it.PeculiarRock] = true
}
for _, item in ipairs(itp.relic:toList()) do
	shareBlacklist[item] = true
end
for _, item in ipairs(itp.sibylline:toList()) do
	shareBlacklist[item] = true
end

callback.register("onItemPickup", function(item, player)
	if global.inGame and item:isValid() then
		itemObj = item:getItem()
		
		if global.activeRules[1][7] and not itemObj.isUseItem and not shareBlacklist[itemObj] then
			if net.host then
				for p, pplayer in ipairs(misc.players) do
					if pplayer ~= player then
					
						pplayer:giveItem(itemObj)
						pplayer:set("item_count_total", pplayer:get("item_count_total") + 1)
						
						if net.host then
							syncItem:sendAsHost(net.ALL, nil, pplayer:getNetIdentity(), itemObj, true)
						end
					end
				end
			end
		end
	end
end)

-- 
table.insert(call.onDraw, function()
	if net.online and global.activeRules[2][20] ~= false then
		for _, player in ipairs(misc.players) do
			if player ~= net.localPlayer then
				if player:get("hp") < player:get("maxhp") * 0.2 and player:get("dead") == 0 then
					graphics.drawImage{
						image = spr.Warning,
						x = player.x,
						y = player.y - 20,
						subimage = ((global.timer * 0.025) % 2) + 1
					}
				end
			end
		end
	end
end)

-- Easter Egg-plant
obj.Eggplant:addCallback("create", function(self)
	if math.chance(5) and self:isValid() then
		self:set("text2", "Zarah says it can hatch into a spider plant.")
	end
end)