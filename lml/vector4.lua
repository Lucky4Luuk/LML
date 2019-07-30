local vector4 = {_TYPE='module', _NAME='vector4', _VERSION='0.1'}
local vector4_meta = {}

function vector4:new(_x,_y,_z,_w)
  local x,y,z,w = _x,_y,_z,_w
  if type(_x) == "table" and _y == nil and _z == nil and _w == nil then
    x = _x[1] or _x.x
    y = _x[2] or _x.y
    z = _x[3] or _x.z
    w = _x[4] or _x.w
  end

  --Make vector4
  local v4 = {x=x,y=y,z=z,w=w,type="vector4"}

  --Metatable stuff
  return setmetatable(v4, vector4_meta)
end

function vector4.table(v)
  return {v.x, v.y, v.z, v.w}
end

function vector4.get(v1, index)
  local result = {}
  for i=1, index:len() do
    local c = index:sub(i, i):lower()
    if c == "x" then result[i] = v1.x elseif c == "y" then result[i] = v1.y elseif c == "z" then result[i] = v1.z elseif c == "w" then result[i] = v1.w end
  end
  return vector4(result[1], result[2], result[3], result[4])
end

function vector4.add(v1, v2)
  local vec_result = {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z, w=v1.w+v2.w}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.sub(v1, v2)
  local vec_result = {x=v1.x-v2.x, y=v1.y-v2.y, z=v1.z-v2.z, w=v1.w-v2.w}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.mul(v1, v2)
  local vec_result = {x=v1.x*v2.x, y=v1.y*v2.y, z=v1.z*v2.z, w=v1.w*v2.w}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.mulnum(v1, v2)
  local vec_result = {x=v1.x*v2, y=v1.y*v2, z=v1.z*v2, w=v1.w*v2}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.div(v1, v2)
  local vec_result = {x=v1.x/v2.x, y=v1.y/v2.y, z=v1.z/v2.z, w=v1.w/v2.w}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.divnum(v1, v2)
  local vec_result = {x=v1.x/v2, y=v1.y/v2, z=v1.z/v2, w=v1.w/v2}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.length(v)
  return math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z + v.w*v.w)
end

function vector4.normalize(v)
  local vec_length = v:length()
  local vec_result = {x=v.x/vec_length, y=v.y/vec_length, z=v.z/vec_length, w=v.w/vec_length}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.dot(v1, v2)
  return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w
end

function vector4.type(v)
  if type(v) == "table" and v._TYPE then
    return v._TYPE
  end
  return type(v)
end

function vector4.tostring(v)
  return "{"..tostring(v.x).."; "..tostring(v.y).."; "..tostring(v.z).."}"
end

function vector4.print(v)
  print(vector4.tostring(v))
end

function vector4.pow(v1,v2)
  local vec_result = {x=v1.x^v2, y=v1.y^v2, z=v1.z^v2, w=v1.w^v2}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.mod(v1, v2)
  local vec_result = {x=v1.x%v2.x, y=v1.y%v2.y, z=v1.z%v2.z, w=v1.w%v2.w}
  return setmetatable(vec_result, vector4_meta)
end

function vector4.modnum(v1, v2)
  local vec_result = {x=v1.x%v2, y=v1.y%v2, z=v1.z%v2, w=v1.w%v2}
  return setmetatable(vec_result, vector4_meta)
end

setmetatable( vector4, { __call = function( ... ) return vector4.new( ... ) end } )

--Get that metatable all done and dusted
--Addition +
vector4_meta.__add = vector4.add

--Subtraction -
vector4_meta.__sub = vector4.sub

--Multiply *
vector4_meta.__mul = function(v1, v2)
  if getmetatable(v1) ~= vector4_meta then
    return vector4.mulnum(v2, v1)
  elseif getmetatable(v2) ~= vector4_meta then
    return vector4.mulnum(v1, v2)
  end
  return vector4.mul(v1, v2)
end

--Division /
vector4_meta.__div = function(v1, v2)
  if getmetatable(v1) ~= vector4_meta then
    return vector4.divnum(v2, v1)
  elseif getmetatable(v2) ~= vector4_meta then
    return vector4.divnum(v1, v2)
  end
  return vector4.div(v1, v2)
end

--The - in front of negative numbers, unary minus
vector4_meta.__unm = function( v )
	return vector4.mulnum( v,-1 )
end

--Equal ==
vector4_meta.__eq = function(v1, v2)
  if vector4.type(v1) ~= vector4.type(v2) then
    return false
  end

  return (v1.x == v2.x and v1.y == v2.y and v1.z == v2.z and v1.w == v2.w)
end

--Pow ^
vector4_meta.__pow = vector4.pow

--Mod %
vector4_meta.__mod = function (v1, v2)
  if getmetatable(v1) ~= vector4_meta then
    --return vector4.modnum(v2, v1)
    if getmetatable(v2) == vector4_meta then
      error("Cannot take the modulo of a number using a vector")
    else
      return v1 % v2 --This shouldn't happen, because for this function to be called at least one of them should have a vector4_meta
    end
  elseif getmetatable(v2) ~= vector4_meta then
    return vector4.modnum(v1, v2)
  end
  return vector4.mod(v1, v2)
end

--To string tostring()
vector4_meta.__tostring = vector4.tostring

--Print print()
vector4_meta.__call = function(...)
  return vector4.print(...)
end

--Type .type
vector4_meta.type = vector4.type(...)

--Indexing
vector4_meta.__index = {}
for k,v in pairs(vector4) do
  vector4_meta.__index[k] = v
end

return vector4
