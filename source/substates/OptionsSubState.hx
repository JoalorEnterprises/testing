package substates;

import flixel.FlxG;
import options.Option;
import options.OptionsMenu;

using StringTools;

class OptionsSubState extends OptionsMenu
{
	public function new()
	{
		var option:Option = new Option('Menu Flicker',
			"Turn this off if you are photosensitive.",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Check for Updates',
			'If checked, checks for updates.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);

        var option:Option = new Option('Old Main Menu',
			'If checked, activates the old main menu.',
			'oldMenu',
			'bool',
			false);
		addOption(option);

		super();
	}
}