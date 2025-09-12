# UnityShaderLib

List of Shader Techniques in ShaderLab & ShaderGraph

# Basic (Foundational)
<h3>

* <ins>Lerp</ins> - Basic Blends between two colors
* <ins>NdotL</ins> - Basic Lighting of Lambertian diffuse model
* <ins>PlainColor</ins> - Basic Color output
* <ins>TangentToWorld</ins> - Matrix construction for calculating WorldNormals
* <ins>Texturing</ins> - Basic Texturing
* <ins>WorldPos</ins> - World Position Calculation

</h3>

# Common

<h3>

<details>
  <summary>Blur</summary>
<br>

> Blur on a texture by taking samples of the surounding/neighbouring pixels and calculating the weighted average.
*  <ins>BoxBlur</ins> - 3x3 Samples with equal weights
*  <ins>GaussianBlur</ins> - 3x3 Samples with Gaussian weights
*  <ins>HorizontalBlur/VerticalBlur</ins> - 1x9,9x1 Samples with equal weights

</details>

<!-- --> <br>

<details>
  <summary>Color</summary>
<br>

- ColorAdjustment

    -  <ins>Desaturate</ins>
        > Desaturate the image by converting to luminance value using common luma formulas (e.g Rec. 601)

    -  <ins>DirectHueShift</ins>
        > Modify Color's Hue,Saturation,Brightness uing Rodrigues’ rotation formula

    - <ins>HSVShift</ins>
        > Modify Color's Hue,Saturation,Brightness by converting RGB to HSV color space

    - <ins>YIQShift</ins>
        > Modify Color's Hue,Saturation,Brightness by converting RGB to YIQ color space

-  ColorBanding
-  ColorBlending
-  ColorBorder
-  ColorRim

</details>




</h3>

## Uncommon


## Advanced
## PostProcessing




Includes old  & new ways of postprocessing
-  [MonoBehaviour.OnRenderImage](https://docs.unity3d.com/ScriptReference/MonoBehaviour.OnRenderImage.html)
-  [HDRP Custom Pass Volume](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@17.3/manual/Custom-Post-Process.html)
