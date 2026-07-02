package mobile.flixel.controls;

#if flixel
class MobileControls extends FlxSpriteGroup {
	private var controls:Array<InputHandler> = [];

	public static var instance:MobileControls;
	public var curDPadMode:String;
	public var curActionMode:String;

	public var buttons:Array<Button> = [];
	public var dpads:Array<DPad> = [];
	public var joysticks:Array<Joystick> = [];
	public var hitboxes:Array<Hitbox> = [];

	public function new() {
		super();
		instance = this;
	}

	public function getHitboxFromName(name:String) {
		for (btn in hitboxes) {
			if (btn != null && btn.jsonName == name)
				return btn;
		}
		return null;
	}

	public function getDPadFromName(name:String) {
		for (btn in dpads) {
			if (btn != null && btn.jsonName == name)
				return btn;
		}
		return null;
	}

	public function getJoyStickFromName(name:String) {
		for (btn in joysticks) {
			if (btn != null && btn.jsonName == name)
				return btn;
		}
		return null;
	}

	public function getButtonFromName(name:String) {
		for (btn in buttons) {
			if (btn != null && btn.jsonName == name)
				return btn;
		}
		return null;
	}

	public function addButtonCamera() {
		var cam:FlxCamera = new FlxCamera();
		cam.bgColor.alpha = 0;
		FlxG.cameras.add(cam, false);
		cam.zoom = 1;
		for (btn in buttons) {
			btn.cameras = [cam];
			btn.camera = cam;
		}
	}

	public function addDPadCamera() {
		var cam:FlxCamera = new FlxCamera();
		cam.bgColor.alpha = 0;
		FlxG.cameras.add(cam, false);
		cam.zoom = 1;
		for (btn in dpads) {
			btn.cameras = [cam];
			btn.camera = cam;
		}
	}

	public function addJoyStickCamera() {
		var cam:FlxCamera = new FlxCamera();
		cam.bgColor.alpha = 0;
		FlxG.cameras.add(cam, false);
		cam.zoom = 1;
		for (btn in joysticks) {
			btn.cameras = [cam];
			btn.camera = cam;
		}
	}

	public function addHitboxCamera() {
		var cam:FlxCamera = new FlxCamera();
		cam.bgColor.alpha = 0;
		FlxG.cameras.add(cam, false);
		cam.zoom = 1;
		for (btn in hitboxes) {
			btn.cameras = [cam];
			btn.camera = cam;
		}
	}

	public function addCamera() {
		var cam:FlxCamera = new FlxCamera();
		cam.bgColor.alpha = 0;
		FlxG.cameras.add(cam, false);
		cam.zoom = 1;
		cameras = [cam];
	}

	public function addButton(name:String) {
		if (buttons.length > 0)
			removeButton();

		var path = Config.MODDED_BUTTON_JSON + name + ".json";
		if (!FileSystem.exists(path))
			path = Config.BUTTON_JSON + name + ".json";

		var rawContent = File.getContent(path);
		if (rawContent == null)
			return;
		var parsed:ControlsJsonDef = Json.parse(rawContent);
		if (parsed.buttons != null) {
			for (data in parsed.buttons) {
				var btn = new Button(data);
				btn.antialiasing = Options.antialiasing;
				addControl(btn);
				buttons.push(btn);
			}
		}
		curActionMode = name;
	}

	public function addDPad(name:String) {
		if (dpads.length > 0)
			removeDPad();

		var path = Config.MODDED_DPAD_JSON + name + ".json";
		if (!FileSystem.exists(path))
			path = Config.DPAD_JSON + name + ".json";

		var rawContent = File.getContent(path);
		if (rawContent == null)
			return;
		var parsed:ControlsJsonDef = Json.parse(rawContent);
		if (parsed.dpads != null) {
			for (data in parsed.dpads) {
				var dpad = new DPad(data);
				dpad.antialiasing = Options.antialiasing;
				addControl(dpad);
				dpads.push(dpad);
			}
		}
		curDPadMode = name;
	}

	public function addJoyStick(name:String) {
		if (joysticks.length > 0)
			removeJoyStick();

		var path = Config.MODDED_JOYSTICK_JSON + name + ".json";
		if (!FileSystem.exists(path))
			path = Config.JOYSTICK_JSON + name + ".json";

		var rawContent = File.getContent(path);
		if (rawContent == null)
			return;
		var parsed:ControlsJsonDef = Json.parse(rawContent);
		if (parsed.joysticks != null) {
			for (data in parsed.joysticks) {
				var joy = new Joystick(data);
				joy.antialiasing = Options.antialiasing;
				addControl(joy);
				joysticks.push(joy);
			}
		}
	}

	public function addHitbox(name:String) {
		if (hitboxes.length > 0)
			removeHitbox();

		var path = Config.MODDED_HITBOX_JSON + name + ".json";
		if (!FileSystem.exists(path))
			path = Config.HITBOX_JSON + name + ".json";

		var rawContent = File.getContent(Config.HITBOX_JSON + name + ".json");
		if (rawContent == null)
			return;
		var parsed:ControlsJsonDef = Json.parse(rawContent);
		if (parsed.hitboxes != null) {
			for (data in parsed.hitboxes) {
				var box = new Hitbox(data);
				box.antialiasing = Options.antialiasing;
				addControl(box);
				hitboxes.push(box);
			}
		}
	}

	private function addControl(c:InputHandler) {
		controls.push(c);
		add(c);
	}

	public function removeButton() {
		for (btn in buttons) {
			controls.remove(btn);
			remove(btn, true);
		}
		buttons = [];
	}

	public function removeDPad() {
		for (dpad in dpads) {
			controls.remove(dpad);
			remove(dpad, true);
		}
		dpads = [];
	}

	public function removeJoyStick() {
		for (joy in joysticks) {
			controls.remove(joy);
			remove(joy, true);
		}
		joysticks = [];
	}

	public function removeHitbox() {
		for (box in hitboxes) {
			controls.remove(box);
			remove(box, true);
		}
		hitboxes = [];
	}

	public function clearControls() {
		removeButton();
		removeDPad();
		removeJoyStick();
		removeHitbox();
		resetAllInputs();
	}

	public function checkState(id:String, state:String = "pressed"):Bool {
		var isAny:Bool = (id == "any" || id == null);

		for (c in controls) {
			if (c == null || c.disabled)
				continue;

			if (isAny) {
				switch (state.toLowerCase()) {
					case "pressed":
						if (c.activeIDs.length > 0)
							return true;
					case "justpressed":
						for (active in c.activeIDs) {
							if (!c.lastActiveIDs.contains(active))
								return true;
						}
					case "justreleased":
						for (last in c.lastActiveIDs) {
							if (!c.activeIDs.contains(last))
								return true;
						}
					case "released":
						if (c.activeIDs.length == 0)
							return true;
				}
			} else {
				switch (state.toLowerCase()) {
					case "pressed":
						if (c.pressed(id))
							return true;
					case "justpressed":
						if (c.justPressed(id))
							return true;
					case "justreleased":
						if (c.justReleased(id))
							return true;
					case "released":
						if (c.released(id))
							return true;
				}
			}
		}
		return false;
	}

	public function resetAllInputs() {
		for (c in controls) {
			if (c != null)
				c.resetInputs();
		}
	}
}
#end
