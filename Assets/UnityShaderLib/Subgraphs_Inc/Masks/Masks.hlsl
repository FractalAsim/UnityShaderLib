#ifndef MASKS_HLSL
#define MASKS_HLSL

float BorderMask(float2 uv, float width, float sharpness)
{
    float2 botLeft = 1 - smoothstep(lerp(0, width, sharpness), width, uv);
    float2 topRight = smoothstep(1 - width, lerp(1 - width, 1, 1 - sharpness), uv);
                
    return saturate(botLeft.r + botLeft.g + topRight.r + topRight.g);
}
#endif