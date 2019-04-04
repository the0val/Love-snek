-- images to load
local backgroundTile, snakeTile

function love.load()
	love.graphics.setDefaultFilter("nearest")
	backgroundTile = love.graphics.newImage("assets/background tile.png")
	snakeTile = love.graphics.newImage("assets/snake tile.png")
end

function love.update()

end

function love.draw()
	love.graphics.scale(2, 2)
	love.graphics.draw(backgroundTile, 0, 0)
	love.graphics.draw(snakeTile, 16, 0)
end
