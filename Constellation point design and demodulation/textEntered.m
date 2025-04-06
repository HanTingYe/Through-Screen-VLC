% Create ValueChangedFcn callback
function textEntered(textarea,label2)
val = textarea.Value;
label2.Text = '';
% Check each element of text area cell array for text
for k = 1:length(val)
    if(~isempty(val{k}))
        label2.Text = 'Those are all messages!';
        break;
    end
end
end