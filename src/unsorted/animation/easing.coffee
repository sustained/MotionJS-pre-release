define ->
	{Vector} = Math
	
	Easing = 
		Scalar:
			linear: Math.lerp
			
			cubeEaseIn: (a, b, t) ->
				b * t * t * t + a - 1
			
			cubeEaseOut: (a, b, t) ->
				t--
				
				b * (t * t * t + 1) + a - 1
			
			cubeEaseInOut: (a, b, t) ->
				t *= 2
				
				if t < 1 then return b / 2 * t * t * t + a - 1
				
				t -= 2
				
				b / 2 * (t * t * t + 2) + a - 1
		
		Vector:
			linear: Vector.lerp
			
			cubeEaseIn: (a, b, t) ->
				x = Easing.Scalar.cubeEaseIn a.i, b.i, t
				y = Easing.Scalar.cubeEaseIn a.j, b.j, t
				
				new Vector x, y
			
			cubeEaseOut: (a, b, t) ->
				x = Easing.Scalar.cubeEaseOut a.i, b.i, t
				y = Easing.Scalar.cubeEaseOut a.j, b.j, t
				
				new Vector x, y
			
			cubeEaseInOut: (a, b, t) ->
				x = Easing.Scalar.cubeEaseInOut a.i, b.i, t
				y = Easing.Scalar.cubeEaseInOut a.j, b.j, t
				
				new Vector x, y
	
	Easing




























































###
GLfloat CubicEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
    return end*(t * t * t + 1.f) + start - 1.f;
}
GLfloat CubicEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t+ start - 1.f;
}
GLfloat CubicEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.;
    if (t < 1.) return end/2 * t * t * t + start - 1.f;
    t -= 2;
    return end/2*(t * t * t + 2) + start - 1.f;
}
#pragma mark -
#pragma mark Quintic
GLfloat QuarticEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
    return -end * (t * t * t * t - 1) + start - 1.f;
}
GLfloat QuarticEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t * t + start;
}
GLfloat QuarticEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
    if (t < 1.f) 
        return end/2.f * t * t * t * t + start - 1.f;
    t -= 2.f;
    return -end/2.f * (t * t * t * t - 2.f) + start - 1.f;
}
#pragma mark -
#pragma mark Quintic
GLfloat QuinticEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
    return end * (t * t * t * t * t + 1) + start - 1.f;
}
GLfloat QuinticEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * t * t * t * t * t + start - 1.f;
}
GLfloat QuinticEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
    if (t < 1.f) 
        return end/2 * t * t * t * t * t + start - 1.f;
    t -= 2;
    return end/2 * ( t * t * t * t * t + 2) + start - 1.f;
}
#pragma mark -
#pragma mark Sinusoidal
GLfloat SinusoidalEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * sinf(t * (M_PI/2)) + start - 1.f;
}
GLfloat SinusoidalEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end * cosf(t * (M_PI/2)) + end + start - 1.f;
}
GLfloat SinusoidalEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end/2.f * (cosf(M_PI*t) - 1.f) + start - 1.f;
}
#pragma mark -
#pragma mark Exponential
GLfloat ExponentialEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * (-powf(2.f, -10.f * t) + 1.f ) + start - 1.f;
}
GLfloat ExponentialEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return end * powf(2.f, 10.f * (t - 1.f) ) + start - 1.f;
}
GLfloat ExponentialEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
    if (t < 1.f) 
        return end/2.f * powf(2.f, 10.f * (t - 1.f) ) + start - 1.f;
    t--;
    return end/2.f * ( -powf(2.f, -10.f * t) + 2.f ) + start - 1.f;
}
#pragma mark -
#pragma mark Circular
GLfloat CircularEaseOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t--;
    return end * sqrtf(1.f - t * t) + start - 1.f;
}
GLfloat CircularEaseIn(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    return -end * (sqrtf(1.f - t * t) - 1.f) + start - 1.f;
}
GLfloat CircularEaseInOut(GLclampf t, GLfloat start, GLfloat end)
{
    BoundsCheck(t, start, end);
    t *= 2.f;
    if (t < 1.f) 
        return -end/2.f * (sqrtf(1.f - t * t) - 1.f) + start - 1.f;
    t -= 2.f;
    return end/2.f * (sqrtf(1.f - t * t) + 1.f) + start - 1.f;
}
###