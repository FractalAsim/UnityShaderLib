# UnityShaderLib

List of Shader Techniques in ShaderLab & ShaderGraph

# Basic (Foundational)
<h3>

- <ins>Lerp</ins> - Basic Blends between two colors
- <ins>NdotL</ins> - Basic Lighting of Lambertian diffuse model
- <ins>PlainColor</ins> - Basic Color output
- <ins>TangentToWorld</ins> - Matrix construction for calculating WorldNormals
- <ins>Texturing</ins> - Basic Texturing
- <ins>WorldPos</ins> - World Position Calculation

</h3>

# Common

<h3>

<details>
  <summary>Blur</summary>
<br>

> Blur on a texture by taking samples of the surounding/neighbouring pixels and calculating the weighted average.

-  <ins>BoxBlur</ins> 
    > 3x3 Samples with equal weights

-  <ins>GaussianBlur</ins> 
    > 3x3 Samples with Gaussian weights

-  <ins>HorizontalBlur/VerticalBlur</ins>
    > 1x9/9x1 Samples with equal weights

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
    >Round/Clamp colors to the nearest N interval which results in a banding effect
    - Optionaly to include a Ramp Texture to determine the color for each interval
    - Used in Toon shading

-  ColorBlending

    -  <ins>ColorBleed</ins>

        > Mix in colors depending on a threshold
        
-  ColorBorder
    > Set Color on the Border edge of an object uvs.

-  ColorRim
    > Adds Color based on the surface normals to the camera
    - Uses the "Fresnel" or "NdotV"

</details>

<!-- --> <br>

<details>
  <summary>Cutoff</summary>
<br>

> Selectively Use of Clip/Discard/AlphaClipping to not draw certain parts of the

- CutoffAxis
    > Draw parts of the object within a selected axis and range in the world

- CutoffBox
    > Draw parts of the object within a Box Bounds(AABB) in the world

-  CutoffPlane
    > Draw parts of the object that are on either side of a Plane in the world

-  HorizontalSlice
    > Draw object with equal horizontal gaps as like being sliced in parts 

</details>

<!-- --> <br>

<details>
  <summary>Dissolve</summary>
<br>

> Hide/Reveal objects by making parts of the object transparent or gone and using a DissolveMap for detail.

- DissolveByDistance
    > Dissolve objects based on distance from a point

- HardDissolve
    > Dissolve object using a dissolve texture for opaque objects

-  SoftDissolve
    > Dissolve object using a dissolve texture for transparent objects

</details>

<!-- --> <br>

<details>
  <summary>FlatShading</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

- Using Geometry shader
    > Use geometry shader to manually calculate and store the normals of a face instead of using interpolated normals for fragment shader


</details>

<!-- --> <br>

<details>
  <summary>FlowMap</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>GerstnerWaterShader</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>NormalBlending</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>OutlineSilhouette</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>ReflectionRefraction</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>TextureChannelSelect</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>TextureSplatting</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>


<!-- --> <br>

<details>
  <summary>UVScrolling</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>VertexDisplacement</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Wireframe</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

</h3>

## Uncommon

<h3>

<details>
  <summary>CelShading</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Foil</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>InteriorMapping</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

</h3>

## Advanced

<h3>

<details>
  <summary>StochasticTexturing</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Tessellation</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

</h3>

## PostProcessing

<h3>

Includes old & new ways of postprocessing in unity
-   [MonoBehaviour.OnRenderImage](https://docs.unity3d.com/ScriptReference/MonoBehaviour.OnRenderImage.html) [Old]
-  [HDRP Custom Pass Volume](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@17.3/manual/Custom-Post-Process.html) [New] 

<details>
  <summary>Bloom</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Bloom</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>LensRain</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Outline</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>Pixelate</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>ScreenBlur</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>ScreenDistortion</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>ScreenTransition</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>UnderwaterScreen</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary>VHSFilter</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using DDXY
    > Use partial derivative ddx, ddy to normals instead of using interpolated normals for fragment shader

</details>

</h3>



