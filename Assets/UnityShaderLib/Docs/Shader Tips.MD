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
The GPU may perform Saturated better due to have an intrinsic Instruction for it.

```
Avoid Doing
clamp(color,0,1)
saturated(color)

Instead Do
pos.xy = in_pos.xy;

```


# 4. Use Frac on Time to wrap number to 0-1 to prevent large floating number inaccuracy
```
Avoid Doing
speed = Time.y

Instead Do
speed = frac(time.y)

```


Optimizations
# 1. If you want to Sum Each Element of a Vec, Use Dot()

```
Avoid Doing
vec4 value = fvalue1.x + fvalue1.y + fvalue1.z + fvalue1.w;

Instead Do
vec4 AllOnes = vec4(1.0);
vec4 fvalue = dot(fvalue2, AllOnes);
```


# 2. Avoid Branching on dynamic values.
Branching is expensive. Instead Use shader keywards and shader variants or masking via multiplication
Try to see if you can convert the logic by using math functions (dot,step,sign,saturate) to return 0 or 1 and multiply to enable or disable.

```

Avoid Doing
if(on)
{
    color = float4(1,0,0,0);
}
else
{
    color = float4(0,1,0,0);
}

Instead Do
color = float4(on,1-on,0,0);
```

# 3. In a standard PBR shader, instead of the normal 3 texture channel packing. consider using 2 texture channel packing to save memeory/performance
This can be done by the following
1. Base/Albedo Texture alpha channel can be instead use to store roughness/smoothness values for opaque objects
2. Normal Map z & w channel can be use to store some other value. You can use Normal.XY to recalculate Normal.Z. However this methodcauses lost of precision when using non-normal texture compression
    1. Convert the map range from [0,1] to [-1,1]
    2. Find out which RGBA channels is storing the x,y values of normals. (Note that different normal map encoding might stores in different RGBA)
    3. Calculate z value = z = sqrt(x*x+y*y)l (pythagoras theorem)
    4. Combine the values into a vector
    5. Unity Shader Graph have a node "Normal Reconstruct Z" for this

# 3. Consider using 