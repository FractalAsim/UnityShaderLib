using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.Rendering.Universal;

// Make the Volume Override active in the Universal Render Pipeline.
[SupportedOnRenderPipeline(typeof(UniversalRenderPipelineAsset))]

// Add the Volume Override to the list of available Volume Override components in the Volume Profile.
[VolumeComponentMenu("MethodsInUnity/VolumeComponent")]

// Set the name of the volume component in the list in the Volume Profile.
[DisplayInfo(name = "MethodsInUnity/VolumeComponent")] 

// If the related Scriptable Renderer Feature doesn't exist, display a warning about adding it to the renderer.
[VolumeRequiresRendererFeatures(typeof(CustomFullScreenRendererFeature))]

public sealed class MethodsInUnityVolumeComponent : VolumeComponent, IPostProcessComponent
{
    // Editor Controls
    [Tooltip("Tooltip")]
    public ClampedFloatParameter intensity = new ClampedFloatParameter(0f, 0f, 1f);

    public UnityEngine.Rendering.ColorParameter color = new UnityEngine.Rendering.ColorParameter(Color.red);

    // Turn On or Off Under Conditions
    public bool IsActive()
    {
        return intensity.GetValue<float>() > 0.0f;
    }
}