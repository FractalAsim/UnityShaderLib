// Uncommon Shader that takes input of TRS manually and creates model matrix

Shader "Uncommon/Transform"
{
    Properties
    {
        _Translation("Translation", Vector) = (0,0,0)
        _Rotation("Rotation", Vector) = (0,0,0,0)
        _Scale("Scale", Vector) = (1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Input to Vertex Shader
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float3 _Translation;
            float4 _Rotation;
            float4 _Scale;

            float4x4 TranslationMatrix(float3 t)
            {
                return float4x4(
                    float4(1, 0, 0, 0),
                    float4(0, 1, 0, 0),
                    float4(0, 0, 1, 0),
                    float4(t.x, t.y, t.z, 1)
                );
            }
            float4x4 ScaleMatrix(float3 s)
            {
                return float4x4(
                    float4(s.x, 0,   0,   0),
                    float4(0,   s.y, 0,   0),
                    float4(0,   0,   s.z, 0),
                    float4(0,   0,   0,   1)
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

                return float4x4(
                    float4(1.0 - (yy + zz), xy + wz,       xz - wy,       0),
                    float4(xy - wz,         1.0 - (xx + zz), yz + wx,     0),
                    float4(xz + wy,         yz - wx,       1.0 - (xx + yy), 0),
                    float4(0, 0, 0, 1)
                );
            }

            float4x4 BuildTRS(float3 pos, float4 rot, float3 scale)
            {
                float4x4 T = TranslationMatrix(pos);
                float4x4 S = ScaleMatrix(scale);
                float4x4 R = RotationMatrix(rot);

                return transpose(mul(mul(S, R), T));
            }

            v2f vert (appdata v)
            {
                v2f o;

                //o.pos = UnityObjectToClipPos(v.vertex); // Original

                // Manually calculate TRS model matrix
                float4x4 model = BuildTRS(_Translation,_Rotation,_Scale);
                o.pos = mul(UNITY_MATRIX_VP, mul(model, v.vertex));

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(1,1,1,1);
            }

            ENDCG
        }
    }
}
