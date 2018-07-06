

attribute vec4 position;

uniform mat4 projection;
uniform mat4 model;
uniform lowp vec4 vertexColor;
uniform float pointSize;

//uniform mat4 mvp;

varying lowp vec4 vVertexColor;


void main(void) {
    
    vVertexColor = vertexColor;
    gl_Position = model * projection * position;
    gl_PointSize = pointSize;
}
