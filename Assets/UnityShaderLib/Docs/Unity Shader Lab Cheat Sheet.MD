# Shader Functions

<details>
<summary>Shader Data Types</summary>

- float : Full Precision, 
- half : Half Precision
- fixed : Low Precision, normally used for color;
- int : Integer for arrays and looping (might not be suppported for some GPU)
- uint : Unsigned Integer
- float4 : Vector of float precision
- floatNxN : Matrix of float precision (some platform only support Square Matrixs) 
- sampler2D _MainTex : : Texture with normal precision
- sampler3D_float _DepthTexture : Texture with full precision
- samplerCUBE_half _Cubemap : Texture with low precision

</details>
<br>

<details>
<summary>Standard Math Functions</summary>

- sign(x) : -1,0,1
- abs(x)
- min(a,b), max(a,b) : max 2 params
- clamp(x,b,c)
- floor(x), ceil(x), round(x)
- pow(x,y), sqrt(x)
- exp(x), log(x)
- radians(x), degrees(x)
- sin(x)/cos(x)/tan(x)/asin(x)/acos(x)/atan(x)
- atan2(x)
- any(x,...) / all(x,...) : true if input are all non zero

</details>
<br>
<details>
<summary>Vector Math Functions</summary>

- length(x)
- distance(a, b)
- normalize()
- dot(a,b)
- cross(a,b)
- mul(a,b) : Matrix multiply
- inverse(m)
- transpose(m)
- reflect(I,N) : reflect direction (I) on mirror surface (N)

</details>
<br>
<details>
<summary>Shader Math Functions</summary>

- saturate(x) : clamp(x,0,1)
- frac(x) : returns the fraction of the number
- fmod(x,y) : floating point modulo
- lerp(a,b,t) - a->b update
- smoothstep(a,b,x) - Hermite interpolation [0,1]
- step(edge,x) : (x < edge) ? 0 : 1

</details>
<br>

# Unity Build-in Vars
- float4 _Time : (t/20, t, t*2, t*3)
- float4 _SinTime : (t/8, t/4, t/2, t)
- float4 _CosTime : (t/8, t/4, t/2, t)
- float4 unity_DeltaTime : (dt, 1/dt, smoothDt, 1/smoothDt)
- float4x4 unity_ObjectToWorld : Model Matrix
- float4x4 unity_WorldToObject : Inverse Model Matrix
- float4x4 UNITY_MATRIX_MVP : MVP Matrix
- float3 _WorldSpaceCameraPos : Camera world pos
- float4 _ScreenParams : (width,height,1+1/width,1+1/height)
- float4 _ProjectionParams : (1 or -1 zflip,near,far,1/far)
- float4 unity_CameraWorldClipPlanes[6] : Camera frustum (left,right,bot,top,near,far)
- float4 _WorldSpaceLightPos0 : first light inscene info (worldpos,1) or (dir,0)

# Unity Shader Functions In UnityCG.cginc
- TRANSFORM_TEX(uv,texturename)
    - Function to update UVs to have two additional "Tilling" and "Offset" configuration to the texture input.
    - Unity search for the the float4 property "{texturename}_ST" for the additional info
- float4 UnityObjectToClipPos(float3)
    - Converts position of object space (local) to clip space (screen). 
    - Same as doing mul(MVP,pos)
- Luminance(half3 rgb)
    - quick function to get luminance (grayscale) by performing dot product
- DecodeHDR(half4 data, half4 decodeInstructions, int colorspaceIsGamma)
    - decode hdr
- LinearEyeDepth(depthtexture.uv) / Linear01Depth(depthtexture.uv)
    - converts z buffer to linear depth