// Legacy Fixed Function Syntax

Shader "Basic/PlainColor2"
{
	Properties
	{
		_Color ("Main Color", color) = (1,1,1,1)
	}
	SubShader
	{
		Color [_Color]
		Pass
		{
			
		}
	}
}
