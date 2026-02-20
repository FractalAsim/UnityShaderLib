using UnityEngine;

[ExecuteInEditMode]
public class InjectTransform : MonoBehaviour
{
    void Update()
    {
        var mat = GetComponent<Renderer>().sharedMaterial;
        if (!mat) return;

        mat.SetVector("_Translation",transform.position);
        mat.SetVector("_Rotation", new Vector4(transform.rotation.x, transform.rotation.y, transform.rotation.z, transform.rotation.w));
        mat.SetVector("_Scale", transform.lossyScale);
    }
}
