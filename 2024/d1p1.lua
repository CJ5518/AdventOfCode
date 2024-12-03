
local file = io.open("input.txt", "r");

local leftList = {};
local rightList = {};

for line in file:lines() do
	local left, right = line:match("(%d+)%s+(%d+)");
	leftList[#leftList+1] = tonumber(left);
	rightList[#rightList+1] = tonumber(right);
end

table.sort(leftList);
table.sort(rightList);

local sum = 0;

for q=1,#leftList do
	sum = sum + math.abs(leftList[q] - rightList[q]);
end

print(sum);
