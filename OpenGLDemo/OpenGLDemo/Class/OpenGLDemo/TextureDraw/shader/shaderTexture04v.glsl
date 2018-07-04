

attribute vec4 position;
attribute vec2 textureCoor;

varying vec2 vTextureCoor;

void main(void) {
    //    fragmentColor = inputColor;
    vTextureCoor = textureCoor;
    gl_Position = position;
    gl_PointSize = 100.0;
}
