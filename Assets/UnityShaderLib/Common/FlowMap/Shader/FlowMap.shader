Shader "Common/FlowMap"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Tex", 2D) = "white" {}
        [NoScaleOffset] _FlowTex ("Flow Tex", 2D) = "white" {}
        [NoScaleOffset] _FlowMap ("Flow Map", 2D) = "white" {}
        _FlowSpeed ("Flow Speed", Vector) = (0.25,0.25,0,0)
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
            sampler2D _FlowMap;
            float4 _FlowSpeed;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);

                o.uv.xy = v.uv;
                o.uv.zw = v.uv;

                return o;
            }

            struct FlowMapOut
            {
                float2 UV_1st_Phase;
                float2 UV_2nd_Phase;
                float _Lerp;
                float Mask;
            };

            FlowMapOut UVFlowMap(sampler2D FlowMap, float2 FlowSpeed, float FlowTime, float2 UV)
            {
                FlowMapOut o;

                fixed4 flow = tex2D(FlowMap, UV);
                fixed2 flowremap = flow.rg * 2 - 1;
                flowremap *= -1;
                flowremap *= FlowSpeed;

                fixed2 fracTime = frac(FlowTime);

                o.UV_1st_Phase = fracTime * flowremap + UV;
                o.UV_2nd_Phase = frac(FlowTime + 0.5) * flowremap + UV;
                o._Lerp = abs(fracTime * 2 - 1); // ping pong
                o.Mask = 1 - step(flow.b,0);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                FlowMapOut o = UVFlowMap(_FlowMap,_FlowSpeed,_Time.y,i.uv);

                fixed4 flow1 = tex2D(_FlowTex, o.UV_1st_Phase);
                fixed4 flow2 = tex2D(_FlowTex, o.UV_2nd_Phase);
                fixed4 flowLoop = lerp(flow1,flow2,o._Lerp);
                fixed4 col = lerp(tex2D(_MainTex, i.uv),flowLoop,o.Mask);

                return col;
            }

            ENDCG
        }
    }
}
