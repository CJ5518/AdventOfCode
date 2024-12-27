require("lib.util");


local function expandInput(str)
	local ret = {};
	local id = 0;
	local isFreeSpace = false;
	for q = 1, str:len() do
		local digit = tonumber(str:sub(q,q));
		for i = 1, digit do
			local obj = {};
			if isFreeSpace then
				obj.free = true;
			else
				obj.id = id;
			end
			ret[#ret+1] = obj;
		end
		if not isFreeSpace then id = id + 1 end
		isFreeSpace = not isFreeSpace;
	end
	return ret;
end

local shiftStartFree = 1;
local shiftStartFile = -1;
local function shiftOnce(tab)
	if shiftStartFile == -1 then shiftStartFile = #tab; end
	--First find the first free space
	local freeIdx;
	for q = shiftStartFree, #tab do
		if tab[q].free then
			freeIdx = q;
			shiftStartFree = q;
			break;
		end
	end
	--Then find the idx on the right end
	local fileIdx;
	for q = shiftStartFile, 1, -1 do
		if tab[q].id then
			fileIdx = q;
			shiftStartFile = q;
			break;
		end
	end
	if fileIdx < freeIdx then
		return false
	end
	local tmp = tab[freeIdx];
	tab[freeIdx] = tab[fileIdx];
	tab[fileIdx] = tmp;
	return true;
end

local function printTab(tab)
	for q = 1, #tab do
		if tab[q].id then
			io.write(tostring(tab[q].id));
		else
			io.write(".");
		end
	end
	io.write("\n");
end

local function getChecksum(tab)
	local count = 0;
	for q = 1, #tab do
		if tab[q].free then return count end
		count = count + tab[q].id * (q-1);
	end
	return count;
end

local file = io.open("input.txt", "r");
local text = file:read("*a");
file:close();

local tab = (expandInput(text));
print("expanded");
while shiftOnce(tab) do end
print(getChecksum(tab));
