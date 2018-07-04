
precision mediump float;

varying vec2 vTextureCoor;

uniform sampler2D colorMap0;
//uniform sampler2D colorMap1;

void main(void) {
    gl_FragColor = texture2D(colorMap0, vTextureCoor);
    
//    gl_FragColor = vec4(1, 0, 0, 1);
    
}
