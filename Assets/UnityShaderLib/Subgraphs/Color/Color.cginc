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
    float3 norm = float(0.57735);
    
    float3 P = norm * dot(norm, col);
    float3 U = col - P;
    float3 V = cross(norm, U);
    
    // Rodrigues’ rotation formula to rotate
    return U * cos(hueShift * UNITY_TWO_PI) + V * sin(hueShift * UNITY_TWO_PI) + P;
}


#endif