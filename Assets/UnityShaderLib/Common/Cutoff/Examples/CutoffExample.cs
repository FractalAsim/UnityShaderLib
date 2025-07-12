using UnityEngine;

[ExecuteInEditMode]
public class CutoffExample : MonoBehaviour
{
    readonly int cutoffPropertyID = Shader.PropertyToID("_Cutoff");
    readonly int minCutoffPropertyID = Shader.PropertyToID("_RangeMin");
    readonly int maxCutoffPropertyID = Shader.PropertyToID("_RangeMax");

    [SerializeField] Transform CutoffMin;
    [SerializeField] Transform CutoffMax;

    [SerializeField] Renderer ShaderCutoffCube;
    [SerializeField] Renderer ShaderCutoffCubeReverse;


    void Update()
    {
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

    }
}
