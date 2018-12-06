player = {}
platform = {}

function love.load()
	platform.width = love.graphics.getWidth() / 2
	platform.height = love.graphics.getHeight() / 16
	platform.x = love.graphics.getWidth() / 4
	platform.y = love.graphics.getHeight() / 2

	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2
	player.speed = 200
	player.img = love.graphics.newImage('vox.png')
	player.canjump = true

	player.ground = player.y
	player.y_velocity = 0
	player.x_velocity = 0
	player.jump_height = -1200
	player.gravity = -6500
	player.max_speed = 5
	player.ac = 0.5
	player.decel = 1.25
end

function love.update(dt)
	--update player position
	player.x = player.x + player.x_velocity
	
	--set player's ability to jump if they're on the ground
	if player.y == player.ground and not love.keyboard.isDown('z') then 
		player.canjump = true
	end
	
	--handle player gravity
	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end

	if player.y > player.ground then
		player.y_velocity = 0
		player.y = player.ground
	end

	--movement code: kinda shnowy
	if love.keyboard.isDown('left') and not love.keyboard.isDown('right')  then
		if not (player.x_velocity < (player.max_speed * -1)) then
			player.x_velocity = player.x_velocity - player.ac
		end
	elseif love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
		if not (player.x_velocity > player.max_speed) then
			player.x_velocity = player.x_velocity + player.ac
		end
	else
		if player.x_velocity ~= 0 then
			player.x_velocity = player.x_velocity / player.decel
		end

		if player.x_velocity < player.decel and player.x_velocity > (player.decel * -1) and not (player.x_velocity == 0) then
			player.x_velocity = 0
		end
	end
	
	if love.keyboard.isDown('z') then
		if player.canjump then
			player.y_velocity = player.jump_height
			player.canjump = false
		end
	end
	--end movement code

end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)
end
