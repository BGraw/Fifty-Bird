--[[brennyn Gray pipe class remake]]

Pipe = Class{}
--[[different from bird class as we will be implementing multiple
    pipes on the same screen whereas the bird is one one image
    SO pipe image is oustide the funtion INIT
    Our GOAL is to reference the pipe image instead of 
    allocating the image as many times as possible.]]
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

--our pipes are scrolling ie: same speed as ground in most cases
PIPE_SPEED = 60

--[[height of pipe image, accessible globally]]
PIPE_HEIGHT = 430
PIPE_WIDTH = 70


function Pipe:init(orientation, y) --previously orientation and variable were not defined
    self.x = VIRTUAL_WIDTH 
        
    self.y = y --[[previously as to set the boundary of the lower pipe 
                    math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 30)]]

    --get width of pipe image using LUA function, get height
    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, -- rotation
    1, -- X scale
    self.orientation == 'top' and -1 or 1) -- Y scale
end