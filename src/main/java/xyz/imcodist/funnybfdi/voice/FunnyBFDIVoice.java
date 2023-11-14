package xyz.imcodist.funnybfdi.voice;

import de.maxhenkel.voicechat.api.VoicechatApi;
import de.maxhenkel.voicechat.api.VoicechatPlugin;
import de.maxhenkel.voicechat.api.audio.AudioConverter;
import de.maxhenkel.voicechat.api.events.ClientReceiveSoundEvent;
import de.maxhenkel.voicechat.api.events.ClientSoundEvent;
import de.maxhenkel.voicechat.api.events.EventRegistration;
import net.minecraft.client.Minecraft;
import net.minecraft.network.chat.Component;
import xyz.imcodist.funnybfdi.FunnyBFDI;
import xyz.imcodist.funnybfdi.other.MouthManager;

public class FunnyBFDIVoice implements VoicechatPlugin {
    @Override
    public void initialize(VoicechatApi api) {
        VoicechatPlugin.super.initialize(api);

        FunnyBFDI.LOGGER.info("Loaded the voice chat stuffs thats cool nice!");
    }

    @Override
    public void registerEvents(EventRegistration registration) {
        VoicechatPlugin.super.registerEvents(registration);

        registration.registerEvent(ClientReceiveSoundEvent.EntitySound.class, this::onClientReceivedSound);
        registration.registerEvent(ClientSoundEvent.class, this::onClientSendSound);
    }

    @Override
    public String getPluginId() {
        return FunnyBFDI.MOD_ID;
    }


    public void onClientReceivedSound(ClientReceiveSoundEvent.EntitySound event) {
        float volume = getVolume(event.getRawAudio(), event.getVoicechat());
        if (volume < 100) return;

        String text = getMessage(volume);
        // this is a terrible way to do this but its incredibly easy
        MouthManager.onPlayerChatted(Component.nullToEmpty(text), event.getId());
    }

    public void onClientSendSound(ClientSoundEvent event) {
        if (Minecraft.getInstance().player == null) return;

        float volume = getVolume(event.getRawAudio(), event.getVoicechat());
        if (volume < 100) return;

        String text = getMessage(volume);
        // this is a terrible way to do this but its incredibly easy
        MouthManager.onPlayerChatted(Component.nullToEmpty(text), Minecraft.getInstance().player.getUUID());
    }


    private float getVolume(short[] rawAudio, VoicechatApi voicechatApi) {
        AudioConverter audioConverter = voicechatApi.getAudioConverter();
        float[] floats = audioConverter.shortsToFloats(rawAudio);

        float average = 0.0f;
        for (float num : floats) {
            if (num < 0) continue;
            average += num;
        }

        average /= floats.length - 1;

        return average;
    }

    private String getMessage(float volume) {
        String text = "a";
        if (volume >= 1500) {
            text = "i";
        } else if (volume <= 400) {
            text = "!";
        }

        return text + text + text;
    }
}
