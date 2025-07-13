// Common Shader that cuts off the fragment out side of a box range

Shader "Common/CutoffBox"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        [Toggle] _Enable("Enable", float) = 0
        _Min("Min", Vector) = (0,0,0,0)
        _Max("Min", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Off 

            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Input to Vertex Shader
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            float4 _Color;

            // For Cutoff
            fixed _Enable;
            float3 _Min;
            float3 _Max;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // If the global position for the axis (x,y,z) is less than min, or more than max, the result wil be negative
                float3 subPos = (i.worldPos - _Min) * (_Max - i.worldPos);

                // If any axis is negative, return negative, otherwise positive
                float clipValue = min(min(subPos.x, subPos.y), subPos.z);

                clip(clipValue * _Enable);

                return _Color;
            }

            ENDCG
        }
    }
}
