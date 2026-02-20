Shader "Basic/StencilMasking"
{
    Properties
    {
        [IntRange] _StencilRef ("Draw Stencil Value", Range(0,255)) = 0
    }
    SubShader
    {
        Tags { "Queue" = "Geometry-1" }
                
        ZWrite Off
        ColorMask 0

        Pass
        {
            Stencil
            {
                Ref [_StencilRef]
                Comp Always
                Pass Replace
            }
        }
    }
}