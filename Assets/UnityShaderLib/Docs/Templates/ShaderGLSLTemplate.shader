Shader "ShaderGLSLTemplate" 
{
	Properties
	{

	}
	SubShader
	{	
		Pass
		{

			GLSLPROGRAM // Begin GLSL
			
			#include "UnityCG.glslinc"

			// Time values from Unity
			// uniform vec4 _Time;
			// uniform vec4 _SinTime;
			// uniform vec4 _CosTime;

			// x = 1 or -1 (-1 if projection is flipped)
			// y = near plane
			// z = far plane
			// w = 1/far plane
			//uniform vec4 _ProjectionParams;

			// x = width
			// y = height
			// z = 1 + 1.0/width
			// w = 1 + 1.0/height
			//uniform vec4 _ScreenParams;

			//uniform vec3 _WorldSpaceCameraPos;
			//uniform vec4 _WorldSpaceLightPos0;

			// xyz = pos, w = 1/range
			//uniform vec4 _LightPositionRange; 

			#ifdef GL_ES
			precision mediump float; // Use medium precision float
			#endif

			#ifdef VERTEX // Begin vertex program/shader

			out vec4 texcoord; // Store a value to send to Frag

			void main()
			{
				vec3 worldLightDir = WorldSpaceLightDir(gl_Vertex);

				//TRANSFORM_TEX_ST(tex, name##_ST)

				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; // Draws the Vertex at the correct position in world
			}

			#endif // Ends vertex program/shader

			#ifdef FRAGMENT // Begin fragment program/shader

			in vec4 texcoord; // Use a store value from Vert

			void main()
			{
				float lum = Luminance(vec3(1.0,0.0,0.0));

				gl_FragColor = vec4(1.0,0.0,0.0,1.0);
			}

			#endif // Ends fragment program/shader

			ENDGLSL // End GLSL
		}
	}
}