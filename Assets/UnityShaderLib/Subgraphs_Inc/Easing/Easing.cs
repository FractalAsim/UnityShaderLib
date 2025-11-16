using System;

/// <summary>
/// Uses Alternate/Expanded Form to reduce number multiplication
/// According to https://easings.net/ & Using Math Calculator to simplfy
/// </summary>
public static class Easing
{
    public static float Linear(float t) => t;

    public static float SineIn(float t) => 1 - MathF.Cos(t * MathF.PI / 2);
    public static float SineOut(float t) => MathF.Sin(t * MathF.PI / 2);
    public static float SineInOut(float t) => -(MathF.Cos(MathF.PI * t) - 1) / 2;

    public static float QuadIn(float t) => t * t;
    public static float QuadOut(float t) => t * (2 - t); // 1 - (1 - x)^2
    public static float QuadInOut(float t) => t < 0.5f ?
        2 * t * t :
        (4 - 2 * t) * t - 1; // 1 - (-2 * x + 2)^2 / 2;

    public static float CubicIn(float t) => t * t * t;
    public static float CubicOut(float t) => t * (t * (t - 3) + 3); // 1 - (1 - x)^3
    public static float CubicInOut(float t) => t < 0.5f ?
        4 * t * t * t :
        t * (t * (4 * t - 12) + 12) - 3; //1 - Math.pow(-2 * x + 2)^3 / 2;
    public static float QuartIn(float t) => t * t * t * t;
    public static float QuartOut(float t) => t * (t * (t * (4 - t) - 6) + 4); // 1 - (1 - x)^4
    public static float QuartInOut(float t) => t < 0.5f ?
        8 * t * t * t * t :
        t * (t * (t * (32 - 8 * t) - 48) + 32) - 7; // 1 - (-2 * x + 2)^4 / 2

    public static float QuintIn(float t) => t * t * t * t * t;
    public static float QuintOut(float t) => t * (t * (t * (t * (t - 5) + 10) - 10) + 5); // 1 - (1 - x)^5
    public static float QuintInOut(float t) => t < 0.5f ?
        16 * t * t * t * t * t :
        t * (t * (t * (t * (16 * t - 80) + 160) - 160) + 80) - 15; // 1 - (-2 * x + 2)^4 / 2

    public static float ExpoIn(float t) => t == 0 ? 0 : MathF.Pow(2, 10 * (t - 1));
    public static float ExpoOut(float t) => t == 1 ? 1 : MathF.Pow(2, -10 * t);
    public static float ExpoInOut(float t) => t == 0 ? 0 : t == 1 ? 1 : t < 0.5f ?
        MathF.Pow(2, 20 * t - 10) / 2 :
        (2 - MathF.Pow(2, -20 * t + 10)) / 2;

    public static float CircularIn(float t) => 1 - MathF.Sqrt(1 - t * t);
    public static float CircularOut(float t) => MathF.Sqrt(t * (2 - t));
    public static float CircularInOut(float t) => t < 0.5f ?
        (1 - MathF.Sqrt(1 - 4 * t * t)) / 2 :
        (MathF.Sqrt(t * (8 - 4 * t) - 3) + 1) / 2;

    public static float BackIn(float t) => (2.70158f * t * t * t) - (1.70158f * t * t);
    public static float BackOut(float t) => 1 + 2.70158f * (t - 1) * (t - 1) * (t - 1) + 1.70158f * (t - 1) * (t - 1);
    public static float BackInOut(float t) => t < 0.5f ?
        (4 * t * t * 7.18982f * (t - 0.360914f)) / 2 :
        (4 * (t - 1) * (t - 1) * 7.18982f * (t - 0.639086f) + 2) / 2;

    public static float ElasticIn(float t) => t == 0 ? 0 : t == 1 ? 1 :
        -(MathF.Pow(2, 10 * t - 10) * MathF.Sin(t * 10 - 10.75f) * (2f / 3f * MathF.PI));
    public static float ElasticOut(float t) => t == 0 ? 0 : t == 1 ? 1
        : MathF.Pow(2, -10 * t) * MathF.Sin((t * 10 - 0.75f) * (2f / 3f * MathF.PI)) + 1;
    public static float ElasticInOut(float t) => t == 0 ? 0 : t == 1 ? 1 : t < 0.5f ?
        -(MathF.Pow(2, 20 * t - 10) * MathF.Sin((20 * t - 11.125f) * (2f / 4.5f * MathF.PI))) / 2 :
        (MathF.Pow(2, -20 * t + 10) * MathF.Sin((20 * t - 11.125f) * (2f / 4.5f * MathF.PI))) / 2 + 1;

