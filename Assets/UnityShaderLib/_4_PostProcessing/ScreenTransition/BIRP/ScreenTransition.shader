Shader "PostProcessing/ScreenTransition"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {} // Input is actually ScreenBuffer

		_TransitionTex("Transition Texture", 2D) = "white" {}
		_Transition("Transition", Range(0, 1)) = 0
		_TransitionColor("Transition Color", Color) = (1,1,1,1)
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

			sampler2D _TransitionTex;
			float _Transition;
			fixed4 _TransitionColor;

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				fixed4 transit = tex2D(_TransitionTex, i.uv);

				//uses texture's blue as cutoff
				if (transit.b < _Transition)
				{
					return _TransitionColor;
				}

				return col;
			}
			ENDCG
		}
	}
}
