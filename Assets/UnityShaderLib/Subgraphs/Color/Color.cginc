#ifndef Color
#define Color

float3 RGBToYIQ(float3 RGB)
{
    // NTSC 1953 colorimetry
    float3x3 formula =
        float3x3(0.299, 0.587, 0.114,
                0.5959, -0.2746, -0.3213,
                0.2115, -0.5227, 0.3112);
    
    return mul(formula, RGB);

}
float3 YIQToRGB(float3 YIQ)
{
    float3x3 formula =
        float3x3(1, 0.956, 0.619,
                1, -0.272, -0.647,
                1, -1.106, 1.703);
    
    return mul(formula, YIQ);
}
float3 YIQShift(float3 rgbCol, float hueShift, float saturation, float brightnessShift)
{
    // Y = Luminance/Brightness
    // IQ = Chromiance
    
    // 1. Convert to YIQ color space
    float3 YIQ = RGBToYIQ(rgbCol);
    
    // 2. Caluclate and adjust
    float hue = atan2(YIQ.b, YIQ.g) + hueShift;
    float chroma = length(float2(YIQ.g, YIQ.b)) * saturation;
    
    // 3. Reconstruct YIQ with new values
    float Y = YIQ.r + brightnessShift;
    float I = chroma * cos(hue);
    float Q = chroma * sin(hue);
    
    // 4. Convert back to RGB color space
    float3 RGB = YIQToRGB(float3(Y, I, Q));
    
    return RGB;
}

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
    return U * cos(hueShift * UNITY_TWO_PI) + V * sin(hueShift * UNITY_TWO_PI) + P;
}
float3 RGBToHSV(float3 col)
{
    // https://www.shadertoy.com/view/lsS3Wc
    // Branchless Formula by inigo quilez
    
    float E = 1e-10;
    
    
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(col.bg, K.wz), float4(col.gb, K.xy), step(col.b, col.g));
    float4 Q = lerp(float4(P.xyw, col.r), float4(col.r, P.yzx), step(P.x, col.r));
    float D = Q.x - min(Q.w, Q.y);
    
    return float3(abs(Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);
}
float3 HSVToRGB(float3 col)
{
    col.x *= 6.0;
    float3 rgb = saturate(float3(-1.0 + abs(col.x - 3.0),
                                2.0 - abs(col.x - 2.0),
                                2.0 - abs(col.x - 4.0)));
    
    
    return col.z * lerp(float3(1.0, 1.0, 1.0), rgb, col.y);
}

float3 RGBToHSL(float3 col)
{
    // https://www.shadertoy.com/view/lsS3Wc
    
    float E = 1e-10;
    
    float minc = min(col.r, min(col.g, col.b));
    float maxc = max(col.r, max(col.g, col.b));
    float3 mask = step(col.grr, col.rgb) * step(col.bbg, col.rgb);
    float3 h = mask * (float3(0.0, 2.0, 4.0) + (col.gbr - col.brg) / (maxc - minc + E)) / 6.0;
    return float3(frac(1.0 + h.x + h.y + h.z),                          // H
                 (maxc - minc) / (1.0 - abs(minc + maxc - 1.0) + E),    // S
                 (minc + maxc) * 0.5);                                  // L
}

#endif