    public static float BounceIn(float t) => 1f - BounceOut(1 - t);
    public static float BounceOut(float t) =>
        t < 0.363636f ? 7.5625f * t * t :
        t < 0.727273f ? 7.5625f * (t -= 0.545455f) * t + 0.75f :
        t < 0.909091f ? 7.5625f * (t -= 0.818182f) * t + 0.9375f :
        7.5625f * (t -= 0.954545f) * t + 0.984375f;

    public static float BounceOut2(float t)
    {
        if (t < 0.363636f) // 1 / 2.75f
        {
            return 7.5625f * t * t;
        }
        else if (t < 0.727273f) // 2 / 2.75f
        {
            return 7.5625f * (t -= 0.545455f) * t + 0.75f;
        }
        else if (t < 0.909091f) // 2.5 / 2.75f
        {
            return 7.5625f * (t -= 0.818182f) * t + 0.9375f;
        }
        else
        {
            return 7.5625f * (t -= 0.954545f) * t + 0.984375f;
        }
    }

    public static float BounceInOut(float t) => t < 0.5f ?
        (1 - BounceOut(1 - 2 * t)) / 2 :
        (1 + BounceOut(2 * t - 1)) / 2;

    public enum EasingType
    {
        Linear,

        SineIn,
        SineOut,
        SineInOut,

        QuadIn,
        QuadOut,
        QuadInOut,

        CubicIn,
        CubicOut,
        CubicInOut,

        QuartIn,
        QuartOut,
        QuartInOut,

        QuintIn,
        QuintOut,
        QuintInOut,

        ExpoIn,
        ExpoOut,
        ExpoInOut,

        CircularIn,
        CircularOut,
        CircularInOut,

        BackIn,
        BackOut,
        BackInOut,

        ElasticIn,
        ElasticOut,
        ElasticInOut,

        BounceIn,
        BounceOut,
        BounceInOut,
    }

    public static float ApplyEasing(EasingType type, float t)
    {
        return type switch
        {
            EasingType.Linear => Linear(t),

            EasingType.SineIn => SineIn(t),
            EasingType.SineOut => SineOut(t),
            EasingType.SineInOut => SineInOut(t),

            EasingType.QuadIn => QuadIn(t),
            EasingType.QuadOut => QuadOut(t),
            EasingType.QuadInOut => QuadInOut(t),

            EasingType.CubicIn => CubicIn(t),
            EasingType.CubicOut => CubicOut(t),
            EasingType.CubicInOut => CubicInOut(t),

            EasingType.QuartIn => QuartIn(t),
            EasingType.QuartOut => QuartOut(t),
            EasingType.QuartInOut => QuartInOut(t),

            EasingType.QuintIn => QuintIn(t),
            EasingType.QuintOut => QuintOut(t),
            EasingType.QuintInOut => QuintInOut(t),

            EasingType.ExpoIn => ExpoIn(t),
            EasingType.ExpoOut => ExpoOut(t),
            EasingType.ExpoInOut => ExpoInOut(t),

            EasingType.CircularIn => CircularIn(t),
            EasingType.CircularOut => CircularOut(t),
            EasingType.CircularInOut => CircularInOut(t),

            EasingType.BackIn => BackIn(t),
            EasingType.BackOut => BackOut(t),
            EasingType.BackInOut => BackInOut(t),

            EasingType.ElasticIn => ElasticIn(t),
            EasingType.ElasticOut => ElasticOut(t),
            EasingType.ElasticInOut => ElasticInOut(t),

            EasingType.BounceIn => BounceIn(t),
            EasingType.BounceOut => BounceOut(t),
            EasingType.BounceInOut => BounceInOut(t),

            _ => throw new NotImplementedException()
        };
    }
}