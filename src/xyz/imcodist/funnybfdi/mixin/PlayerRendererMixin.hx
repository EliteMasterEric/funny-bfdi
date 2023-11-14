package xyz.imcodist.funnybfdi.mixin;

import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;
import net.minecraft.client.renderer.entity.EntityRendererProvider.EntityRendererProvider_Context;
import net.pickhaxe.core.Mixin as PickHaxeMixin;
import xyz.imcodist.funnybfdi.features.BFDIHeadFeature;

// @:mixin({
// 	value: net.minecraft.client.renderer.entity.player.PlayerRenderer,
// 	priority: 1000
// })
import org.spongepowered.asm.mixin.Mixin;
@:strict(Mixin({
    value: untyped net.minecraft.client.renderer.entity.player.PlayerRenderer,
    priority: 1000
}))
abstract class PlayerRendererMixin // implements Mixin
		extends net.minecraft.client.renderer.entity.LivingEntityRenderer<net.minecraft.client.player.AbstractClientPlayer,
	net.minecraft.client.model.PlayerModel<net.minecraft.client.player.AbstractClientPlayer>>
    {

    @:inject({
        method: "<init>*",
        locals: NO_CAPTURE,
        at: "RETURN"
    })
	public function injectHeadFeature(ctx:EntityRendererProvider_Context, slim:Bool, ci:CallbackInfo):Void {
        FunnyBFDIMod.LOGGER.info("Head feature injected!");
        //FunnyBFDIMod.LOGGER.info('${Type.getClassName(Mixin)}');
		// this.addLayer(new BFDIHeadFeature<net.minecraft.client.player.AbstractClientPlayer, net.minecraft.client.model.PlayerModel<net.minecraft.client.player.AbstractClientPlayer>>(this));
	}
}
