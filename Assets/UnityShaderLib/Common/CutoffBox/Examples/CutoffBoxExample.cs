using UnityEngine;

public class CutoffBoxExample : MonoBehaviour
{
    readonly int enablePropertyID = Shader.PropertyToID("_Enable");
    readonly int minXPropertyID = Shader.PropertyToID("_MinX");
    readonly int maxXPropertyID = Shader.PropertyToID("_MaxX");
    readonly int minYPropertyID = Shader.PropertyToID("_MinY");
    readonly int maxYPropertyID = Shader.PropertyToID("_MaxY");
    readonly int minZPropertyID = Shader.PropertyToID("_MinZ");
    readonly int maxZPropertyID = Shader.PropertyToID("_MaxZ");

    public bool EnableCutoff = true;

    [SerializeField] Transform Cube;
    [SerializeField] Transform CutoffBox;

    [SerializeField] Transform CubeSG;
    [SerializeField] Transform CutoffBoxSG;

    Vector3 CutoffBox_startPos = new();
    Vector3 CutoffBoxSG_startPos = new();

    void Start()
    {
        if (CutoffBox == null) return;

        CutoffBox_startPos = CutoffBox.localPosition;

        if (CutoffBoxSG == null) return;

        CutoffBoxSG_startPos = CutoffBoxSG.localPosition;
    }

    void Update()
    {
        if (Cube == null || CutoffBox == null) return;

        UpdateBox(Cube, CutoffBox, CutoffBox_startPos);

        if (CubeSG == null || CutoffBoxSG == null) return;

        UpdateBox(CubeSG, CutoffBoxSG, CutoffBoxSG_startPos);

    }
    void UpdateBox(Transform Box, Transform CutoffBox, Vector3 startPos)
    {
        CutoffBox.localPosition = startPos + new Vector3(Mathf.Sin(Time.time * 2) * 2 - 1, 0, 0);

        var pos = CutoffBox.position;
        var scale = CutoffBox.lossyScale;

        var min = pos - scale / 2;
        var max = pos + scale / 2;
        var minX = min.x;
        var maxX = max.x;
        var minY = min.y;
        var maxY = max.y;
        var minZ = min.z;
        var maxZ = max.z;

        var sharedMaterial = Box.GetComponent<Renderer>().sharedMaterial;
        sharedMaterial.SetFloat(enablePropertyID, EnableCutoff ? 1 : 0);
        sharedMaterial.SetFloat(minXPropertyID, minX);
        sharedMaterial.SetFloat(maxXPropertyID, maxX);
        sharedMaterial.SetFloat(minYPropertyID, minY);
        sharedMaterial.SetFloat(maxYPropertyID, maxY);
        sharedMaterial.SetFloat(minZPropertyID, minZ);
        sharedMaterial.SetFloat(maxZPropertyID, maxZ);
    }
}