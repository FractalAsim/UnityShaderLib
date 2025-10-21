using System.Collections.Generic;
using UnityEngine;
using UnityQuickSetupCode;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class ScreenMotionVectorVisualizerExample : MonoBehaviour
{
    [SerializeField] Shader shader;

    [SerializeField] List<GameObject> movingObjects = new();
    [SerializeField] float moveSpeed = 1;

    Material mat;
    Camera cam;

    List<Vector3> startPoss = new();


    void OnValidate()
    {
        if (shader == null) return;

        mat = new Material(shader);

        startPoss.Clear();
        foreach (GameObject go in movingObjects)
        {
            startPoss.Add(go.transform.position);
        }
    }

    void Update()
    {
        if (cam == null)
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = DepthTextureMode.MotionVectors;
        }

        for (int i = 0; i < movingObjects.Count; i++)
        {
            var offset = Random.insideUnitSphere;
            movingObjects[i].transform.position = startPoss[i] + offset * moveSpeed;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat == null) return;
           
        Graphics.Blit(src, dest, mat);
    }
}