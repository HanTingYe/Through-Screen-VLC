function outputs
% Create figure window and components

fig = uifigure('Position',[500 500 430 275]);

label1 = uilabel(fig,...
    'Position',[100 164 200 15],...
    'Text','Received messages:');

label2 = uilabel(fig,...
    'Position',[100 75 175 15],...
    'Text','');

textarea = uitextarea(fig,...
    'Position',[100 100 150 60],...
    'ValueChangedFcn',@(textarea,event) textEntered(textarea, label2));

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
end