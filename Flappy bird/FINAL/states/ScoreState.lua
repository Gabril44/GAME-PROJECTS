--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}
medalla0 = love.graphics.newImage('medalla0.png')
medalla1 = love.graphics.newImage('medalla1.png')
medalla2 = love.graphics.newImage('medalla2.png')
medalla3 = love.graphics.newImage('medalla3.png')
medalla4 = love.graphics.newImage('medalla5.png')
--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')

    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oh no! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    
    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if(self.score<1)then
    love.graphics.printf('paper medal', 0, 180, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(medalla0, VIRTUAL_WIDTH / 2 - (medalla0:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (medalla0:getWidth() / 2))
    end

    if(self.score>=1 and self.score<10)then
    	love.graphics.draw(medalla1, VIRTUAL_WIDTH / 2 - (medalla1:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (medalla1:getWidth() / 2))
     love.graphics.printf('silver medal', 0, 180, VIRTUAL_WIDTH, 'center')
    end

    if(self.score>=11 and self.score<20)then
    	love.graphics.draw(medalla2, VIRTUAL_WIDTH / 2 - (medalla2:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (medalla2:getWidth() / 2))
     love.graphics.printf('gold medal', 0, 180, VIRTUAL_WIDTH, 'center')
    end

    if(self.score>=21 and self.score<30)then
    	love.graphics.draw(medalla3, VIRTUAL_WIDTH / 2 - (medalla3:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (medalla3:getWidth() / 2))
     love.graphics.printf('diamond medal', 0, 180, VIRTUAL_WIDTH, 'center')
    end

    if(self.score>=31)then
    	love.graphics.draw(medalla4, VIRTUAL_WIDTH / 2 - (medalla4:getWidth() / 2), VIRTUAL_HEIGHT / 2 - (medalla4:getWidth() / 2))
     love.graphics.printf('MONSTER medal', 0, 180, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end