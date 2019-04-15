--This is defeinitely a project I intend to keep working on in the future
--Serves as a simple mini-game for now, maybe something bigger later down the line.
--highly likely needs an overhaul to better utilize love2d physics

local player = require 'player'
player1 = player.new(0, 0)
collectable = {}
world = require 'world'

function love.load()

	collectable.x = -16
	collectable.y = love.graphics.getHeight() / 2 - 70
	collectable.width = 16
	collectable.height = 16
	collectable.x_velocity = 1
	collectable.img = love.graphics.newImage('collectthis.png')
	score = 0
end

function love.update(dt)

	player1.update(dt)

	--collectable object code
	collectable.x = collectable.x + collectable.x_velocity
	if collectable.x > love.graphics.getHeight() then
		collectable.x = -16
		collectable.x_velocity = 1
		score = 0
	end
	if collision(player, collectable) then
		collectable.x = 0
		collectable.x_velocity = collectable.x_velocity * 1.2
		score = score + 1	
	end
end

function collision(a, b)
	--note to self, test negative collision rather than positive
	--collision is much easier this way lol
	if a.x + a.width < b.x then return false end
	if a.x > b.x + b.width then return false end
	if a.y > b.y + b.height then return false end
	if a.y + a.height < b.y then return false end
	
	return true
end

function love.draw()
	love.graphics.print('score: '.. score, 10, 10)
	love.graphics.print('collectable.x: ' .. collectable.x, 10, 90)
	love.graphics.print('collectable.y: ' .. collectable.y, 150, 90)
	if collision(player, collectable) then
		love.graphics.print('COLLISION!', 80, 10)
	else
		love.graphics.print('waiting for collision', 80, 10)
	end
	
	love.graphics.setColor(255,255,255)

	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)
	love.graphics.draw(collectable.img, collectable.x, collectable.y, 0, 1, 1, 0, 16)
end
