--[[
*** variables_globales ***
total_alto    (rango Y del canvas)
total_ancho   (rango X del canvas)
*** fin variables_globales ***
]]--

mensaje = ""

local tablero = require "tablero"

-- Quien juega?
Jugador_Actual=1

-- General
function love.load()
  total_ancho = love.graphics.getWidth()
  total_alto = love.graphics.getHeight()
  love.graphics.setBackgroundColor(140, 101, 110, 255)
  tablero.load()
end

function love.draw()
  local x, y = love.mouse.getPosition()
  tablero.draw(x,y)
  love.graphics.print("TicTacToe Deluxe Edition",love.graphics.getHeight() / 2 + 10 ,10)
  love.graphics.print(mensaje,love.graphics.getHeight() / 2 + 10 ,25)
end

function love.update(dt)
  tablero.update(dt)
end

-- Marcar celda
function love.mousepressed( x, y, button, istouch )
   if button == 'l' or button == 1 then
     local celda = tablero.Celda_Tocada( x, y )
     if celda ~= nil then
	   tablero.Celda_Marcar(celda)
	 end
   end    
end

-- Salir con escape
function love.keypressed(key)
   if key == 'escape' then
      love.event.quit()
   end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end