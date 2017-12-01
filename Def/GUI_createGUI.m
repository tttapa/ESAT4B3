function [ gui ] = GUI_createGUI()
%GUI_CREATEGUI Summary of this function goes here
%   Detailed explanation goes here

gui = HealthVision;
GUI_setColors(gui);
GUI_loadStepsPanel(gui);

end


