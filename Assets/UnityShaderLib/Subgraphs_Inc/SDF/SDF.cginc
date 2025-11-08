#ifndef SDF
#define SDF

float Ellipse(float2 p, float2 e)
{
    // https://www.shadertoy.com/view/tt3yz7
    float2 pAbs = abs(p);
    float2 ei = 1.0 / e;
    float2 e2 = e * e;
    float2 ve = ei * float2(e2.x - e2.y, e2.y - e2.x);
    
    float2 t = float2(0.70710678118654752, 0.70710678118654752);
    for (int i = 0; i < 3; i++)
    {
        float2 v = ve * t * t * t;
        float2 u = normalize(pAbs - v) * length(t * e - v);
        float2 w = ei * (v + u);
        t = normalize(clamp(w, 0.0, 1.0));
    }
    
    float2 nearestAbs = t * e;
    float dist = length(pAbs - nearestAbs);
    return dot(pAbs, pAbs) < dot(nearestAbs, nearestAbs) ? -dist : dist;
}

#endif