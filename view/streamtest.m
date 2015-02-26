% can only stream in data from stdin right now, file reading planned later
% can take "arguments" by using matlab/octave argument to eval variable
% assignments, like:
% octave --eval 'frameskip=100;streamtest' < blah.tsv
% or
% matlab -r 'frameskip=100;streamtest' < blah.tsv

%% defaults
% profiling
exist('profiling_enabled') || (profiling_enabled = 0);

% frames to skip, often 60/120 hz
exist('frameskip') || (frameskip = 0);

if profiling_enabled 
	profile on;
end

for a = 1:11
	input('', 's');
end
hold on
axis([-10000 10000 -10000 10000])
line = input('', 's');
frame = 0;
while !(strcmp(line, '') || frame > 3000)
	% disp('main loop')
	% disp(fields(1:2))
	if mod(frame++, frameskip + 1) == 0
		fields = strsplit(line,'\t','CollapseDelimiters',false);
		% next line only good if frame/time was exported from QTM
		fprintf('Frame: %1s, Time: %2s\n', fields{1}, fields{2})

		% start columns need to reflect time/frame output
		% skip value needs to reflect presence of z measurements
		Xcoords = str2double(fields(3:3:end));
		Ycoords = str2double(fields(4:3:end));
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
		if exist('last')
			delete(last);
		end
		last = plot(Xcoords, Ycoords, 'linestyle', 'none', 'marker', '.');
		drawnow;
	end
	line = input('', 's');
end

if profiling_enabled
	results=profile('info');
	% show 50 most time spent calls
	profshow(results, 50)

	% dont work because results is a struct with two structs? or struct arrays? idk
	% csvwrite('FunctionTable', results.FunctionTable)
	% csvwrite('Heirarchical', results.Heirarchical)
end