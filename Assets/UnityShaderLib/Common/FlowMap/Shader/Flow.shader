Shader "Common/Flow"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}
        _FlowTex ("Flow Tex", 2D) = "white" {}
        _UVTex ("UV Tex", 2D) = "white" {}

        _Speed ("Band Count", Vector) = (0,0,0,0)
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

            #include "UnityCG.cginc"
            //#include "Assets/UnityShaderLib/Subgraphs/Common/Common.cginc"

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
                float4 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler2D _FlowTex;

            sampler2D _UVTex;

            float4 _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.uv.xy = v.uv;
                o.uv.zw = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 uv = tex2D(_UVTex, i.uv);
                uv.rg += frac(_Time.y * _Speed.xy);

                fixed4 flow = tex2D(_FlowTex, uv.rg);


                fixed4 col = tex2D(_MainTex, i.uv);

                return flow;
            }

            ENDCG
        }
    }
}
