using UnityEngine;

[ExecuteInEditMode]
public class CutoffAxisExampel : MonoBehaviour
{
    readonly int cutoffPropertyID = Shader.PropertyToID("_Cutoff");
    readonly int minCutoffPropertyID = Shader.PropertyToID("_RangeMin");
    readonly int maxCutoffPropertyID = Shader.PropertyToID("_RangeMax");

    [SerializeField] Transform CutoffMin;
    [SerializeField] Transform CutoffMax;

    [SerializeField] Renderer ShaderCutoffCube;
    [SerializeField] Renderer ShaderCutoffCubeReverse;

    [SerializeField] Renderer ShaderCutoffSGCube;
    [SerializeField] Renderer ShaderCutoffSGCubeReverse;

    void Update()
    {
        print(Mathf.Sin(0));
        print(Mathf.Sin(0));


        if (CutoffMin == null) return;
        if (CutoffMax == null) return;

        if (ShaderCutoffCube != null)
        {
            var sharedMaterial = ShaderCutoffCube.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
        if (ShaderCutoffCubeReverse != null)
        {
            var sharedMaterial = ShaderCutoffCubeReverse.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }

        if (ShaderCutoffSGCube != null)
        {
            var sharedMaterial = ShaderCutoffSGCube.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
        if (ShaderCutoffSGCubeReverse != null)
        {
            var sharedMaterial = ShaderCutoffSGCubeReverse.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
    }
}
