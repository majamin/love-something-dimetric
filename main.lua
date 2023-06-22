-- https://github.com/SpaceCat-Chan/LoveKeys
LoveKeys = require("LoveKeys")

local colors = {
  ["yellow"] = { 0.88, 0.63, 0.05 },
  ["green"] = { 0.29, 0.75, 0.24 },
  ["red"] = { 0.9, 0.2, 0.2 },
  ["blue"] = { 0.41, 0.53, 0.97 },
}

-- constants
TILE_SIZE = 80
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- set window dimensions
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
  fullscreen = false,
  resizable = false,
  vsync = true,
})

local player = {
  x = 0,
  y = 0,
  speed = 100,
  color = colors["yellow"],
}

-- create a grid of tiles that fit inside the window with random colors
local tiles = {}
for y = 0, WINDOW_HEIGHT, TILE_SIZE do
  for x = 0, WINDOW_WIDTH, TILE_SIZE do
    table.insert(tiles, {
      x = x,
      y = y,
      -- x and y are used to calculate hue
      color = { x / WINDOW_WIDTH, y / WINDOW_HEIGHT, 0.5 },
    })
  end
end

-- a function that pretty prints a table
local function printTable(t)
  for k, v in pairs(t) do
    print(k, v)
  end
end

function love.keypressed(Key)
  LoveKeys.keypressed(Key)
end

function love.keyreleased(Key)
  LoveKeys.keyreleased(Key)
end

function love.load()
  LoveKeys.RegisterKey("up")
  LoveKeys.RegisterKey("down")
  LoveKeys.RegisterKey("left")
  LoveKeys.RegisterKey("right")

  love.graphics.setBackgroundColor(colors["blue"])

  -- isometric transform (reverse order of operations)
  transform = love.math.newTransform()
  transform:scale(1, 0.5)
  transform:translate(WINDOW_WIDTH / 2, TILE_SIZE)
  transform:rotate(math.pi / 4)
end

function love.draw()
  love.graphics.applyTransform(transform)
  for _, tile in ipairs(tiles) do
    love.graphics.setColor(tile.color)
    love.graphics.rectangle("fill", tile.x, tile.y, TILE_SIZE, TILE_SIZE)
  end
  -- draw player
  love.graphics.setColor(player.color)
  love.graphics.rectangle("fill", player.x, player.y, TILE_SIZE, TILE_SIZE)
end

function love.update(dt)
  if LoveKeys.up.Held then
    player.x = player.x - player.speed * dt
    player.y = player.y - player.speed * dt
  end
  if LoveKeys.down.Held then
    player.x = player.x + player.speed * dt
    player.y = player.y + player.speed * dt
  end
  if LoveKeys.left.Held then
    player.x = player.x - player.speed * dt
    player.y = player.y + player.speed * dt
  end
  if LoveKeys.right.Held then
    player.x = player.x + player.speed * dt
    player.y = player.y - player.speed * dt
  end

  LoveKeys.update(dt)
end
