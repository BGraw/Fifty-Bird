--[[ Brennyn Gray

    The PlayState class is the bulk of the game, where the 
    player actually controls the bird and avoids pipes. 
    When the player collides with a pipe, we should go to the 
    GameOver state, where we then go back to the main menu.]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 80
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24


function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    --keep track of our score
    self.score = 0

    --add delay for interval randomization
    self.delay = 2

    --addition for pause feature
    self.pause = false

    --[[initialize last recorded Y value for a gap placement
        to base other gaps off of]]
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    if self.pause == false then
        --update timer for pipe spawning
        self.timer = self.timer + dt
    
        --[[spawn a new pipe pair every 2 seconds]]
        if self.timer > self.delay then 

            --[[modify the last Y coordinate we placed so that 
                pipe gaps arent too far apart. no higher than 10 
                pixels below top edge of screen,  no lower than
                a gap length ]]
            local y = math.min(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y
        
            --[[add a new pipe pair at the end of our screen at 
            our new Y]]
            table.insert(self.pipePairs, PipePair(y))

            --reset timer and randomize delay for pipe intervals
            self.timer = 0
            self.delay = math.random(1, 3)
        end

        --for every pair of pipes...
        for k, pair in pairs(self.pipePairs) do
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true  
                    sounds['score']:play()
                end
            end
            --update position of pair
            pair:update(dt)
        end

        --[[ we need this second loop because without it we end 
        deleting the pair that leaves the screen and this would
        cause the table to skip the next pair oof pipes, causing a 
        glitch.]]
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

       --[[update bird based on gravity and input]]
        self.bird:update(dt)

        --simple collision between bird and all pipePairs
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        --reset if we hit the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()
        
            gStateMachine:change('score', {
                score = self.score
            })
        end
        if love.keyboard.wasPressed('p') then
            self.pause = true
            scrolling = false
            self.bird.y = self.bird.y;
        end
    else
        if love.keyboard.wasPressed('p') then
            self.pause = false
            scrolling = true
        end
    end
end  

function PlayState:render()
    if self.pause == true then
        --render bird and pipes in last state
        for k, pair in pairs(self.pipePairs) do 
            pair:render()
        end
        self.bird:render()
        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

        --render pause menu
        love.graphics.setFont(flappyFont)
        love.graphics.print('Paused...', VIRTUAL_WIDTH - 140, 8)
    
        love.graphics.setFont(mediumFont)
        love.graphics.print('Press P to resume', VIRTUAL_WIDTH - 140, 40)
    else
        for k, pair in pairs(self.pipePairs) do
            pair:render()
        end

        --[[display our score in the top left corner]]
        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

        self.bird:render()
    end
end

