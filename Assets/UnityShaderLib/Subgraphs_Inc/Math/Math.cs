using System;

public static class Math
{
    public static float Clerp(float start, float end, float t)
    {
        float min = 0.0f;
        float max = 360.0f;
        float half = MathF.Abs((max - min) * 0.5f);

        float diff = end - start;

        if (diff < -half)
        {
            diff += (max - min);
        }
        if (diff > half)
        {
            diff -= (max - min);
        }

        return start + diff * t;
    }

    public static float Punch(float amplitude, float value)
    {
        float s = 9;
        if (value == 0)
        {
            return 0;
        }
        else if (value == 1)
        {
            return 0;
        }
        float period = 1 * 0.3f;
        s = period / (2 * MathF.PI) * MathF.Asin(0);
        return (amplitude * MathF.Pow(2, -10 * value) * MathF.Sin((value * 1 - s) * (2 * MathF.PI) / period));
    }
}
