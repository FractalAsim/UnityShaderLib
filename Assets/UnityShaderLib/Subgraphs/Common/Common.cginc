#ifndef Common
#define Common

float MainLightOnSurface(float3 normal)
{
    float3 worldNormal = UnityObjectToWorldNormal(normal);
    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    return dot(worldNormal, lightDir);
}

float Remap1101(float num)
{
    return num * 0.5f + 0.5f;
}

float Fresnel(float3 worldNormal, float3 viewDir, float power)
{
    // Normalize just incase
    return pow(1.0 - saturate(dot(normalize(worldNormal), normalize(viewDir))), power);
}

#endif