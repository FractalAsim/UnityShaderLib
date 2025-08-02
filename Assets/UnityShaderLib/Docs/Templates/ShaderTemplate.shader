Shader "ShaderTemplate"
{
    Properties
    {
        _Float ("Float", Float) = 1
        _Int ("Int", Int) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _Vector ("Vector", Vector) = (1,1,1,1)
        _Range ("Range", Range(0, 10)) = 1
        _Texture ("Texture", 2D) = "white" {} // "white" , "black" , "gray" , "bump"
    }
    SubShader
    {
        // Render Options
        // "Queue" = "[name]+[offset]"
        // “RenderType” = "[name]"
        Tags { "RenderType"="Opaque" }

        // Get the frame buffer at this point into the named texture to be used in the next pass and other subshader?
        // Need to declare the named texture in the pass to use
        GrabPass {"FrameBufferTex"}


        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma geometry geo // compile function name as DX10 geometry shader. Having this option automatically turns on #pragma target 4.0, described below.
            #pragma fragment frag
            //#pragma hull hs // compile function name as DX11 hull shader. Having this option automatically turns on #pragma target 5.0, described below.
            //#pragma domain ds // compile function name as DX11 domain shader. Having this option automatically turns on #pragma target 5.0, described below.

            // Render Mode Options for the current pass
            // Cull Back | Front | Off
            // ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
            // ZWrite On | Off
            //
            // Set Blending for the current pass
            // https://docs.unity3d.com/Manual/SL-Blend.html
            // Blend Off
            // Blend Source Dest // One , Zero , SrcColor , SrcAlpha,DstColor,DstAlpha,OneMinusSrcColor,OneMinusSrcAlpha,OneMinusDstColor,OneMinusDstAlpha
            // Blend rendertarget Source Dest // 1-7 

            // Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
            // Blend One OneMinusSrcAlpha // Premultiplied transparency
            // Blend One One // Additive
            // Blend OneMinusDstColor One // Soft Additive
            // Blend DstColor Zero // Multiplicative
            // Blend DstColor SrcColor // 2x Multiplicative

            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2g
            {
                float4 pos : POSITION;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            [maxvertexcount(3)]
            void geo(triangle v2g input[3], inout TriangleStream<g2f> triStream)
            {
                float3 offset = float3(0, 0.1, 0); // move triangle up

                for (int i = 0; i < 3; i++)
                {
                    g2f o;
                    o.pos = input[i].pos;
                    o.pos.xyz += offset;
                    triStream.Append(o);
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }
}
