using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class SimpleMaterialBlit : MonoBehaviour
{
    [SerializeField] Material mat;

    [Range(1, 8)] public int colorBits = 0;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null) return;

        mat.SetFloat("_colorDepth", Mathf.Pow(2, colorBits - 1));

        Graphics.Blit(src, dest, mat);
    }
}