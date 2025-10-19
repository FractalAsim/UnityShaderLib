Shader "MethodsInUnity/ExampleGrayscale"
{
  SubShader
  {
      Cull Off ZWrite Off ZTest Always

      Pass
      {

        HLSLPROGRAM
            
            #include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
                
            #pragma vertex VertDefault
            #pragma fragment Frag

            Texture2D _MainTex;
            SamplerState sampler_MainTex;
            float _Blend;

            float4 Frag(VaryingsDefault i) : SV_Target
            {
                float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

                float luminance = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750));
                color.rgb = lerp(color.rgb, luminance.xxx, _Blend.xxx);

                return color;
            }

        ENDHLSL
      }
  }
}