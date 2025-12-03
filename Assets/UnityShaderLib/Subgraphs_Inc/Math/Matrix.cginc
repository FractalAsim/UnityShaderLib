#ifndef MATRIX_INCLUDED
#define MATRIX_INCLUDED

#define IDENTITYMATRIX float4x4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)

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

float4x4 AxisMatrix(float3 forward, float3 right, float3 up)
{
    return float4x4(
		right.x, up.x, forward.x, 0,
		right.y, up.y, forward.y, 0,
		right.z, up.z, forward.z, 0,
		0, 0, 0, 1
	);
}

float4x4 LookAtMatrix(float3 forward, float3 up)
{
    float3 x = normalize(cross(forward, up));
    float3 y = up;
    float3 z = forward;
    return AxisMatrix(x, y, z);
}

#endif 


//float4x4 inverse(float4x4 m)
//{
//    float n11 = m[0][0], n12 = m[1][0], n13 = m[2][0], n14 = m[3][0];
//    float n21 = m[0][1], n22 = m[1][1], n23 = m[2][1], n24 = m[3][1];
//    float n31 = m[0][2], n32 = m[1][2], n33 = m[2][2], n34 = m[3][2];
//    float n41 = m[0][3], n42 = m[1][3], n43 = m[2][3], n44 = m[3][3];

//    float t11 = n23 * n34 * n42 - n24 * n33 * n42 + n24 * n32 * n43 - n22 * n34 * n43 - n23 * n32 * n44 + n22 * n33 * n44;
//    float t12 = n14 * n33 * n42 - n13 * n34 * n42 - n14 * n32 * n43 + n12 * n34 * n43 + n13 * n32 * n44 - n12 * n33 * n44;
//    float t13 = n13 * n24 * n42 - n14 * n23 * n42 + n14 * n22 * n43 - n12 * n24 * n43 - n13 * n22 * n44 + n12 * n23 * n44;
//    float t14 = n14 * n23 * n32 - n13 * n24 * n32 - n14 * n22 * n33 + n12 * n24 * n33 + n13 * n22 * n34 - n12 * n23 * n34;

//    float det = n11 * t11 + n21 * t12 + n31 * t13 + n41 * t14;
//    float idet = 1.0f / det;

//    float4x4 ret;

//    ret[0][0] = t11 * idet;
//    ret[0][1] = (n24 * n33 * n41 - n23 * n34 * n41 - n24 * n31 * n43 + n21 * n34 * n43 + n23 * n31 * n44 - n21 * n33 * n44) * idet;
//    ret[0][2] = (n22 * n34 * n41 - n24 * n32 * n41 + n24 * n31 * n42 - n21 * n34 * n42 - n22 * n31 * n44 + n21 * n32 * n44) * idet;
//    ret[0][3] = (n23 * n32 * n41 - n22 * n33 * n41 - n23 * n31 * n42 + n21 * n33 * n42 + n22 * n31 * n43 - n21 * n32 * n43) * idet;

//    ret[1][0] = t12 * idet;
//    ret[1][1] = (n13 * n34 * n41 - n14 * n33 * n41 + n14 * n31 * n43 - n11 * n34 * n43 - n13 * n31 * n44 + n11 * n33 * n44) * idet;
//    ret[1][2] = (n14 * n32 * n41 - n12 * n34 * n41 - n14 * n31 * n42 + n11 * n34 * n42 + n12 * n31 * n44 - n11 * n32 * n44) * idet;
//    ret[1][3] = (n12 * n33 * n41 - n13 * n32 * n41 + n13 * n31 * n42 - n11 * n33 * n42 - n12 * n31 * n43 + n11 * n32 * n43) * idet;

//    ret[2][0] = t13 * idet;
//    ret[2][1] = (n14 * n23 * n41 - n13 * n24 * n41 - n14 * n21 * n43 + n11 * n24 * n43 + n13 * n21 * n44 - n11 * n23 * n44) * idet;
//    ret[2][2] = (n12 * n24 * n41 - n14 * n22 * n41 + n14 * n21 * n42 - n11 * n24 * n42 - n12 * n21 * n44 + n11 * n22 * n44) * idet;
//    ret[2][3] = (n13 * n22 * n41 - n12 * n23 * n41 - n13 * n21 * n42 + n11 * n23 * n42 + n12 * n21 * n43 - n11 * n22 * n43) * idet;

//    ret[3][0] = t14 * idet;
//    ret[3][1] = (n13 * n24 * n31 - n14 * n23 * n31 + n14 * n21 * n33 - n11 * n24 * n33 - n13 * n21 * n34 + n11 * n23 * n34) * idet;
//    ret[3][2] = (n14 * n22 * n31 - n12 * n24 * n31 - n14 * n21 * n32 + n11 * n24 * n32 + n12 * n21 * n34 - n11 * n22 * n34) * idet;
//    ret[3][3] = (n12 * n23 * n31 - n13 * n22 * n31 + n13 * n21 * n32 - n11 * n23 * n32 - n12 * n21 * n33 + n11 * n22 * n33) * idet;

//    return ret;
//}

//float4 matrix_to_quaternion(float4x4 m)
//{
//    float tr = m[0][0] + m[1][1] + m[2][2];
//    float4 q = float4(0, 0, 0, 0);

