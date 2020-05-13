--[[brennyn Gray creation of bird class]]

Bird = Class{}

--[[ the lower the number the slower you will fall]]
local GRAVITY = 20

--[[load image from disk adn assign its width and height]]
function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --draw our bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    
    --update our Y velocity
    self.dy = 0

end

function Bird:collides(pipe)
    --[[-the 2's are left and top offsets,
        -the 4's are right and bottom offsets,
        -both offsets are used to shrink the bounding box to give
        the player a bit of leeway]]
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height -4) >= pipe.y and self.y +2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    ---apply gravity to velocity
    self.dy = self.dy + (GRAVITY * dt)
    
    --add a burst of negative gravity if we hit space
    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

   --apply velocity to Y position
    self.y = self.y + self.dy

end

--[[ render our bird to the screen]]
function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end