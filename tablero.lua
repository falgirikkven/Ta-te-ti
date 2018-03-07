local tablero = {}

-- estas constantes son propias de este archivo y se
-- colocan fuera de las funciones para no declararlas
-- cada vez que se llamen a las funciones que las implementan
local relleno_sin_mouse_libre = {148, 148, 148, 255}
local relleno_sin_mouse_circulo = {122, 122, 175, 255}
local relleno_sin_mouse_cruz = {175, 122, 122, 255}
local relleno_con_mouse_libre = {180, 180, 180, 255}
local relleno_con_mouse_circulo = {163, 163, 199, 255}
local relleno_con_mouse_cruz = {199, 163, 163, 255}
local contorno = {255, 255, 255, 255}

--[[
*** variables_utilizadas ***
tablero.arriba_izquierda_x   (donde empieza la
tablero.arriba_izquierda_y    primera celda del tablero)

tablero.celda_ancho          (dimensiones de las
tablero.celda_alto            celdas del tablero)

tablero.distancia_horizontal (espaciado entre celda
tablero.distancia_vertical    y celda del tablero)
*** fin variables_utilizadas ***
]]--

-- Las celdas del tablero son una tabla en si
-- mismas, un poco complicado pero asi esta la cosa
-- (esta variable necesita ser declarada)
tablero.celdas = {}
--[[
*** celdas_variables
pos_x  (posicion en la que sera
pos_y   dibujada la celda)

valor  (a cual jugador le pertenece esta celda?)
*** fin celdas_variables
]]--

-- sirve para saber si hubo algun cambio
local necesita_actualizar = false

-- *** Funciones_directamente_llamadas_por_Love *** --

function tablero.nueva_celda( x, y )
   return( { pos_x = x,
	         pos_y = y,
	         valor = 0 } )
end

-- Load
function tablero.load()
  tablero.arriba_izquierda_x = total_ancho * 0.1
  tablero.arriba_izquierda_y = total_alto * 0.13
  tablero.celda_ancho = total_ancho * 0.25
  tablero.celda_alto = total_alto * 0.25
  tablero.distancia_horizontal = total_ancho * 0.02
  tablero.distancia_vertical = total_alto * 0.02
  for fila=1, 3 do
    for colum=1, 3 do
      local celda_posicion_x = tablero.arriba_izquierda_x +
	   (colum-1) * ( tablero.celda_ancho + tablero.distancia_horizontal )
	  local celda_posicion_Y = tablero.arriba_izquierda_y +
	   (fila-1) * ( tablero.celda_alto + tablero.distancia_vertical )
	  local nueva_celda = tablero.nueva_celda( celda_posicion_x, celda_posicion_Y, fila, colum )
	  table.insert( tablero.celdas, nueva_celda )
    end
   end
end

function tablero.MouseDentroCelda( celda, mouseX, mouseY )
  local dx = mouseX - celda.pos_x
  local dy = mouseY - celda.pos_y
  if dx<0 or dx>tablero.celda_ancho then
    return false
  end
  if dy<0 or dy>tablero.celda_alto then
    return false
  end
  return true
end

function tablero.draw_relleno(celda, mouseX, mouseY)
  local val=celda.valor
  local relleno
  if tablero.MouseDentroCelda( celda, mouseX, mouseY ) then
    if val==1 then
	  relleno=relleno_con_mouse_circulo
	elseif val==2 then
	  relleno=relleno_con_mouse_cruz
	else
      relleno=relleno_con_mouse_libre
	end
  else
    if val == 1 then
	  relleno=relleno_sin_mouse_circulo
	elseif val==2 then
	  relleno=relleno_sin_mouse_cruz
	else
      relleno=relleno_sin_mouse_libre
	end
  end
  love.graphics.setColor(relleno)
  love.graphics.rectangle( 'fill', celda.pos_x, celda.pos_y, tablero.celda_ancho, tablero.celda_alto )
end

-- Draw
function tablero.draw( mouseX, mouseY)
  
  for _, celda in pairs( tablero.celdas ) do
    tablero.draw_relleno(celda, mouseX, mouseY)
    
	love.graphics.setColor(contorno)
    love.graphics.rectangle( 'line', celda.pos_x, celda.pos_y, tablero.celda_ancho, tablero.celda_alto )
  end
  
end

--Update (verifica las condiciones de victoria
function tablero.update(dt)
  if not necesita_actualizar then
    return
  end
  necesita_actualizar =false
  
  local valores = {}
  local i = 1
  mensaje = ""
  for _, celda in pairs( tablero.celdas ) do
    valores[i]=celda.valor
	i=i+1
  end
  
  local fin=false
  local jug_aux
  -- verifica filas
  for j=0,2,1 do
    
    if valores[3*j+1]~=0 then
	  jug_aux=valores[3*j+1]
	  if valores[3*j+2] == jug_aux and valores[3*j+3] == jug_aux then
	    fin=true
	  end
	end
	
  end
  
  -- verifica columnas
  if not fin then
    for j=1,3,1 do
	
      if valores[j]~=0 then
	    jug_aux=valores[j]
	    if valores[j+3] == jug_aux and valores[j+6] == jug_aux then
	      fin=true
	    end
	  end
	  
    end
  end
  
  -- diagonal 1-5-9
  if not fin then
    jug_aux=valores[1]
	if valores[5] == jug_aux and valores[9] == jug_aux and jug_aux~=0 then
	  fin=true
	end
  end
  
  -- diagonal 7-5-3
  if not fin then
    jug_aux=valores[7]
	if valores[5] == jug_aux and valores[3] == jug_aux and jug_aux~=0 then
	  fin=true
	end
  end
  
  if fin then
    mensaje="Juego finalizado: Gana el "
	if jug_aux == 1 then
	  mensaje=mensaje.."azul"
	else
	  mensaje=mensaje.."rojo"
	end
  end
end
-- *** fin Funciones_directamente_llamadas_por_Love *** --

-- Funciones llamadas por accion del usuario
function tablero.Celda_Marcar(celda)
  if celda.valor == 0 then
    celda.valor = Jugador_Actual
	if Jugador_Actual==1 then
	  Jugador_Actual=2
	else
	  Jugador_Actual=1
	end
	necesita_actualizar=true
  end
end

-- Podes adivinar porque declaro out=nil?
function tablero.Celda_Tocada( mouseX, mouseY )
  local out = nil
  for _, celda in pairs( tablero.celdas ) do
	if tablero.MouseDentroCelda( celda, mouseX, mouseY ) then
	  out=celda
	end
  end
  return out
end

return tablero
