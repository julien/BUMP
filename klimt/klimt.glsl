// Author: Nicolas Barradeau
// Title: klimt

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

#define PROCESSING_COLOR_SHADER
const vec3 blue				= vec3( 0.4453125, 	0.890625, 	0.890625 );
const vec3 yellow_bright	= vec3( 0.9296875, 	0.8671875, 	0.18359375 );
const vec3 yellow_dark		= vec3( 0.921875,  	0.80078125, 0.);
const vec3 orange			= vec3( 0.88671875, 0.625,		0.1171875);
const vec3 pink				= vec3( 0.92578125, 0.46484375,	0.89453125);

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

const float MAX_TRACE_DIST = 50.0;
const float MIN_HIT_DIST = 0.001;	
const int MAX_NUM_STEPS = 100;		

float hash( float n ) { return fract(sin(n)*753.5453123); }
float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*157.0 + 113.0*p.z;
    return mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                   mix( hash(n+157.0), hash(n+158.0),f.x),f.y),
               mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+270.0), hash(n+271.0),f.x),f.y),f.z);
}

vec2 opU( vec2 a, vec2 b ) { return (a.x < b.x) ? a : b; }
float sdPlane(in vec3 p) { return p.y; }
float sdSphere(in vec3 p, float s){
    float d1 = length(p) - s;
   	return d1;
}

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v){
  const vec4 C = vec4(0.211324865405187,  
                      0.366025403784439,  
                     -0.577350269189626,  
                      0.024390243902439); 
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod289(i);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float getColor( in vec2 uv )
{
    float m = 4.5;
    float t = u_time * .01;
    float noise = snoise( vec2( m * uv.x + t, m * uv.y - t ));
    noise += snoise( uv);
    return noise * 12.;
}

vec2 map(in vec3 pos, in vec2 uv){

    vec2 res = vec2( 	  sdPlane(pos - vec3(0.0, -2.0, 0.0)),       1.0 );
    res = opU( res, vec2(sdSphere(pos-vec3( 2.5,0.,0.), 	1.5+ sin( u_time*.1)*.25),2.) );

  	float freq = getColor( uv );
  	float d1 = 0.1*sin(freq * pos.x) * sin(freq * pos.y + 0.8) * sin(freq * pos.z + 0.3);
  	float d2 = 0.1*sin(freq * pos.x) * sin(freq * pos.y + 0.8) * sin(freq * pos.z + 0.3);
    return vec2( res.x -  d2, 1. );
}

float softshadow( in vec3 ro, in vec3 rd, in float mint, in float tmax ){
	float res = 1.0;
    float t = mint;
    for(int i = 0; i < 16; ++i)
    {
		float h = map(ro + rd * t, vec2(1.)).x;
        res = min(res, 8.0 * h / t);	
        t += clamp(h, 0.02, 0.10);
        if(h < 0.001 || t > tmax) break;
    }
    return clamp( res, 0.0, 1.0 );
}

vec3 calcNormal(in vec3 pos, in vec2 uv ){
    vec3 eps = vec3(0.001, 0.0, 0.0);
	vec3 nor = vec3(
	    map(pos+eps.xyy, uv).x - map(pos-eps.xyy, uv).x,
	    map(pos+eps.yxy, uv).x - map(pos-eps.yxy, uv).x,
	    map(pos+eps.yyx, uv).x - map(pos-eps.yyx, uv).x);
	return normalize(nor);
}

vec2 calcIntersection(in vec3 ro, in vec3 rd, in vec2 uv ){
    float h =  MIN_HIT_DIST * 2.0;	
    float t = 0.0;					
	float finalDist = -1.0;			
    float id = -1.0;
    for(int i = 0; i < MAX_NUM_STEPS; ++i){
    	if(h < MIN_HIT_DIST || t > MAX_TRACE_DIST) break;

        vec2 distToClosest = map(ro + rd * t, uv);
        h = distToClosest.x;	
        id = distToClosest.y;	
        t += h;					
    }

    if(t < MAX_TRACE_DIST) finalDist = t;
    if(t > MAX_TRACE_DIST) id = -1.0;
    return vec2(finalDist, id);
}

vec3 render(in vec3 ro, in vec3 rd, in vec2 uv) {
    
    float ssDistToCenter = length(uv);
    vec3 bgColor1 = vec3(0.6, 0.2, 0.9);
    vec3 bgColor2 = vec3(0.0, 0.2, 0.8);
    vec3 surfaceColor = vec3(1.);

    vec2 results = calcIntersection(ro, rd, uv);
    float t = results.x;						
    float id = results.y;						

    vec3 lightPos = vec3(0.0,10.000,0.0);
    vec3 pos = ro + rd * t;
    vec3 n = calcNormal(pos, uv);
    vec3 diffColor = orange;
    n += noise( n + getColor( uv ) );
    vec3 l = normalize(lightPos - pos);
    float diffStrength = max( pow( dot(n, l), 2. ), 0.0 );
    float ambientStrength = clamp(0.5 + .5 * n.y, 0.0, 1.0);
    vec3 ambientColor = vec3( 0. );
    surfaceColor = diffStrength * diffColor + ambientColor;

    return surfaceColor;
}

mat3 setCamMatrix(in vec3 ro, in vec3 ta, float roll)
{
	vec3 ww = normalize(ta - ro);	
    vec3 uu = normalize(cross(ww, vec3(sin(roll), cos(roll), 0.0)));
    vec3 vv = normalize(cross(uu, ww));
    return mat3(uu, vv, ww);
}

void main()
{
    
   	vec2 p = (-u_resolution.xy + 2.0 * gl_FragCoord.xy) / u_resolution.y;

    float radius = 5.0;
    float camX = 7.;
    float camZ = 0.;

    vec3 ro = vec3( camX, 00.0, camZ);									
	vec3 ta = vec3(0.0);											
    mat3 cameraMatrix = setCamMatrix(ro, ta, 0.0);					
    
    float lensLength = 2.0;
    vec3 rd = normalize(cameraMatrix * vec3(p.xy, lensLength));		
    
    vec3 color = render(ro, rd, p);
    gl_FragColor = vec4(color, 1.0);
}