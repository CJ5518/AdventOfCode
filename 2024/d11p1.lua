require("lib.util");

local readCells = {};

local file = io.open("input.txt", "r");

local text = file:read("*a");
file:close();

for numStr in text:gmatch("%d+") do
	readCells[#readCells+1] = tonumber(numStr);
end

local function tick()
	local writeCells = {};
	for q = 1, #readCells do
		if readCells[q] == 0 then
			writeCells[#writeCells+1] = 1;
		elseif tostring(readCells[q]):len() % 2 == 0 then
			local s = tostring(readCells[q]);
			local firstHalf = s:sub(1,s:len()/2);
			local secondHalf = s:sub((s:len()/2)+1);
			writeCells[#writeCells+1] = tonumber(firstHalf);
			writeCells[#writeCells+1] = tonumber(secondHalf);
		else
			writeCells[#writeCells+1] = readCells[q] * 2024;
		end
	end
	readCells = writeCells;
end

for q = 1,25 do
	tick();
end
print(#readCells);
