package xyz.imcodist.funnybfdi.features;

import net.minecraft.client.model.geom.ModelPart;
import net.minecraft.client.model.geom.builders.LayerDefinition;
import net.minecraft.client.model.geom.builders.CubeListBuilder;
import net.minecraft.client.model.geom.builders.PartDefinition;
import net.minecraft.client.model.geom.builders.MeshDefinition;
import com.mojang.blaze3d.vertex.PoseStack;
import net.minecraft.client.model.geom.PartPose;
import net.minecraft.client.model.*;
import net.minecraft.client.renderer.entity.layers.RenderLayer;
import net.minecraft.client.renderer.entity.RenderLayerParent;
import net.minecraft.client.renderer.MultiBufferSource;
import net.minecraft.world.entity.LivingEntity;

class BFDIHeadFeature<T:LivingEntity, M:EntityModel<T> & HeadedModel> extends RenderLayer<T, M> {
    private final base:ModelPart;

	public function new(context:RenderLayerParent<T, M>) {
		super(context);

        var modelData:MeshDefinition = new MeshDefinition();
        var modelPartData:PartDefinition = modelData.getRoot();
        modelPartData.addOrReplaceChild("mouth", CubeListBuilder.create().texOffs(0, 0).addBox(-4.0, -8.0, 4.51, 8.0, 16.0, 0.0), PartPose.offset(0.0, 0.0, 0.0));
        var texturedModelData:LayerDefinition  = LayerDefinition.create(modelData, 16, 16);

        this.base = texturedModelData.bakeRoot().getChild("mouth");
	}

	public overload function render(poseStack:PoseStack, buffer:MultiBufferSource, packedLight:Int, livingEntity:T, limbSwing:Single, limbSwingAmount:Single,
		partialTick:Single, ageInTicks:Single, netHeadYaw:Single, headPitch:Single) {}
}
