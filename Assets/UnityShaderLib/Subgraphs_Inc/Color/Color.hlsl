#ifndef COLOR_HLSL
#define COLOR_HLSL

// Requires for TWO_PI
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl"

float3 DirectHueShift(float3 col, float hueShift)
{
    // 1.Project color into normalized luminance vector to keep brightness value
    // 2.Use Rodrigues’rotation formula to rotate(hueshift)
    // 3.Add shiftedvalue on top of original projection
    
    // Luminance normalized vector
    float3 norm = float3(0.57735, 0.57735, 0.57735);
    
    float3 P = norm * dot(norm, col);
    float3 U = col - P;
    float3 V = cross(norm, U);
    
    // Rodrigues’ rotation formula to rotate
    half s, c;
    sincos(hueShift * TWO_PI, s, c);
    return U * c + V * s + P;
}


#endif