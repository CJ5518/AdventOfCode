require("lib.util");


local function buildTree(numbers, sum)
	local tree = {};
	sum = sum or 0;
	local addSum = sum + numbers[1];
	local mulSum = sum * numbers[1];
	local conSum = tonumber(tostring(sum) .. tostring(numbers[1]));
	if #numbers >= 2 then
		table.remove(numbers, 1);
		tree.add = buildTree(cloneTable(numbers), addSum);
		tree.mul = buildTree(cloneTable(numbers), mulSum);
		tree.con = buildTree(cloneTable(numbers), conSum);
	else
		tree.add = addSum;
		tree.mul = mulSum;
		tree.con = conSum;
	end
	return tree;
end

local function traverse(tree, func)
	if type(tree.add) == "table" then
		traverse(tree.add, func);
		traverse(tree.mul, func);
		traverse(tree.con, func);
	else
		func(tree.add);
		func(tree.mul);
		func(tree.con);
	end
end

local part2Res = 0;

local function part2(numbers)
	local firstNum = numbers[1];
	table.remove(numbers, 1);
	local tree = buildTree(cloneTable(numbers));
	local sumOfGoods = 0;
	local countedAlready = false;
	local function traverseFunc(num)
		if not countedAlready and num == firstNum then
			part2Res = part2Res + num;
			countedAlready = true;
		end
	end
	traverse(tree, traverseFunc);
end

local file = io.open("input.txt", "r");

for line in file:lines() do
	local numbers = {}
	for numstr in string.gmatch(line, "%d+") do
		numbers[#numbers+1] = tonumber(numstr);
	end
	part2(numbers);
end

file:close();

print(part2Res);
printf("%.0f",part2Res);