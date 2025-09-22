# UnityShaderLib
<h3>

 This project is to showcase a list of Shader Techniques done in Unity.

Contains Shader/ShaderGraph Examples that are meant to show off the technique only and not production ready.


Shaders are Categorized into 5 categories depending on their use and complexity
  1. <ins>Basic</ins> - Fundamental Shaders (Must know)
  2. <ins>Common</ins> - Popular Shaders that you can find everywhere
  3. <ins>Uncommon</ins> - Specialized or Optimized Shaders
  4. <ins>Advanced</ins> - Complex, difficult to understand or Uber Shaders
  5. <ins>PostProcessing</ins> - Shaders targeting 2D, Screen or 2D Sprites

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
  <summary>ReflectionRefraction</summary>
<br>

> TODO

</details>


<!-- --> <br>

<details>
  <summary><ins>Silhouette</ins></summary>
<br>

> TODO

</details>


<!-- --> <br>

<details>
  <summary>><ins>TextureChannelSelect</ins></summary>
<br>

> Select Red, Green or Blue channel of the texture using dot product. Normally use for rgb masks

</details>

<!-- --> <br>

<details>
  <summary>TextureSplatting</summary>
<br>

> Use of a special "Splat" Texture to have different parts of the model to use different texture in one material. Common used for terrain.

- <ins>Gray</ins>
    > Use of a gray scale "Splat Texture"

- <ins>RGBA</ins>
    > Use of a RGBA "Splat Texture" to support max 4 different texture.

- <ins>RGBABlend</ins>
    > RGBA but blends properly when "Splat Texture" channels overlaps

</details>

<!-- --> <br>

<details>
  <summary><ins>UVScrolling</ins></summary>
<br>

> Common technique to animate the appearance of the object by updating uvs.

</details>

<!-- --> <br>

<details>
  <summary><ins>VertexDisplacement</ins></summary>
<br>

> Common technique to make object move by updating the position in vertex shader. 

</details>

<!-- --> <br>

<details>
  <summary>Wireframe</summary>
<br>

> Common Debug/Test shader to show the triangle edges of the object. 

- <ins>WireframeBary</ins>
    > Use of Geometry shader to add in barycentric coordinates and using the coordinates to find nearest edge to create outlines.
    
- <ins>WireframeDist</ins>
    > Use of Geometry shader to calculate distance to nearest edge and using the distance to create outlines at the smallest distance.


</details>

</h3>

## Uncommon

<h3>

<details>
  <summary><ins>CelShading</ins></summary>
<br>

> Very popular cartoon/anime non-photorealistic rendering.  

- Usually done by combination of Outline + ColorBanding Shader

</details>

<!-- --> <br>

<details>
  <summary>Explode</summary>
<br>

> TODO

</details>

<!-- --> <br>

<details>
  <summary><ins>Foil</ins></summary>
<br>

> Foil effect similar to the holofoil in Trading Card Games

</details>

<!-- --> <br>

<details>
  <summary><ins>InteriorMapping</ins></summary>
<br>

> Popular technique for faking rooms in buildings instead of modeling actual rooms

- Use of a specially prepared exterior texture and interior cube map.

- Additional work is done to have Rooms are randomized in look

</details>

</h3>

## Advanced

<h3>

<details>
  <summary>StochasticTexturing</summary>
<br>

> Techniques to fix repeated patterns/artifacts when using texture tilling, mimaps on large surfaces

- <ins>HexTilling</ins>
    > Segment the uvs into 3 Hexagonal groups and rotate each group to produce non-repeating patterns

</details>

<!-- --> <br>

<details>
  <summary>Tessellation</summary>
<br>

> Special use inserting more vertices into the mesh. Usually as a pre-step to add more details when viewing the object very close.

- <ins>TessellationBasic</ins>
    > Standard tessalation by use of Hull and Domain Shader

- <ins>TessellationDisplacement</ins>
    > Use of tessllation and do vertex displacement using a height/displacement map to add more details to a low poly plane/object

    > Usually use for terrains.

</details>

</h3>

## PostProcessing

<h3>

PostProcessing Shaders are a group of shaders that is normally done on top of the final rendered scene.

Includes old & new ways of postprocessing in unity
-   [MonoBehaviour.OnRenderImage](https://docs.unity3d.com/ScriptReference/MonoBehaviour.OnRenderImage.html) [Old]
-  [HDRP Custom Pass Volume](https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@17.3/manual/Custom-Post-Process.html) [New] 

<details>
  <summary><ins>Bloom</ins></summary>
<br>

> Simulation the Camera Effect of having bright lights glow/bleed with nearby colors due to short exposure time.

> Technique is done by bluring bright regions and layering it on the original image

</details>

<!-- --> <br>

<details>
  <summary><ins>LensRain</ins></summary>
<br>

> Simulation the Camera Effect of having rain streaking down on the lens.

> Technique Usually Includes the folowing effect combined
- Static Droplets
- Water Streaks

</details>

<!-- --> <br>

<details>
  <summary>Outline</summary>
<br>

> Technique to create an outline around the visible parts of the model.

> Post-Processing version of Outline is done using different techniques

- <ins>OutlineDepth</ins>
    > Use Depth Buffer to detect edges and create outline

- <ins>OutlineNormal</ins>
    > Use World Normals to detect edges and create outline

</details>

<!-- --> <br>

<details>
  <summary><ins>Pixelate</ins></summary>
<br>

> Styleized effect to have parts or the whole image appear at low-resolution

> Technique us usually done by downsampling and then upscale.

</details>

<!-- --> <br>

<details>
  <summary>ScreenBlur</summary>
<br>

> Simulation the Camera Effect of having parts of the image streatched out due to fast motion of camera.

> Technique is usually done by combining the neighbouring pixel (samples/tap) and average them up (based on weights)

- <ins>BoxBlur9Tap</ins>
    > Sample 9 nearest neighbour pixel and apply Avergae weights

- <ins>BoxBlurGaussian9Tap</ins>
    > Sample 9 nearest neighbour pixel and apply Gaussian weights

- <ins>ConeBlur4Tap</ins>
    > Sample 4 nearest diagonal neighbour pixel and apply Average weights

- <ins>DownResBlur</ins>
    > Simple blur effect as a result of downsampling the image/Screen.

- <ins>RadialBlurGaussian9Tap</ins>
    > Sample 9 neighbour pixel around a circle and apply Gaussian weights

</details>

<!-- --> <br>

<details>
  <summary><ins>ScreenDistortion</ins></summary>
<br>

> Popular Effect to bend or warp the screen by use of distortion maps to shift and move UVs of the screen

</details>

<!-- --> <br>

<details>
  <summary>ScreenTransition</summary>
<br>

> Simple Effect to mask the screen using a special transition texture, normally used before transitioning to a new scene or area.

</details>

<!-- --> <br>

<details>
  <summary>UnderwaterScreen</summary>
<br>

> Special effect to transform the screen to appear as a camera being submerge underwater.

</details>

<!-- --> <br>

<details>
  <summary>VHSFilter</summary>
<br>

> Stylied effect to give the screen/image the look as seen from an old CRT displays.

</details>

</h3>
