--[[Brennyn Gray]]

ScoreState = Class{__includes = BaseState}

--[[ add graphics for scores]]

--[[When we enter the score state, we expect to receive the 
    score from the play state so we know what to render to the
    state]]

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    --go back to 'play' if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    --simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You Lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
    if self.score < 6 then
        love.graphics.draw(love.graphics.newImage('bronze.png'), VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 - 20)
    elseif self.score < 10 then
        love.graphics.draw(love.graphics.newImage('silver.png'), VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 - 20)
    elseif self.score < 100 then
        love.graphics.draw(love.graphics.newImage('gold.png'), VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 - 20)
    end
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
