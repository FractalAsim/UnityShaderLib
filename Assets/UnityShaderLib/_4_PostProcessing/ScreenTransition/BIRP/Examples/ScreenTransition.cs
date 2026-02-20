using UnityEngine;

[ExecuteInEditMode]
public class ScreenTransition : MonoBehaviour
{
    public Material TransitionMaterial;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (TransitionMaterial == null) return;

        Graphics.Blit(source, destination, TransitionMaterial);
    }
}