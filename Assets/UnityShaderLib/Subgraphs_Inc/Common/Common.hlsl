#ifndef COMMON_HLSL
#define COMMON_HLSL

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

inline float TimeLoop01()
{
    // _SinTime is still available in URP
    return _SinTime.w * 0.5 + 0.5;
}

inline float MainLightOnSurface(float3 normalOS)
{
    float3 worldNormal = TransformObjectToWorldNormal(normalOS);
    Light mainLight = GetMainLight();
    return dot(normalize(worldNormal), mainLight.direction);
}

inline float Remap1101(float num)
{
    return num * 0.5 + 0.5;
}

inline float Fresnel(float3 worldNormal, float3 viewDir, float power)
{
    return pow(1.0 - saturate(dot(normalize(worldNormal), normalize(viewDir))), power);
}

inline float pulse(float a, float b, float x)
{
    return step(a, x) - step(b, x);
}

inline float smoothpulse(float a1, float a2, float b1, float b2, float x)
{
    return smoothstep(a1, a2, x) - smoothstep(b1, b2, x);
}

#endif // COMMON_HLSL