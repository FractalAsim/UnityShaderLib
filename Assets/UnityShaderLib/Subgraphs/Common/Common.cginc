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

#endif