Shader "Common/GerstnerWater"
{
    Properties
    {
        // _Color ("Water Color", Color) = (0.2, 0.4, 0.7, 1)
        // _WaveAmp ("Wave Amplitude", Float) = 0.5
        // _WaveLen ("Wave Length", Float) = 4.0
        // _WaveSpeed ("Wave Speed", Float) = 1.0
        // _Steepness ("Steepness", Float) = 0.5
        // _Direction1 ("Wave Direction 1", Vector) = (1, 0, 0, 0)
        // _Direction2 ("Wave Direction 2", Vector) = (0.5, 0, 0.5, 0)
        // _Direction3 ("Wave Direction 3", Vector) = (-0.7, 0, 0.3, 0)
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

            #include "UnityCG.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;

                float3 normal : TEXCOORD0;
            };

            fixed4 _Color;
            float _WaveAmp;
            float _WaveLen;
            float _WaveSpeed;
            float _Steepness;

            float4 _Direction1;
            float4 _Direction2;
            float4 _Direction3;

            // Gerstner wave function, does not have normal calculation applied
            void GerstnerWave(float3 pos, float2 dir, float amp, float len, float speed, float steep, float t, out float3 disp, out float3 normal)
            {
                dir = normalize(dir);

                float k = UNITY_TWO_PI / len; // frequency
                float w = sqrt(9.81 * k); // angular frequency
                float phase = k * dot(dir, pos.xz) - w * t * speed;

                float cosP = cos(phase);
                float sinP = sin(phase);

                float Qi = steep / (k * amp);

                disp.x = Qi * amp * cosP * dir.x;
                disp.y = amp * sinP;
                disp.z = Qi * amp * cosP * dir.y;

                normal.rb =  sinP * (k * amp) * dir;
                normal.g = 1 - (cosP * (k * amp) * Qi);
            }

            v2f vert (appdata v)
            {
                v2f o;

                // normalize directions
                float2 d1 = float2(-0.2,-0.7);
                float2 d2 = float2(-1,0);
                float2 d3 = float2(-0.5,0.5);

                // Get Distplacement based on GerstnerWave Equation
                float3 disp;
                float3 normal;

                float3 totaldisp;

                GerstnerWave(v.pos, d1, 0.07, 2.5, 1, 0.3, _Time.y, disp, normal);
                totaldisp = disp;
                o.normal = normal;

                GerstnerWave(v.pos, d2, 0.05, 3, 1, 0.3, _Time.y, disp, normal);
                totaldisp += disp;
                o.normal += normal;

                GerstnerWave(v.pos, d3, 0.04, 1.8, 1, 0.4, _Time.y, disp, normal);
                totaldisp += disp;
                o.normal += normal;

                // Apply Displacement
                v.pos.xyz += totaldisp;

                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            uniform float4 _LightColor0;

            fixed4 frag (v2f i) : SV_Target
            {
                // Basic light using NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(dot(i.normal, lightDir), 0.0);

                fixed4 col = float4(0,0,0.5660378,1) * _LightColor0 * NdotL;
                return col;
            }

            ENDCG
        }
    }
}
