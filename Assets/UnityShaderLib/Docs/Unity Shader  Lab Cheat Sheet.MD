Math
floor()
saturate() // 
step()
smoothstep()
sharpstep()
normalize()
cross()



float4 _Time; // (t/20, t, t*2, t*3)
float4 _SinTime // (t/8, t/4, t/2, t)
float4 _CosTime // (t/8, t/4, t/2, t)
float4 unity_DeltaTime // (dt, 1/dt, smoothDt, 1/smoothDt)


UnityObjectToClipPos() => Converts position of object space (local) to clip space (screen). Works by applying MVP matrix on position




UNITY_MATRIX_MVP
unity_ObjectToWorld
unity_WorldToObject

_WorldSpaceCameraPos
_ProjectionParams

_ScreenParams

_WorldSpaceLightPos0

# In UnityCG.cginc
- TRANSFORM_TEX(uv,texturename)
    - Function to update UVs to have two additional "Tilling" and "Offset" configuration to the texture input.
    - Unity search for the the float4 property "{texturename}_ST" for the additional info
- Luminance(half3 rgb)
    - quick function to get luminance (grayscale) by performing dot product
- DecodeHDR(half4 data, half4 decodeInstructions, int colorspaceIsGamma)
    - decode hdr
- LinearEyeDepth(float z)
    - converts z buffer to linear depth