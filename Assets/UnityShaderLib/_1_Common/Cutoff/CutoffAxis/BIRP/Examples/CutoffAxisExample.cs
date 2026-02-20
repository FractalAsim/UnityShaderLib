using UnityEngine;

[ExecuteInEditMode]
public class CutoffAxisExample : MonoBehaviour
{
    readonly int cutoffPropertyID = Shader.PropertyToID("_Cutoff");
    readonly int minCutoffPropertyID = Shader.PropertyToID("_RangeMin");
    readonly int maxCutoffPropertyID = Shader.PropertyToID("_RangeMax");

    [SerializeField] Transform CutoffMin;
    [SerializeField] Transform CutoffMax;

    [SerializeField] Renderer CutoffObject;
    [SerializeField] Renderer CutoffObjectReverse;

    [SerializeField] Renderer CutoffObjectSG;
    [SerializeField] Renderer CutoffObjectSGReverse;

    void Update()
    {
        if (CutoffMin == null) return;
        if (CutoffMax == null) return;

        if (CutoffObject != null)
        {
            var sharedMaterial = CutoffObject.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
        if (CutoffObjectReverse != null)
        {
            var sharedMaterial = CutoffObjectReverse.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }

        if (CutoffObjectSG != null)
        {
            var sharedMaterial = CutoffObjectSG.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
        if (CutoffObjectSGReverse != null)
        {
            var sharedMaterial = CutoffObjectSGReverse.GetComponent<Renderer>().sharedMaterial;

            var min = CutoffMin.transform.position.y;
            var max = CutoffMax.transform.position.y;
            sharedMaterial.SetFloat(minCutoffPropertyID, min);
            sharedMaterial.SetFloat(maxCutoffPropertyID, max);

            var cutoff = 0.5f * Mathf.Sin(Time.time) + 0.5f;
            sharedMaterial.SetFloat(cutoffPropertyID, cutoff);
        }
    }
}