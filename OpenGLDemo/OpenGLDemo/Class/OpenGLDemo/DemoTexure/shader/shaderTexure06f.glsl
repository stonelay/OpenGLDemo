
precision mediump float;

varying vec2 vTexureCoor;

uniform sampler2D colorMap0;
//uniform sampler2D colorMap1;

void main(void) {
        gl_FragColor = texture2D(colorMap0, vTexureCoor);
    
//
//    vec4 color1 = texture2D(colorMap0, vTexureCoor);
//    vec4 color2 = texture2D(colorMap1, vTexureCoor);
//    gl_FragColor = vec4(vec3(1.5 * color1 * color2), 1.0);
    
    
}
