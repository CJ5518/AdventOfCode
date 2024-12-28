local Vector2 = require("lib.Vector2");
require("lib.util");
local board = require("lib.boards"):new("input.txt");

local function initBoard(bo)
	bo:forAll(function(b,x,y,ele)
		ele.symbol = tonumber(ele.symbol);
	end)
end

initBoard(board);

--Find the trailheads

local trailheads = {};
board:forAll(function(b,x,y, element)
	if element.symbol == 0 then
		trailheads[#trailheads+1] = Vector2:new(x,y);
	end
end)

local function getDirections(fromPos, currPos)
	local function rotate90(vec)
		return Vector2:new(-vec.y, vec.x);
	end
	local direction = Vector2:new(1,0);
	local candidates = {};
	for q = 1, 4 do
		local candidate = currPos + direction;
		if candidate ~= fromPos then
			candidate[#candidate+1] = candidate;
		end
		direction = rotate90(direction);
		candidates[#candidates+1] = candidate;
	end
	return candidates;
end

local function enterVector(vec, tab)
	for i, v in ipairs(tab) do
		if v == vec then return end
	end
	tab[#tab+1] = vec;
end

local function get9sCount(fromPos, currPos, neededNum, found9s)
	if not board:inBoundsVec(currPos) then return 0 end
	local currElement = board:getElementVec(currPos);
	if currElement.symbol == neededNum then
		if neededNum == 9 then enterVector(currPos, found9s) end
		local others = getDirections(fromPos, currPos);
		for q = 1, #others do
			get9sCount(currPos, others[q], neededNum + 1, found9s);
		end
	end
end

--Assumes pos is a trailhead
local function checkTrailhead(pos)
	local ret = {};
	get9sCount(Vector2:new(-10,-10), pos, 0, ret);
	return #ret;
end

local sum = 0;
for q = 1, #trailheads do
	sum = sum + (checkTrailhead(trailheads[q]));
end
print(sum);