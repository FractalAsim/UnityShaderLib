Shader "Common/ColorRim"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimIntensity ("Rim Intensity", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        
        CGPROGRAM

        #pragma surface surf Standard vertex:vert // Use Unity's surface shader as a base

        #include "Assets/UnityShaderLib/Subgraphs_Inc/Common/Common.cginc"

        struct Input
        {
            float3 worldNormal;
            float3 viewDir;
        };

        fixed4 _RimColor;
        fixed _RimIntensity;

        void vert (inout appdata_full v, out Input o)
        {
            //v.vertex.xyz += v.normal * _RimIntensity;
            o.worldNormal  = UnityObjectToWorldNormal(v.normal);

            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = float3(0.5,0.5,0.5);
            o.Emission = Fresnel(IN.worldNormal,IN.viewDir,_RimIntensity) * _RimColor.rgb;
        }
        ENDCG
    }
}
