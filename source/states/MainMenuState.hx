package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.FlxObject;

import lime.app.Application;
import alphabet.Alphabet;
import base.CoolUtil;

using StringTools;

class MainMenuState extends FlxState
{
	var options:Array<String> = [
		'Play', 
		'Instructions', 
		'Gallery',
		'Credits',
		'Exit'
	];

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;

	public static var gamepad:FlxGamepad;
	public static var gameVersion:String = '1.1.0';

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Play':
				FlxG.switchState(new states.PlayState());
			case 'Instructions':
				FlxG.switchState(new states.InstructionsState());
			case 'Gallery':
				FlxG.switchState(new states.GalleryState());
			case 'Credits':
				FlxG.switchState(new states.CreditsState());
			case 'Exit':
				quitGame();
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var camMain:FlxCamera;

	var bg:FlxSprite;

	override function create() 
	{
		camMain = new FlxCamera();
		FlxG.cameras.reset(camMain);
		FlxG.cameras.setDefaultDrawTarget(camMain, true);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		FlxG.camera.follow(camFollowPos, null, 1);

		var yScroll:Float = Math.max(0.25 - (0.05 * (options.length - 4)), 0.1);
		bg = new FlxSprite().loadGraphic(Paths.image('titleBG'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.scrollFactor.set(0, yScroll / 3);
		bg.antialiasing = true;
		add(bg);

		var header:Alphabet = new Alphabet(0, grpOptions.y - 55, 'BandLab Radio Player', true);
		header.scrollFactor.set(0, Math.max(0.25 - (0.05 * (options.length - 4))));
		header.screenCenter(X);
        add(header);
		
		initOptions();

		selectorLeft = new Alphabet(0, 0, '>', true);
		selectorLeft.scrollFactor.set(0, yScroll);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		selectorRight.scrollFactor.set(0, yScroll);
		add(selectorRight);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 24, 0, "BRP v" + gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();

		super.create();
	}

	function initOptions() {
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.scrollFactor.set(0, Math.max(0.25 - (0.05 * (options.length - 4)), 0.1));
			grpOptions.add(optionText);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
	
		var mult:Float = FlxMath.lerp(1.07, bg.scale.x, CoolUtil.clamp(1 - (elapsed * 9), 0, 1));
		bg.scale.set(mult, mult);
		bg.updateHitbox();
		bg.offset.set();

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN) {
			changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);
		}

		if (FlxG.keys.justPressed.ENTER) {
			FlxG.sound.play(Paths.sound('selection'));
			grpOptions.forEach(function(grpOptions:Alphabet)
			{
				FlxFlicker.flicker(grpOptions, 2, 0.06, false, false, function(flick:FlxFlicker)
				{
					openSelectedSubstate(options[curSelected]);
				});
			});
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        	if (gamepad != null) {
            		trace("controller detected! :D");

            		if (gamepad.justPressed.DPAD_UP || gamepad.justPressed.DPAD_DOWN) {
                		changeSelection(gamepad.justPressed.DPAD_UP ? -1 : 1);
            		}

            		if (gamepad.justPressed.A) {
                		FlxG.sound.play(Paths.sound('selection'));
				grpOptions.forEach(function(grpOptions:Alphabet)
				{
					FlxFlicker.flicker(grpOptions, 2, 0.06, false, false, function(flick:FlxFlicker)
					{
						openSelectedSubstate(options[curSelected]);
					});
				});
            		}
		} else {
            		trace("oops! no controller detected!");
            		trace("probably bc it isnt connected or you dont have one at all.");
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
				var add:Float = (grpOptions.members.length > 4 ? grpOptions.members.length * 8 : 0);
				camFollow.setPosition(item.getGraphicMidpoint().x, item.getGraphicMidpoint().y - add);
			}
		}
	}

	function quitGame() {
	    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
		    Sys.exit(0);
	    }, false);
	}
}