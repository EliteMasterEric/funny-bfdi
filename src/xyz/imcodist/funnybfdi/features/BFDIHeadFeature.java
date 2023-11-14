package xyz.imcodist.funnybfdi.features;

import com.mojang.blaze3d.vertex.PoseStack;
import com.mojang.blaze3d.vertex.VertexConsumer;
import com.mojang.math.Axis;
import net.minecraft.client.model.*;
import net.minecraft.client.model.geom.ModelPart;
import net.minecraft.client.model.geom.PartPose;
import net.minecraft.client.model.geom.builders.CubeListBuilder;
import net.minecraft.client.model.geom.builders.LayerDefinition;
import net.minecraft.client.model.geom.builders.MeshDefinition;
import net.minecraft.client.model.geom.builders.PartDefinition;
import net.minecraft.client.renderer.MultiBufferSource;
import net.minecraft.client.renderer.RenderType;
import net.minecraft.client.renderer.entity.RenderLayerParent;
import net.minecraft.client.renderer.entity.layers.RenderLayer;
import net.minecraft.client.renderer.texture.OverlayTexture;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.LivingEntity;
import xyz.imcodist.funnybfdi.FunnyBFDI;
import xyz.imcodist.funnybfdi.other.Config;
import xyz.imcodist.funnybfdi.other.MouthManager;

public class BFDIHeadFeature<T extends LivingEntity, M extends EntityModel<T> & HeadedModel> extends RenderLayer<T, M> {
    private final ModelPart base;

    public BFDIHeadFeature(RenderLayerParent<T, M> context) {
        super(context);

        MeshDefinition modelData = new MeshDefinition();
        PartDefinition modelPartData = modelData.getRoot();
        modelPartData.addOrReplaceChild("mouth", CubeListBuilder.create().texOffs(0, 0).addBox(-4.0F, -8.0F, 4.51F, 8.0F, 16.0F, 0.0F), PartPose.offset(0.0F, 0.0F, 0.0F));
        LayerDefinition texturedModelData = LayerDefinition.create(modelData, 16, 16);

        this.base = texturedModelData.bakeRoot().getChild("mouth");
    }

    @Override
    public void render(PoseStack matrices, MultiBufferSource vertexConsumers, int light, T entity, float limbAngle, float limbDistance, float tickDelta, float animationProgress, float headYaw, float headPitch) {
        if (!Config.enabled) return;
        if (Config.mouthSize <= 0.0f) return;

        ModelPart head = getParentModel().getHead();
        if (entity.isInvisible()) return;
        if (!head.visible) return;

        MouthManager.MouthState mouthState = MouthManager.getPlayerMouthState(entity.getUUID());

        String mouthExpression = "normal";
        if (entity.getHealth() <= 10) {
            // when less then half health
            mouthExpression = "sad";
        }

        String mouth = "idle";

        // status effects
        boolean hasAbsorb = false;
        boolean hasPoison = false;
        for (MobEffectInstance effectInstance : entity.getActiveEffects()) {
            if (effectInstance.getEffect().equals(MobEffects.ABSORPTION)) {
                hasAbsorb = true;
                continue;
            }

            if (effectInstance.getEffect().equals(MobEffects.POISON)) {
                hasPoison = true;
            }
        }

        // absorption
        if (mouthExpression.equals("normal") && hasAbsorb) {
            mouthExpression = "normal";
            mouth = "absorption";
        }

        // is at critical hearts (shaky health bar oooo)
        if (entity.getHealth() <= 4) {
            mouthExpression = "sad";
            mouth = "critical";
        }

        if (entity.isUnderWater()) {
            mouth = "water";
        }

        // is talking
        if (mouthState != null && mouthState.talking) {
            String shape = mouthState.transitionMouthShape;

            if (!shape.equals("0")) {
                if (!mouth.equals("absorption") && !mouth.equals("critical") && !mouth.equals("water")) {
                    mouth = "talk" + shape;
                } else {
                    mouth = mouth + "talk";
                }
            } else {
                if (mouth.equals("water")) mouth = mouth + "talkclosed";
            }
        } else {
            if (hasPoison) {
                mouthExpression = "special";
                mouth = "poison";
            }
        }

        // is hurt
        if (entity.hurtTime > 0) {
            mouthExpression = "special";
            mouth = "hurt";
        }

        RenderType renderLayer = RenderType.entityTranslucent(new ResourceLocation(FunnyBFDI.MOD_ID, "textures/mouths/" + mouthExpression + "/" + mouth + ".png"));
        VertexConsumer vertices = vertexConsumers.getBuffer(renderLayer);

        float offsetScale = 250.0f;

        // make changes to the matrix
        matrices.translate(head.x / 8.0, head.y / 16.0, head.z / 8.0);

        matrices.mulPose(Axis.YP.rotationDegrees(180.0F));

        matrices.mulPose(Axis.YP.rotation(head.yRot));
        matrices.mulPose(Axis.XN.rotation(head.xRot));
        matrices.mulPose(Axis.ZN.rotation(head.zRot));

        matrices.translate(Config.mouthOffsetX / -offsetScale, Config.mouthOffsetY / offsetScale, Config.mouthOffsetZ / offsetScale);
        matrices.scale(Config.mouthSize, Config.mouthSize, 1.0f);

        // render
        this.base.render(matrices, vertices, light, OverlayTexture.NO_OVERLAY);

        // revert all the changes i made to the matrix
        matrices.scale(1.0f / Config.mouthSize, 1.0f / Config.mouthSize, 1.0f);
        matrices.translate((Config.mouthOffsetX / -offsetScale) * -1.0f, (Config.mouthOffsetY / offsetScale) * -1.0f, (Config.mouthOffsetZ / offsetScale) * -1.0f);

        matrices.mulPose(Axis.ZN.rotation(-head.zRot));
        matrices.mulPose(Axis.XN.rotation(-head.xRot));
        matrices.mulPose(Axis.YP.rotation(-head.yRot));

        matrices.mulPose(Axis.YP.rotationDegrees(-180.0F));

        matrices.translate((head.x / 8.0) * -1.0f, (head.y / 16.0) * -1.0f, (head.z / 8.0) * -1.0f);
    }
}
