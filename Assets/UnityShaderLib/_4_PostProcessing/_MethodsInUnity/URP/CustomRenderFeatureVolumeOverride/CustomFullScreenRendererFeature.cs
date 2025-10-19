using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.Universal;

public sealed class CustomFullScreenRendererFeature : ScriptableRendererFeature
{
    [SerializeField] Material mat;

    CustomFullScreenRenderPass renderPass;

    // Unity calls this method when the Scriptable Renderer Feature loads for the first time, and when you change a property.
    public override void Create()
    {
        if(mat)
        {
            renderPass = new CustomFullScreenRenderPass(name, mat);
        }
    }

    // Unity calls AddRenderPasses once per camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (renderPass == null) return;

        // Skip rendering if the target is a Reflection Probe or a preview camera.
        if (renderingData.cameraData.cameraType == CameraType.Preview ||
            renderingData.cameraData.cameraType == CameraType.Reflection)
        {
            return;
        }

        // Skip rendering if the camera is outside the custom volume.
        var myVolume = VolumeManager.instance.stack?.GetComponent<MethodsInUnityVolumeComponent>();
        if (myVolume == null || !myVolume.IsActive())
        {
            return;
        }

        // Specify injection point
        renderPass.renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;

        // Specify required buffers
        renderPass.ConfigureInput(ScriptableRenderPassInput.None);

        renderer.EnqueuePass(renderPass);
    }
}

class CustomFullScreenRenderPass : ScriptableRenderPass
{
    Material mat;

    static MaterialPropertyBlock matProperties = new();

    // Declare a property that enables or disables the render pass that samples the color texture.
    static readonly bool kSampleActiveColor = true;

    // Declare a property that adds or removes depth-stencil support.
    static readonly bool kBindDepthStencilAttachment = false;

    static readonly int kBlitTexturePropertyId = Shader.PropertyToID("_BlitTexture");
    static readonly int kBlitScaleBiasPropertyId = Shader.PropertyToID("_BlitScaleBias");

    public CustomFullScreenRenderPass(string passName, Material material)
    {
        // Add a profiling sampler.
        profilingSampler = new ProfilingSampler(passName);

        // Assign the material to the render pass.
        mat = material;

        // To make sure the render pass can sample the active color buffer, set URP to render to intermediate textures instead of directly to the backbuffer.
        requiresIntermediateTexture = kSampleActiveColor;
    }

    // Add commands to render the effect.
    static void ExecuteMainPass(RasterCommandBuffer cmd, RTHandle sourceTexture, Material material)
    {
        matProperties.Clear();

        if (sourceTexture != null)
        {
            // set input texture
            matProperties.SetTexture(kBlitTexturePropertyId, sourceTexture);
        }

        // Set the scale and bias so shaders that use Blit.hlsl work correctly. because sometimes uvs of image are flipped???
        matProperties.SetVector(kBlitScaleBiasPropertyId, new Vector4(1, 1, 0, 0));

        // get and set material properties based on volume
        var volume = VolumeManager.instance.stack?.GetComponent<MethodsInUnityVolumeComponent>();
        if (volume != null)
        {
            matProperties.SetFloat("_Intensity", volume.intensity.value);
            matProperties.SetColor("_Color", volume.color.value);
        }

        // call command buffer to Draw (to the current render target, aka - blit)
        cmd.DrawProcedural(Matrix4x4.identity, material, 0, MeshTopology.Triangles, 3, 1, matProperties);
    }

    // Declare the resource the copy render pass uses.
    class CopyPassData
    {
        public TextureHandle inputTexture;
    }

    // Declare the resources the main render pass uses.
    class MainPassData
    {
        public Material material;
        public TextureHandle inputTexture;
    }

    static void ExecuteMainPass(MainPassData data, RasterGraphContext context)
    {
        ExecuteMainPass(context.cmd, data.inputTexture.IsValid() ? data.inputTexture : null, data.material);
    }

    // Implement the rendering logic.
    public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
    {
        // Get the resources the pass uses.
        UniversalResourceData resourcesData = frameData.Get<UniversalResourceData>();
        UniversalCameraData cameraData = frameData.Get<UniversalCameraData>();

        // Sample from the current color texture.
        using (var builder = renderGraph.AddRasterRenderPass<MainPassData>(passName, out var passData, profilingSampler))
        {
            passData.material = mat;

            TextureHandle destination;

            // Copy cameraColor to a temporary texture, if the kSampleActiveColor property is set to true. 
            if (kSampleActiveColor)
            {
                var cameraColorDesc = renderGraph.GetTextureDesc(resourcesData.cameraColor);
                cameraColorDesc.name = "_CameraColorCustomPostProcessing";
                cameraColorDesc.clearBuffer = false;

                destination = renderGraph.CreateTexture(cameraColorDesc);
                passData.inputTexture = resourcesData.cameraColor;

                // If you use framebuffer fetch in your material, use builder.SetInputAttachment to reduce GPU bandwidth usage and power consumption. 
                builder.UseTexture(passData.inputTexture, AccessFlags.Read);
            }
            else
            {
                destination = resourcesData.cameraColor;
                passData.inputTexture = TextureHandle.nullHandle;
            }

            // Set the render graph to render to the temporary texture.
            builder.SetRenderAttachment(destination, 0, AccessFlags.Write);

            // Bind the depth-stencil buffer.
            // This is a demonstration. The code isn't used in the example.
            if (kBindDepthStencilAttachment)
                builder.SetRenderAttachmentDepth(resourcesData.activeDepthTexture, AccessFlags.Write);

            // Set the render method.
            builder.SetRenderFunc((MainPassData data, RasterGraphContext context) => ExecuteMainPass(data, context));

            // Set cameraColor to the new temporary texture so the next render pass can use it. You don't need to blit to and from cameraColor if you use the render graph system.
            if (kSampleActiveColor)
            {
                resourcesData.cameraColor = destination;
            }
        }
    }
}