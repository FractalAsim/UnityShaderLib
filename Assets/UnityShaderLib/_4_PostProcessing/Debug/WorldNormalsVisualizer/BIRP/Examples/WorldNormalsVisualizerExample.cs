using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class WorldNormalsVisualizerExample : MonoBehaviour
{
    [SerializeField] Shader shader;

    Material mat;
    Camera cam;

    void OnValidate()
    {
        if (shader == null) return;

        mat = new Material(shader);
    }

    void Update()
    {
        if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.DepthNormals;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null) return;
           
        Graphics.Blit(src, dest, mat);
    }
}