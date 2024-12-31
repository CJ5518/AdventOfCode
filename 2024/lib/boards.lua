require("lib.util");
local Vector2 = require("lib.Vector2");

local boards = {};
boards.__index = boards;

--Makes a new board from an advent of code style input file
function boards:new(filename)
	local ret = {};
	setmetatable(ret, self);
	local file = io.open(filename, "r");
	ret.board = {};
	for line in file:lines() do
		ret.board[#ret.board+1] = {};
		for q=1,line:len() do
			local obj = {};
			obj.symbol = line:sub(q,q);
			ret.board[#ret.board][q] = obj;
		end
	end
	ret.width = #ret.board[1];
	ret.height = #ret.board;
	file:close();
	return ret;
end

function boards:getElement(x,y)
	typeCheck(x, "number", y, "number");
	return self.board[y][x];
end
function boards:getElementVec(vec)
	typeCheck(vec, "table");
	return self.board[vec.y][vec.x];
end

function boards:setElement(x,y, value)
	typeCheck(x, "number", y, "number");
	self.board[y][x] = value;
end
function boards:setElementVec(vec, value)
	typeCheck(vec, "table");
	return self:setElement(vec.x, vec.y, value);
end

function boards:inBounds(x,y)
	typeCheck(x, "number", y, "number");
	return self.board[y] and self.board[y][x];
end
function boards:inBoundsVec(v)
	typeCheck(v, "table");
	return self:inBounds(v.x, v.y);
end

--Gets the 4 neighbors arround a position, only the ones that are in bounds
--returns an array of vector 2s
function boards:_getNeighborsVecInternal(vec, all)
	typeCheck(vec, "table");
	local ret = {};
	local function addPos(pos)
		if all or self:inBoundsVec(pos) then
			ret[#ret+1] = pos;
		end
	end
	addPos(vec + Vector2:new(1,0));
	addPos(vec + Vector2:new(-1,0));
	addPos(vec + Vector2:new(0,1));
	addPos(vec + Vector2:new(0,-1));
	return ret;
end
function boards:getNeighborsVec(vec)
	return self:_getNeighborsVecInternal(vec, false);
end
function boards:getAllNeighborsVec(vec)
	return self:_getNeighborsVecInternal(vec, true);
end

function boards:print()
	for y = 1, self.height do
		for x = 1, self.width do
			io.write(self:getElement(x,y).symbol);
		end
		io.write("\n");
	end
end

function boards:clone()
	return cloneTable(self);
end

function boards:forAll(func)
	for y = 1, self.height do
		for x = 1, self.width do
			func(self,x,y,self:getElement(x,y));
		end
	end
end

return boards;
