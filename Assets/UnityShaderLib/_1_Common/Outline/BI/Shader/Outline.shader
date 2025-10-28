Shader "Common/Outline"
{
    Properties
    {
        _Color("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex("Texture", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (1,0,0,1)
        _OutlineWidth("Outlines width", Range(0.0, 2.0)) = 0.15
        //_Angle("Switch shader on angle", Range(0.0, 180.0)) = 89
    }
    SubShader
    {
        Pass
        {
            Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
		    Cull Back
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float4 normal : NORMAL;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float4 _OutlineColor;
            float _OutlineWidth;
            //float _Angle;

            v2f vert (appdata v)
            {
                // float3 scaleDir = normalize(v.pos.xyz);
                // if (degrees(acos(dot(scaleDir.xyz, v.normal.xyz))) > _Angle) 
                // {
                //     v.pos.xyz += normalize(v.normal.xyz) * _OutlineWidth;
                // }
                // else 
                // {
                //     v.pos.xyz += scaleDir * _OutlineWidth;
                // }

                v.pos.xyz += normalize(v.pos.xyz) * _OutlineWidth;

                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }

        //Surface shader
		Tags{ "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert noshadow

		struct Input 
        {
			float2 uv_MainTex;
			float4 color : COLOR;
		};

        sampler2D _MainTex;
        float4 _Color;

		void surf(Input IN, inout SurfaceOutput o) 
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
    }
}
