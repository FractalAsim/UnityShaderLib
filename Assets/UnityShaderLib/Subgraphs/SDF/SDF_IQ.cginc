// sdf functions from https://iquilezles.org/articles/distfunctions2d/
// sdf here are optimized for their specific shape
// functions & params are Renamed for more verbose
// functions are categorized

#ifndef SDF_IQ
#define SDF_IQ

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------
inline float ndot(float2 a, float2 b)
{
    return a.x * b.x - a.y * b.y;
}

inline float dot2(float2 v)
{
    return dot(v, v);
}

// -----------------------------------------------------------------------------
// Lines
// -----------------------------------------------------------------------------
inline float SquareLine(float2 pos, float2 startOffset, float2 endOffset, float thickness)
{
    float l = length(endOffset - startOffset);
    float2 d = (endOffset - startOffset) / l;
    float2 q = (pos - (startOffset + endOffset) * 0.5);
    q = mul(float2x2(d.x, -d.y, d.y, d.x), q);
    q = abs(q) - float2(l, thickness) * 0.5;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

inline float Line(float2 pos, float2 startOffset, float2 endOffset)
{
    float2 pa = pos - startOffset;
    float2 ba = endOffset - startOffset;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

// -----------------------------------------------------------------------------
// Curves
// -----------------------------------------------------------------------------
inline float Parabola(float2 pos, float k)
{
    pos.x = abs(pos.x);
    
    float ik = 1.0 / k;
    float p = ik * (pos.y - 0.5 * ik) / 3.0;
    float q = 0.25 * ik * ik * pos.x;
    
    float h = q * q - p * p * p;
    float r = sqrt(abs(h));
    
    float x = (h > 0.0) ?
        pow(q + r, 1.0 / 3.0) - pow(abs(q - r), 1.0 / 3.0) * sign(r - q) :
        2.0 * cos(atan2(r, q) / 3.0) * sqrt(p);
    
    return length(pos - float2(x, k * x * x)) * sign(pos.x - x);
}

inline float Parabola(float2 pos, float thickness, float height)
{
    pos.x = abs(pos.x);
    
    float ik = thickness * thickness / height;
    float p = ik * (height - pos.y - 0.5 * ik) / 3.0;
    float q = pos.x * ik * ik * 0.25;
    float h = q * q - p * p * p;
    float r = sqrt(abs(h));
    
    float x = (h > 0.0) ?
        pow(q + r, 1.0 / 3.0) - pow(abs(q - r), 1.0 / 3.0) * sign(r - q) :
        2.0 * cos(atan(r / q) / 3.0) * sqrt(p);
    
    x = min(x, thickness);
    
    return length(pos - float2(x, height - x * x / ik)) *
           sign(ik * (pos.y - height) + pos.x * pos.x);
}
inline float Bezier(float2 pos, float2 A, float2 B, float2 C)
{
    float2 a = B - A;
    float2 b = A - 2.0 * B + C;
    float2 c = a * 2.0;
    float2 d = A - pos;
    
    // cubic to be solved (kx*=3 and ky*=3)
    float kk = 1.0 / dot(b, b);
    float kx = kk * dot(a, b);
    float ky = kk * (2.0 * dot(a, a) + dot(d, b)) / 3.0;
    float kz = kk * dot(d, a);
    
    float res = 0.0;
    
    float p = ky - kx * kx;
    float p3 = p * p * p;
    float q = kx * (2.0 * kx * kx - 3.0 * ky) + kz;
    float h = q * q + 4.0 * p3;
    
    if (h >= 0.0)
    {
        h = sqrt(h);
        float2 x = (float2(h, -h) - q) / 2.0;
        float2 uv = sign(x) * pow(abs(x), float(1.0 / 3.0));
        float t = clamp(uv.x + uv.y - kx, 0.0, 1.0);
        res = dot2(d + (c + b * t) * t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos(q / (p * z * 2.0)) / 3.0;
        float m = cos(v);
        float n = sin(v) * 1.732050808;
        float3 t = clamp(float3(m + m, -n - m, n - m) * z - kx, 0.0, 1.0);
        res = min(dot2(d + (c + b * t.x) * t.x),
                  dot2(d + (c + b * t.y) * t.y));
    }
    return sqrt(res);
}
float Hyberbola(float2 pos, float k, float he) // k in (0,inf)
{
    // symmetry and rotation
    pos = abs(pos);
    pos = float2(pos.x - pos.y, pos.x + pos.y) / sqrt(2.0);
    
    // distance to y(x)=k/x by finding t in such that t⁴ - xt³ + kyt - k² = 0
    float x2 = pos.x * pos.x / 16.0;
    float y2 = pos.y * pos.y / 16.0;
    float r = k * (4.0 * k - pos.x * pos.y) / 12.0;
    float q = (x2 - y2) * k * k;
    float h = q * q + r * r * r;
    float u;
    
    if (h < 0.0)
    {
        float m = sqrt(-r);
        u = m * cos(acos(q / (r * m)) / 3.0);
    }
    else
    {
        float m = pow(sqrt(h) - q, 1.0 / 3.0);
        u = (m - r / m) / 2.0;
    }
    
    float w = sqrt(u + x2);
    float b = k * pos.y - x2 * pos.x * 2.0;
    float t = pos.x / 4.0 - w + sqrt(2.0 * x2 - u + b / w / 4.0);
    
    // comment this line out for an infinite hyperbola
    t = max(t, sqrt(he * he * 0.5 + k) - he / sqrt(2.0));
    
    // distance from t
    float d = length(pos - float2(t, k / t));
    
    // sign
    return pos.x * pos.y < k ? d : -d;
}

// -----------------------------------------------------------------------------
// Circles
// -----------------------------------------------------------------------------
inline float Circle(float2 pos, float radius)
{
    return length(pos) - radius;
}
inline float Ellipse(float2 pos, float2 size)
{
    // Analytical distance to an 2D ellipse, which is more
    // complicated than it seems. It ends up being a quartic
    // equation, which can be resolved through a cubic, then
    // a quadratic. Some steps through the derivation can be
    // found in this article: 
    //
    // https://iquilezles.org/articles/ellipsedist
    //
    //
    // Ellipse distances related shaders:
    //
    // Analytical     : https://www.shadertoy.com/view/4sS3zz
    // Newton Trig    : https://www.shadertoy.com/view/4lsXDN
    // Newton No-Trig : https://www.shadertoy.com/view/tttfzr 
    // ?????????????? : https://www.shadertoy.com/view/tt3yz7
    
    pos = abs(pos);
    if (pos.x > pos.y)
    {
        float tmpx = pos.x;
        pos.x = pos.y;
        pos.y = tmpx;
        float tmpa = size.x;
        size.x = size.y;
        size.y = tmpa;
    }

    float l = size.y * size.y - size.x * size.x;
    float m = size.x * pos.x / l;
    float m2 = m * m;
    float n = size.y * pos.y / l;
    float n2 = n * n;
    float c = (m2 + n2 - 1.0) / 3.0;
    float c3 = c * c * c;
    float q = c3 + m2 * n2 * 2.0;
    float d = c3 + m2 * n2;
    float g = m + m * n2;
    float co;
    if (d < 0.0)
    {
        float h = acos(q / c3) / 3.0;
        float s = cos(h);
        float t = sin(h) * sqrt(3.0);
        float rx = sqrt(-c * (s + t + 2.0) + m2);
        float ry = sqrt(-c * (s - t + 2.0) + m2);
        co = (ry + sign(l) * rx + abs(g) / (rx * ry) - m) / 2.0;
    }
    else
    {
        float h = 2.0 * m * n * sqrt(d);
        float s = sign(q + h) * pow(abs(q + h), 1.0 / 3.0);
        float u = sign(q - h) * pow(abs(q - h), 1.0 / 3.0);
        float rx = -s - u - c * 4.0 + 2.0 * m2;
        float ry = (s - u) * sqrt(3.0);
        float rm = sqrt(rx * rx + ry * ry);
        co = (ry / sqrt(rm - rx) + 2.0 * g / rm - m) / 2.0;
    }
    float2 r = size * float2(co, sqrt(1.0 - co * co));
    return length(r - pos) * sign(pos.y - r.y);
}
float Ellipse2(float2 pos, float2 size)
{
    // Using Newtown's root solver to compute the distance to
    // an ellipse, instead of using the analytical solution in
    // https://www.shadertoy.com/view/4sS3zz.
    //
    // In retrospect, it's the same as Antonalog's https://www.shadertoy.com/view/MtXXW7
    //
    // More information here:
    //
    // https://iquilezles.org/articles/ellipsedist
    //
    //
    // Ellipse distances related shaders:
    //
    // Analytical     : https://www.shadertoy.com/view/4sS3zz
    // Newton Trig    : https://www.shadertoy.com/view/4lsXDN
    // Newton No-Trig : https://www.shadertoy.com/view/tttfzr 
    // ?????????????? : https://www.shadertoy.com/view/tt3yz7
    // symmetry
    pos = abs(pos);

    // find root with Newton solver
    float2 q = size * (pos - size);
    float w = (q.x < q.y) ? 1.570796327 : 0.0;
    for (int i = 0; i < 5; i++)
    {
        float2 cs = float2(cos(w), sin(w));
        float2 u = size * float2(cs.x, cs.y);
        float2 v = size * float2(-cs.y, cs.x);
        w = w + dot(pos - u, v) / (dot(pos - u, u) + dot(v, v));
    }
    
    // compute final point and distance
    float d = length(pos - size * float2(cos(w), sin(w)));
    
    // return signed distance
    return (dot(pos / size, pos / size) > 1.0) ? d : -d;
}

inline float Arc(float2 pos, float angle, float width, float thickness)
{
    float2 sc = float2(sin(angle), cos(angle));
    pos.x = abs(pos.x);
    return ((sc.y * pos.x > sc.x * pos.y) ? length(pos - sc * width) :
                                         abs(length(pos) - width)) - thickness;
}
inline float Ring(float2 pos, float angle, float radius, float thickness)
{
    float2 cs = float2(cos(angle), sin(angle));
    pos.x = abs(pos.x);
    //pos = mul(float2x2(cs.x, cs.y, -cs.y, cs.x), pos); 
    pos = mul(float2x2(cs.x, -cs.y, cs.y, cs.x), pos); // fix
    return max(abs(length(pos) - radius) - thickness * 0.5,
               length(float2(pos.x, max(0.0, abs(radius - pos.y) - thickness * 0.5))) * sign(pos.x));
}
inline float Horseshoe(float2 pos, float angle, float radius, float len, float thickness)
{
    float2 cs = float2(cos(angle), sin(angle));
    float2 w = float2(len, thickness);
    
    pos.x = abs(pos.x);
    float l = length(pos);
    pos = mul(float2x2(-cs.x, cs.y, cs.y, cs.x), pos);
    pos = float2((pos.y > 0.0 || pos.x > 0.0) ? pos.x : l * sign(-cs.x),
               (pos.x > 0.0) ? pos.y : l);
    pos = float2(pos.x, abs(pos.y - radius)) - w;
    return length(max(pos, 0.0)) + min(0.0, max(pos.x, pos.y));
}
inline float Pie(float2 pos, float angle, float radius)
{
    float2 c = float2(sin(angle), cos(angle));
    pos.x = abs(pos.x);
    float l = length(pos) - radius;
    float m = length(pos - c * clamp(dot(pos, c), 0.0, radius));
    return max(l, m * sign(c.y * pos.x - c.x * pos.y));
}
inline float SlicedCircle(float2 pos, float radius, float h)
{
    float w = sqrt(radius * radius - h * h);
    pos.x = abs(pos.x);
    float s = max((h - radius) * pos.x * pos.x + w * w * (h + radius - 2.0 * pos.y), h * pos.x - w * pos.y);
    return (s < 0.0) ? length(pos) - radius :
           (pos.x < w) ? h - pos.y :
           length(pos - float2(w, h));
}
inline float Pentagon(float2 pos, float radius)
{
    float3 k = float3(0.809016994, 0.587785252, 0.726542528); // cos(pi/5), sin(pi/5), tan(pi/5)
    pos.x = abs(pos.x);
    pos -= 2.0 * min(dot(float2(-k.x, k.y), pos), 0.0) * float2(-k.x, k.y);
    pos -= 2.0 * min(dot(float2(k.x, k.y), pos), 0.0) * float2(k.x, k.y);
    pos -= float2(clamp(pos.x, -radius * k.z, radius * k.z), radius);
    return length(pos) * sign(pos.y);
}
inline float Hexagon(float2 pos, float radius)
{
    float3 k = float3(-0.866025404, 0.5, 0.577350269);
    pos = abs(pos);
    pos -= 2.0 * min(dot(k.xy, pos), 0.0) * k.xy;
    pos -= float2(clamp(pos.x, -k.z * radius, k.z * radius), radius);
    return length(pos) * sign(pos.y);
}
inline float Octogon(float2 pos, float radius)
{
    float3 k = float3(-0.9238795325, 0.3826834323, 0.4142135623); // cos(pi/8), sin(pi/8), tan(pi/8)
    pos = abs(pos);
    pos -= 2.0 * min(dot(float2(k.x, k.y), pos), 0.0) * float2(k.x, k.y);
    pos -= 2.0 * min(dot(float2(-k.x, k.y), pos), 0.0) * float2(-k.x, k.y);
    pos -= float2(clamp(pos.x, -k.z * radius, k.z * radius), radius);
    return length(pos) * sign(pos.y);
}
inline float Hexagram(float2 pos, float radius)
{
    float4 k = float4(-0.5, 0.8660254038, 0.5773502692, 1.7320508076);
    pos = abs(pos);
    pos -= 2.0 * min(dot(k.xy, pos), 0.0) * k.xy;
    pos -= 2.0 * min(dot(k.yx, pos), 0.0) * k.yx;
    pos -= float2(clamp(pos.x, radius * k.z, radius * k.w), radius);
    return length(pos) * sign(pos.y);
}
inline float Pentagram(float2 pos, float radius)
{
    const float k1x = 0.809016994; // cos(π/5) = ¼(√5+1)
    const float k2x = 0.309016994; // sin(π/10) = ¼(√5-1)
    const float k1y = 0.587785252; // sin(π/5) = ¼√(10-2√5)
    const float k2y = 0.951056516; // cos(π/10) = ¼√(10+2√5)
    const float k1z = 0.726542528; // tan(π/5) = √(5-2√5)
    const float2 v1 = float2(k1x, -k1y);
    const float2 v2 = float2(-k1x, -k1y);
    const float2 v3 = float2(k2x, -k2y);
    
    pos.x = abs(pos.x);
    pos -= 2.0 * max(dot(v1, pos), 0.0) * v1;
    pos -= 2.0 * max(dot(v2, pos), 0.0) * v2;
    pos.x = abs(pos.x);
    pos.y -= radius;
    return length(pos - v3 * clamp(dot(pos, v3), 0.0, k1z * radius)) * sign(pos.y * v3.x - pos.x * v3.y);
}
inline float Star(float2 pos, float radius, int sides, float m)
{
    // next 4 lines can be precomputed for a given shape
    float an = 3.141593 / float(sides);
    float en = 3.141593 / m; // m is between 2 and n
    float2 acs = float2(cos(an), sin(an));
    float2 ecs = float2(cos(en), sin(en)); // ecs=vec2(0,1) for regular polygon
    
    //float bn = fmod(atan2(pos.x, pos.y), 2.0 * an) - an; 
    float bn = fmod(atan2(pos.x, pos.y) * sign(pos.x), 2.0 * an) - an; // fix
    
    pos = length(pos) * float2(cos(bn), abs(sin(bn)));
    pos -= radius * acs;
    pos += ecs * clamp(-dot(pos, ecs), 0.0, radius * acs.y / ecs.y);
    return length(pos) * sign(pos.x);
}



// -----------------------------------------------------------------------------
// Rectangle / Box
// -----------------------------------------------------------------------------
inline float Rectangle(float2 pos, float2 size)
{
    float2 d = abs(pos) - size;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}
inline float RoundedRectangle(float2 pos, float2 size, float4 radius)
{
    radius.xy = (pos.x > 0.0) ? radius.xy : radius.zw;
    radius.x = (pos.y > 0.0) ? radius.x : radius.y;
    float2 q = abs(pos) - size + radius.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - radius.x;
}
inline float ChamferBox(float2 pos, float2 size, float chamfer)
{
    pos = abs(pos) - size;

    pos = (pos.y > pos.x) ? pos.yx : pos.xy;
    pos.y += chamfer;

    float k = 1.0 - sqrt(2.0);
    if (pos.y < 0.0 && pos.y + pos.x * k < 0.0)
        return pos.x;

    if (pos.x < pos.y)
        return (pos.x + pos.y) * sqrt(0.5);

    return length(pos);
}
inline float Rhombus(float2 pos, float2 size)
{
    pos = abs(pos);
    float h = clamp(ndot(size - 2.0 * pos, size) / dot(size, size), -1.0, 1.0);
    float d = length(pos - 0.5 * size * float2(1.0 - h, 1.0 + h));
    return d * sign(pos.x * size.y + pos.y * size.x - size.x * size.y);
}
inline float Parallelogram(float2 pos, float width, float height, float skew)
{
    float2 e = float2(skew, height);
    pos = (pos.y < 0.0) ? -pos : pos;
    float2 w = pos - e;
    w.x -= clamp(w.x, -width, width);
    float2 d = float2(dot(w, w), -w.y);
    float s = pos.x * e.y - pos.y * e.x;
    pos = (s < 0.0) ? -pos : pos;
    float2 v = pos - float2(width, 0.0);
    v -= e * clamp(dot(v, e) / dot(e, e), -1.0, 1.0);
    d = min(d, float2(dot(v, v), width * height - abs(s)));
    return sqrt(d.x) * sign(-d.y);
}
inline float IsoscelesTrapezoid(float2 pos, float botWidth, float topWidth, float height)
{
    float2 k1 = float2(topWidth, height);
    float2 k2 = float2(topWidth - botWidth, 2.0 * height);
    pos.x = abs(pos.x);
    float2 ca = float2(pos.x - min(pos.x, (pos.y < 0.0) ? botWidth : topWidth), abs(pos.y) - height);
    float2 cb = pos - k1 + k2 * clamp(dot(k1 - pos, k2) / dot2(k2), 0.0, 1.0);
    float s = (cb.x < 0.0 && ca.y < 0.0) ? -1.0 : 1.0;
    return s * sqrt(min(dot2(ca), dot2(cb)));
}
inline float IsoscelesTrapezoid(float2 pos, float2 startOffset, float2 endOffset, float botWidth, float rb)
{
    // This sdf seem to have a bug producing a white line in the middle
    float rba = rb - botWidth;
    float baba = dot(endOffset - startOffset, endOffset - startOffset);
    float papa = dot(pos - startOffset, pos - startOffset);
    float paba = dot(pos - startOffset, endOffset - startOffset) / baba;
    float x = sqrt(papa - paba * paba * baba);
    float cax = max(0.0, x - ((paba < 0.5) ? botWidth : rb));
    float cay = abs(paba - 0.5) - 0.5;
    float k = rba * rba + baba;
    float f = clamp((rba * (x - botWidth) + paba * baba) / k, 0.0, 1.0);
    float cbx = x - botWidth - f * rba;
    float cby = paba - f;
    float s = (cbx < 0.0 && cay < 0.0) ? -1.0 : 1.0;
    return s * sqrt(min(cax * cax + cay * cay * baba,
                       cbx * cbx + cby * cby * baba));
}

// -----------------------------------------------------------------------------
// Triangle
// -----------------------------------------------------------------------------
inline float EquilateralTriangle(float2 pos, float r)
{
    float k = sqrt(3.0);
    pos.x = abs(pos.x) - r;
    pos.y = pos.y + r / k;
    if (pos.x + k * pos.y > 0.0)
        pos = float2(pos.x - k * pos.y, -k * pos.x - pos.y) / 2.0;
    pos.x -= clamp(pos.x, -2.0 * r, 0.0);
    return -length(pos) * sign(pos.y);
}
inline float IsoscelesTriangle(float2 pos, float2 q)
{
    pos.x = abs(pos.x);
    float2 a = pos - q * clamp(dot(pos, q) / dot(q, q), 0.0, 1.0);
    float2 b = pos - q * float2(clamp(pos.x / q.x, 0.0, 1.0), 1.0);
    float s = -sign(q.y);
    float2 d = min(float2(dot(a, a), s * (pos.x * q.y - pos.y * q.x)),
                   float2(dot(b, b), s * (pos.y - q.y)));
    return -sqrt(d.x) * sign(d.y);
}
inline float Triangle(float2 pos, float2 p0, float2 p1, float2 p2)
{
    float2 e0 = p1 - p0, e1 = p2 - p1, e2 = p0 - p2;
    float2 v0 = pos - p0, v1 = pos - p1, v2 = pos - p2;
    float2 pq0 = v0 - e0 * clamp(dot(v0, e0) / dot(e0, e0), 0.0, 1.0);
    float2 pq1 = v1 - e1 * clamp(dot(v1, e1) / dot(e1, e1), 0.0, 1.0);
    float2 pq2 = v2 - e2 * clamp(dot(v2, e2) / dot(e2, e2), 0.0, 1.0);
    float s = sign(e0.x * e2.y - e0.y * e2.x);
    float2 d = min(min(float2(dot(pq0, pq0), s * (v0.x * e0.y - v0.y * e0.x)),
                       float2(dot(pq1, pq1), s * (v1.x * e1.y - v1.y * e1.x))),
                       float2(dot(pq2, pq2), s * (v2.x * e2.y - v2.y * e2.x)));
    return -sqrt(d.x) * sign(d.y);
}

// -----------------------------------------------------------------------------
// Blobby
// -----------------------------------------------------------------------------
inline float UnevenCapsule(float2 pos, float botRadius, float topRadius, float height)
{
    pos.x = abs(pos.x);
    float b = (botRadius - topRadius) / height;
    float a = sqrt(1.0 - b * b);
    float k = dot(pos, float2(-b, a));
    if (k < 0.0)
        return length(pos) - botRadius;
    if (k > a * height)
        return length(pos - float2(0.0, height)) - topRadius;
    return dot(pos, float2(a, b)) - botRadius;
}
inline float Vesica(float2 pos, float radius, float dist)
{
    // Distance to a vesica shape (intersection of two disks)
    pos = abs(pos);

    float b = sqrt(radius * radius - dist * dist); // can delay this sqrt by rewriting the comparison
    return ((pos.y - b) * dist > pos.x * b) ? length(pos - float2(0.0, b)) * sign(dist)
                               : length(pos - float2(-dist, 0.0)) - radius;
}
inline float OrientedVesica(float2 pos, float2 startOffset, float2 endOffset, float width)
{
    // shape constants
    float r = 0.5 * length(endOffset - startOffset);
    float d = 0.5 * (r * r - width * width) / width;
    
    // center, orient and mirror
    float2 v = (endOffset - startOffset) / r;
    float2 c = (endOffset + startOffset) * 0.5;
    float2 q = 0.5 * abs(mul(float2x2(v.y, v.x, -v.x, v.y), (pos - c)));
    
    // feature selection (vertex or body)
    float3 h = (r * q.x < d * (q.y - r)) ? float3(0.0, r, 0.0)
                                         : float3(-d, 0.0, d + width);
    
    // distance
    return length(q - h.xy) - h.z;
}
inline float BlobbyCross(float2 pos, float radius, float thickness)
{
    // Exact SDF of a blobby cross made of parabolic segments. Inspired by 
    // oneshader's Tractrix SDF: https://www.shadertoy.com/view/sdsXWN
    // PLEASE NOTE - the interior distance is not always exact.
    pos = abs(pos);
    pos = float2(abs(pos.x - pos.y), 1.0 - pos.x - pos.y) / sqrt(2.0);

    float p = (radius - pos.y - 0.25 / radius) / (6.0 * radius);
    float q = pos.x / (radius * radius * 16.0);
    float h = q * q - p * p * p;

    float x;
    if (h > 0.0)
    {
        float r = sqrt(h);
        x = pow(q + r, 1.0 / 3.0) - pow(abs(q - r), 1.0 / 3.0) * sign(r - q);
    }
    else
    {
        float r = sqrt(p);
        x = 2.0 * r * cos(acos(q / (p * r)) / 3.0);
    }
    x = min(x, sqrt(2.0) / 2.0);

    float2 z = float2(x, radius * (1.0 - 2.0 * x * x)) - pos;
    return length(z) * sign(z.y) - thickness;
}
inline float QuadraticCircle(float2 pos)
{
    // This version is correct everywhere except at the center of the shape
    pos = abs(pos);
    if (pos.y > pos.x)
        pos = pos.yx;

    float a = pos.x - pos.y;
    float b = pos.x + pos.y;
    float c = (2.0 * b - 1.0) / 3.0;
    float h = a * a + c * c * c;
    float t;
    if (h >= 0.0)
    {
        h = sqrt(h);
        t = sign(h - a) * pow(abs(h - a), 1.0 / 3.0) - pow(h + a, 1.0 / 3.0);
    }
    else
    {
        float z = sqrt(-c);
        float v = acos(a / (c * z)) / 3.0;
        t = -z * (cos(v) + sin(v) * 1.732050808);
    }
    t *= 0.5;
    float2 w = float2(-t, t) + 0.75 - t * t - pos;
    return length(w) * sign(a * a * 0.5 + b - 1.5);
}

// -----------------------------------------------------------------------------
// Special
// -----------------------------------------------------------------------------
inline float Moon(float2 pos, float pos2, float radius, float radius2)
{
    pos.y = abs(pos.y);
    float a = (radius * radius - radius2 * radius2 + pos2 * pos2) / (2.0 * pos2);
    float b = sqrt(max(radius * radius - a * a, 0.0));
    if (pos2 * (pos.x * b - pos.y * a) > pos2 * pos2 * max(b - pos.y, 0.0))
        return length(pos - float2(a, b));
    return max(length(pos) - radius,
              -(length(pos - float2(pos2, 0)) - radius2));
}
inline float Egg(float2 pos, float height, float botRadius, float tipRadius)
{
    float ce = 0.5 * (height * height - (botRadius - tipRadius) * (botRadius - tipRadius)) / (botRadius - tipRadius);

    pos.x = abs(pos.x);

    if (pos.y < 0.0)
        return length(pos) - botRadius;
    if (pos.y * ce - pos.x * height > height * ce)
        return length(float2(pos.x, pos.y - height)) - tipRadius;
    return length(float2(pos.x + ce, pos.y)) - (ce + botRadius);
}
inline float Heart(float2 p)
{
    p.x = abs(p.x);

    if (p.y + p.x > 1.0)
        return sqrt(dot2(p - float2(0.25, 0.75))) - sqrt(2.0) / 4.0;

    return sqrt(min(dot2(p - float2(0.00, 1.00)),
                    dot2(p - 0.5 * max(p.x + p.y, 0.0)))) * sign(p.x - p.y);
}
inline float RoundedCross(float2 pos, float height)
{
    float k = 0.5 * (height + 1.0 / height); // k should be const/precomputed at modeling time
    
    pos = abs(pos);
    return (pos.x < 1.0 && pos.y < pos.x * (k - height) + height) ?
        k - sqrt(dot2(pos - float2(1.0, k))) : // circular arc
        sqrt(min(dot2(pos - float2(0.0, height)), // top corner
                 dot2(pos - float2(1.0, 0.0)))); // right corner
}
inline float Cross(float2 pos, float len, float thickness, float size)
{
    // Exact fix by rodolphito, 2021-07-10
    float2 b = float2(len, thickness);
    pos = abs(pos);
    pos = (pos.y > pos.x) ? pos.yx : pos.xy;

    float2 u = pos + min(size, 0.0) - b.yy;
    float2 v = pos + max(size, 0.0) - b;
    
    if ((u.x > 0.0 || v.y < v.x)
     && (v.x < 0.0 || v.y < 0.0))
        return max(v.x, v.y) + min(size, 0.0);
     
    float d = length(u.x < 0.0 ? u : v);
    
    return u.x < 0.0
     ? max(max(size, 0.0) - d, v.x + min(size, 0.0))
     : min(size, 0.0) + d;
}
inline float RoundedX(float2 pos, float size, float thickness)
{
    // Exact Fix by pyBlob, 2023-09-12
    size = size / sqrt(2.); // match w to original
    pos = abs(pos);
    pos = (pos + float2(pos.y, -pos.x)) / sqrt(2.);
    pos = abs(pos);
    
    if (pos.x > size)
        return length(pos - float2(size, 0)) - thickness;
    
    pos -= thickness;
    return max(pos.y, 0.) - length(min(pos, 0.));
}
inline float Polygon(float2 pos, float2 v[5])
{
    // Change Num and array len to your use
    const int num = 5;
    float d = dot(pos - v[0], pos - v[0]);
    float s = 1.0;
    for( int i=0, j=num-1; i<num; j=i, i++ )
    {
        // distance
        float2 e = v[j] - v[i];
        float2 w = pos - v[i];
        float2 b = w - e*clamp( dot(w,e)/dot(e,e), 0.0, 1.0 );
        d = min( d, dot(b,b) );

        // winding number from http://geomalgorithms.com/a03-_inclusion.html
        bool3x1 cond = bool3x1(pos.y >= v[i].y,
                            pos.y < v[j].y,
                            e.x*w.y>e.y*w.x );
        if( all(cond) || all(!(cond)) ) s=-s;  
    }
    
    return s*sqrt(d);
}
inline float Tunnel(float2 pos, float width, float height)
{
    float2 wh = float2(width, height);
    
    pos.x = abs(pos.x);
    pos.y = -pos.y;
    float2 q = pos - wh;

    float d1 = dot2(float2(max(q.x, 0.0), q.y));
    q.x = (pos.y > 0.0) ? q.x : length(pos) - wh.x;
    float d2 = dot2(float2(q.x, max(q.y, 0.0)));
    float d = sqrt(min(d1, d2));

    return (max(q.x, q.y) < 0.0) ? -d : d;
}
inline float Stairs(float2 pos, float width, float height, float steps)
{
    float2 wh = float2(width, height);
    
    // base
    float2 ba = wh * steps;
    float d = min(dot2(pos - float2(clamp(pos.x, 0.0, ba.x), 0.0)),
                  dot2(pos - float2(ba.x, clamp(pos.y, 0.0, ba.y))));
    float s = sign(max(-pos.y, pos.x - ba.x));

    // steps repetition
    float dia = dot2(wh);
    //pos = mul(float2x2(wh.x, -wh.y, wh.y, wh.x), pos);
    pos = mul(float2x2(wh.x, wh.y, -wh.y, wh.x), pos); // fix
    float id = clamp(round(pos.x / dia), 0.0, steps - 1.0);
    pos.x = pos.x - id * dia;
    //pos = mul(float2x2(wh.x, wh.y, -wh.y, wh.x), pos / dia);
    pos = mul(float2x2(wh.x, -wh.y, wh.y, wh.x), pos / dia); // fix

    float hh = wh.y / 2.0;
    pos.y -= hh;
    if (pos.y > hh * sign(pos.x))
        s = 1.0;
    pos = (id < 0.5 || pos.x > 0.0) ? pos : -pos;
    d = min(d, dot2(pos - float2(0.0, clamp(pos.y, -hh, hh))));
    d = min(d, dot2(pos - float2(clamp(pos.x, 0.0, wh.x), hh)));

    return sqrt(d) * s;
}
inline float CoolS(float2 pos)
{
    float six = (pos.y < 0.0) ? -pos.x : pos.x;
    pos.x = abs(pos.x);
    pos.y = abs(pos.y) - 0.2;
    float rex = pos.x - min(round(pos.x / 0.4), 0.4);
    float aby = abs(pos.y - 0.2) - 0.6;

    float d = dot2(float2(six, pos.y) - clamp(0.5 * (six - pos.y), 0.0, 0.2));
    d = min(d, dot2(float2(pos.x, -aby) - clamp(0.5 * (pos.x - aby), 0.0, 0.4)));
    d = min(d, dot2(float2(rex, pos.y - clamp(pos.y, 0.0, 0.4))));

    float s = 2.0 * pos.x + aby + abs(aby + 0.4) - 0.4;
    return sqrt(d) * sign(s);
}
inline float CircleWave(float2 pos, float tb, float ra)
{
    pos.x = abs(pos.x); // Fix
    
    tb = 3.1415927 * 5.0 / 6.0 * max(tb, 0.0001);
    float2 co = ra * float2(sin(tb), cos(tb));
    
    pos.x = abs(fmod(pos.x, co.x * 4.0) - co.x * 2.0);
    
    // Border sdf
    {
        float2 p1 = pos;
        float2 p2 = float2(abs(pos.x - 2.0 * co.x), -pos.y + 2.0 * co.y);
        float d1 = ((co.y * p1.x > co.x * p1.y) ? length(p1 - co) : abs(length(p1) - ra));
        float d2 = ((co.y * p2.x > co.x * p2.y) ? length(p2 - co) : abs(length(p2) - ra));
    
    
        return min(d1, d2);
    }
    
    // Full sdf
    {
        float2 q = float2(pos.x - 2.0 * co.x, -pos.y + 2.0 * co.y);

        bool b = co.y * pos.x > co.x * pos.y;

        float2 u = b ? pos : q;
        float2 v = b ? q : pos;
        float l1 = length(v) - ra;
        float l2 = length(u - co);
        float s = b ? -l1 : l1;
        return sign(s) * min(abs(l1), l2);
    }
}
























































































//float sdUnevenCapsule22(in vec2 p, in vec2 a, in vec2 b, in float r1, in float r2)
//{
//    vec2 pa = p - a, ba = b - a;
//    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
//    return length(pa - ba * h) - mix(r1, r2, h);
//}

#endif