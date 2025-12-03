#ifndef MATRIX_INCLUDED
#define MATRIX_INCLUDED

#define IdentityMatrix float4x4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)

float4x4 TranslationMatrix(float3 t)
{
    return float4x4(
        float4(1, 0, 0, t.x),
        float4(0, 1, 0, t.y),
        float4(0, 0, 1, t.z),
        float4(0, 0, 0, 1)
    );
}
float4x4 RotationMatrix(float4 q)
{
    float x2 = q.x + q.x;
    float y2 = q.y + q.y;
    float z2 = q.z + q.z;

    float xx = q.x * x2;
    float yy = q.y * y2;
    float zz = q.z * z2;
    float xy = q.x * y2;
    float xz = q.x * z2;
    float yz = q.y * z2;
    float wx = q.w * x2;
    float wy = q.w * y2;
    float wz = q.w * z2;

    float4x4 m = 0;

    m[0][0] = 1.0 - (yy + zz);
    m[0][1] = xy - wz;
    m[0][2] = xz + wy;
    //m[0][3] = 0;

    m[1][0] = xy + wz;
    m[1][1] = 1.0 - (xx + zz);
    m[1][2] = yz - wx;
    //m[1][3] = 0;

    m[2][0] = xz - wy;
    m[2][1] = yz + wx;
    m[2][2] = 1.0 - (xx + yy);

    //m[3][0] = 0;
    //m[3][1] = 0;
    //m[3][2] = 0;
    m[3][3] = 1.0;

    return m;
}
float4x4 ScaleMatrix(float3 s)
{
    return float4x4(
        float4(s.x, 0, 0, 0),
        float4(0, s.y, 0, 0),
        float4(0, 0, s.z, 0),
        float4(0, 0, 0, 1)
    );
}

float4x4 BuildTRS(float3 pos, float4 rot, float3 scale)
{
    float4x4 T = TranslationMatrix(pos);
    float4x4 S = ScaleMatrix(scale);
    float4x4 R = RotationMatrix(rot);

    return mul(mul(T, R), S);
}



#endif