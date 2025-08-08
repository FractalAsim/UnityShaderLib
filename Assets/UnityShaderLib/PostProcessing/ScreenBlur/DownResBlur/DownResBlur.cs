using UnityEngine;

[ExecuteInEditMode]
public class DownResBlur : MonoBehaviour
{
    [Range(0, 6)] public int DownResFactor = 0;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int width = source.width >> DownResFactor;
        int height = source.height >> DownResFactor;

        // Copy source input to a lower res texture using blit (scale texture down)
        RenderTexture tempTex = RenderTexture.GetTemporary(width, height);
        Graphics.Blit(source, tempTex);

        // Copy lower res texture to destination output (scale texture up)
        Graphics.Blit(tempTex, destination);
        RenderTexture.ReleaseTemporary(tempTex);
    }
}