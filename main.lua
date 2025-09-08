json = require("json")
misa = require("misa")

playonce = false

function love.load()

    math.randomseed(os.time())

    arraylist = {}
    for index = 1, # arraylist do
        name = arraylist[index]
        addDebug(name)
    end

    countdown = 1
    Heart = 2

    --state variable
    shootingBullet = false
    checkCollision = false
    gameOver = false
    gamestart = true

    -- variable list
    monsterList = {}
    monster2List = {}
    monster3List = {}
    monster4List = {}
    bulletList = {}
    explosionList = {}

    -- background
    bg = misa.newObject("bg.jpg")
    bg.x = 400
    bg.y = 300

    bg2 = misa.newObject("bg2.jpg")
    bg2.x = 400
    bg2.y = -300

    start = misa.newObject("start.png")
    start.x = 400
    start.y = 300

    planet1 = misa.newObject("planet1.png")
    planet1.x = 400
    planet1.y = 300

    planet2 = misa.newObject("planet2.png")
    planet2.x = 400
    planet2.y = -300

    -- character
    spaceship = misa.newObject("spaceship.png")
    spaceship.x = 400
    spaceship.y = 500
    spaceship.xScale = 0.4
    spaceship.yScale = 0.4

    gameover = misa.newObject("gameover.png")
    gameover.x = 400
    gameover.y = 300
    gameover.xScale = 1.5
    gameover.yScale = 1.5
    gameover.alpha = 0

    -- life
    heart = misa.newObject("heart.png")
    heart.x = 760
    heart.y = 40
    heart.alpha = 1

    heart2 = misa.newObject("heart2.png")
    heart2.x = 740
    heart2.y = 40
    heart2.alpha = 1

    heart3 = misa.newObject("heart3.png")
    heart3.x = 720
    heart3.y = 40
    heart3.alpha = 1

    --fond
    impactFont = love.graphics.newFont("Impact.ttf", 48)
    impactFont2 = love.graphics.newFont("Impact.ttf", 24)

    --sound
    soundBGList = {}
    shootSoundList = {}
    deathSoundList = {}
    playSound("soundBG.wav", soundBGList, 1)

    -- score data
    score  = 0
    dataString = misa.loadData()
    highscore = tonumber(dataString) 
    --if an old highscore doesn't exit, o is returned here instead. 

    -- Data testing
    -- misa.saveData("This is a test")
    -- misa.loadData()
    -- misa.deleteData()
    -- misa.loadData()

    misa.loadData()
    if misa.dataObject.highscore == nil then
        misa.dataObject.highscore = 0
    end
    highscore = misa.dataObject.highscore

end

