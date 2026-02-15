#ifndef Common
#define Common

inline float TimeLoop01()
{
    return _SinTime.w * 0.5 + 0.5;
}

inline float MainLightOnSurface(float3 normal)
{
    float3 worldNormal = UnityObjectToWorldNormal(normal);
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    return dot(worldNormal, lightDir);
}

inline float Remap1101(float num)
{
    return num * 0.5f + 0.5f;
}

inline float Fresnel(float3 worldNormal, float3 viewDir, float power)
{
    // Normalize just incase
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

#endif