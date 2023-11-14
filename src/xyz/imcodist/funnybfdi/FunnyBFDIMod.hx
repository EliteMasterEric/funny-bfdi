package xyz.imcodist.funnybfdi;

import java.Lib;
import net.pickhaxe.core.CommonMod;
import net.pickhaxe.core.Environment;
import eu.midnightdust.lib.config.MidnightConfig;

import xyz.imcodist.funnybfdi.other.Config;

class FunnyBFDIMod extends CommonMod {
  // Created by CommonMod macro.
  // public static final String MOD_ID;
  // public static final Logger LOGGER;

  public override function onModInitialize():Void {
    #if fabric
    LOGGER.info('Hello Fabric! Welcome to Minecraft ${Environment.MINECRAFT_VERSION}!');
    #end

    initMidnightConfig();
  }

  function initMidnightConfig():Void {
    // Had to perform a cast to get this to work.
    // TODO: Why is java.lang.Class<MidnightConfig> incompatible with java.lang.Class<T extends MidnightConfig>?
    LOGGER.info('Registering MidnightConfig...');
    var configCls:java.lang.Class<MidnightConfig> = cast Lib.toNativeType(Config);
    MidnightConfig.init(MOD_ID, configCls);
  }
}