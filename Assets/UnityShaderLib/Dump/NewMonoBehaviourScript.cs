//// World Normal
//using Unity.Mathematics;

//o.normal.xyz = normalize(UnityObjectToWorldNormal(v.normal)); // vert

//// World Position
//float3 wpos : TEXCOORD3;
//o.wpos = mul(unity_ObjectToWorld, v.vertex).xyz;

//// ------- To Modify In World Space:
//v.vertex += mul(unity_WorldToObject, offx, offy, offz, 0);

//// Distance to camera
//float toCamera = length(_WorldSpaceCameraPos - i.worldPos.xyz) - _ProjectionParams.y;

//// Screen Position
//float4 screenPos : TEXCOORD1;                   // v2f (TEXCOORD can be 0,1,2, etc - the obly rule is to avoid duplication)
//o.screenPos = ComputeScreenPos(o.pos);          // vert
//float2 screenUV = i.screenPos.xy / i.screenPos.w;     // frag (Returns in 01 range (if on screen))

//// Reflect:
//float dotprod = max(0, dot(worldNormal, i.viewDir.xyz));
//float3 reflected = normalize(i.viewDir.xyz - 2 * (dotprod) * worldNormal);