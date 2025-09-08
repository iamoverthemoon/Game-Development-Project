local misa = {}

function misa.newObject(imageName)
    local object = {}
    object.x = 0
    object.y = 0
    object.rotation = 0
    object.xScale = 1
    object.yScale = 1
    object.image = love.graphics.newImage(imageName)
    object.width = object.image:getWidth()
    object.height = object.image:getHeight()
    object.xOrigin = object.width / 2
    object.yOrigin = object.height / 2
    object.red = 1
    object.green = 1
    object.blue = 1
    object.alpha = 1
    return object
end

function misa.drawObject(objs)
    love.graphics.setColor(objs.red, objs.green, objs.blue, objs.alpha)
    love.graphics.draw(objs.image,objs.x ,objs.y, objs.rotation, objs.xScale, objs.yScale, objs.xOrigin, objs.yOrigin)
end

function misa.drawAnimation(objs)
    love.graphics.setColor(objs.red, objs.green, objs.blue, objs.alpha)
    love.graphics.draw(objs.imageList[objs.currentFrame],objs.x ,objs.y, objs.rotation, objs.xScale, objs.yScale, objs.xOrigin, objs.yOrigin)
end

-- function misa.loadMusic(newSound)
--     local sound = love.audio.newSource(newSound, "static")
--     sound:setLooping(true)
--     return sound
-- end

function misa.newAnimation(baseName, extension, frames)
    name = baseName .."1"..extension
    object = misa.newObject(name)

    object.imageList= {}
    for index = 1, frames do
        name = baseName..index..extension
        object.imageList[index] = love.graphics.newImage(name)
    end

    object.currentFrame = 1

    return object
end

misa.imageList = {}
function misa.reuseImage(imageName)
    local image = misa.imageList[imageName]
    if image == nil then
        image = love.graphics.newImage(imageName)
        misa.imageList[name] = image
    end
end

misa.fileStatus = ""
misa.dataObject = nil

function misa.saveData()
    dataString = json.encode(misa.dataObject)
    --convert an entire object into a string
    love.filesystem.write("save.txt", dataString)
    --allow to save 1 data entry
    misa.fileStatus = "File saved\n" .. misa.fileStatus
end

function misa.loadData()
    if love.filesystem.getInfo("save.txt") == nil then
        misa.fileStatus = "File not found\n" .. misa.fileStatus
        misa.dataObject = {}
        -- create a new empty object
        -- return "0"
    else
        local dataString = love.filesystem.read("save.txt")
        misa.filestatus= "File loaded: " .. dataString .. "\n" .. misa.fileStatus
        misa.dataObject = json.decode(dataString)
        -- convert the file's string back into the saved data object
        -- return dataString
    end
end

function misa.deleteData()
    love.filesystem.remove("save.txt")
    misa.fileStatus = "Flle deleted\n" .. misa.fileStatus
end

function misa.loadMusic(song)
    misa.music = love.audio.newSource(song, "static")
    misa.music:setLooping(false)
    love.audio.play(misa.music)
end

return misa