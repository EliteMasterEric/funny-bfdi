package xyz.imcodist.funnybfdi.other;

import java.util.UUID;

class MouthState {
    public var playerUUID:UUID;

    public var queueForDeletion:Bool = false;

    public var talking:Bool = false;

    public var talkText:String = "";
    public var talkCharacter:Int = 0;

    public var currentMouthShape:String;
    public var transitionMouthShape:String;

    private var talkTimer:Float = 0.0;

    public function new(playerUUID:UUID) {
        this.playerUUID = playerUUID;
        this.currentMouthShape = "0";
        this.transitionMouthShape = this.currentMouthShape;
    }

    public function tick():Void {
        if (talking) {
            talkTimer += 0.75 * Config.mouthSpeed;

            if (talkTimer >= 1.0) {
                if (talkCharacter >= talkText.length - 1) {
                    talking = false;
                    queueForDeletion = true;
                }

                if (talkCharacter < talkText.length) {
                    talkCharacter += 1;
                    if (talkCharacter >= talkText.length) talkCharacter = talkText.length - 1;

                    updateMouthShape();
                }

                talkTimer -= 1.0;
            }

            if (Config.mouthTransitions) {
                if (currentMouthShape == "8") {
                    transitionMouthShape = switch (transitionMouthShape) {
                        case "9": "7";
                        case "7", "8": "8";
                        default: "9";
                    };
                } else {
                    if (transitionMouthShape == "8" || transitionMouthShape == "7") {
                        transitionMouthShape = "9";
                    } else if (transitionMouthShape == "3" && !(currentMouthShape == "3")) {
                        transitionMouthShape = "2";
                    } else {
                        transitionMouthShape = currentMouthShape;
                    }
                }
            } else {
                transitionMouthShape = currentMouthShape;
            }
        }
    }

    public function updateMouthShape():Void {
        var character:String = talkText.charAt(talkCharacter);

        transitionMouthShape = currentMouthShape;
        currentMouthShape = switch (character.toLowerCase()) {
            case "a", "e", "u": "2";
            case "i": "3";
            case "o", "r": "8";
            case "m", "p", "b": "6";
            case "f", "v": "5";
            case "l": "4";
            case "t", "d", "k", "g", "n", "s", " ": "0";
            default: "1";
        };
    }
}