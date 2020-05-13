--Brennyn Gray Flappy Bird remake

--call our push.lua file
push = require 'push'

--require our class file
Class = require 'Class'

--call our bird class
require 'Bird'

--call our pipe class
require 'pipe'

--Class representing our pipe pairs together
require 'PipePair'

--all code related to game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- window settings
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--call local images for our background display
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--[[add speed variables for parallax scrolling, 
    NOTE: the ground scroll speed needs to be higher than the 
    background scroll speed to create the parallax scrolling
    effect.]]
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

--loop our image
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local Bird = Bird()

--[[scrolling variable used to pause the game when there
    is a collision]]
local scrolling = true



function love.load()
        love.graphics.setDefaultFilter('nearest', 'nearest')

        --seed the RNG
        math.randomseed(os.time())

        love.window.setTitle('Graw Bird')

        --initialize our nice-looking retro text fonts
        smallFont = love.graphics.newFont('font.ttf', 8)
        mediumFont = love.graphics.newFont('flappy.ttf', 14)
        flappyFont = love.graphics.newFont('flappy.ttf', 28)
        hugeFont = love.graphics.newFont('flappy.ttf', 56)
        love.graphics.setFont(flappyFont)

        --initialize our table of sounds
        sounds = {
            ['jump'] = love.audio.newSource('jump.wav', 'static'),
            ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
            ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
            ['score'] = love.audio.newSource('score.wav', 'static'),
            ['pause'] = love.audio.newSource('Pause.wav', 'static'),

            ['music'] = love.audio.newSource('marios_way.mp3', 'static')
        }

        --kick off music
        sounds['music']:setLooping(true)
        sounds['music']:play()

        -- initialize virtual resolution
        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
            fullscreen = false,
            resizeable = true,
            vsync = true
        })

        gStateMachine = StateMachine {
            ['title'] = function() return TitleScreenState() end,
            ['countdown'] = function() return CountdownState() end,
            ['play'] = function() return PlayState() end,
            ['score'] = function() return ScoreState() end,
            ['pause'] = function() return PauseState() end
        }
        gStateMachine:change('title')

        --[[ creates our own tables for keysPressed]]
        love.keyboard.keysPressed = {}

        --initialize mouse input table
        love.mouse.buttonsPressed = {}

end

--[[function that will allow our window and content to
    properly scale with the resizing of window]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[ function that gets key input from the user]]
function love.keypressed(key)
    --[[stores the keys that are getting pressed by LOVE2D]]
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    --[[this means on the last frame was this key pressed]]
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[mouse input function for each time the mouse is pressed]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling == true then
    --make our scroll frame rate independant
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
   
    --[[ ground image is consistent enonugh that we do not
        need to create a ground looping point so virtual 
        width will suffice]]
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end


--[[ render funtion for our updates in our code]]
function love.draw()
    push:start()

    --[[draw state machinge between the background and ground
    which defers render logic to the currently active state]]
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end