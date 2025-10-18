// Common Shader that cuts off the fragment in horizontal segments. Like being slice in parts

Shader "Common/HorizontalSlice"
{
    Properties
    {
        _Slice("Slice", Range(0,1)) = 0
        _SliceAmt("Slice Amt", Float) = 2
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
                float4 pos2 : TEXCOORD0;
            };

            // For HorizontalSlice
            fixed _Slice;
            fixed _SliceAmt;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.pos2 = v.pos;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float start = (i.pos2.y + 0.4999) * _SliceAmt;
                float fractional = frac(start);
                float clipValue = step(fractional, _Slice) - 0.01;

                clip(clipValue);

                return float4(fractional.xxx,1);
            }

            ENDCG
        }
    }
}
