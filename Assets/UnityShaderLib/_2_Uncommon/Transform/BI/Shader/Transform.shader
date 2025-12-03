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

            #include "Assets/UnityShaderLib/Subgraphs_Inc/Math/Matrix.cginc"

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
