## Clip()/Discard vs Alpha transparency Performance
Performance for Clip() may some times be faster than Alpha transparency. Depending on the hardware and architecture, such as most mobile devices that uses tile-based deffered renderes (TBDR), clip() is slower than alpha transparency.
Do benchmarkto find out.

## Use Frame Debuggers (RenderDoc) to debug shaders
For more advanced users, you need to use frame debuggeres to debug.

## beware of function overhead, discard() floor() etc.. check performance on renderer model (openGL, etc)


## Use DDX & DDY on UVs to Sampling Texture to avoid the issue of sampling hard seams because of a large discontinuity in the mip values of the texture coordinates.