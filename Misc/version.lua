-- Main menu versioning
local function split(str, maxLength)
	local linetable = {}
	local line
	str:gsub('(%s*)(%S+)', 
		function(spc, word)
			if spc and spc:find("\n") then
				table.insert(linetable, line)
				line = word
			elseif not line or #line + #spc + #word > maxLength then
				table.insert(linetable, line)
				line = word
			else
				line = line..spc..word
			end
		end
	)
	table.insert(linetable, line)
	local finalstring = ""
	for i, str in ipairs(linetable) do
		local fin = "\n"
		if i == #linetable then fin = "" end
		finalstring = finalstring..str..fin
	end
	return finalstring
end

local ii = 0
local patchNotes = [[PATCH NOTES:


- New survivor variant: Precursor (Seraph)!
- New interactables: Refabricator, Void Catalyst, Small Void Chest and more!
- New enemies: Clay Admonitor and Squall Eel!
- New artifact: Artifact of Deviation!
- New monster logs: Security Chest, Clay Admonitor and Squall Eel!
- New stages!
- New music tracks!
- Void overhaul part 2 (out of 3!).
- Judgement rework.
- Nemeses now appear after Void's Pass.
- Void portal spawns are now more predictable.
- Added a visual cue for increasing difficulty after an ethereal.
- Reworked Baroness' special.
- Baroness' attacks on vehicle no longer cause odd sliding.
- Tweaked Seraph's skill sprites.
- Added slight screen shake to Seraph's skills.
- Tweaked Executioner's achievement.
- Reworked Electrocutioner's primary.
- Nemesis Executioner's minions now inherit items instead of stats.
- Shudders no longer fire bullets on hit, they have a new attack instead.
- Zanzan the trader no longer gives curses on low item values, can give nothing instead. 
- Lots of fixes!
(And more!)
- - - - - - - - - - - -
For the full log enter:
pastebin.com/JkJ2tMAB]]
--[[- - - - - - - - - - - -
For the full log enter:]]
-- pastebin.com/0xjghHLA (dev)
-- pastebin.com/JkJ2tMAB (stable)

local function drawVersionName()
	local verString = "Starstorm "..modloader.getModVersion("Starstorm")
	local w, h = graphics.getGameResolution()
	local mx, my = input.getMousePos(true)
	
	graphics.color(Color.fromHex(0x808080))
	graphics.alpha(1)
	graphics.print(verString, w - 3, 3, 3, 2)
	
	local verWidth = graphics.textWidth(verString, 3)
	local verHeight = graphics.textHeight(verString, 3)
	
	if mx > w - verWidth - 6 and my < verHeight + 3 then
		if ii < 1 then
			ii = ii + 0.2
		end
	elseif ii > 0 then
		ii = ii - 0.2
	end
	
	if ii > 0 then
		local notesString = split(patchNotes, math.floor(w * 0.05))
		
		local notesWidth = graphics.textWidth(notesString, 3)
		local notesHeight = graphics.textHeight(notesString, 3)
		
		local twidth = 3 + notesWidth + 3
		local theight = 3 + verHeight + 1 + notesHeight + 3
		
		local yy = (ii - 1) * 10
		
		graphics.color(Color.GRAY)
		graphics.alpha(ii * 0.5)
		graphics.rectangle(w - twidth, 0, w, theight + yy, false)
		graphics.rectangle(w - twidth - 1, 0, w - twidth, theight - 1 + yy, false)
		
		graphics.alpha(ii)
		graphics.color(Color.WHITE)
		graphics.print(verString, w - 3, 3, 3, 2)
		graphics.color(Color.fromHex(0x808080))
		graphics.print(notesString, w - 3 - notesWidth, 3 + verHeight + 1 + yy, 3)
	end
end
callback.register("globalRoomStart", function(room)
	if room == rm.Start then
		graphics.bindDepth(-99, drawVersionName)
	end
end)