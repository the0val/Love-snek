-- assets to load
local backgroundTile, snakeTile, foodTile, deadTile, Fstandard14, cursor, hand

-- configurables
local tileSide = 16
local tickrate = 0.1
local gamestate = "classic"

local lg = love.graphics
--local gameMode = require("game mode")

local tileMap, bottomPad, rightPad, boardWidth, boardHeight, ticktime, keyStack, head, oppositeDirection, pause

local function drawMessageRect( firstLine, secondLine, width, height )
	local w, h = lg.getDimensions()
	lg.setColor(0, 0, 0, 0.7)
	lg.rectangle("fill", (w-width)/2, (h-height)/2, width, height)
	lg.setColor(255, 255, 255)
	lg.print(firstLine, (w - lg.getFont():getWidth(firstLine)) / 2, h / 2 - 20)
	lg.print(secondLine, (w - lg.getFont():getWidth(secondLine)) / 2, h / 2 + 20)
end

local function randFood()
	local fX = love.math.random(boardWidth)
	local fY = love.math.random(boardHeight)
	if tileMap[fX][fY] == 0 then
		tileMap[fX][fY] = -1
	else
		return randFood()
	end
end

local function moveAlong()
	for x = 1, boardWidth do
		for y = 1, boardHeight do
			if tileMap[x][y] > 0 then
				tileMap[x][y] = tileMap[x][y] - 1
			end
		end
	end
end

local function togglePause( set )
	pause = not pause
	if set ~= nil then pause = set end
	ticktime = 0
	keyStack = {}
end

local function die()
	head.isDead = true
	pause = true
end

local function restart()
	head = {x = 2, y = 2, length = 1, direction = nil, isDead = false}
	ticktime = 0
	keyStack = {}
	love.resize(lg.getDimensions())
	pause = false
end

local function checkDeath( head )
	if head.x < 1 or head.y < 1 or head.x > boardWidth or head.y > boardHeight then
		die()
		return true
	end

	if tileMap[head.x][head.y] > 0 then
		die()
		return true
	end
end

local function checkEatFood( head, tileMap )
	if tileMap[head.x][head.y] < 0 then
		head.length = head.length + (-5) * tileMap[head.x][head.y]
		randFood()
		for x = 1, boardWidth do
			for y = 1, boardHeight do
				-- needed to make sure the tail end 'pauses' immediately
				if tileMap[x][y] > 0 then tileMap[x][y] = tileMap[x][y] + 5 end
			end
		end
	end
end

function love.resize( w, h )
	bottomPad = 2 * tileSide + h % tileSide
	rightPad = tileSide + w % tileSide
	boardWidth = (w - rightPad - tileSide) / tileSide
	boardHeight = (h - bottomPad - tileSide) / tileSide
	tileMap = {}
	for x = 1, boardWidth do
		tileMap[x] = {}
		for y = 1, boardHeight do
			tileMap[x][y] = 0
		end
	end
	tileMap[2][2] = 1
	randFood()
end

function love.load()
	lg.setDefaultFilter("nearest")
	backgroundTile = lg.newImage("assets/background tile.png")
	snakeTile = lg.newImage("assets/snake tile.png")
	foodTile = lg.newImage("assets/food tile.png")
	deadTile = lg.newImage("assets/dead tile.png")
	Fstandard14 = lg.setNewFont("assets/Helvetica.ttf", 14)
	cursor = love.mouse.getSystemCursor("arrow")
	hand = love.mouse.getSystemCursor("hand")
	oppositeDirection = {up = "down", down = "up", left = "right", right = "left"}
	restart()
end

function love.update( dt )
	ticktime = ticktime + dt
	if ticktime < tickrate or pause then return end
	ticktime = ticktime % tickrate

	if keyStack[1] ~= oppositeDirection[head.direction] or head.length == 1 then
		head.direction = keyStack[1] or head.direction
	end
	table.remove(keyStack, 1)

	if head.direction == "up" then
		head.y = head.y - 1
	elseif head.direction == "down" then
		head.y = head.y + 1
	elseif head.direction == "left" then
		head.x = head.x - 1
	elseif head.direction == "right" then
		head.x = head.x + 1
	else return end
	
	moveAlong()
	if checkDeath(head) then return end
	checkEatFood(head, tileMap)
	tileMap[head.x][head.y] = head.length 
end

function love.draw()
	local w, h = lg.getDimensions()

	lg.setColor(249, 0, 91)
	lg.rectangle("fill", 0, 0, w, tileSide)
	lg.rectangle("fill", 0, 0, tileSide, h)
	lg.rectangle("fill", w-rightPad, 0, rightPad, h)
	lg.rectangle("fill", 0, h-bottomPad, w, bottomPad)
	lg.setColor(255, 255, 255)
	local y = tileSide
	for x = 1, boardWidth do
		for y = 1, boardHeight do
			local drawable
			if tileMap[x][y] == 0 then drawable = backgroundTile
			elseif tileMap[x][y] == -1 then drawable = foodTile
			else drawable = snakeTile end
			lg.draw(drawable, x * tileSide, y * tileSide)
		end
	end

	if head.isDead then
		lg.draw(deadTile, head.x*tileSide, head.y*tileSide)
		drawMessageRect("You died.", "Press [space] to restart", 320, 120)
	end

	if pause and not head.isDead then
		drawMessageRect("Game paused", "press [space] to unpause", 320, 120)
	end

	if gamestate == "menu" then
		lg.setColor(0, 0, 0, 0.7)
		lg.rectangle("fill", (w-500)/2, (h-300)/2, 500, 300)
		lg.setColor(255, 255, 255)
	end

	--gameMode.drawOpenMenuButton()
	lg.print("Length: "..head.length, w-90, h-25)
end

function love.keypressed( key )
	if not (key == "up" or key == "down" or key == "left" or key == "right") then
		if key == "space" then
			if head.isDead then
				restart()
			else
				togglePause()
			end
		end
		return
	end
	table.insert(keyStack, key)
end

--[[function love.mousepressed( x, y )
	if gameMode.handleOpenMenuButton(x, y) then
		gamestate = "menu"
	else
		gamestate = "classic"
	end
end

function love.mousemoved( x, y )
	if gameMode.handleOpenMenuButton(x, y) then
		love.mouse.setCursor(hand)
	else
		love.mouse.setCursor(cursor)
	end
end]]
