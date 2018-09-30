
function output = column_center(data)

output = data-repmat(mean(data), size(data,1), 1);