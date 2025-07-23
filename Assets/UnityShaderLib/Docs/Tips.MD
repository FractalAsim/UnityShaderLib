# 1. Use Swizzle Assignment whenever possible and avoid having single assigments
You can save instruction counts by having single assignment to vectors/matrices instead of multiple assignment as GPU generally works better on vectors

```
Avoid Doing
pos.x = in_pos.x;
pos.y = in_pos.y;

Instead Do
pos.xy = in_pos.xy;
```

# 2. Use MAD to possible save instruction count due to SIMD. 
You can save instruction counts when doing math by having a Multiply+Add on a single line. The GPU might execute this in one operation instead of doing each math operation.


```
Avoid using divide and use Multiply, As Some Compiler automatically optimizes this and converts to multiply, but some dont

vec4 result3 = (value * -0.5) + 1.0;

```

# 3. Use Saturate is more better than Clamp01
The GPU perform Saturated better,

# 4


Math Tricks

If you want to Sum Each Element of a Vec, Use Dot()

```
Avoid Doing
vec4 value = fvalue1.x + fvalue1.y + fvalue1.z + fvalue1.w;

Instead Do
vec4 AllOnes = vec4(1.0);
vec4 fvalue = dot(fvalue2, AllOnes);
```




1. Multiply scalar values before vector values
2. Avoid Branching based on dynamic values
3. beware of function overhead, discard() floor() etc.. check performance on renderer model (openGL, etc)
4. Use Frame Debuggers to debug shaders