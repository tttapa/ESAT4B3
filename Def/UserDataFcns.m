function fcns = UserDataFcns
% WHY MATLAB, WHY?
    fcns.userPrompt = @userPrompt;
    fcns.deleteUser = @deleteUser;
    fcns.loadUserData = @loadUserData;
    fcns.saveUserData = @saveUserData;
    fcns.renameUserFolder = @renameUserFolder;
    fcns.nameRegExp = @nameRegExp;
    fcns.updateGuiUser = @updateGuiUser;
    
    datafolder = 'Data';
    
    function userPrompt(gui)
        items = loadUserItems;
        set(gui.SelectUserListBox, 'Items', items);
        gui.userdata = UserData;
        gui.SelectUserListBox.ValueChangedFcn = @selectUser;
        drawnow;
        while isempty(gui.userdata.name)
            pause(0.1);
        end

        gui.userdata = gui.userdata;

        gui.HeaderPanel.Visible = 'on';
        gui.MainPanel.Visible = 'on';
        gui.SelectUserPanel.Visible = 'off';

        updateGuiUser(gui);
        
        function selectUser(~, ev)
            value = ev.Value;

            if(strcmp(value, 'Add New User ...'))
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
                gui.userdata.name = name;
                gui.userdata.age = round(str2double(answer{2}));
                gui.userdata.height = str2double(answer{3});
                gui.userdata.weight = str2double(answer{4}); 

                saveUserData(gui.userdata);
                folder = fullfile(datafolder,gui.userdata.name);
                mkdir(folder);
            else
            % Load existing user
                gui.userdata = loadUserData(value{1});
            end
        end
    end

    function deleteUser(name)
        delete(fullfile(datafolder,strcat(name, '.usr')));
    end

    function saveUserData(userdata)
        fileID = fopen(fullfile(datafolder,strcat(userdata.name, '.usr')),'w');
        fileContent = jsonencode(userdata);
        fwrite(fileID, fileContent);
        fclose(fileID);
    end

    function userdata = loadUserData(name)
        fileID = fopen(fullfile(datafolder,strcat(name, '.usr')),'r');
        fileContent = fread(fileID,'*char');
        userdata = UserData(jsondecode(fileContent));
        fclose(fileID);
    end

    function items = loadUserItems
        cd('Data/');
        files = dir('*.usr');
        items{1} = 'Add New User ...';
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
        % TODO: check if newname exists
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