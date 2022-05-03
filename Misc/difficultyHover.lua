local etherealDifficultyNames = {
	[dif.Drizzle] = "Deluge",
	[dif.Rainstorm] = "Tempest",
	[dif.Monsoon] = "Cyclone",
	[dif.Typhoon] = "Super Typhoon"
}
table.insert(call.onHUDDraw, function()
	if misc.hud:get("show_time") == 1 then
		local swidth, sheight = graphics.getHUDResolution()
		local mx, my = input.getMousePos(true)
		
		if mx > swidth - 98 and mx < swidth - 77
		and my > 15 and my < 35 then
			local extraDif = ExtraDifficulty.getCurrent()
			local txt, txt2
			if extraDif == 0 then
				txt = Difficulty.getActive().displayName
				txt2 = txt
			else
				txt = etherealDifficultyNames[Difficulty.getActive()] or Difficulty.getActive().displayName
				txt2 = txt
				
				if extraDif > 0 then
					txt = txt.." &b&(Ethereal "..extraDif..")"
					txt2 = txt2.." (Ethereal "..extraDif..")"
				end
			end
			txt = txt.." &lt&["..Difficulty.getScaling().."]"
			txt2 = txt2.." ["..Difficulty.getScaling().."]" -- dumb
			local off = 2
			local off2 = 4
			local twidth = graphics.textWidth(txt2, graphics.FONT_DEFAULT)
			local theight = graphics.textHeight(txt2, graphics.FONT_DEFAULT)
			local xx = math.min(mx - twidth, swidth - twidth - 6)
			local yy = my - theight
			graphics.color(Color.BLACK)
			graphics.alpha(0.62)
			graphics.rectangle(xx - off, yy - off, xx + twidth + off2, yy + theight + off2, false)
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(txt, xx + off2, yy + off2 - 1, graphics.FONT_DEFAULT)
		end
	end
end)