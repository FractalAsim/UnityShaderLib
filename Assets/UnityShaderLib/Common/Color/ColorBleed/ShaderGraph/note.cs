//using Unity.Mathematics;

//finalColor = baseColor + (bleedColor * bleedStrength * occlusion);


//fixed4 frag(v2f i) : SV_Target {
//    float3 baseColor = tex2D(_MainTex, i.uv).rgb;

//// Sample from a second texture that stores nearby surface color (e.g., from screen space)
//float2 bleedUV = i.uv + _BleedOffset; // Offset to simulate nearby pixel
//float3 bleedColor = tex2D(_BleedTex, bleedUV).rgb;

//float occlusion = tex2D(_OcclusionTex, i.uv).r; // Optional AO mask

//float bleedStrength = _BleedStrength; // 0~1

//float3 finalColor = baseColor + bleedColor * bleedStrength * (1 - occlusion);
//return fixed4(finalColor, 1.0);
//}



//using Unity.Mathematics;

//float3 mix = col.gbr + col.brg;

//col.rgb += mix * mix * bleedStrength;

//Colour from each channel (Red, Green, Blue) "leaks" or "bleeds" into other channels. 