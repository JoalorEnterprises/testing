package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import lime.app.Application;

import flixel.input.gamepad.FlxGamepad;

#if sys
import sys.FileSystem;
#end

class GalleryState extends FlxState
{
    public static var gamepad:FlxGamepad;

    var currentIndex:Int = 0;

    var checker:FlxBackdrop;

    var background:FlxSprite;
    var imageSprite:FlxSprite;
    var imagePaths:Array<String>;
    var imageDescriptions:Array<String>;
    var imageTitle:Array<String>;

    var descriptionText:FlxText;
    var titleText:FlxText;

    override public function create():Void
    {
        super.create();

        background = new FlxSprite(0, 0).loadGraphic(Paths.image("menuBG"));
        background.setGraphicSize(Std.int(background.width * 1));
        background.screenCenter();
        add(background);

        #if (flixel_addons < "3.0.0")
	checker = new FlxBackdrop(Paths.image('ui/grid'), 0.2, 0.2, true, true);
	#else
	checker = new FlxBackdrop(Paths.image('ui/grid'));
	#end
        checker.scrollFactor.set(0.07, 0);
        add(checker);

        imagePaths = [
            "gallery/arcadiamania", 
            "gallery/ascension", 
            "gallery/christmaswishes", 
            "gallery/creepyolforest", 
            "gallery/dreamylofibeats", 
            "gallery/foreverconfusing", 
            "gallery/gamedevelopment", 
            "gallery/gbacliche", 
            "gallery/newera", 
            "gallery/nighttimegaming", 
            "gallery/nighttimegamingremix", 
            "gallery/pixelbirthdaybash", 
            "gallery/pureindianvibes", 
            "gallery/relaxingeveninglofi", 
            "gallery/silvercandy", 
            "gallery/universalquestioning", 
            "gallery/untitledlofisong"
        ];
        imageDescriptions = [
            "The cover for Arcadia Mania.", 
            "The cover for Ascension.", 
            "The cover for Christmas Wishes.", 
            "The cover for Creepy Ol Forest.", 
            "The cover for Dreamy Lo-fi Beats.", 
            "The cover for Forever Confusing.", 
            "The cover for Game Development.", 
            "The cover for GBA Cliche.", 
            "The cover for New Era.", 
            "The cover for Nighttime Gaming.", 
            "The cover for Nighttime Gaming REMIX.", 
            "The cover for Pixel Birthday Bash.", 
            "The cover for Pure Indian Vibes.", 
            "The cover for Relaxing Evening Lo-fi.", 
            "The cover for Silver Candy.", 
            "The cover for Universal Questioning.", 
            "The cover for Unitled Lo-fi Song."
        ];
        imageTitle = [
            "Arcadia Mania Cover", 
            "Ascension Cover", 
            "Christmas Wishes Cover", 
            "Creepy Ol Forest Cover", 
            "Dreamy Lo-fi Beats Cover", 
            "Forever Confusing Cover", 
            "Game Development Cover", 
            "GBA Cliche Cover", 
            "New Era Cover", 
            "Nighttime Gaming Cover", 
            "Nighttime Gaming REMIX Cover", 
            "Pixel Birthday Bash Cover", 
            "Pure Indian Vibes Cover", 
            "Relaxing Evening Lo-fi Cover", 
            "Silver Candy Cover", 
            "Universal Questioning Cover", 
            "Untitled Lo-fi Song Cover"
        ];

        imageSprite = new FlxSprite(50, 50).loadGraphic(Paths.image("galleryPlaceholder"));
        imageSprite.screenCenter();
        add(imageSprite);

        descriptionText = new FlxText(50, -100, FlxG.width - 100, imageDescriptions[currentIndex]);
        descriptionText.setFormat(null, 25, 0xffffff, "center");
        descriptionText.screenCenter();
        descriptionText.y += 250;
        descriptionText.setFormat(Paths.font("vcr.ttf"), 32, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(descriptionText);

        titleText = new FlxText(50, 50, FlxG.width - 100, imageTitle[currentIndex]);
        titleText.screenCenter(X);
        titleText.setFormat(null, 40, 0xffffff, "center");
        titleText.setFormat(Paths.font("vcr.ttf"), 32, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(titleText);

        var controlsTxt:FlxText = new FlxText(5, FlxG.height - 24, 0, "Use LEFT/RIGHT on your keyboard or D-pad to go through the gallery.", 12);
	controlsTxt.scrollFactor.set();
	controlsTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(controlsTxt);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        checker.x -= 0.45;
	checker.y -= 0.16;

        if (FlxG.keys.justPressed.LEFT)
        {
            currentIndex--;
            if (currentIndex < 0)
            {
                currentIndex = imagePaths.length - 1;
            }

            remove(imageSprite);
            if(FileSystem.exists(Paths.image(imagePaths[currentIndex]))) {
                imageSprite.loadGraphic(Paths.image(imagePaths[currentIndex]));
            } else {
                trace('ohno its dont exist');
            }
            imageSprite.screenCenter();
            add(imageSprite);

            descriptionText.text = imageDescriptions[currentIndex];
            titleText.text = imageTitle[currentIndex];
        }
        else if (FlxG.keys.justPressed.RIGHT)
        {
            currentIndex++;
            if (currentIndex >= imagePaths.length)
            {
                currentIndex = 0;
            }

            remove(imageSprite);
            if(FileSystem.exists(Paths.image(imagePaths[currentIndex]))) {
                imageSprite.loadGraphic(Paths.image(imagePaths[currentIndex]));
            } else {
                trace('ohno its dont exist');
            }
            imageSprite.screenCenter();
            add(imageSprite);

            descriptionText.text = imageDescriptions[currentIndex];
            titleText.text = imageTitle[currentIndex];
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new states.MainMenuState());
        }

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (gamepad != null) {
            trace("controller detected! :D");

            if (gamepad.justPressed.DPAD_LEFT)
            {
                currentIndex--;
                if (currentIndex < 0)
                {
                    currentIndex = imagePaths.length - 1;
                }

                remove(imageSprite);
                if(FileSystem.exists(Paths.image(imagePaths[currentIndex]))) {
                    imageSprite = new FlxSprite(50, 50).loadGraphic(Paths.image(imagePaths[currentIndex]));
                } else {
                    trace('ohno its dont exist');
                }
                imageSprite.screenCenter();
                add(imageSprite);

                descriptionText.text = imageDescriptions[currentIndex];
                titleText.text = imageTitle[currentIndex];
            }
            else if (gamepad.justPressed.DPAD_RIGHT)
            {
                currentIndex++;
                if (currentIndex >= imagePaths.length)
                {
                    currentIndex = 0;
                }

                remove(imageSprite);
                if(FileSystem.exists(Paths.image(imagePaths[currentIndex]))) {
                    imageSprite = new FlxSprite(50, 50).loadGraphic(Paths.image(imagePaths[currentIndex]));
                } else {
                    trace('ohno its dont exist');
                }
                imageSprite.screenCenter();
                add(imageSprite);

                descriptionText.text = imageDescriptions[currentIndex];
                titleText.text = imageTitle[currentIndex];
            }

            if (gamepad.justPressed.B)
            {
                FlxG.switchState(new states.MainMenuState());
            }
	} else {
            trace("oops! no controller detected!");
            trace("probably bc it isnt connected or you dont have one at all.");
	}
    }
 }
