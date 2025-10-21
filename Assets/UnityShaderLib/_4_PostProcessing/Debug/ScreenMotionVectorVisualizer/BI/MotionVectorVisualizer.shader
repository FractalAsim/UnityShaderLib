Shader "Debug/WorldNormalsVisualizer"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            
            #include "UnityCG.cginc"

            struct appdata // Input To Vertex
            {
                float4 pos : POSITION;

                float2 uv : TEXCOORD0;
            };

            struct v2f // Input To Fragment
            {
                float4 pos : SV_POSITION;

                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.uv = v.uv;

                return o;
            }

            // Unity Injects this texture rendered from camera or gbuffer
            sampler2D _CameraMotionVectorsTexture;

            fixed4 frag(v2f i) : SV_Target
            {
                // Returns in [-1,1]
                float2 deltas = tex2D(_CameraMotionVectorsTexture, i.uv).rg;

                // Remap from [-1,1] to [0,1]
                float4 col = float4(deltas,0, 1);

                return col;
            }
            ENDCG
        }
    }
}