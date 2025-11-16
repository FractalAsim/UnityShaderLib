#ifndef Math
#define Math

// Circuluar Lerp for angles that goes from 0-360-0
float clerp(float a, float b, float t)
{
    float diff = fmod(b - a + 540, 360) - 180;
    return a + diff * t;
}

#endif