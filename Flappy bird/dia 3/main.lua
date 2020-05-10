push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState' 
require 'states/CountdownState'
require 'states/TitleScreenState'


WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH=512
VIRTUAL_HEIGHT=288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED=30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413


local bird = Bird()

local pipes = {}

local pipePairs = {}

local spawnTimer = 0

local lastY= -PIPE_HEIGHT + math.random(80)+20

local scrolling = true

function love.load()

  love.graphics.setDefaultFilter('nearest', 'nearest')

  math.randomseed(os.time())

  love.window.setTitle('Flappy ghost by Gabriel Acevedo')

  smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {

    vsync=true;
    fullscreen=true;
    resizable=true;

  })

  gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')


      love.keyboard.keysPressed = {}
end

function love.update( dt )
	--if scrolling then
	backgroundScroll=(backgroundScroll+BACKGROUND_SCROLL_SPEED*dt)
	%BACKGROUND_LOOPING_POINT
	--------------------------------------------------------------
	groundScroll=(groundScroll+GROUND_SCROLL_SPEED*dt)
	%VIRTUAL_WIDTH
    --------------------------------------------------------------
     -- update background and ground scroll offsets


    -- now, we just update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- reset input table
    love.keyboard.keysPressed = {}
    --[[spawnTimer = spawnTimer+dt
     if spawnTimer > 2 then

        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
        
        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    bird:update(dt)]]

    --[[for k, pipe in pairs (pipes) do
      pipe:update(dt)
     if pipe.x < -pipe.width then

    	table.remove(pipes, k)

     end  
    end]]--
--agregar las tuberias

    --[[for k, pair in pairs(pipePairs) do
        pair:update(dt)
        
        for l, pipe in pairs(pair.pipes) do
        if bird:collides(pipe) then
                    -- pause the game to show collision
       scrolling = false
        end
      end

     if pair.x< -PIPE_WIDTH then
   	  pair.remove=true
     end

    end

   

--quitarlas
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end
 end

    love.keyboard.keysPressed={}

end]]
end
function love.keyboard.wasPressed( key )
	if love.keyboard.keysPressed[key]then
		return true
	else
		return false
	end
end

function love.resize( w,h )
	push:resize (w,h)
end

function love.keypressed( key )
    love.keyboard.keysPressed[key] = true

	if key == 'escape'then
		love.event.quit()
	end
end

function love.draw()
	push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    --[[for k, pipe in pairs(pipes) do
    --	pipe:render()
    --end
    for k, pair in pairs(pipePairs) do
        pair:render()
    end]]

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)
    --love.graphics.printf('gabikpo', 0, 20, VIRTUAL_WIDTH, 'center' )
    --bird:render()
    gStateMachine:render()

    push:finish()
end