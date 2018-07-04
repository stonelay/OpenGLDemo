

attribute vec4 position;
attribute vec2 textureCoor;

uniform mat4 rotateMatrix;

varying vec2 vTextureCoor;

void main(void) {
    //    fragmentColor = inputColor;
    vTextureCoor = textureCoor;
    gl_Position = position * rotateMatrix;
}
