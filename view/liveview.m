% can only stream in data from stdin - file reading doesn't seem compelling
% can take "arguments" by using matlab/octave argument to eval variable
% assignments, like:
% octave --eval 'frameskip=100;liveview' < blah.tsv
% or
% matlab -r 'frameskip=100;liveview' < blah.tsv
% note : vagrant ssh -c "cd git/swarm/view;time head -n 40 game-day\ test2\,\ only\ labeled.tsv | octave --eval 'liveview'"&time head -n 40 game-day\ test2\,\ only\ labeled.tsv | matlab -r 'liveview'&

% TODO: add "argument" for headerless file
% TODO: add file reading switch because debugging streaming sucks

% from: http://stackoverflow.com/a/3628885
% subindex = @(A,r) A(r);      % An anonymous function to index a matrix

% function parse_header
% 	line = input('', 's');

% 	while subindex(isletter(line), 1)
% 		fields = strsplit(line,'\t','CollapseDelimiters',false);
% 		switch fields{1}
% 			case 'NO_OF_FRAMES'

% 			case 'FREQUENCY'

% 			case 'DESCRIPTION'

% 			case 'TIME_STAMP'

% 			case 'DATA_INCLUDED'

% 			case 'Frame'

% 		end
% 	end
% end


% defaults/options

% profiling
if ~exist('profiling_enabled', 'var')
	profiling_enabled = 0;
end

if profiling_enabled
	profile on;
end

% frames to skip, often 60/120 hz
if ~exist('frameskip', 'var')
	frameskip = 0;
end

if ~exist('headerlines', 'var')
	headerlines = 12;
end

% 2 for 2d, 3 for 3d (default)
if ~exist('columnskip', 'var')
	columnskip = 3;
end

if ~exist('size', 'var')
	size = 10000;
end

% skip header
for a = 1:headerlines
	input('','s');
end
global configuration;
hold on
if exist('configuration', 'var')
	if isfield(configuration, 'wallPoints')
		points = configuration.wallPoints;
		for wall = 1:length(points)/2
			x = [points(wall*2 - 1,1),points(wall*2,1)]
			y = [points(wall*2 - 1,2),points(wall*2,2)]
			plot(x,y);
		end
	end
	if isfield(configuration, 'view_size')
		size = configuration.view_size;
	end
end


axis([-size size -size size])
line = input('', 's');
% file = fopen('game-day test2, only labeled, first 50.tsv')
% line = fgetl(file);
% for a = 1:headerlines
%     fgetl(file);
% end
frame = 0;
while ~(strcmpi(line,''))
	frame = frame + 1;
	% disp('main loop')
	% disp(fields(1:2))
	if (mod(frame, frameskip + 1) == 0)
		if ~isstrprop(line(1), 'digit')
			continue
		end
		fields = strsplit(line,'\t','CollapseDelimiters',false);
		% next line only good if frame/time was exported from QTM
		fprintf('Frame: %1s, Time: %2s\n', fields{1}, fields{2})

		% start columns need to reflect time/frame output
		% skip value needs to reflect presence of z measurements
		Xcoords = str2double(fields(3:columnskip:end));
		Ycoords = str2double(fields(4:columnskip:end));
		% Xcoords = str2double(fields(1:3:end));
		% Ycoords = str2double(fields(2:3:end));

		% this seems (empirically) necessary, but not sure about reasoning
		Xcoords = Xcoords(~isnan(Xcoords));
		Ycoords = Ycoords(~isnan(Ycoords));
		% check lengths
		% disp(length(Xcoords))
		% disp(length(Ycoords))

		% Xcoords = Xcoords(cellfun('isnumeric',fields(3:2:end)))
		% Ycoords = Ycoords(cellfun('isnumeric',fields(4:2:end)))

		% remove last plotted frame or disable to see tracks
		if exist('last', 'var')
			delete(last);
		end
		last = plot(Xcoords, Ycoords, 'linestyle', 'none', 'marker', '.');
		drawnow;
	end
	line = input('', 's');
	% line = fgetl(file);
end
if exist('last', 'var')
	delete(last);
end
% fclose(file);
% disp('done');

if profiling_enabled
	results = profile('info');
	% show 50 most time spent calls
	profshow(results, 50)

	% dont work because results is a struct with two structs? or struct arrays? idk
	% csvwrite('FunctionTable', results.FunctionTable)
	% csvwrite('Heirarchical', results.Heirarchical)
end