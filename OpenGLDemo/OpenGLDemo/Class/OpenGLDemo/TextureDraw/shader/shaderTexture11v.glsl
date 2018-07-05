

attribute vec4 position;

uniform mat4 projection;
uniform mat4 model;

//uniform mat4 mvp;

//varying vec2 vVertexColor;


void main(void) {
    
//    vTextureCoor = vertexColor;
    gl_Position = model * projection * position;
    gl_PointSize = 32.0;
}
