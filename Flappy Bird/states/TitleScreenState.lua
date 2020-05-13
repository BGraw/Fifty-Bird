--[[Brennyn Gray

    TitleScreenState is the starting screen of the game, shown
    on startup, display "Prsee Enter"]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    --print title to screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Graw Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press p to pause in game', 0, 136, VIRTUAL_WIDTH, 'center')
end
