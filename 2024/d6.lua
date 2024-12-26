local Vector2 = require("lib.Vector2");
require("lib.util");
local original = require("lib.boards"):new("input.txt");

function rotate90(vec)
	return Vector2:new(-vec.y, vec.x);
end

function tickBoard(board)
	local newPos = board.currPos + board.direction;
	if board:inBoundsVec(newPos) and board:getElementVec(newPos).symbol == "#" then
		--Turn, don't move
		board.direction = rotate90(board.direction);
	else
		--Track where we've been
		local currElement = board:getElementVec(board.currPos);
		if not currElement.visitation then
			currElement.visitation = {};
		end
		currElement.visitation[#currElement.visitation+1] = board.direction:clone();
		currElement.symbol = "X";

		--Update position
		if not board:inBoundsVec(newPos) then return false end
		board.currPos = newPos;
	end
	return true
end

function initBoard(board)
	board.direction = Vector2:new(0, -1);
	local function setStart(board, x,y)
		local element = board:getElement(x,y);
		if element.symbol == "^" then
			board.startPos = Vector2:new(x,y);
			board.currPos = board.startPos:clone();
			element.symbol = ".";
		end
	end
	board:forAll(setStart);
end

function loopsInfinitely(board)
	while tickBoard(board) do
		local currElement = board:getElementVec(board.currPos);
		--check if visitation has an entry that's a duplicate of another entry
		local copies = {};
		if currElement.visitation then
			for q = 1, #currElement.visitation do
				local entry = currElement.visitation[q];
				for i,v in pairs(copies) do
					if v == entry then return true end
				end
				copies[#copies+1] = cloneTable(entry);
			end
		end
	end
	--If we make it out obv doesn't loop infinitely
	return false;
end

initBoard(original);

local function part1()
	local discoveryBoard = original:clone();

	while tickBoard(discoveryBoard) do
	end

	local count = 0;
	local function countEm(board, x,y)
		if board:getElement(x,y).symbol == "X" then count = count + 1; end
	end

	discoveryBoard:forAll(countEm);
	print(count)
end

local function part2()
	local discoveryBoard = original:clone();
	local count = 0;
	local positions = {};

	local function notInThere(pos)
		return not (positions[pos.x] and positions[pos.x][pos.y]);
	end

	while tickBoard(discoveryBoard) do
		if notInThere(discoveryBoard.currPos) then
			local testBoard = original:clone();
			local element = testBoard:getElementVec(discoveryBoard.currPos);
			element.symbol = "#";
			if loopsInfinitely(testBoard) then
				count = count + 1;

				--Log this position
				positions[#positions+1] = discoveryBoard.currPos;
				if not positions[discoveryBoard.currPos.x] then
					positions[discoveryBoard.currPos.x] = {};
				end
				positions[discoveryBoard.currPos.x][discoveryBoard.currPos.y] = true;
			end
		end
	end
	print(count);
end

part1()
part2()
