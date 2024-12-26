require("lib.util");

local Vector2 = {};

Vector2.__index = Vector2;

function Vector2:new(x,y)
	local ret = {};
	setmetatable(ret, self);
	ret.x = x;
	ret.y = y;
	return ret;
end

function Vector2:magnitude()
	return math.sqrt(self:magnitudeSquared());
end
function Vector2:magnitudeSquared()
	return (self.x*self.x) + (self.y*self.y);
end
function Vector2:clone()
	return cloneTable(self);
end
Vector2.__tostring = function(a)
	return tostring(a.x) .. ", " .. tostring(a.y);
end
Vector2.__add = function(a,b)
	return Vector2:new(a.x + b.x,b.y + a.y);
end
Vector2.__sub = function(a,b)
	return Vector2:new(a.x - b.x,a.y - b.y);
end
Vector2.__unm = function(a)
	return Vector2:new(-a.x, -a.y);
end
Vector2.__mul = function(a, b)
	return Vector2:new(a.x * b, a.y * b);
end
Vector2.__div = function(a, b)
	return Vector2:new(a.x / b, a.y / b);
end
Vector2.__eq = function(a,b)
	return a.x == b.x and b.y == a.y;
end

return Vector2;
