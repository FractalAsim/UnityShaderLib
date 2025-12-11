Shader "Common/PhongReflection"
{
    Properties
    {
        _MainTex ("Albedo", 2D) = "white" {}
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(1, 128)) = 32
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _SpecColor;
            float _Shininess;

            float4 _LightColor0;

            struct appdata
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv  : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;

                o.worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.worldNormal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz);

                // Diffuse
                float Kd = tex2D(_MainTex, i.uv).rgb;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = max(0.0, dot(normalize(i.worldNormal), lightDir));
                float3 diffuse = Kd * _LightColor0.rgb * NdotL;

                // Specular
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 reflectSource = reflect(-L, N);
                float specularStrength = max(0, dot(viewDir, reflectSource));
                float3 specular = pow(specularStrength, _Shininess) * _SpecColor.rgb;

                float3 Intensity = diffuse + specular;

                return float4(Intensity, 1);
            }

            ENDCG
        }
    }
}
