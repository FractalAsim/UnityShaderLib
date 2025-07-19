//// Gyroid 
//using Unity.Mathematics;

//float sdGyroid(float3 pos, float scale, float thickness, float bias)
//{
//    pos *= scale;
//    return abs(dot(sin(pos), cos(pos.zxy)) + bias) / scale - thickness;
//}