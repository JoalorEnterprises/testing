package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import alphabet.Alphabet;
import base.CoolUtil;

import flixel.input.gamepad.FlxGamepad;

import lime.app.Application;
import openfl.Assets;

using StringTools;

class CreditsState extends FlxState
{
	public static var gamepad:FlxGamepad;

	private var grpCredits:FlxTypedGroup<Alphabet>;

	static var curSelected:Int = 0;
	
	var credits:Array<CreditsMetadata> = [];
	var descText:FlxText;
	var bg:FlxSprite;

	public static var coolColors:Array<FlxColor> = [
		0x00000000, // Transparent
		0xFFFFFFFF, // White
		0xFF808080, // Gray
		0xFF000000, // Black
		0xFF008000, // Green
		0xFF00FF00, // Lime
		0xFFFFFF00, // Yellow
		0xFFFFA500, // Orange
		0xFFFF0000, // Red
		0xFF800080, // Purple
		0xFF0000FF, // Blue
		0xFF8B4513, // Brown
		0xFFFFC0CB, // Pink
		0xFFFF00FF, // Magenta
		0xFF00FFFF // Cyan
	];

	override function create()
	{
		var initCreditlist = CoolUtil.coolTextFile(Paths.txt('creditsList'));

		if (Assets.exists(Paths.txt('creditsList')))
		{
			initCreditlist = Assets.getText(Paths.txt('creditsList')).trim().split('\n');

			for (i in 0...initCreditlist.length)
			{
				initCreditlist[i] = initCreditlist[i].trim();
			}
		}
		else
		{
			trace("OOPS! Could not find 'creditsList.txt'!");
			trace("Replacing it with normal credits...");
			initCreditlist = "Joalor64 YT:Main Programmer\n
			JonnycatMeow:libX11 for MacOS\n
			thepercentageguy:Menu Code\n
			zacksgamerz:Friday Night Fever Jukebox Code\n
			Stilic:NativeUtil\n
			Gidk-g:Literally One Useful PR".trim()
				.split('\n');

			for (i in 0...initCreditlist.length)
			{
				initCreditlist[i] = initCreditlist[i].trim();
			}
		}

		for (i in 0...initCreditlist.length)
		{
			var data:Array<String> = initCreditlist[i].split(':');
			credits.push(new CreditsMetadata(data[0], data[1]));
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.color = randomizeColor();
		add(bg);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.text = 'what';
		descText.borderSize = 2.4;
		add(descText);

		initOptions();

		var descText:FlxText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		changeSelection();

		super.create();
	}

	function initOptions()
	{
		grpCredits = new FlxTypedGroup<Alphabet>();
		add(grpCredits);

		for (i in 0...credits.length)
		{
			var creditText:Alphabet = new Alphabet(90, 320, credits[i].modderName, true);
			creditText.isMenuItem = true;
			creditText.targetY = i - curSelected;
			grpCredits.add(creditText);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
			changeSelection(FlxG.keys.justPressed.UP ? -shiftMult : shiftMult);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new states.MainMenuState());

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Std.int(FlxG.mouse.wheel));

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        	if (gamepad != null) {
            		trace("controller detected! :D");

			var shiftMult:Int = 1;
			if (gamepad.justPressed.RIGHT_TRIGGER || gamepad.justPressed.LEFT_TRIGGER)
				shiftMult = 3;

            		if (gamepad.justPressed.DPAD_UP || gamepad.justPressed.DPAD_DOWN)
                		changeSelection(gamepad.justPressed.DPAD_UP ? -shiftMult : shiftMult);

            		if (gamepad.justPressed.B)
                		FlxG.switchState(new states.MainMenuState());
		} else {
            		trace("oops! no controller detected!");
            		trace("probably bc it isnt connected or you dont have one at all.");
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		descText.text = credits[curSelected].desc;

		var bullShit:Int = 0;

		for (item in grpCredits.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}

	public static function randomizeColor()
    	{
		var chance:Int = FlxG.random.int(0, coolColors.length - 1);
		var color:FlxColor = coolColors[chance];
		return color;
    	}
}

class CreditsMetadata
{
	public var modderName:String = "";
	public var desc:String = "";

	public function new(name:String, desc:String)
	{
		this.modderName = name;
		this.desc = desc;
	}
}