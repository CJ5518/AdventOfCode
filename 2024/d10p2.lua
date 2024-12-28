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
			candidates[#candidates+1] = candidate;
		end
		direction = rotate90(direction);
	end
	return candidates;
end

local function pathIsSame(a,b)
	for i,v in ipairs(a) do
		if a[i] ~= b[i] then
			return false;
		end
	end
	return true;
end

local function enterPath(path, tab)
	for i, v in ipairs(tab) do
		if pathIsSame(v, path) then return end
	end
	tab[#tab+1] = path;
end

local function get9sCount(fromPos, currPos, neededNum, totalPaths, currPath)
	if not board:inBoundsVec(currPos) then return end
	local currElement = board:getElementVec(currPos);
	if currElement.symbol == neededNum then
		if neededNum == 9 then enterPath(currPath, totalPaths) end
		local others = getDirections(fromPos, currPos);
		for q = 1, #others do
			local nextPath = cloneTable(currPath);
			nextPath[#nextPath+1] = others[q];
			get9sCount(currPos, others[q], neededNum + 1, totalPaths, nextPath);
		end
	end
end

--Assumes pos is a trailhead
local function checkTrailhead(pos)
	local ret = {};
	get9sCount(Vector2:new(-10,-10), pos, 0, ret, {});
	return #ret;
end


local sum = 0;
for q = 1, #trailheads do
	sum = sum + (checkTrailhead(trailheads[q]));
end
print(sum);
