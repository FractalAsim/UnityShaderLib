Shader "PostProcessing/ScreenTransition"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_TransitionTex("Transition Texture", 2D) = "white" {}
		_Transition("Transition", Range(0, 1)) = 0
		_TransitionColor("Transition Color", Color) = (1,1,1,1)
	}

	SubShader
	{
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
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;

			sampler2D _TransitionTex;
			float _Transition;
			fixed4 _TransitionColor;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
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