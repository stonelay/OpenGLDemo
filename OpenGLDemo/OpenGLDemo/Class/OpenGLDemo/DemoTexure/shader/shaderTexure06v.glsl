

attribute vec4 position;
attribute vec2 texureCoor;

uniform mat4 rotateMatrix;

varying vec2 vTexureCoor;

void main(void) {
    //    fragmentColor = inputColor;
    vTexureCoor = texureCoor;
    gl_Position = position * rotateMatrix;
}
