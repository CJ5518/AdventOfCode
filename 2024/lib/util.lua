--General junk, global functions

function printf(s, ...)
	print(string.format(s, ...));
end
function errorf(s, ...)
	local tab = {...};
	local level = tab[#tab];
	tab[#tab] = nil;
	error(string.format(s, unpack(tab)), level);
end

--Will definitely crash on a cyclic table
function cloneTable(tab)
	local ret = {};
	setmetatable(ret, getmetatable(tab));
	for i,v in pairs(tab) do
		if type(v) == "table" then
			ret[i] = cloneTable(v);
		else
			ret[i] = v;
		end
	end
	return ret;
end

function typeCheck(...)
	local tab = {...};
	for q = 1, #tab, 2 do
		local item = tab[q];
		local wantedType = tab[q + 1];
		if type(item) ~= wantedType then
			errorf("Error in function %s, bad argument #%d, expected %s but got %s",
			debug.getinfo(2,"n").name,
			(q + 1) / 2,
			wantedType,
			type(item),
			4
		);
		end
	end
end
