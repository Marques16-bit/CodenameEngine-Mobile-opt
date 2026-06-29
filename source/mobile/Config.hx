package mobile;

class Config
{
	public static var DPAD_PATH:String = "assets/mobile/DPad/images/";
	public static var BUTTON_PATH:String = "assets/mobile/Button/images/";
	public static var JOYSTICK_PATH:String = "assets/mobile/JoyStick/images/";

	public static var DPAD_JSON:String = "assets/mobile/DPad/";
	public static var BUTTON_JSON:String = "assets/mobile/Button/";
	public static var JOYSTICK_JSON:String = "assets/mobile/JoyStick/";
	public static var HITBOX_JSON:String = "assets/mobile/Hitbox/";

	/* RECOMMEND TO CHANGING THESE FOR THE GAMES USING MODDING SYSTEM */
	public static var MODDED_DPAD_PATH(get, default):String = "";
	public static var MODDED_BUTTON_PATH(get, default):String = "";
	public static var MODDED_JOYSTICK_PATH(get, default):String = "";

	public static var MODDED_DPAD_JSON(get, default):String = "";
	public static var MODDED_BUTTON_JSON(get, default):String = "";
	public static var MODDED_JOYSTICK_JSON(get, default):String = "";
	public static var MODDED_HITBOX_JSON(get, default):String = "";

	private static function get_MODDED_DPAD_PATH()
	{
		return getModFolder() + "mobile/DPad/images/";
	}
	private static function get_MODDED_BUTTON_PATH()
	{
		return getModFolder() + "mobile/Button/images/";
	}
	private static function get_MODDED_JOYSTICK_PATH()
	{
		return getModFolder() + "mobile/JoyStick/images/";
	}
	private static function get_MODDED_DPAD_JSON()
	{
		return getModFolder() + "mobile/DPad/";
	}
	private static function get_MODDED_BUTTON_JSON()
	{
		return getModFolder() + "mobile/Button/";
	}
	private static function get_MODDED_JOYSTICK_JSON()
	{
		return getModFolder() + "mobile/JoyStick/";
	}
	private static function get_MODDED_HITBOX_JSON()
	{
		return getModFolder() + "mobile/Hitbox/";
	}
	private static function getModFolder()
	{
		#if MOD_SUPPORT
		final moddyFolder:String = (ModsFolder.currentModFolder != null
			&& ModsFolder.currentModFolder != "default") ? '${ModsFolder.modsPath}${ModsFolder.currentModFolder}/' : "";
		return moddyFolder;
		#else
		return "";
		#end
	}
}
