Shader "SurfaceShaderTemplate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

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

        CGPROGRAM

        //#pragma surface surf Lambert 
        //#pragma surface surf BlinnPhong
        #pragma surface surf Standard // Standard StandardSpecular 
        //#pragma surface surf Standard noforwardadd noshadow noambient halfasview novertexlights nolightmap nodynlightmap nofog noshadowmask 
        //#pragma addshadow fullforwardshadows 
 

        /*
        #pragma surface surf Custom
        half4 LightingCustom (SurfaceOutput s, half3 viewDir, UnityGI gi)
        {
            return half4(1,1,1,1);
        }
        void LightingCustom_GI (SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
        {

        }
        */

        struct Input 
        {
            float2 uv_MainTex; // uv_[name]
            float4 color : COLOR;
            float3 customColor; // no uv_ infront

            float3 worldPos;
            float3 worldNormal;
            float3 viewDir;
            float4 screenPos;
        };

        //#pragma tessellate:tess tessphong:_Phong
        float _Phong;
        float4 tess()
        {
            // float minDist = 10.0;
            // float maxDist = 25.0;
            // return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
            // return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);

            return 0;
        }

        //#pragma vertex:vert
        void vert (inout appdata_full v) 
        {
            
        }

        //#pragma finalcolor:mycolor
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
        {
            //color *= _ColorTint;
        }

        void surf (Input IN, inout SurfaceOutputStandard o) // SurfaceOutput, SurfaceOutputStandard, SurfaceOutputStandardSpecular
        {
            o.Albedo = 1;
        }

        
        /*
        struct SurfaceOutput
        {
            fixed3 Albedo;  // diffuse color
            fixed3 Normal;  // tangent space normal, if written
            fixed3 Emission;
            half Specular;  // specular power in 0..1 range
            fixed Gloss;    // specular intensity
            fixed Alpha;    // alpha for transparencies
        };
        struct SurfaceOutputStandard
        {
            fixed3 Albedo;      // base (diffuse or specular) color
            fixed3 Normal;      // tangent space normal, if written
            half3 Emission;
            half Metallic;      // 0=non-metal, 1=metal
            half Smoothness;    // 0=rough, 1=smooth
            half Occlusion;     // occlusion (default 1)
            fixed Alpha;        // alpha for transparencies
        };
        struct SurfaceOutputStandardSpecular
        {
            fixed3 Albedo;      // diffuse color
            fixed3 Specular;    // specular color
            fixed3 Normal;      // tangent space normal, if written
            half3 Emission;
            half Smoothness;    // 0=rough, 1=smooth
            half Occlusion;     // occlusion (default 1)
            fixed Alpha;        // alpha for transparencies
        };
        */

        ENDCG
    }
}
