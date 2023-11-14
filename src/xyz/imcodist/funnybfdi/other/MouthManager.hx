package xyz.imcodist.funnybfdi.other;

import java.util.UUID;
import net.minecraft.network.chat.Component;

class MouthManager {
    static final playerMouths:Array<MouthState> = [];

    public static function tick():Void {
        if (!Config.enabled) {
            if (playerMouths.length > 0) {
                for (mouth in playerMouths) {
                    playerMouths.remove(mouth);
                }
            }

            return;
        }

        for (mouth in playerMouths) {
            mouth.tick();
            if (mouth.queueForDeletion) {
                playerMouths.remove(mouth);
            }
        }
    }

    public static function onPlayerChatted(message:Component, senderUUID:UUID):Void {
        if (!Config.enabled) return;

        var mouthState:MouthState = getOrCreatePlayerMouthState(senderUUID);

        mouthState.talkCharacter = 0;
        mouthState.talkText = message.getString();
        mouthState.updateMouthShape();

        mouthState.talking = true;
    }

    public static function getOrCreatePlayerMouthState(playerUUID:UUID):MouthState {
        var getState:MouthState = getPlayerMouthState(playerUUID);
        if (getState != null) return getState;


        var newPlayerState:MouthState = new MouthState(playerUUID);
        playerMouths.push(newPlayerState);

        return newPlayerState;
    }

    public static function getPlayerMouthState(playerUUID:UUID):MouthState {
        for (mouthState in playerMouths) {
            if (mouthState.playerUUID.equals(playerUUID)) {
                return mouthState;
            }
        }

        return null;
    }
}
