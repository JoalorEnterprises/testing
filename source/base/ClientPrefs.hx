package base;

import flixel.FlxG;

/**
 * @author ShadowMario
 * @see https://github.com/ShadowMario/FNF-PsychEngine
 */

class ClientPrefs 
{
	public static var flashing:Bool = true;
	public static var checkForUpdates:Bool = true;
	public static var oldMenu:Bool = false;

	public static function saveSettings() {
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.oldMenu = oldMenu;
	
		FlxG.save.flush();
	}

	public static function loadPrefs() {
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.checkForUpdates != null) {
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}
		if(FlxG.save.data.oldMenu != null) {
			oldMenu = FlxG.save.data.oldMenu;
		}
	}
}