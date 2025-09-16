# UnityShaderLib
<h3>

 This project is to showcase a list of Shader Techniques done in Unity.

 - Contains Shader/ShaderGraph Examples that are meant to show off the technique only and not production ready.

</h3>

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

> Blur on a texture by taking samples of the surounding/neighbouring pixels and calculating the weighted average

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
        
-  <ins>ColorBorder</ins>
    > Set Color on the Border edge of an object uvs.

-  <ins>ColorRim</ins>
    > Adds Color based on the surface normals to the camera
    - Uses the "Fresnel" or "NdotV"

</details>

<!-- --> <br>

<details>
  <summary>Cutoff</summary>
<br>

> Selectively Use of Clip/Discard/AlphaClipping to not draw certain parts of the object

-  <ins>CutoffAxis</ins>
    > Draw parts of the object within a selected axis and range in the world

-  <ins>CutoffBox</ins>
    > Draw parts of the object within a Box Bounds(AABB) in the world

-  <ins>CutoffPlane</ins>
    > Draw parts of the object that are on either side of a Plane in the world

-  <ins>HorizontalSlice</ins>
    > Draw object with equal horizontal gaps as like being sliced in parts 

</details>

<!-- --> <br>

<details>
  <summary>Dissolve</summary>
<br>

> Hide/Reveal objects by making parts of the object transparent or gone and using a DissolveMap for detail

-  <ins>DissolveByDistance</ins>
    > Dissolve objects based on distance from a point

-  <ins>HardDissolve</ins>
    > Dissolve object using a dissolve texture for opaque objects

-  <ins>SoftDissolve</ins>
    > Dissolve object using a dissolve texture for transparent objects

</details>

<!-- --> <br>

<details>
  <summary>FlatShading</summary>
<br>

> Flatshading or Faceted Shadding is a Stylized effect to having each face of the mesh to be of the same color.

- Using <ins>DDXY</ins>
    > Use partial derivative ddx, ddy to use as normals instead of using interpolated normals for fragment shader

- Using <ins>Geometry shader</ins> 
    > Use geometry shader to manually calculate and store the normals of a face instead of using interpolated normals for fragment shader

</details>

<!-- --> <br>

<details>
  <summary><ins>FlowMap</ins></summary>
<br>

> Use of a special Texture "FlowMap" to shift UVs to give a appearance of water flowing

- A Special Lerp Technique is used to loop the FlowMap and blend seemlessly over time

</details>

<!-- --> <br>

<details>
  <summary><ins>GerstnerWater</ins></summary>
<br>

> Well known shader to do vertex displacement using the Gerstner wave equations for ocean/water wave movement

</details>


<!-- --> <br>

<details>
  <summary>NormalBlending (Detail Normal Map)</summary>
<br>

> Technique to combine/blend two normals together. Usually for one detailed normal map and a base normal map

- <ins>Reoriented (RNM)</ins>
    > Technique described by  Colin Barré-Brisebois and Stephen Hill in [blog](https://blog.selfshadow.com/publications/blending-in-detail/)

    > Reorient one detail normal so it follows a base normal map
    
    > Unity has a build-in Reoreinted Normal Blend Node in Shader Graph that uses a tweaked version of this
    
- <ins>Simple</ins>
    
    > Technique documented In Unreal Engine [UDK/UDK](https://docs.unrealengine.com/udk/Three/MaterialBasics.html#Detail%20Normal%20Map)

    > Unity has a build-in Reoreinted Normal Blend Node in Shader Graph that uses this

- <ins>WhiteOut</ins>
    > Technique described by Christopher Oat in "SIGGRAPH 2007 chapter 4 - Animated Wrinkle Maps" Ruby "Whiteout"

</details>


<!-- --> <br>

<details>
  <summary><ins>Outline</ins></summary>
<br>

> Easy Technique to create an outline around the visible parts of the model.

> Two pass shader which first draws a slightly larger model and then draw normally on top.

> Have some issue when another object with the same shader or transparent object overlap due to being on the transparent renderqueue and draw order.

<details>
  <summary><ins>Silhouette</ins></summary>
<br>

> TODO

</details>


<!-- --> <br>

<details>
  <summary>ReflectionRefraction</summary>
<br>

> TODO

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



