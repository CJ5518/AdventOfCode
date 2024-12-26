--General junk, global functions

function printf(s, ...)
	print(string.format(s, ...));
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
