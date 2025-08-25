// Celshading is simply the combination of ColorBanding/Ramp Shader and Outline shader

Shader "Common/CelShading"
{
    Properties
    {
        _BandCount ("Band Count", Float) = 5
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth("Outlines width", Range(0.0, 2.0)) = 0.02
    }
    SubShader
    {
       Pass // Outline
        {
            Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
		    Cull Back
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float4 _OutlineColor;
            float _OutlineWidth;

            v2f vert (appdata v)
            {
                v.pos.xyz += normalize(v.pos.xyz) * _OutlineWidth;

                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }

        Pass // Main Opaque
        {
            Tags { "RenderType"="Opaque" }
            LOD 100

            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"
            #include "Assets/UnityShaderLib/Subgraphs/Common/Common.cginc"

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float4 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 normal : NORMAL;
            };

            float4 _Color;
            float _BandCount;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float NdotL = MainLightOnSurface(i.normal);
                float band = max(_BandCount,1);
                float color = ceil(Remap1101(NdotL) * band) / band;
                
                return float4(color.xxx,1);
            }

            ENDCG
        }
    }
}