//    if (tr > 0)
//    {
//        float s = sqrt(tr + 1.0) * 2; // S=4*qw 
//        q.w = 0.25 * s;
//        q.x = (m[2][1] - m[1][2]) / s;
//        q.y = (m[0][2] - m[2][0]) / s;
//        q.z = (m[1][0] - m[0][1]) / s;
//    }
//    else if ((m[0][0] > m[1][1]) && (m[0][0] > m[2][2]))
//    {
//        float s = sqrt(1.0 + m[0][0] - m[1][1] - m[2][2]) * 2; // S=4*qx 
//        q.w = (m[2][1] - m[1][2]) / s;
//        q.x = 0.25 * s;
//        q.y = (m[0][1] + m[1][0]) / s;
//        q.z = (m[0][2] + m[2][0]) / s;
//    }
//    else if (m[1][1] > m[2][2])
//    {
//        float s = sqrt(1.0 + m[1][1] - m[0][0] - m[2][2]) * 2; // S=4*qy
//        q.w = (m[0][2] - m[2][0]) / s;
//        q.x = (m[0][1] + m[1][0]) / s;
//        q.y = 0.25 * s;
//        q.z = (m[1][2] + m[2][1]) / s;
//    }
//    else
//    {
//        float s = sqrt(1.0 + m[2][2] - m[0][0] - m[1][1]) * 2; // S=4*qz
//        q.w = (m[1][0] - m[0][1]) / s;
//        q.x = (m[0][2] + m[2][0]) / s;
//        q.y = (m[1][2] + m[2][1]) / s;
//        q.z = 0.25 * s;
//    }

//    return q;
//}

//void decompose(in float4x4 m, out float3 position, out float4 rotation, out float3 scale)
//{
//    float sx = length(float3(m[0][0], m[0][1], m[0][2]));
//    float sy = length(float3(m[1][0], m[1][1], m[1][2]));
//    float sz = length(float3(m[2][0], m[2][1], m[2][2]));

//    // if determine is negative, we need to invert one scale
//    float det = determinant(m);
//    if (det < 0)
//    {
//        sx = -sx;
//    }

//    position.x = m[3][0];
//    position.y = m[3][1];
//    position.z = m[3][2];

//    // scale the rotation part

//    float invSX = 1.0 / sx;
//    float invSY = 1.0 / sy;
//    float invSZ = 1.0 / sz;

//    m[0][0] *= invSX;
//    m[0][1] *= invSX;
//    m[0][2] *= invSX;

//    m[1][0] *= invSY;
//    m[1][1] *= invSY;
//    m[1][2] *= invSY;

//    m[2][0] *= invSZ;
//    m[2][1] *= invSZ;
//    m[2][2] *= invSZ;

//    rotation = matrix_to_quaternion(m);

//    scale.x = sx;
//    scale.y = sy;
//    scale.z = sz;
//}

//float4x4 extract_rotation_matrix(float4x4 m)
//{
//    float sx = length(float3(m[0][0], m[0][1], m[0][2]));
//    float sy = length(float3(m[1][0], m[1][1], m[1][2]));
//    float sz = length(float3(m[2][0], m[2][1], m[2][2]));

//    // if determine is negative, we need to invert one scale
//    // float det = determinant(m);
//    // sx = lerp(-sx, sx, step(0, det));

//    sx = lerp(1, sx, step(0, sx));
//    sy = lerp(1, sy, step(0, sy));
//    sz = lerp(1, sz, step(0, sz));

//    float invSX = 1.0 / sx;
//    float invSY = 1.0 / sy;
//    float invSZ = 1.0 / sz;

//    // invSX = lerp(invSX, 1, (float)_is_unexpected(invSX));
//    // invSY = lerp(invSY, 1, (float)_is_unexpected(invSY));
//    // invSZ = lerp(invSZ, 1, (float)_is_unexpected(invSZ));

//    float4x4 nm = IDENTITY_MATRIX;

//    nm[0][0] = m[0][0] * invSX;
//    nm[0][1] = m[0][1] * invSX;
//    nm[0][2] = m[0][2] * invSX;

//    nm[1][0] = m[1][0] * invSY;
//    nm[1][1] = m[1][1] * invSY;
//    nm[1][2] = m[1][2] * invSY;

//    nm[2][0] = m[2][0] * invSZ;
//    nm[2][1] = m[2][1] * invSZ;
//    nm[2][2] = m[2][2] * invSZ;

//    /*
//    nm[0][0] = lerp(nm[0][0], 1, (float)_is_unexpected(nm[0][0]));
//    nm[0][1] = lerp(nm[0][1], 0, (float)_is_unexpected(nm[0][1]));
//    nm[0][2] = lerp(nm[0][2], 0, (float)_is_unexpected(nm[0][2]));

//    nm[1][0] = lerp(nm[1][0], 0, (float)_is_unexpected(nm[1][0]));
//    nm[1][1] = lerp(nm[1][1], 1, (float)_is_unexpected(nm[1][1]));
//    nm[1][2] = lerp(nm[1][2], 0, (float)_is_unexpected(nm[1][2]));

//    nm[2][0] = lerp(nm[2][0], 0, (float)_is_unexpected(nm[2][0]));
//    nm[2][1] = lerp(nm[2][1], 0, (float)_is_unexpected(nm[2][1]));
//    nm[2][2] = lerp(nm[2][2], 1, (float)_is_unexpected(nm[2][2]));
//    */

//    return nm;
//}