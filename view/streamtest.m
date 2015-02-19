for a = 1:11
	input('', 's');
end
line = input('', 's');
while !(strcmp(line, ''))
	fields = strsplit(line,'\t','CollapseDelimiters',false);
	disp(fields);
	line = input('', 's');
end