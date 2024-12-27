require("lib.util");

--Worst code I've ever written but whatever

local function expandInput(str)
	local ret = {};
	local id = 0;
	local isFreeSpace = false;
	for q = 1, str:len() do
		local digit = tonumber(str:sub(q,q));
		local obj = {};
		obj.blockSize = digit;
		ret[#ret+1] = obj;
		if not isFreeSpace then
			obj.id = id;
			id = id + 1
		else
			obj.free = true;
		end
		isFreeSpace = not isFreeSpace;
	end
	return ret;
end

local shiftStartFree = 1;
local shiftStartFile = -1;
local function shiftOnce(tab)
	if shiftStartFile == -1 then shiftStartFile = #tab; end
	local fileIdx;
	local freeIdx;
	local allDone;

	--Find the last file
	for q = #tab, 1, -1 do
		if tab[q].id and not tab[q].done then
			fileIdx = q;
			tab[q].done = true;
			break;
		end
		if q == 1 then allDone = true end
	end
	if not fileIdx then return false end
	--Find the free space of the right size
	for q = 1, fileIdx do
		if tab[q].free and tab[q].blockSize >= tab[fileIdx].blockSize then
			freeIdx = q;
			print(fileIdx);
			break;
		end
	end
	if allDone then return false end
	if not freeIdx then return true end
	if fileIdx < freeIdx then
		return false
	end
	if tab[fileIdx].blockSize == tab[freeIdx].blockSize then
		local tmp = tab[freeIdx];
		tab[freeIdx] = tab[fileIdx];
		tab[fileIdx] = tmp;
	else
		local freeCloneRest = cloneTable(tab[freeIdx]);
		local freeCloneFile = cloneTable(freeCloneRest);
		freeCloneFile.blockSize = tab[fileIdx].blockSize;
		freeCloneRest.blockSize = tab[freeIdx].blockSize - tab[fileIdx].blockSize;
		tab[freeIdx] = tab[fileIdx];
		tab[fileIdx] = freeCloneFile;
		table.insert(tab, freeIdx + 1, freeCloneRest);
	end
	return true;
end

local function printTab(tab)
	for q = 1, #tab do
		local char;
		if tab[q].id then
			char = (tostring(tab[q].id));
		else
			char = (".");
		end
		for i = 1, tab[q].blockSize do
			io.write(char);
		end
	end
	io.write("\n");
end

local function getChecksum(tab)
	local index = 0;
	local count = 0;
	for q = 1, #tab do
		for i = 1, tab[q].blockSize do
			if tab[q].id then
				count = count + (index * tab[q].id);
			end
			index = index + 1;
		end
	end
	return count;
end

local file = io.open("input.txt", "r");
local text = file:read("*a");
file:close();

local tab = (expandInput(text));
while shiftOnce(tab) do
end
print(getChecksum(tab));
