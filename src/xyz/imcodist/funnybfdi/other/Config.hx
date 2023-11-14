package xyz.imcodist.funnybfdi.other;

import eu.midnightdust.lib.config.MidnightConfig;
import eu.midnightdust.lib.config.MidnightConfig.MidnightConfig_Entry;
import eu.midnightdust.lib.config.MidnightConfig.MidnightConfig_Comment;

class Config extends MidnightConfig {
	@:strict(MidnightConfig_Entry())
	public static var enabled:Bool = true;

	@:strict(MidnightConfig_Comment({centered: true}))
	public static var mouthCategory:MidnightConfig_Comment;
	@:strict(MidnightConfig_Entry({isSlider: true, min: 0.2, max: 1.8}))
	public static var mouthSpeed:Single = 1.0;
	@:strict(MidnightConfig_Entry())
	public static var mouthTransitions:Bool = true;

	@:strict(MidnightConfig_Comment({centered: true}))
	public static var mouthTransformCategory:MidnightConfig_Comment;
	@:strict(MidnightConfig_Entry({isSlider: true, min: 0.0, max: 2.0}))
	public static var mouthSize:Single = 1.0;
	@:strict(MidnightConfig_Entry({min: -150.0, max: 150.0}))
	public static var mouthOffsetX:Single = 0.0;
	@:strict(MidnightConfig_Entry({min: -150.0, max: 150.0}))
	public static var mouthOffsetY:Single = 0.0;
	@:strict(MidnightConfig_Entry({min: -150.0, max: 150.0}))
	public static var mouthOffsetZ:Single = 0.0;
}
