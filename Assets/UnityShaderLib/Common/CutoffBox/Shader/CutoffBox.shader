// Common Shader that cuts off the fragment out side of a box range

Shader "Common/CutoffBox"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        [Toggle] _Enable("Enable", float) = 0
        _MinX("Min X", float) = 0
        _MaxX("Max X", float) = 1
        _MinY("Min Y", float) = 0
        _MaxY("Max Y", float) = 1
        _MinZ("Min Z", float) = 0
        _MaxZ("Max Z", float) = 1
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
            fixed _MinX;
            fixed _MaxX;
            fixed _MinY;
            fixed _MaxY;
            fixed _MinZ;
            fixed _MaxZ;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float x = (i.worldPos.x - _MinX) * (_MaxX - i.worldPos.x);
                float y = (i.worldPos.y - _MinY) * (_MaxY - i.worldPos.y);
                float z = (i.worldPos.z - _MinZ) * (_MaxZ - i.worldPos.z);
                float xyz = min(min(x, y), z);

                clip(xyz * _Enable);

                return _Color;
            }

            ENDCG
        }
    }
}
