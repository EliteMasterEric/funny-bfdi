package xyz.imcodist.funnybfdi.mixin;

import net.minecraft.client.model.PlayerModel;
import net.minecraft.client.player.AbstractClientPlayer;
import net.minecraft.client.renderer.entity.EntityRendererProvider;
import net.minecraft.client.renderer.entity.LivingEntityRenderer;
import net.minecraft.client.renderer.entity.player.PlayerRenderer;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import xyz.imcodist.funnybfdi.features.BFDIHeadFeature;

@Mixin(PlayerRenderer.class)
public abstract class PlayerEntityRendererMixin extends LivingEntityRenderer<AbstractClientPlayer, PlayerModel<AbstractClientPlayer>> {
    public PlayerEntityRendererMixin(EntityRendererProvider.Context ctx, PlayerModel<AbstractClientPlayer> model, float shadowRadius) {
        super(ctx, model, shadowRadius);
    }

    @Inject(method = "<init>*", at = @At("RETURN"))
    public void init(EntityRendererProvider.Context ctx, boolean slim, CallbackInfo ci) {
        this.addLayer(new BFDIHeadFeature<>(this));
    }
}