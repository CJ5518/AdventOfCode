require("lib.util");

local readCells = {};

local file = io.open("input.txt", "r");

local text = file:read("*a");
file:close();

for numStr in text:gmatch("%d+") do
	readCells[#readCells+1] = tonumber(numStr);
end

local memoize = {};

local function extraStones(number, ticksLeft)
	if ticksLeft == 0 then return 0; end
	if not memoize[number] then memoize[number] = {}; end
	if memoize[number][ticksLeft] then
		return memoize[number][ticksLeft];
	end
	if number == 0 then
		memoize[number][ticksLeft] = extraStones(1, ticksLeft - 1);
		return memoize[number][ticksLeft];
	elseif tostring(number):len() % 2 == 0 then
		local s = tostring(number);
		local firstHalf = tonumber(s:sub(1,s:len()/2));
		local secondHalf = tonumber(s:sub((s:len()/2)+1));
		memoize[number][ticksLeft] = extraStones(firstHalf, ticksLeft - 1) + extraStones(secondHalf, ticksLeft - 1)  + 1;
		return memoize[number][ticksLeft];
	else
		memoize[number][ticksLeft] = extraStones(number * 2024, ticksLeft - 1);
		return memoize[number][ticksLeft];
	end
end

local function tick(num)
	local sum = 0;
	for q = 1, #readCells do
		sum = sum + extraStones(readCells[q], num) + 1;
	end
	return sum;
end

printf("%.f", tick(75));
