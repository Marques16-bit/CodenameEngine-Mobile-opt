package funkin.backend.assets;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;
import funkin.backend.assets.ModsFolder;
import funkin.backend.scripting.Script;
import haxe.io.Path;
import lime.utils.AssetLibrary;
import openfl.utils.Assets as OpenFlAssets;
import animate.FlxAnimateFrames;

using StringTools;

class Paths
{
	public static var assetsTree:AssetsLibraryList;

	public static var tempFramesCache:Map<String, FlxFramesCollection> = [];

	public static function init() {
		FlxG.signals.preStateSwitch.add(function() {
			tempFramesCache.clear();
		});
	}

	public static inline function getPath(file:String, ?library:String) {
		var returnedPath:String = library != null ? '$library:assets/$library/$file' : 'assets/$file';
		#if (sys && !windows)
		returnedPath = Path.normalize(returnedPath);
		if (openfl.utils.Assets.exists(returnedPath)) return returnedPath;
		var fixedPath:String = library != null ? '$library:assets/$library/' : 'assets/';
		var parts:Array<String> = returnedPath.split("/");
		for (it=>part in parts) {
			if (it == 0) continue;
			var entries:Array<String> = null;
			if (Path.extension(part) == "") entries = assetsTree.getFolders(fixedPath);
			else entries = assetsTree.getFiles(fixedPath);
			for (entry in entries) {
				if (entry.toLowerCase() == part.toLowerCase()) {
					fixedPath += entry + (it != parts.length - 1 ? "/" : "");
					break;
				}
			}
		}
		if (returnedPath.toLowerCase() == fixedPath.toLowerCase()) returnedPath = fixedPath;
		#end
		return returnedPath;
	}

	public static inline function video(key:String, ?ext:String)
		return getPath('videos/$key.${ext != null ? ext : Flags.VIDEO_EXT}');

	public static inline function ndll(key:String)
		return getPath('ndlls/$key.ndll');

	public static inline function file(file:String, ?library:String)
		return getPath(file, library);

	public static inline function txt(key:String, ?library:String)
		return getPath('data/$key.txt', library);

	public static inline function pack(key:String, ?library:String)
		return getPath('data/$key.pack', library);

	public static inline function ini(key:String, ?library:String)
		return getPath('data/$key.ini', library);

	public static inline function fragShader(key:String, ?library:String)
		return getPath('shaders/$key.frag', library);

	public static inline function vertShader(key:String, ?library:String)
		return getPath('shaders/$key.vert', library);

	public static inline function xml(key:String, ?library:String)
		return getPath('data/$key.xml', library);

	public static inline function json(key:String, ?library:String)
		return getPath('data/$key.json', library);

	public static inline function ps1(key:String, ?library:String)
		return getPath('data/$key.ps1', library);

	static public function sound(key:String, ?library:String, ?ext:String)
		return getPath('sounds/$key.${ext != null ? ext : Flags.SOUND_EXT}', library);

	public static inline function soundRandom(key:String, min:Int, max:Int, ?library:String)
		return sound(key + FlxG.random.int(min, max), library);

	inline static public function music(key:String, ?library:String, ?ext:String)
		return getPath('music/$key.${ext != null ? ext : Flags.SOUND_EXT}', library);

	inline static public function voices(song:String, ?difficulty:String, ?suffix:String = "", ?ext:String) {
		if (difficulty == null) difficulty = Flags.DEFAULT_DIFFICULTY;
		if (ext == null) ext = Flags.SOUND_EXT;
		var diff = getPath('songs/$song/song/Voices$suffix-${difficulty}.${ext}', null);
		return openfl.utils.Assets.exists(diff) ? diff : getPath('songs/$song/song/Voices$suffix.${ext}', null);
	}

	inline static public function inst(song:String, ?difficulty:String, ?suffix:String = "", ?ext:String) {
		if (difficulty == null) difficulty = Flags.DEFAULT_DIFFICULTY;
		if (ext == null) ext = Flags.SOUND_EXT;
		var diff = getPath('songs/$song/song/Inst$suffix-${difficulty}.${ext}', null);
		return openfl.utils.Assets.exists(diff) ? diff : getPath('songs/$song/song/Inst$suffix.${ext}', null);
	}

	static public function image(key:String, ?library:String, checkForAtlas:Bool = false, ?ext:String) {
		// 🌟 INTERCEPTADOR .OPT CORRIGIDO PARA EVITAR BUGS NO HSCRIPT
		var optPath = getPath('images/$key.opt', library);
		if (openfl.utils.Assets.exists(optPath)) return optPath;

		if (ext == null) ext = Flags.IMAGE_EXT;
		if (checkForAtlas) {
			var atlasPath = getPath('images/$key/spritemap.$ext', library);
			var multiplePath = getPath('images/$key/1.$ext', library);
			if (atlasPath != null && openfl.utils.Assets.exists(atlasPath)) return atlasPath.substr(0, atlasPath.length - 14);
			if (multiplePath != null && openfl.utils.Assets.exists(multiplePath)) return multiplePath.substr(0, multiplePath.length - 6);
		}
		return getPath('images/$key.$ext', library);
	}