-- sound function
function playSound(name, List, volume)
    for index = 1, #List do
        sound = List[index]
        if sound:isPlaying() == false then
            sound:setVolume(volume)
            love.audio.play(sound)
            return
        end
    end

    newSound = love.audio.newSource(name, "static")
    newSound:setVolume(volume)
    love.audio.play(newSound)
    List[#List + 1] = newSound
end

function love.update(dt)

    --start page
    if gamestart == ture then
        start.alpha = 1
    end

    -- set the game to that start
    if love.keyboard.isDown("s") == true then
        start.alpha = 0 

        monsterList = {}
        monster2List = {}
        monster3List = {}
        monster4List = {}
        bulletList = {}
        explosionList = {}

        gameover.alpha = 0

        -- reset player position
        spaceship.x = 400
        spaceship.y = 500

        -- reset score
        score = 0

        --reset life
        Heart = 2
        heart.alpha = 1
        heart2.alpha = 1
        heart3.alpha = 1

        gameOver = false
    end

    -- game over page
    if gameOver == true then
    -- Game Over Phase
        if love.keyboard.isDown("r") == true then
        -- restart button
            
            --delete objects
            monsterList = {}
            monster2List = {}
            monster3List = {}
            monster4List = {}
            bulletList = {}
            explosionList = {}

            gameover.alpha = 0

            -- reset player position
            spaceship.x = 400
            spaceship.y = 500

            -- reset score
            score = 0

            --reset life
            Heart = 2
            heart.alpha = 1
            heart2.alpha = 1
            heart3.alpha = 1

            gameOver = false
        end
    end

    -- Moving Main Background
    bg.y = bg.y + 2
    bg2.y = bg2.y + 2

    if bg.y >= 900 then
        bg.y = -300
    end 
    if bg2.y >= 900 then
        bg2.y = -300
    end

    -- Moving first layer
    planet1.y = planet1.y + 1.2
    planet2.y = planet2.y + 1.2

    if planet1.y >= 900 then
        planet1.y = -300
    end 
    if planet2.y >= 900 then
        planet2.y = -300
    end

    -- life status
    if Heart == 1 then
        heart3.alpha = 0
    end

    if Heart == 0 then
        heart2.alpha = 0
    end

    if Heart == -1 then
        heart.alpha = 0
        gameOver = true
        gameover.alpha = 1
        return
    end

    love.timer.sleep(1/60 - dt)

    -- bubble effect when the moster die
    for index = #explosionList, 1, -1 do
        explosion = explosionList[index]
        explosion.currentFrame = explosion.currentFrame + 1
        if explosion.currentFrame > 9 then
            table.remove(explosionList, index)
        end
    end

        -- Create the monster
        if math.random(1,40) == 1 then
            newMonster = misa.newObject("monsterR.png")
            newMonster.x = 0 + math.random(0,600)
            newMonster.y = 0
            newMonster.xScale = 0.3
            newMonster.yScale = 0.3
            monsterList[#monsterList + 1] = newMonster

            -- Create the Blue monster
            if score >= 100 then
                if math.random(1,2) == 1 then
                    newMonster.image = love.graphics.newImage("monsterB.png")
                    newMonster.xScale = 0.6
                    newMonster.yScale = 0.6
                end
            end
            -- Create the Green monster
            if score >= 200 then
                if math.random(1,2) == 1 then
                    newMonster.image = love.graphics.newImage("monsterG.png")
                    newMonster.xScale = 0.4
                    newMonster.yScale = 0.4
                end
            end
            -- Create the Yellow monster
            if score >= 300 then
                if math.random(1,2) == 1 then
                    newMonster.image = love.graphics.newImage("monsterY.png")
                    newMonster.xScale = 0.25
                    newMonster.yScale = 0.25
                    newMonster.width = newMonster.image:getWidth()
                    newMonster.height = newMonster.image:getHeight()
                end
            end
        end

        for index = #monsterList, 1, -1 do
            monster = monsterList[index]

            monster.y = monster.y + 1

            if monster.y > 600 then
                monster.alpha = 0
            end

            if monster.alpha <= 0 then
                table.remove(monsterList, index)
            end
        end

        -- Ship moving
        if love.keyboard.isDown("right") == true then
            spaceship.x = spaceship.x + 5
        end
        if love.keyboard.isDown("left") == true then
            spaceship.x = spaceship.x - 5
        end
        if love.keyboard.isDown("up") == true then
            spaceship.y = spaceship.y - 5
        end
        if love.keyboard.isDown("down") == true then
            spaceship.y = spaceship.y + 5
        end

        -- Bullet shooting
        if love.keyboard.isDown("space") == true then
            -- if shootingBullet == false then
            if #bulletList < 1 then
                newBullet = misa.newObject("bullet.png")
                newBullet.x = spaceship.x
                newBullet.y = spaceship.y - 50
                newBullet.xScale = 0.8
                newBullet.yScale = 0.8
                bulletList[#bulletList + 1] = newBullet
                shootingBullet = false
            -- else
            --     shootingBullet = true
            end
        end

        for index = #bulletList, 1, -1 do
            bullet = bulletList[index] 
            if bullet.y > 0 then
                bullet.y =  bullet.y - 10
            else
                table.remove(bulletList, index)
            end
        end 

        -- if countdown == 0 then 
        --     for index = #bulletList, 1, -1 do
        --         bullet = bulletList[index] 
        --         if bullet.y > 0 then
        --             bullet.y =  bullet.y - 10
        --         else
        --             table.remove(bulletList, index)
        --         end
        --     end 
        --     countdown = 60
        -- else 
        --     countdown = countdown - 1
        -- end


        -- How to kill the moster
        for index = #bulletList, 1, -1 do
            bullet = bulletList[index] 

            for index2 = #monsterList, 1, -1 do
                monster = monsterList[index2]

                xDistance = monster.x - bullet.x
                yDistance = monster.y - bullet.y
                distance = math.sqrt(xDistance^2 + yDistance^2)

                radius = monster.width * monster.xScale / 2

                if distance < radius then
                -- if checkCollision(bullet, enemy) == true then 
                    table.remove(bulletList, index)
                    table.remove(monsterList, index2)
                    playSound("shootSound.wav", shootSoundList, 1)
                    score = score + 10

                    newBomb = misa.newAnimation("bomb", ".png", 10)
                    newBomb.x = bullet.x
                    newBomb.y = bullet.y
                    newBomb.xScale = 0.8
                    newBomb.yScale = 0.8
                    explosionList[#explosionList + 1] = newBomb

                    break
                end
            end
        end

        -- move all enemies each frame
        -- How the ship gonna die
        for index = #monsterList, 1, -1 do
            monster = monsterList[index] -- get1 enemy form the list
            monster.y = monster.y + 2 -- move enemy down

            -- remove enemy when it reaches the bottom of the screen
            if monster.y < 0 - monster.height/2 then
                table.remove(monsterList, index)
            end

            -- chek is enemy collides with player ship
            xDistance = monster.x - spaceship.x
            yDistance = monster.y - spaceship.y
            distance = math.sqrt(xDistance^2 + yDistance^2)

            radius = spaceship.width * spaceship.xScale / 2

            if distance < radius then
                if score > highscore then
                    highscore = score
                    misa.dataObject.highscore = highscore
                    misa.saveData()
                end

                playSound("deathSound.wav", deathSoundList, 1)
                Heart = Heart - 1
                table.remove(monsterList, index)
            end
        end

end

function love.draw()
    misa.drawObject(bg)
    misa.drawObject(bg2)
    misa.drawObject(planet1)
    misa.drawObject(planet2)
    misa.drawObject(spaceship)

    --score
    love.graphics.print("SCORE: ".. score, impactFont, 10, 10)
    love.graphics.print("HIGH SCORE: ".. highscore, impactFont2, 10, 60)

    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.print(misa.fileStatus, 0, 0) -- Draw file status

    --Life
    misa.drawObject(heart)
    misa.drawObject(heart2)
    misa.drawObject(heart3)

    for index = 1, #bulletList do
        bullet = bulletList[index]
        misa.drawObject(bullet)
    end

    for index = 1, #monsterList do
        monster = monsterList[index]
        misa.drawObject(monster)
    end

    for index = #explosionList, 1, -1 do
        explosion = explosionList[index]
        misa.drawAnimation(explosion)
    end

    -- Checking the number of bullet and monster
    --love.graphics.print(#bulletList, 0, 0)
    -- love.graphics.print(#monsterList, 790, 0)

    misa.drawObject(gameover)

    -- love.graphics.print(fileStatus, 0, 0)

    misa.drawObject(start)

end