// Technique Texture Channel Select Technique : Allow user to Select Channel of a texture using Dot Product

Shader "Common/TextureChannelSelect"
{
    Properties
    {
       _MainTex ("Texture", 2D) = "white" {}
       [ChannelSelect] _ChannelSelect ("ChannelSelect", Vector) = (1,0,0,0)
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

            #include "UnityCG.cginc" // Required to use certian unity shader functions e.g TRANSFORM_TEX

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST; // required for TRANSFORM_TEX

            float4 _ChannelSelect;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = dot(_ChannelSelect,tex2D(_MainTex, i.uv));

                return col;
            }

            ENDCG
        }
    }
}