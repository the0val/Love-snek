local lg = love.graphics
local gameMode = {}
local Fstandard12 = lg.newFont("assets/Helvetica.ttf", 12)

function gameMode.drawOpenMenuButton()
	local w, h = lg.getDimensions()
	local oldFont = lg.getFont()
	lg.setFont(Fstandard12)
	lg.setColor(0, 255, 100)
	gameMode.menuButton = {width = Fstandard12:getWidth("Open game menu"), height = Fstandard12:getHeight("Open game menu")}
	gameMode.menuButton.x = (w - gameMode.menuButton.width) / 2
	gameMode.menuButton.y = h - 25

	lg.print("Open game menu", gameMode.menuButton.x, gameMode.menuButton.y)
	lg.rectangle("fill", gameMode.menuButton.x, gameMode.menuButton.y + gameMode.menuButton.height, gameMode.menuButton.width, 1)
	lg.setColor(255, 255, 255)
	lg.setFont(oldFont)
end

return gameMode
