package states;

import base.Menu;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OldMainMenuState extends Menu
{
	public static var gameVer:String = '1.2.0b';
	var bg:FlxSprite;

	override public function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image('titleBG'));
		add(bg);

		// Create menu
		Menu.title = "BandLab Radio Player";
		Menu.options = [
			'Play', 
			'Instructions', 
			'Gallery',
			'Credits',
			'Options'
			'Exit'
		];
		Menu.includeExitBtn = false;
		Menu.callback = (option:MenuSelection) ->
		{
			trace('Epic menu option ${option}');
			// Option check
			switch (option.id)
			{
				case 0:
					trace('Play');
					FlxG.switchState(new states.PlayState());
				case 1:
					trace('Instructions');
					FlxG.switchState(new states.InstructionsState());
				case 2:
					trace('Gallery');
					FlxG.switchState(new states.GalleryState());
				case 3:
					trace('Credits');
					FlxG.switchState(new states.CreditsState());
				case 4:
					trace('Options')
					openSubState(new substates.OptionsSubState());
				case 5:
					trace('Exit');
					#if sys
					Sys.exit(0);
					#else
					openfl.system.System.exit(0);
					#end
				default:
					trace('something is fucked');
			}
		}

		var versionShit:FlxText = new FlxText(5, FlxG.height - 24, 0, "BRP v" + gameVer, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}