Shader "Debug/Test"
{
    Properties
    {
        _f1 ("float",range(-3,10)) = 0
        _f2 ("float",range(-3,10)) = 0
        _f3 ("float",range(-3,10)) = 0

        _v1 ("vector",vector) = (0,0,0,0)
        _v2 ("vector",vector) = (0,0,0,0)
        _v3 ("vector",vector) = (0,0,0,0)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert // Use "vert" function for Vertex Shader
            #pragma fragment frag // Use "frag" function for Fragment Shader

            #include "UnityCG.cginc"
            #include "Assets/UnityShaderLib/Subgraphs/SDF/SDF_IQ.cginc"
            //#include "Assets/UnityShaderLib/Subgraphs/SDF/SDF.cginc"


            // Input to Vertex Shader
            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Input to Fragment Shader
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float _f1;
            float _f2;
            float _f3;

            float4 _v1;
            float4 _v2;
            float4 _v3;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.pos);
                o.uv = v.uv;
                return o;
            }

            // float ChamferRectangle( in vec2 p, in vec2 b, in float chamfer )
            // {
            //     p = abs(p)-b;

            //     p = (p.y>p.x) ? p.yx : p.xy;
            //     p.y += chamfer;
    
            //     const float k = 1.0-sqrt(2.0);
            //     if( p.y<0.0 && p.y+p.x*k<0.0 )
            //         return p.x;
    
            //     if( p.x<p.y )
            //         return (p.x+p.y)*sqrt(0.5);    
    
            //     return length(p);
            // }



            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = float4(1,1,1,1);
                i.uv = i.uv * 2 - 1;

                float sdf; 
                
                // sdf = Circle(i.uv,0.25);
                // sdf = Rectangle(i.uv,float(0.25));
                // sdf = RoundedRectangle(i.uv,float2(0.3,0.3),float1(0.25));
                
                //sdf = SquareLine(i.uv,_v1,_v2,_f1);
                //sdf = Line(i.uv,_v1,_v2);
                //sdf = ChamferBox(i.uv,_v1,_f1);

                //sdf = Rhombus(i.uv,_v1);

                //sdf = IsoscelesTrapezoid(i.uv, _f1, _f2,_v2);
                //sdf = IsoscelesTrapezoid(i.uv, _v1, _v2,_f1,_f2);
                //sdf = sdParallelogram(i.uv, _f1,_f2,_f3);

                // sdf = EquilateralTriangle(i.uv, _f1);
                // sdf = IsoscelesTriangle(i.uv, _v1);
                // sdf = Triangle(i.uv, _v1, _v2, _v3);

                //sdf = sdUnevenCapsule(i.uv, _f1,_f2,_f3);

                // sdf = Pentagon(i.uv, _f1);
                // sdf = Hexagon(i.uv, _f1);
                // sdf = Octogon(i.uv, _f1);

                //sdf = sdHexagram(i.uv, _f1);
                //sdf = Pentagram(i.uv, _f1);
                //sdf = Star(i.uv, 0.7, _f1, _f2);

                //sdf = Pie(i.uv,_f1, _f2);
                //sdf = SlicedCircle(i.uv, _f1, _f2);
                //sdf = Arc(i.uv, _f3, _f1, _f2);
                //sdf = Ring(i.uv, _f3, _f1, _f2);
                //sdf = Horseshoe(i.uv, 2.0, _f1, _f2,_f3);

                // sdf = Vesica(i.uv, _f1, _f2);
                // sdf = OrientedVesica(i.uv, _v1, _v2,_f1);

                //sdf = Moon(i.uv, _f1,_f2,_f3);
                //sdf = RoundedCross(i.uv, _f1);
                //sdf = Egg(i.uv, _f1,_f2,_f3);
                //sdf = Heart(i.uv + float2(0,_f1));

                //sdf = Cross(i.uv,_f1,_f2,_f3);
                //sdf = RoundedX(i.uv,_f1,_f2);
                
                // float2 v0 = 0.8*cos(float2(0.0,2.00) + 0.0 );
                // float2 v1 = 0.8*cos(float2(0.0,1.50) + 1.0 );
                // float2 v2 = 0.8*cos(float2(0.0,3.00) + 2.0 );
                // float2 v3 = 0.8*cos(float2(0.0,2.00) + 4.0 );
                // float2 v4 = 0.8*cos(float2(0.0,1.00) + 5.0 );

                // float2 arr[5];
                // arr[0] = v0;
                // arr[1] = v1;
                // arr[2] = v2;
                // arr[3] = v3;
                // arr[4] = v4;
                // sdf = Polygon(i.uv, arr);

                //sdf = Ellipse(i.uv, _v1);
                //sdf = Ellipse2(i.uv, _v1);

                // sdf = Parabola(i.uv, _f1);
                // sdf = Parabola(i.uv, 0.7+0.6,0.4+0.35);

                // float2 v0 = float2(1.3,0.9)*cos(float2(0.0,5.0) );
                // float2 v1 = float2(1.3,0.9)*cos(float2(3.0,4.0) );
                // float2 v2 = float2(1.3,0.9)*cos(float2(2.0,0.0) );
                // sdf = Bezier(i.uv, v0,v1,v2);

                //sdf = Stairs(i.uv, _v1, 6);
                //sdf = sdTunnel(i.uv, _v1);

                //sdf = BlobbyCross(i.uv, _f1,_f2);
                //sdf = QuadraticCircle(i.uv);

                // float an = smoothstep(-0.2,0.2,sin(0.2));
                // float k = 3.0 + 2.98*sin(1.0);
                // float h = 0.8 + 5.0*an;
                // sdf = Hyberbola(i.uv, _f1,_f2);
                //sdf = CoolS(i.uv);
                //sdf = CircleWave(i.uv, _f1,_f2);

                i.uv *= 2;
                //i.uv.g *= -1;

                //sdf = sdStar(i.uv, _f1,_f2);


                //sdf = RegularPolygon(i.uv, _f1,_f2);

                // float2 v1 = 0.8*cos( float2(0.0,2.00) + 0.0 );
	            // float2 v2 = 0.8*cos( float2(0.0,1.50) + 1.5 );
	            // float2 v3 = 0.8*cos( float2(0.0,3.00) + 4.0 );
	            // float2 v4 = 0.8*cos( float2(1.0,3.00) + 5.0 );

                //sdf = Quad(i.uv, v1, v2, v3, v4 );
                //sdf = Arrow(i.uv, _v1,_v2,_f1,_f2);

                //sdf = SquareStairs(i.uv,_f1,_f2);
                //sdf = RoundSquare(i.uv, _f1,_f2);
                //sdf = sdHyperbolicCross(i.uv, _f1);
                
                col = sdf;
                return sdf;
            }

            ENDCG
        }
    }
}