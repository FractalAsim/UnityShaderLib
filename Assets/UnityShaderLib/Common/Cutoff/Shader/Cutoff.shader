Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)

        _XCutoff("X Cutoff", Range(0,1)) = 1 //Interpolate 0 = full cutoff 1 = no cutoff
        _YCutoff("Y Cutoff", Range(0,1)) = 1 //Interpolate
        _ZCutoff("Z Cutoff", Range(0,1)) = 1 //Interpolate
        _MinCutoff("Min Cutoff", Float) = 0 //The X/Y/Z position in worldspace to represent 0% cutoff
        _MaxCutoff("Max Cutoff", Float) = 10 //The X/Y/Z position in worldspace to represent 100% cutoff
        [Toggle] _Reverse("Reverse",Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
