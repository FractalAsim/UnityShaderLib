using UnityEngine;

[ExecuteInEditMode]
public class CutoffPlaneExample : MonoBehaviour
{
    readonly int enablePropertyID = Shader.PropertyToID("_Enable");
    readonly int pNormalPropertyID = Shader.PropertyToID("_PNormal");
    readonly int pCenterPropertyID = Shader.PropertyToID("_PCenter");

    public bool EnableCutoff = true;
    public bool Reverse = false;

    [SerializeField] Transform Cube;
    [SerializeField] Transform CutoffPlane;

    [SerializeField] Transform CubeSG;
    [SerializeField] Transform CutoffPlaneSG;

    void Update()
    {
        if (Cube == null || CutoffPlane == null) return;

        UpdatePlane(Cube, CutoffPlane);

        if (CubeSG == null || CutoffPlaneSG == null) return;

        UpdatePlane(CubeSG, CutoffPlaneSG);

    }
    void UpdatePlane(Transform Cube, Transform plane)
    {
        plane.Rotate(new Vector3(0.5f, 0, 0));

        Vector3 normal = -plane.transform.forward;
        Vector3 pos = plane.transform.position;

        var sharedMaterial = Cube.GetComponent<Renderer>().sharedMaterial;
        sharedMaterial.SetFloat(enablePropertyID, EnableCutoff ? 1 : 0);
        sharedMaterial.SetVector(pNormalPropertyID, Reverse ? normal : -normal);
        sharedMaterial.SetVector(pCenterPropertyID, pos);
    }
}