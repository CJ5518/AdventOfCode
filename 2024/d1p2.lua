
local file = io.open("input.txt", "r");

local leftList = {};
local rightList = {};

for line in file:lines() do
	local left, right = line:match("(%d+)%s+(%d+)");
	leftList[#leftList+1] = tonumber(left);
	if not rightList[tonumber(right)] then
		rightList[tonumber(right)] = 1;
	else
		rightList[tonumber(right)] = rightList[tonumber(right)] + 1
	end
end

local sum = 0;

for q=1,#leftList do
	local num = leftList[q]
	sum = sum + math.abs(num * (rightList[num] and rightList[num] or 0));
end

print(sum);
