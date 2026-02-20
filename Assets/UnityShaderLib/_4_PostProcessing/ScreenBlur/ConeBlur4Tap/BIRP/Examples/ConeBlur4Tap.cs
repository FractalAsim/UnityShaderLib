using UnityEngine;

[ExecuteInEditMode]
public class ConeBlur4Tap : MonoBehaviour
{
    public Material BlurMaterial;

    [Range(0, 10)] public int Iterations = 3;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int width = source.width;
        int height = source.height;

        // Apply Material multiple times
        RenderTexture tempTex = null;
        for (int i = 0; i < Iterations; i++)
        {
            tempTex = RenderTexture.GetTemporary(width, height);
            Graphics.Blit(source, tempTex, BlurMaterial);
            source = tempTex;
        }
        RenderTexture.ReleaseTemporary(tempTex);

        Graphics.Blit(source, destination);
    }
}