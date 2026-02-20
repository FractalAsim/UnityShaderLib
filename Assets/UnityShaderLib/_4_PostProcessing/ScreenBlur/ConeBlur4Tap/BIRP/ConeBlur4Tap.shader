Shader "Blur/ConeBlur (4 Tap)"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img // Macro for minimal vertex shader
			#pragma fragment frag
			
			#include "UnityCG.cginc"

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

			float4 frag (v2f_img i) : SV_Target
			{
				float4 col = tex2Dcone4tapSample(_MainTex, i.uv, _MainTex_TexelSize.xy);
				return col;
			}
			ENDCG
		}
	}
}