Shader "Common/ColorBandingRamp"
{
    Properties
    {
        _Ramp ("Ramp Texture", 2D) = "white" {}
       _RampSelect ("Ramp Select (Row)", Float) = 0
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
