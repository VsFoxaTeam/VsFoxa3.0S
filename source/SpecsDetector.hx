package;

#if cpp
import cpp.ConstCharStar;
import cpp.Native;
import cpp.UInt64;
#end
import flixel.FlxG;
import lime.app.Application;
import openfl.system.Capabilities;
import MusicBeatState;


// taken from WI v2, you need enough gigafarts and RAM for proper use

#if windows
@:headerCode("#include <windows.h>")
#elseif linux
@:headerCode("#include <stdio.h>")
#end
class SpecsDetector extends MusicBeatState
{
	var cache:Bool = false;
	var isCacheSupported:Bool = false;

	override public function create()
	{
		super.create();

		FlxG.save.data.cachestart = checkSpecs();
		FlxG.switchState(new SplashState());
	}

	function checkSpecs():Bool
	{
		var cpu:Bool = Capabilities.supports64BitProcesses;
		var ram:UInt64 = CppAPI.obtainRAM();

		trace('\n--- SYSTEM INFO ---\nMEMORY AMOUNT: $ram\nCPU 64 BITS: $cpu');

		// cpu = false; testing methods
		if (cpu && ram >= 4096)
			return true;
		else
		{
			return messageBox("Vs. Foxa 3.0",
				"Your PC does not meet the requirements Vs. Foxa 3.0 has.\nWhile you can still play the mod, you may experience framedrops and/or lag spikes.\n\nDo you want to play anyway?");
		}

		return true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function messageBox(title:ConstCharStar = null, msg:ConstCharStar = null)
	{
		#if windows
		var msgID:Int = untyped MessageBox(null, msg, title, untyped __cpp__("MB_ICONQUESTION | MB_YESNO"));

		if (msgID == 7)
		{
			Sys.exit(0);
		}

		return true;
		#else
		lime.app.Application.current.window.alert(cast msg, cast title);
		return true;
		#end
	}
}
