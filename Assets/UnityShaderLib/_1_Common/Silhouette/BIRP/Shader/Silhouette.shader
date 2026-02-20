// Common two pass shader to draw Silhouette when object is occluded

Shader "Common/Silhouette"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
        _SilhouetteColor("Outline Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        // Draw when occluded (Silhouette solid color) 
		Pass
        {
            Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent"}

            ZWrite Off
		    ZTest Always //ZTest Always
            Cull Back

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
            };

            sampler2D _MainTex;
            float4 _SilhouetteColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _SilhouetteColor;
            }

            ENDCG
        }

        // Draw Normal
        Pass
        {
            Tags { "RenderType"="Opaque" }

            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"

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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                // Apply Tilling and Offset to uvs using variable "[Name]_ST". Must declare. E.g float4 _MainTex_ST
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Use UV to sample texture
                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }

            ENDCG
        }
    }
}
