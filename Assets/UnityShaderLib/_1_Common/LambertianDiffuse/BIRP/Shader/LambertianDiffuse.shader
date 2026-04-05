// Classic Lambert Model

Shader "Common/LambertianDiffuse"
{
    Properties 
    {
        _MainTex ("Albedo", 2D) = "white" {}
    }
    SubShader 
    {
        Tags { "RenderType"="Opaque" }

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

                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct v2f 
            {
                float4 pos : SV_POSITION;

                float2 uv  : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _LightColor0;

            // Vertex Shader
            v2f vert (appdata v) 
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            // Fragment Shader
            fixed4 frag (v2f i) : SV_Target 
            {
                // Material diffuse coefficient - aka albedo
                fixed3 Kd = tex2D(_MainTex, i.uv).rgb;

                // NdotL
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0.0, dot(normalize(i.worldNormal), lightDir));

                // Ambient coefficient
                fixed3 Ka = fixed3(0,0,0);

                // Equation
                fixed3 Intensity = Kd * _LightColor0.rgb * NdotL + Ka;

                return fixed4(Intensity, 1);
            }

            ENDCG
        }
    }
}
