using UnityEngine;
using Math = System.Math;

public static class NearestPointTo
{
    /// <summary>
    /// Find the closest point on an ellipse centered on the origin.
    /// </summary>
    /// Credit:
    ///     2015-09     Original Paper          by Luc. Maisonobe   https://www.spaceroots.org/documents/distance/distance-to-ellipse.pdf
    ///     2017-08-27  Python Code             by Carl Chatfield   https://wet-robots.ghost.io/simple-method-for-distance-to-ellipse/
    ///     2017-11-10  Trig-Free Optimization  by Adrian Stephens  https://github.com/0xfaded/ellipse_demo/issues/1
    ///     2018-07-12  C# Code for Unity3D     by Johannes Peter   https://gist.github.com/JohannesMP/777bdc8e84df6ddfeaa4f0ddb1c7adb3
    public static Vector2 Ellipse(Vector2 point, double semiMajor, double semiMinor)
    {
        double px = Math.Abs(point.x);
        double py = Math.Abs(point.y);

        double a = semiMajor;
        double b = semiMinor;
        
        double tx = 0.70710678118;
        double ty = 0.70710678118;

        double x, y, ex, ey, rx, ry, qx, qy, r, q, t = 0;

        for (int i = 0; i < 3; ++i)
        {
            x = a * tx;
            y = a * ty;

            ex = (a * a - b * b) * (tx * tx * tx) / a;
            ey = (b * b - a * a) * (ty * ty * ty) / b;

            rx = x - ex;
            ry = y - ey;

            qx = px - ex;
            qy = py - ey;

            r = Math.Sqrt(rx * rx + ry * ry);
            q = Math.Sqrt(qy * qy + qx * qx);

            tx = Math.Min(1, Math.Max(0, (qx * r / q + ex) / a));
            ty = Math.Min(1, Math.Max(0, (qy * r / q + ey) / b));

            t = Math.Sqrt(tx * tx + ty * ty);

            tx /= t;
            ty /= t;
        }

        return new Vector2
        {
            x = (float)(a * (point.x < 0 ? -tx : tx)),
            y = (float)(b * (point.y < 0 ? -ty : ty))
        };
    }
}