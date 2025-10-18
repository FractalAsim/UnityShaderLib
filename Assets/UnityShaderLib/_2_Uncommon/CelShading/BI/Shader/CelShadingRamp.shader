// Celshading is simply the combination of ColorBanding/Ramp Shader and Outline shader
// Using RampTexture version

Shader "Uncommon/CelShadingRamp"
{
    Properties
    {
        _Ramp ("Ramp Texture", 2D) = "white" {}
        _RampSelect ("Ramp Select (Row)", Float) = 0
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

            sampler2D _Ramp;
            float _RampSelect;

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
                float2 uvSample = float2(Remap1101(NdotL),_RampSelect);
                fixed4 col = tex2D(_Ramp, uvSample);
                
                return col;
            }

            ENDCG
        }
    }
}
