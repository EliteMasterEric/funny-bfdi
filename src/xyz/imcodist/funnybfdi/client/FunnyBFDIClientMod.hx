package xyz.imcodist.funnybfdi.client;

import net.minecraft.network.chat.Component;

import net.pickhaxe.core.Environment;
import net.pickhaxe.core.ClientMod;

import xyz.imcodist.funnybfdi.other.MouthManager;

class FunnyBFDIClient extends ClientMod {
  	// Created by ClientMod macro.
  	// public static final String MOD_ID;
  	// public static final Logger LOGGER;

	public override function onModInitialize():Void {
		#if fabric
		LOGGER.info('Hello Fabric Client! Welcome to Minecraft ${Environment.MINECRAFT_VERSION}!');
		#end

		LOGGER.info("You swear you heard \"New Friendly\" begin to play in your head.");
	
		#if fabric
		registerChatEventFabric();
		#elseif forge
		registerChatEventForge();
		#end
	}

	#if fabric
	function registerChatEventFabric():Void {
		net.fabricmc.fabric.api.client.message.v1.ClientReceiveMessageEvents.CHAT.register(((message, signedMessage, sender, params, receptionTimestamp) -> {
			if (sender == null) return;

			var messageText:Component = message;
			if (signedMessage != null) messageText = signedMessage.decoratedContent();

			MouthManager.onPlayerChatted(Component.nullToEmpty(messageText.getString() + " "), sender.getId());
		}));

		net.fabricmc.fabric.api.client.event.lifecycle.v1.ClientTickEvents.END_CLIENT_TICK.register((client -> MouthManager.tick()));
	}
	#end
}