// Common Shader that cuts off the fragment on one side of a plane

Shader "Common/CutoffPlane"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

		[Toggle] _Enable("Enable", float) = 0
        _PNormal("Plane Normal", Vector) = (0,0,0,0)
        _PCenter("Plane Center", Vector) = (0,0,0,0)
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
			fixed4 _PNormal;
			fixed4 _PCenter;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float clipValue = dot(_PNormal, i.worldPos - _PCenter);

                clip(clipValue * _Enable);

                return _Color;
            }

            ENDCG
        }
    }
}
