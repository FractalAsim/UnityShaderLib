Shader "Basic/ColorLerp"
{
    Properties
    {
        _Color1 ("Color1", Color) = (1,0,0,1)
        _Color2 ("Color2", Color) = (0,1,0,1)
        _Blend ("Blend", Range(0, 1)) = 0
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

            float4 _Color1;
            float4 _Color2;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return lerp(_Color1,_Color2,_Blend);
            }

            ENDCG
        }
    }
}