Shader "Blur/Box Blur (9 Tap)"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {} // Input is actually ScreenBuffer
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

			float4 box9tapSample(sampler2D tex, float2 uv, float2 scale)
			{
				float4 c = float4(0,0,0,0);

				c += tex2D(tex, uv + float2(-scale.x, scale.y));
				c += tex2D(tex, uv + float2(0, scale.y));
				c += tex2D(tex, uv + float2(scale.x, scale.y));
				c += tex2D(tex, uv + float2(-scale.x, 0));

				c += tex2D(tex, uv + float2(0, 0));

				c += tex2D(tex, uv + float2(scale.x, 0));
				c += tex2D(tex, uv + float2(-scale.x, -scale.y));
				c += tex2D(tex, uv + float2(0, -scale.y));
				c += tex2D(tex, uv + float2(scale.x, -scale.y));

				return c / 9;
			}

			float4 frag (v2f_img i) : SV_Target
			{
				float4 col = box9tapSample(_MainTex, i.uv, _MainTex_TexelSize.xy);
				return col;
			}
			ENDCG
		}
	}
}
