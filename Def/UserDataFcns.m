function fcns = UserDataFcns
% WHY MATLAB, WHY?
    fcns.userPrompt = @userPrompt;
    fcns.deleteUserData = @deleteUserData;
    fcns.loadUserData = @loadUserData;
    fcns.saveUserData = @saveUserData;
    fcns.nameRegExp = @nameRegExp;
    fcns.updateGuiUser = @updateGuiUser;
    
    function userdata = userPrompt(gui)
        items = loadUserItems;
        set(gui.SelectUserListBox, 'Items', items);

        gui.SelectUserListBox.ValueChangedFcn = @selectUser;
        drawnow;
        while ~exist('userdata','var')
            pause(0.1);
        end

        gui.userdata = userdata;

        gui.HeaderPanel.Visible = 'on';
        gui.MainPanel.Visible = 'on';
        gui.SelectUserPanel.Visible = 'off';

        updateGuiUser(gui);
        
        function selectUser(~, ev)
            value = ev.Value;

            if(strcmp(value, 'Create New User ...'))
            % Add new user
                prompt = {'Name:','Age:','Height (m):','Weight (kg):'};
                dlg_title = 'New user';
                num_lines = 1;
                defaultans = {'Jan Vermeulen','65','1.75','75'};
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                if isempty(answer) || isempty(answer{1}) || isempty(answer{2}) ...
                        || isempty(answer{3}) || isempty(answer{4})
                    % TODO: alert?
                    return;
                end

                name = nameRegExp(answer{1});
                userdata.name = name;
                userdata.age = round(str2double(answer{2}));
                userdata.height = str2double(answer{3});
                userdata.weight = str2double(answer{4}); 

                saveUserData(userdata),
            else
            % Load existing user
                userdata = loadUserData(value{1});
            end
        end
    end

    function deleteUserData(userdata)
        delete(strcat('Data/', userdata.name, '.usr'));
    end

    function saveUserData(userdata)
        fileID = fopen(strcat('Data/', userdata.name, '.usr'),'w');
        fileContent = jsonencode(userdata);
        fwrite(fileID, fileContent);
        fclose(fileID);
    end

    function userdata = loadUserData(name)
        fileID = fopen(strcat('Data/', name, '.usr'),'r');
        fileContent = fread(fileID,'*char');
        userdata = jsondecode(fileContent);
        fclose(fileID);
    end

    function items = loadUserItems
        cd('Data/');
        files = dir('*.usr');
        items{1} = 'Create New User ...';
        if ~isempty(files)
            for i = 1:length(files)
                fileID = fopen(files(i).name,'r');
                fileContent = fread(fileID,'*char');
                data = jsondecode(fileContent);
                fclose(fileID);
                items{i+1} = data.name;
            end
        end
        cd('../');
    end

    function renameUserFolder(oldname, newname)
        cd('Data/');
        movefile(oldname, newname);
        cd('../');
    end

    function newname = nameRegExp(name)
        newname = regexprep(name,'[^a-zA-Z ]+','_'); % Replace all strange characters with underscores
        newname = regexprep(newname,'(^_)|(_$)',''); % Strip leading and trailing underscores
        newname = regexprep(newname,'(^ )|( $)',''); % Strip leading and trailing spaces
    end

    function updateGuiUser(gui)
        gui.HeaderUserEditField.Value = gui.userdata.name;

        % Set ECG Gauge
        gui.ECGGauge.ScaleColorLimits = [0 60; 60 220 - gui.userdata.age; 220 - gui.userdata.age 240 ];
    end
end