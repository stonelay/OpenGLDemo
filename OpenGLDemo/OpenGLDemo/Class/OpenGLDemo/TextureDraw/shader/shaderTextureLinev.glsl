
attribute vec4 position;
//attribute vec2 textureCoor;


uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

//varying vec2 vTextureCoor;

void main(void) {
    //    fragmentColor = inputColor;
//    vTextureCoor = textureCoor;
    //    gl_Position = position;
    gl_Position = projectionMatrix * modelViewMatrix * position;
//    gl_PointSize = 4.0;
}
