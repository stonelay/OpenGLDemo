

//attribute vec4 position;
//attribute vec2 texureCoor;
//
//varying vec2 vTexureCoor;
//
//void main(void) {
//    //    fragmentColor = inputColor;
//    vTexureCoor = texureCoor;
////    gl_Position = position;
//    gl_Position = position;
////    gl_PositionSize = 
//}


attribute vec4 position;
attribute vec2 texureCoor;


uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

varying vec2 vTexureCoor;

void main(void) {
    //    fragmentColor = inputColor;
    vTexureCoor = texureCoor;
    //    gl_Position = position;
    gl_Position = projectionMatrix * modelViewMatrix * position;
}
