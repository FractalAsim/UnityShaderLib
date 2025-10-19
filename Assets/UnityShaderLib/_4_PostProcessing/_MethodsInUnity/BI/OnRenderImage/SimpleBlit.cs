/*
 * 
 * About:
 * Fast and easy way to do Fullscreen PostProcessing
 * 
 * How It Works:
 * Uses an old unity method of using MonoBehaviour.OnRenderImage() on object with a camera, to modify the image taken from the camera using a shader/material
 * 
 * How To Use:
 * 1. Attach this script to a gameobject with camera component
 * 2. Assign a material or a shader
 * 
 * Note:
 * Works only in Game Window
 * Does not work for shadergraph shaders
 * 
 */

namespace MethodsInUnity
{
    using UnityEngine;

    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class SimpleBlit : MonoBehaviour
    {
        [SerializeField] Shader shader;

        Material mat;

        void OnValidate()
        {
            if (shader == null) return;

            mat = new Material(shader);
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (mat == null) return;

            Graphics.Blit(src, dest, mat);
        }
    }
}