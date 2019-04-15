local player = {}


player.new = function(x, y)
	
	self.__index = self

	return setmetatable({
		x = x,
		y = y,
	}, self)
end


	 x = love.graphics.getWidth() / 2
	 y = love.graphics.getHeight() / 2 + 50
	 width = 32
	 height = 32
	 img = love.graphics.newImage('player.png')
	 canjump = true
	 slide = false
	
	--RIP - geometry collisions aren't a thing yet
	--TODO: geo collisions
	 ground =  y
	 y_velocity = 0
	 x_velocity = 0
	 jump_height = -1200
	 gravity = -6500
	 max_speed = 10
	 ac = 0.25
	 decel = 3


	player.update = function(dt)
		--update player position
		 x =  x +  x_velocity
		--update player sprite
		--TODO: better sprite system (states?)
		if  slide then
			 img = love.graphics.newImage('slide.png')
		else
			 img = love.graphics.newImage('player.png')
		end
		--set player's ability to jump if they're on the ground
		--RIP
		if  y ==  ground and not love.keyboard.isDown('z') then 
			 canjump = true
		end
	
		--handle player gravity
		if  y_velocity ~= 0 then
			 y =  y +  y_velocity * dt
			 y_velocity =  y_velocity -  gravity * dt
		end
		
		--RIP X2
		if  y >  ground then
			 y_velocity = 0
			 y =  ground
		end
	
		--movement code: kinda shnowy
		--I wanted movement to feel really smooth so the movement code is fairly big
		if love.keyboard.isDown('left') and not love.keyboard.isDown('right')  then
			if not ( x_velocity > ( max_speed - 2)) then
				--reset player speed if moving in the opposite direction
				if  x_velocity > 0 and not  slide then
					 x_velocity =  x_velocity / 2
				end	
				--give the player an initial dash to keep movement quick
				if  x_velocity < 1 and  x_velocity > -1 then
					 x_velocity = -4
					 slide = false
				end
				--increment player velocity
				if not ( x_velocity < ( max_speed * -1)) then
					 x_velocity =  x_velocity - ( ac / 2)
				end
			else
				--if moving at max speed cause a slowdown animation
				 slide = true
				 x_velocity =  x_velocity /  decel
			end
		elseif love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
			if not ( x_velocity < (( max_speed - 2) * -1)) then
				--reset player speed if moving in the opposite direction
				if  x_velocity < 0 and not  slide then
					 x_velocity =  x_velocity / 2
				end
				--give the player an initial dash to keep movement quick
					if  x_velocity < 1 and  x_velocity > -1 then
					 x_velocity = 4
					 slide = false
				end
				--increment player velocity
				if not ( x_velocity >  max_speed) then
					 x_velocity =  x_velocity + ( ac / 2)
				end
			else
				--if moving at max speed cause a slowdown animation
				 slide = true
				 x_velocity =  x_velocity /  decel
			end
		else
			--neutral player slowdown
			if  x_velocity ~= 0 then
				if  x_velocity > 0 then
					 x_velocity =  x_velocity - ( ac)
				else
					 x_velocity =  x_velocity + ( ac)
				end
			end
			--make sure player actually hits zero velocity
			if  x_velocity <  decel and  x_velocity > ( decel * -1) and not ( x_velocity == 0) then
				 x_velocity = 0
			end
		end
		
		--make player jump
		if love.keyboard.isDown('z') then
			if  canjump then
				 y_velocity =  jump_height
				 canjump = false
				 slide = false
			end
		end
		--end movement code

	end

	player.draw = function()

		love.graphics.print('player velocity: '..  x_velocity, 10, 30)
		love.graphics.print('player.x: ' ..  x, 10, 50)
		love.graphics.print('player.y: ' ..  y, 10, 70)

	end

return player
