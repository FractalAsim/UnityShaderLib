Shader "Blur/ConeBlur (4 Tap)"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;

			float4 tex2Dcone4tapSample(sampler2D tex, float2 uv, float2 scale)
			{
				float4 c = float4(0,0,0,0);
				c += tex2D(tex, uv + float2(-scale.x, -scale.y));
				c += tex2D(tex, uv + float2(-scale.x, scale.y));
				c += tex2D(tex, uv + float2(scale.x, scale.y));
				c += tex2D(tex, uv + float2(scale.x, -scale.y));
				return c * 0.25;
			}

			float4 frag (v2f i) : SV_Target
			{
				float4 col = tex2Dcone4tapSample(_MainTex, i.uv, _MainTex_TexelSize.xy);
				return col;
			}
			ENDCG
		}
	}
}