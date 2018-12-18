--project named puzzlr, probably due for rename
--This is defeinitely a project I intend to keep working on in the future
--Serves as a simple mini-game for now, maybe something bigger later down the line.
--highly likely needs an overhaul to better utilize love2d physics

player = {}
collectable = {}
world = require 'world'

function love.load()
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2 + 50
	player.width = 32
	player.height = 32
	player.img = love.graphics.newImage('player.png')
	player.canjump = true
	player.slide = false
	
	--RIP - geometry collisions aren't a thing yet
	--TODO: geo collisions
	player.ground = player.y
	player.y_velocity = 0
	player.x_velocity = 0
	player.jump_height = -1200
	player.gravity = -6500
	player.max_speed = 10
	player.ac = 0.25
	player.decel = 2

	collectable.x = -16
	collectable.y = love.graphics.getHeight() / 2 - 70
	collectable.width = 16
	collectable.height = 16
	collectable.x_velocity = 1
	collectable.img = love.graphics.newImage('collectthis.png')
	score = 0
end

function love.update(dt)
	--update player position
	player.x = player.x + player.x_velocity
	--update player sprite
	--TODO: better sprite system (states?)
	if player.slide then
		player.img = love.graphics.newImage('slide.png')
	else
		player.img = love.graphics.newImage('player.png')
	end
	--set player's ability to jump if they're on the ground
	--RIP
	if player.y == player.ground and not love.keyboard.isDown('z') then 
		player.canjump = true
	end
	
	--handle player gravity
	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end
	
	--RIP X2
	if player.y > player.ground then
		player.y_velocity = 0
		player.y = player.ground
	end

	--movement code: kinda shnowy
	--I wanted movement to feel really smooth so the movement code is fairly big
	if love.keyboard.isDown('left') and not love.keyboard.isDown('right')  then
		if not (player.x_velocity > (player.max_speed - 2)) then
			--reset player speed if moving in the opposite direction
			if player.x_velocity > 0 and not player.slide then
				player.x_velocity = player.x_velocity / 2
			end	
			--give the player an initial dash to keep movement quick
			if player.x_velocity < 1 and player.x_velocity > -1 then
				player.x_velocity = -4
				player.slide = false
			end
			--increment player velocity
			if not (player.x_velocity < (player.max_speed * -1)) then
				player.x_velocity = player.x_velocity - (player.ac / 2)
			end
		else
			--if moving at max speed cause a slowdown animation
			player.slide = true
			player.x_velocity = player.x_velocity / player.decel
		end
	elseif love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
		if not (player.x_velocity < ((player.max_speed - 2) * -1)) then
			--reset player speed if moving in the opposite direction
			if player.x_velocity < 0 and not player.slide then
				player.x_velocity = player.x_velocity / 2
			end
			--give the player an initial dash to keep movement quick
				if player.x_velocity < 1 and player.x_velocity > -1 then
				player.x_velocity = 4
				player.slide = false
			end
			--increment player velocity
			if not (player.x_velocity > player.max_speed) then
				player.x_velocity = player.x_velocity + (player.ac / 2)
			end
		else
			--if moving at max speed cause a slowdown animation
			player.slide = true
			player.x_velocity = player.x_velocity / player.decel
		end
	else
		--neutral player slowdown
		if player.x_velocity ~= 0 then
			if player.x_velocity > 0 then
				player.x_velocity = player.x_velocity - (player.ac)
			else
				player.x_velocity = player.x_velocity + (player.ac)
			end
		end
		--make sure player actually hits zero velocity
		if player.x_velocity < player.decel and player.x_velocity > (player.decel * -1) and not (player.x_velocity == 0) then
			player.x_velocity = 0
		end
	end
	
	--make player jump
	if love.keyboard.isDown('z') then
		if player.canjump then
			player.y_velocity = player.jump_height
			player.canjump = false
			player.slide = false
		end
	end
	--end movement code
	
	--collectable code
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
	love.graphics.print('player velocity: '.. player.x_velocity, 10, 30)
	love.graphics.print('score: '.. score, 10, 10)
	love.graphics.print('player.x: ' .. player.x, 10, 50)
	love.graphics.print('player.y: ' .. player.y, 10, 70)
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
