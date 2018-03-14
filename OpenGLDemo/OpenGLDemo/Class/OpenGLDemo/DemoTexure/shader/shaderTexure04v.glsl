

attribute vec4 position;
attribute vec2 texureCoor;

varying vec2 vTexureCoor;

void main(void) {
    //    fragmentColor = inputColor;
    vTexureCoor = texureCoor;
    gl_Position = position;
    gl_PointSize = 4.0;
}
