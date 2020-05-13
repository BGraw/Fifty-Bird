--[[Brennyn Gray]]


PipePair = Class{}


function PipePair:init(y)

    -- size of gap betweeen pipes
    local GAP_HEIGHT = math.min(80, 100)

    --initialize pipes 
    self.x = VIRTUAL_WIDTH + 32

    --[[y value is for the topmost pipe; gap is a vertical
        shift of the second]]
    self.y = y 
    
    --[[ stops the pipes from spawning off the top of the screen]]
    if self.y <= 0 then 
        self.y = self.y + 50
    else
        self.y = y
    end

    --instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    --[[whether this pipe pair is ready to be removed]]
    self.remove = false

    --whether or not the pair of pipes has been scored
    self.scored = false
end

function PipePair:update(dt)
    --[[remove the pipe if its beyond the left edge of the
        screen, else move it from right to left]]
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end