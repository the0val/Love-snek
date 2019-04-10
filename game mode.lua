local lg = love.graphics
local Fstandard12 = lg.newFont("assets/Helvetica.ttf", 12)

local function handleButton( mouseX, mouseY, x, y, w, h )
	return mouseX > x and mouseY > y and mouseX < x+w and mouseY < y+h
end

local gameMode = {}
local w, h = lg.getDimensions()
gameMode.menuButton = {width = Fstandard12:getWidth("Open game menu"), height = Fstandard12:getHeight("Open game menu")}
gameMode.menuButton.x = (w - gameMode.menuButton.width) / 2
gameMode.menuButton.y = h - 25

function gameMode.drawOpenMenuButton()
	local oldFont = lg.getFont()
	lg.setFont(Fstandard12)
	lg.setColor(0, 255, 100)
	lg.print("Open game menu", gameMode.menuButton.x, gameMode.menuButton.y)
	lg.rectangle("fill", gameMode.menuButton.x, gameMode.menuButton.y + gameMode.menuButton.height, gameMode.menuButton.width, 1)
	lg.setColor(255, 255, 255)
	lg.setFont(oldFont)
end

function gameMode.handleOpenMenuButton( mouseX, mouseY )
	return handleButton( mouseX, mouseY, gameMode.menuButton.x, gameMode.menuButton.y, gameMode.menuButton.width, gameMode.menuButton.height)
end

function gameMode.drawMenu()
	local w, h = lg.getDimensions()

end

return gameMode
