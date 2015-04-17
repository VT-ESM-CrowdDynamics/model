function tsv = tsv_out(frame_num)
  % display a vector as tsv
  tsv = sprintf('%d\t', frame_num)(1:end-1);
  tsv = strrep(tsv, 'NaN', '');
end
