#ifndef EASING
#define EASING

/// <summary>
/// Uses Alternate/Expanded Form to reduce number multiplication
/// According to https://easings.net/ & Using Math Calculator to simplfy
/// </summary>

inline float Linear(float t)
{
    return t;
}

// Sine
inline float SineIn(float t)
{
    return 1.0 - cos(t * UNITY_PI / 2.0);
}
inline float SineOut(float t)
{
    return sin(t * UNITY_PI / 2.0);
}
inline float SineInOut(float t)
{
    return -(cos(UNITY_PI * t) - 1.0) / 2.0;
}

// Quad
inline float QuadIn(float t)
{
    return t * t;
}
inline float QuadOut(float t)
{
    return t * (2.0 - t); // 1 - (1 - x)^2
}
inline float QuadInOut(float t)
{
    return (t < 0.5) ? 
    (2.0 * t * t) : 
    ((4.0 - 2.0 * t) * t - 1.0); // 1 - (-2 * x + 2)^2 / 2;
}

// Cubic
inline float CubicIn(float t)
{
    return t * t * t;
}
inline float CubicOut(float t)
{
    return t * (t * (t - 3.0) + 3.0); // 1 - (1 - x)^3
}
inline float CubicInOut(float t)
{
    return (t < 0.5) ?
    (4.0 * t * t * t) :
    (t * (t * (4.0 * t - 12.0) + 12.0) - 3.0); //1 - Math.pow(-2 * x + 2)^3 / 2;
}

// Quart
inline float QuartIn(float t)
{
    return t * t * t * t;
}
inline float QuartOut(float t)
{
    return t * (t * (t * (4.0 - t) - 6.0) + 4.0); // 1 - (1 - x)^4
}
inline float QuartInOut(float t)
{
    return (t < 0.5) ? 
    (8.0 * t * t * t * t) : 
    (t * (t * (t * (32.0 - 8.0 * t) - 48.0) + 32.0) - 7.0); // 1 - (-2 * x + 2)^4 / 2
}

// Quint
inline float QuintIn(float t)
{
    return t * t * t * t * t;
}

inline float QuintOut(float t)
{
    return t * (t * (t * (t * (t - 5.0) + 10.0) - 10.0) + 5.0); // 1 - (1 - x)^5
}

inline float QuintInOut(float t)
{
    return (t < 0.5) ? 
    (16.0 * t * t * t * t * t) : 
    (t * (t * (t * (t * (16.0 * t - 80.0) + 160.0) - 160.0) + 80.0) - 15.0); // 1 - (-2 * x + 2)^4 / 2
}

// Expo
inline float ExpoIn(float t)
{
    return (t == 0.0) ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
}
inline float ExpoOut(float t)
{
    return (t == 1.0) ? 1.0 : pow(2.0, -10.0 * t);
}
inline float ExpoInOut(float t)
{
    return (t == 0.0) ? 0.0 : (t == 1.0) ? 1.0 : (t < 0.5) ?
    pow(2.0, 20.0 * t - 10.0) / 2.0 :
    (2.0 - pow(2.0, -20.0 * t + 10.0)) / 2.0;
}

// Circular
inline float CircularIn(float t)
{
    return 1.0 - sqrt(1.0 - t * t);
}
inline float CircularOut(float t)
{
    return sqrt(t * (2.0 - t));
}
inline float CircularInOut(float t)
{
    return (t < 0.5) ?
    (1.0 - sqrt(1.0 - 4.0 * t * t)) / 2.0 :
    (sqrt(t * (8.0 - 4.0 * t) - 3.0) + 1.0) / 2.0;
}

// Back
inline float BackIn(float t)
{
    return (2.70158 * t * t * t) - (1.70158 * t * t);
}
inline float BackOut(float t)
{
    return 1.0 + 2.70158 * (t - 1.0) * (t - 1.0) * (t - 1.0) + 1.70158 * (t - 1.0) * (t - 1.0);
}
inline float BackInOut(float t)
{
    return (t < 0.5) ?
    (4.0 * t * t * 7.18982 * (t - 0.360914)) / 2.0 :
    (4.0 * (t - 1.0) * (t - 1.0) * 7.18982 * (t - 0.639086) + 2.0) / 2.0;
}

// Elastic
inline float ElasticIn(float t)
{
    return (t == 0.0) ? 0.0 : (t == 1.0) ? 1.0 :
    -(pow(2.0, 10.0 * t - 10.0) * sin((t * 10.0 - 10.75) * (2.0 * UNITY_PI / 3.0)));
}
inline float ElasticOut(float t)
{
    return (t == 0.0) ? 0.0 : (t == 1.0) ? 1.0 :
    pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * (2.0 * UNITY_PI / 3.0)) + 1.0;
}
inline float ElasticInOut(float t)
{
    return (t == 0.0) ? 0.0 : (t == 1.0) ? 1.0 : (t < 0.5) ?
    -(pow(2.0, 20.0 * t - 10.0) * sin((20.0 * t - 11.125) * (2.0 * UNITY_PI / 4.5))) / 2.0 :
    (pow(2.0, -20.0 * t + 10.0) * sin((20.0 * t - 11.125) * (2.0 * UNITY_PI / 4.5))) / 2.0 + 1.0;
}

// Bounce
inline float BounceOut(float t)
{
    return (t < 0.363636) ? (7.5625 * t * t) :
           (t < 0.727273) ? (7.5625 * (t -= 0.545455) * t + 0.75) :
           (t < 0.909091) ? (7.5625 * (t -= 0.818182) * t + 0.9375) :
                            (7.5625 * (t -= 0.954545) * t + 0.984375);
}
inline float BounceIn(float t)
{
    return 1.0 - BounceOut(1.0 - t);
}
inline float BounceOut2(float t)
{
    if (t < 0.363636)
        return 7.5625 * t * t;
    else if (t < 0.727273)
        return 7.5625 * (t -= 0.545455) * t + 0.75;
    else if (t < 0.909091)
        return 7.5625 * (t -= 0.818182) * t + 0.9375;
    else
        return 7.5625 * (t -= 0.954545) * t + 0.984375;
}
inline float BounceInOut(float t)
{
    return (t < 0.5) ?
    (1.0 - BounceOut(1.0 - 2.0 * t)) / 2.0 :
    (1.0 + BounceOut(2.0 * t - 1.0)) / 2.0;
}

inline float Spring(float start, float end, float t)
{
    float damping = (1 - t);
    float oscillation = sin(t * 20.0);

    return lerp(start, end, t) + (oscillation * damping * 0.05) * (end - start);
}
inline float Spring2(float start, float end, float t)
{
    float damping = pow(2.0, -10.0 * t); // exponential decay
    float oscillation = sin((t - 0.075) * 20.0); // spring frequency
    
    float overshoot = oscillation * damping;

    return start + (end - start) * (t + overshoot);
}

#endif