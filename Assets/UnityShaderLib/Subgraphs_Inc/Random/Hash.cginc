
// Very Common Hash function
inline float hash11(float n)
{
    return frac(sin(n) * 43758.5453);
}

// Very Common Hash function
inline float hash21(float2 uv)
{
    return frac(sin(dot(uv.xy, float2(12.9898, 78.233))) * 43758.5453);
}

inline float2 hash22(float2 p)
{
    return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
}
