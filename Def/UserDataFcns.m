function fcns = UserDataFcns
% WHY MATLAB, WHY?
    fcns.userPrompt = @userPrompt;
    fcns.updateUserData = @updateUserData;
    fcns.saveUserData = @saveUserData;
    fcns.updateGuiUser = @updateGuiUser;
    
    datafolder = 'Data';
    
    function userPrompt(gui)
        [items, itemsdata] = loadUserItems;
        set(gui.SelectUserListBox, 'Items', items, ...
            'ItemsData', itemsdata);
        gui.userdata = UserData;
        gui.SelectUserListBox.ValueChangedFcn = @selectUser;
        drawnow;
        while exist('gui','var') && isempty(gui.userdata.name) % TODO: gives error when closing the app
            pause(0.1);
        end

        gui.HeaderPanel.Visible = 'on';
        gui.MainPanel.Visible = 'on';
        gui.SelectUserPanel.Visible = 'off';

        updateGuiUser(gui);
        
        function selectUser(~, ev)
            userdata = ev.Value;

            if isempty(userdata{1})
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
                gui.userdata.stepGoal = 10000;

                saveUserData(gui.userdata);
                folder = fullfile(datafolder,gui.userdata.name);
                mkdir(folder);
            else
            % Load existing user
                gui.userdata = userdata{1};
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

    function userdata = loadUserData(filename)
        fileID = fopen(filename,'r');
        fileContent = fread(fileID,'*char');
        userdata = UserData(jsondecode(fileContent));
        fclose(fileID);
    end

    function [items, itemsdata] = loadUserItems
        files = dir(fullfile(datafolder,'*.usr'));
        items{1} = 'Add New User ...';
        itemsdata{1} = [];
        if ~isempty(files)
            for i = 1:length(files)
                data = loadUserData(fullfile(files(i).folder,files(i).name));
                items{i+1} = data.name;
                itemsdata{i+1} = data;
                folder = fullfile(datafolder,data.name);
                if ~exist(folder,'file')
                    mkdir(folder);
                end
            end
        end
    end

    function newname = nameRegExp(name)
        newname = regexprep(name,'[^a-zA-Z ]+','_'); % Replace all strange characters with underscores
        newname = regexprep(newname,'(^_)|(_$)',''); % Strip leading and trailing underscores
        newname = regexprep(newname,'(^ )|( $)',''); % Strip leading and trailing spaces
    end

    function updateGuiUser(gui)
        gui.StepsDailyGoalEditField.Value = gui.userdata.stepGoal;
        gui.HeaderUserEditField.Value = gui.userdata.name;

        % Set ECG Gauge
        gui.ECGGauge.ScaleColorLimits = [0 60; 60 220 - gui.userdata.age; 220 - gui.userdata.age 240 ];
    end

    function updated = updateUserData(gui, newUserData)
        newUserData.name = nameRegExp(newUserData.name);
        oldname = gui.userdata.name;
        newname = newUserData.name;
        if isempty(newname)
            updated = false;
            return;
        end
        
        if ~strcmp(oldname, newname)
            oldfolder = fullfile(datafolder,oldname);
            newfolder = fullfile(datafolder,newname);
            if exist(newfolder,'file')
                 button = questdlg(strcat('"',newname,{'" already exists. Are you sure you want to overwrite all existing data?'}),'Title','Yes','No','No');
                 if strcmp(button, 'Yes')
                      [status, message, messageid] = rmdir(newfolder,'s');
                      if status == false
                          ME = MException(messageid, message);
                          throw(ME);
                      end
                 else
                     updated = false;
                     return
                 end
            end
            [status, message, messageid] = movefile(oldfolder, newfolder);
            if status == false
                ME = MException(messageid, message);
                throw(ME);
            end
            deleteUser(oldname);
        end
        saveUserData(newUserData);
        gui.userdata.name = newUserData.name;
        gui.userdata.age = newUserData.age;
        gui.userdata.height= newUserData.height;
        gui.userdata.weight = newUserData.weight;
        updateGuiUser(gui);
        updated = true;
    end
end