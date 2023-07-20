package;

import haxe.Http;
import flixel.FlxG;
import flixel.FlxState;
import lime.app.Application;
import states.OldMainMenuState;
import states.MainMenuState;
import states.OutdatedState;
import base.ClientPrefs;

using StringTools;

// since a substate can't be the initial state, we make a temporary state
class Init extends FlxState 
{
    var mustUpdate:Bool = false;
    public static var updateVersion:String = '';

    override function create() 
    {
		ClientPrefs.loadPrefs();
		
        #if (desktop && ClientPrefs.checkForUpdates)
	trace('checking for updates...');
	var http = new Http("https://raw.githubusercontent.com/Joalor64GH/BandLab-Radio-Player/main/embed/gitVersion.txt");

	http.onData = function(data:String) 
	{
	    updateVersion = data.split('\n')[0].trim();
	    var curVersion:String = MainMenuState.gameVersion.trim();
	    trace('version online: ' + updateVersion + ', your version: ' + curVersion);
	    if(updateVersion != curVersion) 
	    {
	        trace('oh noo outdated!!');
		mustUpdate = true;
	    }
	}

	http.onError = function (error) 
	{
	    trace('error: $error');
	}

	http.request();
	#end

        if (mustUpdate && ClientPrefs.checkForUpdates) {
            FlxG.switchState(new OutdatedState());
        } else {
			if (ClientPrefs.oldMenu)
				FlxG.switchState(new OldMainMenuState());
			else
            	FlxG.switchState(new MainMenuState());
        }
        super.create();
    }
}