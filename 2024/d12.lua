local Vector2 = require("lib.Vector2");
require("lib.util");
local board = require("lib.boards"):new("input.txt");


local function getSidesOfRegion(region)
	local sides = {};
	--Basically just check all 4 sides of every item in region

	local function addSide(origin, neighbor)
		local side = {};
		side.pos = cloneTable(origin);
		side.direction = origin - neighbor;
		sides[#sides+1] = side;
		local element = board:getElementVec(origin);
		if not element.sides then
			element.sides = {};
		end
		element.sides[#element.sides+1] = side.direction;
	end

	for q = 1, #region do
		local pos = region[q];
		local regionSymbol = board:getElementVec(pos).symbol;
		local neighbors = board:getAllNeighborsVec(pos);
		for q = 1, #neighbors do
			if board:inBoundsVec(neighbors[q]) then
				if board:getElementVec(neighbors[q]).symbol ~= regionSymbol then
					addSide(pos, neighbors[q]);
				end
			else
				addSide(pos, neighbors[q]);
			end
		end
	end
	
	--#sides has been verified to equal the perimeter
	--So now just count how many sides are contiguous
	--Not too hard prolly, just pick a side, then find every side that could be connected
	--Would be nice to have an index for this
	--A side (A) is connected to another side (B) if B is at a position immediately next 
	--to A such that B's position is 90 degrees of As direction
	--Then just go down each direction 90 degrees of the direction of A
	--After that add 1 to the real side count, remove all the entries we've looked at
	--And be on our merry way
	--Remove sides that are done!
	--Will make it go way faster
	local sideCount = 0;

	local function rotate90(vec)
		return Vector2:new(-vec.y, vec.x);
	end

	local function clearEntry(pos, dir)
		local element = board:getElementVec(pos);
		local idx;
		for i,v in pairs(element.sides) do
			if v == dir then
				idx = i;
				break;
			end
		end
		assert(table.remove(element.sides, idx));
	end

	local function clearSide(pos, sideDir)
		--Clear this specific entry
		local originElement = board:getElementVec(pos);
		clearEntry(pos, sideDir);
		--Go one way
		local moveDir = rotate90(sideDir);
		local newPos = pos;
		local function goDirection()
			while true do
				newPos = newPos + moveDir;
				if not board:inBoundsVec(newPos) then break end
				local newElement = board:getElementVec(newPos);
				local isInThere = false;
				if not newElement.sides then break end
				for i,v in pairs(newElement.sides) do
					if v == sideDir then
						isInThere = true; break;
					end
				end
				if not isInThere then break end
				clearEntry(newPos, sideDir);
			end
		end
		goDirection();
		--Go the other way
		moveDir = rotate90(moveDir);
		moveDir = rotate90(moveDir);
		newPos = pos;
		goDirection();
	end

	for q = 1, #region do
		local pos = region[q];
		local element = board:getElementVec(pos);
		if element.sides then
			local cache = #element.sides;
			for i = 1, cache do
				--Clear side func removes from this list so just clear it like this
				clearSide(pos, element.sides[1]);
				sideCount = sideCount + 1;
			end
		end
	end
	return sideCount;
end

--Counts the perimeter of a region
local function getPerimeterOfRegion(region)
	--Basically just check all 4 sides of every item in region
	local sum = 0;

	for q = 1, #region do
		local pos = region[q];
		local regionSymbol = board:getElementVec(pos).symbol;
		local neighbors = board:getNeighborsVec(pos);
		for q = 1, #neighbors do
			if board:getElementVec(neighbors[q]).symbol ~= regionSymbol then
				sum = sum + 1;
			end
		end
		--If no neighbors then it's the edge
		sum = sum + (4 - #neighbors);
	end
	return sum;
end

--Returns a table of positions marking a region
local function getRegion(pos)
	local ret = {};
	local symbol = board:getElementVec(pos).symbol;
	local function addToRet(position)
		for i, v in pairs(ret) do
			if v == position then return false end
		end
		ret[#ret+1] = position;
		return true;
	end
	local function getRegionInner(posWorking)
		for i,v in pairs(board:getNeighborsVec(posWorking)) do
			if board:getElementVec(v).symbol == symbol then
				if addToRet(v) then
					getRegionInner(v);
				end
			end
		end
	end
	ret[#ret+1] = pos;
	getRegionInner(pos);
	return ret;
end

local function doAllRegionsPart1(b, x,y,element)
	if not element.done then
		local region = getRegion(Vector2:new(x,y));
		local perimeter = getPerimeterOfRegion(region);
		local area = #region;
		for i,v in pairs(region) do
			board:getElementVec(v).done = true;
		end
		sum = sum + (perimeter * area);
	end
end

local function doAllRegionsPart2(b, x,y,element)
	if not element.done then
		local region = getRegion(Vector2:new(x,y));
		local perimeter = getSidesOfRegion(region);
		local area = #region;
		for i,v in pairs(region) do
			board:getElementVec(v).done = true;
		end
		sum = sum + (perimeter * area);
	end
end

sum = 0;
board:forAll(doAllRegionsPart2);
print(sum);
