classdef PrintMeshList < mv.gui.Plugin
%SAYHELLO Demo plugin that just display some content on the console
%
%   Class SayHello
%
%   Example
%   SayHello
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = PrintMeshList(varargin)
    % Constructor for PrintMeshList class

    end

end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        disp('print mesh list');
        
        scene = frame.scene;
        for i = 1:length(scene.meshHandleList)
            mh = scene.meshHandleList{i};
            disp(mh.id);
        end
        
    end
    
end % end methods

end % end classdef