	public static inline function script(key:String, ?library:String, isAssetsPath:Bool = false) {
		var scriptPath = isAssetsPath ? key : getPath(key, library);
		if (!openfl.utils.Assets.exists(scriptPath)) {
			var p:String;
			for(ex in Script.scriptExtensions) {
				if (openfl.utils.Assets.exists(p = scriptPath + '.' + ex)) {
					scriptPath = p;
					break;
				}
			}
		}
		return scriptPath;
	}

	static public function chart(song:String, ?difficulty:String, ?variant:String):String
	{
		difficulty = (difficulty != null ? difficulty : Flags.DEFAULT_DIFFICULTY);

		return getPath('songs/$song/charts/${variant != null ? variant + "/" : ""}$difficulty.json', null);
	}

	public static function character(character:String):String {
		return getPath('data/characters/$character.xml', null);
	}

	inline static public function getFontName(font:String) {
		return openfl.utils.Assets.exists(font, FONT) ? openfl.utils.Assets.getFont(font).fontName : font;
	}

	public static inline function font(key:String) {
		return getPath('fonts/$key');
	}

	public static inline function obj(key:String) {
		return getPath('models/$key.obj');
	}

	public static inline function dae(key:String) {
		return getPath('models/$key.dae');
	}

	public static inline function md2(key:String) {
		return getPath('models/$key.md2');
	}

	public static inline function md5(key:String) {
		return getPath('models/$key.md5');
	}

	public static inline function awd(key:String) {
		return getPath('models/$key.awd');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String, ?ext:String)
		return FlxAtlasFrames.fromSparrow(image(key, library, ext), file('images/$key.xml', library));

	inline static public function getAnimateAtlasAlt(key:String, ?settings:FlxAnimateSettings)
		return FlxAnimateFrames.fromAnimate(key, null, null, null, false, settings);

	inline static public function getSparrowAtlasAlt(key:String, ?ext:String)
		return FlxAtlasFrames.fromSparrow('$key.${ext != null ? ext : Flags.IMAGE_EXT}', '$key.xml');

	inline static public function getPackerAtlas(key:String, ?library:String, ?ext:String)
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library, ext), file('images/$key.txt', library));

	inline static public function getPackerAtlasAlt(key:String, ?ext:String)
		return FlxAtlasFrames.fromSpriteSheetPacker('$key.${ext != null ? ext : Flags.IMAGE_EXT}', '$key.txt');

	inline static public function getAsepriteAtlas(key:String, ?library:String, ?ext:String)
		return FlxAtlasFrames.fromAseprite(image(key, library, ext), file('images/$key.json', library));

	inline static public function getAsepriteAtlasAlt(key:String, ?ext:String)
		return FlxAtlasFrames.fromAseprite('$key.${ext != null ? ext : Flags.IMAGE_EXT}', '$key.json');

	inline static public function getAssetsRoot():String
		return  ModsFolder.currentModFolder != null ? '${ModsFolder.modsPath}${ModsFolder.currentModFolder}' : #if (sys && !mobile && TEST_BUILD) '${Main.pathBack}assets/' #else 'assets' #end;

	public static function getFrames(key:String, assetsPath:Bool = false, ?library:String, ?ext:String = null, ?animateSettings:FlxAnimateSettings) {
		if (tempFramesCache.exists(key)) {
			var frames = tempFramesCache[key];
			if (frames != null && frames.parent != null && frames.parent.bitmap != null && frames.parent.bitmap.readable)
				return frames;
			else
				tempFramesCache.remove(key);
		}
		return tempFramesCache[key] = loadFrames(assetsPath ? key : Paths.image(key, library, true, ext), false, null, false, ext, animateSettings);
	}

	public static function framesExists(key:String, checkAtlas:Bool = false, checkMulti:Bool = true, assetsPath:Bool = false, ?library:String) {
		var path = assetsPath ? key : Paths.image(key, library, true);
		var noExt = Path.withoutExtension(path);
		if(checkAtlas && openfl.utils.Assets.exists('$noExt/Animation.json'))
			return true;
		if(checkMulti && openfl.utils.Assets.exists('$noExt/1.png'))
			return true;
		if(openfl.utils.Assets.exists('$noExt.xml'))
			return true;
		if(openfl.utils.Assets.exists('$noExt.txt'))
			return true;
		if(openfl.utils.Assets.exists('$noExt.json'))
			return true;
		return false;
	}

	static function loadFrames(path:String, Unique:Bool = false,
