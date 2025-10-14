using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class DepthVisualizer : MonoBehaviour
{
    [SerializeField] Shader shader;

    enum DepthSelect { Raw, Linear }
    [SerializeField] DepthSelect depthSelect = DepthSelect.Raw;

    Material mat;
    Camera cam;

    void OnValidate()
    {
        if (shader == null) return;

        mat = new Material(shader);

        if(depthSelect == DepthSelect.Raw)
        {
            mat.SetKeyword(new LocalKeyword(shader, "_DEPTHSELECT_RAW"), true);
            mat.SetKeyword(new LocalKeyword(shader, "_DEPTHSELECT_LINEAR"), false);
        }
        else
        {
            mat.SetKeyword(new LocalKeyword(shader, "_DEPTHSELECT_RAW"), false);
            mat.SetKeyword(new LocalKeyword(shader, "_DEPTHSELECT_LINEAR"), true);
        }
    }

    void Update()
    {
        if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.Depth;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null) return;
           
        Graphics.Blit(src, dest, mat);
    }
}