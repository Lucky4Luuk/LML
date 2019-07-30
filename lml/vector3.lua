local vector3 = {_TYPE='module', _NAME='vector3', _VERSION='0.1'}
local vector3_meta = {}

function vector3:new(_x,_y,_z)
  local x,y,z = _x,_y,_z
  if type(_x) == "table" and _y == nil and _z == nil then
    x = _x[1] or _x.x
    y = _x[2] or _x.y
    z = _x[3] or _x.z
  end

  --Make vector3
  local v3 = {x=x,y=y,z=z,type="vector3"}

  --Metatable stuff
  return setmetatable(v3, vector3_meta)
end

function vector3.table(v)
  return {v.x, v.y, v.z}
end

function vector3.get(v1, index)
  local result = {}
  for i=1, index:len() do
    local c = index:sub(i, i):lower()
    if c == "x" then result[i] = v1.x elseif c == "y" then result[i] = v1.y elseif c == "z" then result[i] = v1.z end
  end
  return vector3(result[1], result[2], result[3])
end

function vector3.add(v1, v2)
  local vec_result = {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.sub(v1, v2)
  local vec_result = {x=v1.x-v2.x, y=v1.y-v2.y, z=v1.z-v2.z}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.mul(v1, v2)
  local vec_result = {x=v1.x*v2.x, y=v1.y*v2.y, z=v1.z*v2.z}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.mulnum(v1, v2)
  local vec_result = {x=v1.x*v2, y=v1.y*v2, z=v1.z*v2}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.div(v1, v2)
  local vec_result = {x=v1.x/v2.x, y=v1.y/v2.y, z=v1.z/v2.z}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.divnum(v1, v2)
  local vec_result = {x=v1.x/v2, y=v1.y/v2, z=v1.z/v2}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.length(v)
  return math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
end

function vector3.normalize(v)
  local vec_length = v:length()
  local vec_result = {x=v.x/vec_length, y=v.y/vec_length, z=v.z/vec_length}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.dot(v1, v2)
  return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

function vector3.cross(v1, v2)
  local vec_result = {
    x = v1.y * v2.z - v2.y * v1.z,
    y = v1.z * v2.x - v2.z * v1.x,
    z = v1.x * v2.y - v2.x * v1.y
  }
  return vec_result
end

function vector3.type(v)
  if type(v) == "table" and v._TYPE then
    return v._TYPE
  end
  return type(v)
end

function vector3.tostring(v)
  return "{"..tostring(v.x).."; "..tostring(v.y).."; "..tostring(v.z).."}"
end

function vector3.print(v)
  print(vector3.tostring(v))
end

function vector3.pow(v1,v2)
  local vec_result = {x=v1.x^v2, y=v1.y^v2, z=v1.z^v2}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.mod(v1, v2)
  local vec_result = {x=v1.x%v2.x, y=v1.y%v2.y, z=v1.z%v2.z}
  return setmetatable(vec_result, vector3_meta)
end

function vector3.modnum(v1, v2)
  local vec_result = {x=v1.x%v2, y=v1.y%v2, z=v1.z%v2}
  return setmetatable(vec_result, vector3_meta)
end

setmetatable( vector3, { __call = function( ... ) return vector3.new( ... ) end } )

--Get that metatable all done and dusted
--Addition +
vector3_meta.__add = vector3.add

--Subtraction -
vector3_meta.__sub = vector3.sub

--Multiply *
vector3_meta.__mul = function(v1, v2)
  if getmetatable(v1) ~= vector3_meta then
    return vector3.mulnum(v2, v1)
  elseif getmetatable(v2) ~= vector3_meta then
    return vector3.mulnum(v1, v2)
  end
  return vector3.mul(v1, v2)
end

--Division /
vector3_meta.__div = function(v1, v2)
  if getmetatable(v1) ~= vector3_meta then
    return vector3.divnum(v2, v1)
  elseif getmetatable(v2) ~= vector3_meta then
    return vector3.divnum(v1, v2)
  end
  return vector3.div(v1, v2)
end

--The - in front of negative numbers, unary minus
vector3_meta.__unm = function( v )
	return vector3.mulnum( v,-1 )
end

--Equal ==
vector3_meta.__eq = function(v1, v2)
  if vector3.type(v1) ~= vector3.type(v2) then
    return false
  end

  return (v1.x == v2.x and v1.y == v2.y and v1.z == v2.z)
end

--Pow ^
vector3_meta.__pow = vector3.pow

--Mod %
vector3_meta.__mod = function (v1, v2)
  if getmetatable(v1) ~= vector3_meta then
    return vector3.modnum(v2, v1)
  elseif getmetatable(v2) ~= vector3_meta then
    return vector3.modnum(v1, v2)
  end
  return vector3.mod(v1, v2)
end

--To string tostring()
vector3_meta.__tostring = vector3.tostring

--Print print()
vector3_meta.__call = function(...)
  return vector3.print(...)
end

--Type .type
vector3_meta.type = vector3.type(...)

--Indexing
vector3_meta.__index = {}
for k,v in pairs(vector3) do
  vector3_meta.__index[k] = v
end

return vector3
