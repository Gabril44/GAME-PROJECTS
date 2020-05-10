--Bienvenido al código de mi pong, fue hecho siguiendo los cursos de Harvard pero borrando la poo

push = require 'push'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 764
--cambiara a 1200 x 720--
--1024 x 764--

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--velocidad de las paletas, en update se utiliza
PADDLE_SPEED = 200

    player1Score = 0
    player2Score = 0
    gameWinner = 0
    

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle("Pong by: Gabriel Acevedo")
 
    math.randomseed(os.time())

   
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 23)

   
    love.graphics.setFont(smallFont)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    function love.resize( w,h )
        push:resize(w,h)
    end

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    --atributos de los jugadores
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
    player1X=10
    player2X=VIRTUAL_WIDTH-10
    counter=0
    servingPLayer = 0

     --pelota
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2


    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    
    gameState = 'start'
end


function love.update(dt)

    --devolver para el otro lado la pelota una vez que se anote un punto en el score
    if gameState == 'serve' then
        
        ballDY = math.random(-50, 50)
        if servingPLayer == 2 then
            ballDX = math.random(140, 200)
        else
            ballDX = -math.random(140, 200)
        end

    elseif gameState == 'play' then
  --colison!! probablemente lo que más me costó.
  --player1
   if (ballX > player1X + 4 or player1X > ballX + 4) or (ballY>player1Y+20 or player1Y>ballY+4) then
        --normal--
         counter=0
    else 
      ballDX = -ballDX * 1.03
      ballX = player1X+5
      sounds['paddle_hit']:play() 
   --mantener el movimiento y randomizarlo
    if ballDY < 0 then
         ballDY = -math.random(10, 150)
    else
        ballDY = math.random(10, 150)
            end
      end
  --player2

    if (ballX > player2X + 4 or player2X > ballX + 4) or (ballY>player2Y+20 or player2Y>ballY+4) then
        --normal--
            counter=0
    else 
      ballDX = -ballDX * 1.03
      ballX = player2X - 4

      sounds['paddle_hit']:play()
     -- mantener el movimiento y randomizarlo
      if ballDY < 0 then
          ballDY = -math.random(10, 150)
           else
         ballDY = math.random(10, 150)
       end
     end

      --para evitar que la pelota se pase por arriba o abajo de la pantalla
      if ballY<=0 then
        ballY=0
        ballDY= -ballDY
        sounds['wall_hit']:play()
    end
     if ballY>=VIRTUAL_HEIGHT-4 then
       ballY=VIRTUAL_HEIGHT-4
        ballDY = -ballDY
        sounds['wall_hit']:play()
    end

     if ballX<0 then
      player2Score=player2Score+1
      servingPLayer=2
      sounds['score']:play()
      gameState='serve'
      --resetar pelota
      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

       if player2Score >= 10 then 
      --gana player2
          gameWinner=2

          gameState='done'

         end

    elseif  ballX>=432 then
      player1Score=player1Score+1
      servingPLayer=1
      sounds['score']:play()
      gameState='serve'

      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2
        if player1Score >= 10 then 
       --gana player1
          gameWinner=1

          gameState='done'
         end

    end

  end


    -- movimiento del player1
    if love.keyboard.isDown('w') then
       
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
      
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- movimiento player 2 
    if love.keyboard.isDown('up') then
      
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
       
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    --acomodamiento de la pelota
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end


function love.keypressed(key)
   
    if key == 'escape' then
        
        love.event.quit()
   
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'

        elseif gameState == 'serve' then

            gameState = 'play'
            
           --imprimimos la pelota en el medio de la pantalla
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
   if key == 'enter' or key == 'return' then
     if gameState == 'done' then
        
        gameState = 'play'
        player2Score=0
        player1Score=0

     end
   end

end

function displayFPS( )
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
end

function love.draw()
 
    push:apply('start')
    --color gris de atari
    love.graphics.clear(0, 0, 0, 255)
    --seteo la letra pequeña
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Pong by: Gabriel Acevedo\n 21/04/2020 ', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then 
     love.graphics.printf('A jugar!', 0, 20, VIRTUAL_WIDTH, 'center')
   --seteo la letra grande
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH/ 2 + 30, VIRTUAL_HEIGHT/3)
    elseif gameState == 'done' then
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player '..gameWinner..' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press ENTER to restart <3', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
    love.graphics.setFont(smallFont)
    love.graphics.printf ('point! press ENTER', 0, 10, VIRTUAL_WIDTH, 'center')

    end
   --imprimimos a los jugadores y la pelota
    love.graphics.rectangle('fill', player1X, player1Y, 5, 20)

 
    love.graphics.rectangle('fill', player2X, player2Y, 5, 20)

    --pelota
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    displayFPS()
 
    push:apply('end')
end
