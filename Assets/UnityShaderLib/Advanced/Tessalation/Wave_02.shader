Shader "Custom/Wave_02"
{
    Properties
    {
        _MainTex    ("Albedo (RGB)", 2D        ) = "white" {}
        _Color      ("Color",        Color     ) = (1,1,1,1)
        _Glossiness ("Smoothness",   Range(0,1)) = 0.5
        _Metallic   ("Metallic",     Range(0,1)) = 0.0

        _WaveHeight    ("Wave Height",    Float) = 1
        _WaveFrequency ("Wave Frequency", Float) = 1
        _WaveSpeed     ("Wave Speed",     Float) = 1

        _TessFactor  ("Tessellation Factor",       Range(1,   50)) = 10
        _TessMinDist ("Tessellation Min Distance", Range(0.1, 50)) = 10
        _TessMaxDist ("Tessellation Max Distance", Range(0.1, 50)) = 25
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows tessellate:tess vertex:vert
        #pragma target 5.0

        #include "Tessellation.cginc"

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        sampler2D _MainTex;
        float4    _Color;
        float     _Glossiness;
        float     _Metallic;

        float _WaveHeight;
        float _WaveFrequency;
        float _WaveSpeed;

        float _TessFactor;
        float _TessMinDist;
        float _TessMaxDist;

        float4 tess(appdata_full v0, appdata_full v1, appdata_full v2) 
        {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _TessMinDist, _TessMaxDist, _TessFactor);
        }

        void vert(inout appdata_full v)
        {
            float wavePower = _WaveHeight * sin(_Time.x * _WaveSpeed + v.vertex.x * _WaveFrequency);

            v.vertex.y = v.vertex.y + wavePower;
        }

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            float4 color = tex2D (_MainTex, i.uv_MainTex) * _Color;

            o.Albedo     = color.rgb;
            o.Metallic   = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha      = color.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}