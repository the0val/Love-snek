-- images to load
local backgroundTile, snakeTile, foodTile

local tileSide = 16

local lg = love.graphics

local tileMap, bottomPad, rightPad, boardWidth, boardHeight

local function randFood()
	local fX = math.random(boardWidth)
	local fY = math.random(boardHeight)
	if tileMap[fX][fY] == 0 then
		tileMap[fX][fY] = -1
	else
		return randFood()
	end
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
end

function love.update()

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
