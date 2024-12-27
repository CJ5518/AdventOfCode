local Vector2 = require("lib.Vector2");
require("lib.util");
local board = require("lib.boards"):new("input.txt");

--Get a list of the ineresting symbols
local symbolList = {};
local function getSymbols(board, x,y)
	if board:getElement(x,y).symbol ~= "." then
		symbolList[board:getElement(x,y).symbol] = true;
	end
end
board:forAll(getSymbols);

local function enterAntinode(vec)
	if board:inBoundsVec(vec) then
		local element = board:getElementVec(vec);
		element.antinode = true;
	end
end

local function evaluateSymbol(symbol)
	local function forAllMiddle(xStart,yStart)
		return function(board, x,y,element)
			if element.symbol == symbol and (x ~= xStart and y~= yStart) then
				local origin = Vector2:new(xStart, yStart);
				local dest = Vector2:new(x,y);
				local difference = dest - origin;
				local antNode1 = dest + difference;
				local antNode2 = origin - difference;
				enterAntinode(antNode1);
				enterAntinode(antNode2);
			end
		end
	end
	local function forAllStart(board, x, y, element)
		if element.symbol == symbol then
			board:forAll(forAllMiddle(x,y));
		end
	end
	board:forAll(forAllStart);
end

for i, v in pairs(symbolList) do
	evaluateSymbol(i);
end

local antinodeCount = 0;
local function countAntinodes(board, x, y)
	if board:getElement(x,y).antinode then antinodeCount = antinodeCount + 1; end
end

board:forAll(countAntinodes);

print(antinodeCount);
