function tsv = tsv_out(frame)
  % display a vector as tsv
  tsv = sprintf('%d\t', frame)(1:end-1);
  tsv = strrep(tsv, 'NaN', '');
end