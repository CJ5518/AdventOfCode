require("lib.util");

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
	return ret;
end

function boards:getElement(x,y)
	return self.board[y][x];
end
function boards:getElementVec(vec)
	return self:getElement(vec.x, vec.y);
end

function boards:setElement(x,y, value)
	self.board[y][x] = value;
end
function boards:setElementVec(vec, value)
	return self:setElement(vec.x, vec.y, value);
end

function boards:inBounds(x,y)
	return self.board[y] and self.board[y][x];
end
function boards:inBoundsVec(v)
	return self:inBounds(v.x, v.y);
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
			func(self,x,y);
		end
	end
end

return boards;
