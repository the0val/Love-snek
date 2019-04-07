-- images to load
local backgroundTile, snakeTile, foodTile

local tileSide = 16
local tickrate = 0.1
local lenght = 1

local lg = love.graphics

local tileMap, bottomPad, rightPad, boardWidth, boardHeight, ticktime, keyStack, head, oppositeDirection, pause

local function randFood()
	local fX = math.random(boardWidth)
	local fY = math.random(boardHeight)
	if tileMap[fX][fY] == 0 then
		tileMap[fX][fY] = -1
	else
		return randFood()
	end
end

local function die()

end

function love.resize( w, h )
	bottomPad = 32 + h % tileSide
	rightPad = 16 + w % tileSide
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
	love.resize(lg.getDimensions())
	oppositeDirection = {up = "down", down = "up", left = "right", right = "left"}
	ticktime = 0
	keyStack = {}
	head = {x = 2, y = 2, direction = nil}
end

function love.update( dt )
	ticktime = ticktime + dt
	if ticktime < tickrate or pause then return end
	ticktime = ticktime % tickrate

	if keyStack[1] ~= oppositeDirection[head.direction] or lenght == 1 then
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

	if tileMap[head.x][head.y] == -1 then
		lenght = lenght + 5
		randFood()
		for x = 1, boardWidth do
			for y = 1, boardHeight do
				if tileMap[x][y] > 0 then tileMap[x][y] = tileMap[x][y] + 5 end
			end
		end
	end
	tileMap[head.x][head.y] = lenght + 1


	for x = 1, boardWidth do
		for y = 1, boardHeight do
			if tileMap[x][y] > 0 then
				tileMap[x][y] = tileMap[x][y] - 1
			end
		end
	end
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
			lg.draw(drawable, x * 16, y * 16)
		end
	end
end

function love.keypressed( key )
	if not (key == "up" or key == "down" or key == "left" or key == "right") then
		if key == "space" then
			pause = not pause
			ticktime = 0
		end
		return
	end
	table.insert(keyStack, key)
end
