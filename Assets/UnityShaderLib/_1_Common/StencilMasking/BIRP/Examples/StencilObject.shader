Shader "Basic/StencilObject"
{
    Properties
    {
		_Color ("Main Color", color) = (1,1,1,1)

        [IntRange] _StencilRef ("Stencil Value", Range(0,255)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry-1" }

        Color [_Color]

        Pass
        {
            Stencil
            {
                Ref [_StencilRef]
                Comp Equal
                Pass Keep // Write Stencil Value to buffer if stencil test and depth test passess
            }
        }
    }
}