// Common Shader that cuts off the fragment when it's position in a selected axis is above a certain value Interpolated though a range.
// Addition Reverse var to go from max->min instead

Shader "Info/PropertyDrawers"
{
    Properties
    {
        [KeywordEnum(X, Y, Z)] _Axis("Cutoff Axis", Float) = 0 // 3 Enum Selection (shader variants)
        [Toggle] _Reverse("Reverse",Integer) = 0 // Boolean selection (shader variant)

        _Cutoff("Cutoff", Range(0,1)) = 1 // Interpolate
        _RangeMin("Min Cutoff", Float) = 0 // The Min X/Y/Z position value in worldspace to when @ 0% cutoff
        _RangeMax("Max Cutoff", Float) = 10 // The Max X/Y/Z position value in worldspace to when @ 100% cutoff
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

            #pragma shader_feature_local _AXIS_X _AXIS_Y _AXIS_Z // Compile shader variant only for this file for the shaders being used in material
            #pragma shader_feature_local _REVERSE_ON

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

            // For CutoffXYZ
            fixed _Cutoff;
            fixed _RangeMin;
            fixed _RangeMax;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float clipValue = 0;
                fixed pos;

                if(_AXIS_X)
                {
                    pos = i.worldPos.x;
                }
                else if(_AXIS_Y)
                {
                    pos = i.worldPos.y;
                }
                else if(_AXIS_Z)
                {
                    pos = i.worldPos.z;
                }

                if(_REVERSE_ON)
                {
                    clipValue = lerp(_RangeMin,_RangeMax,_Cutoff) - (_RangeMax - pos);
                }
                else
                {
                    clipValue = lerp(_RangeMin,_RangeMax,_Cutoff) - (pos - _RangeMin);
                }

                clip(clipValue);

                return _Color;
            }

            ENDCG
        }
    }
}
