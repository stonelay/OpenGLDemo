precision mediump float;

varying vec2 vTexureCoor;

uniform sampler2D colorMap0;

void main(void) {
    //    gl_FragColor = fragmentColor;
//    gl_FragColor = vec4(1, 0, 0, 1);
    
    gl_FragColor = texture2D(colorMap0, vTexureCoor);
//    float block = 100.0;
//    float delta = 1.0/block;
//    vec4 maxColor = vec4(-1.0);
//
//    for (int i = -1; i <= 1 ; i++) {
//        for (int j = -1; j <= 1; j++) {
//            float x = vTexureCoor.x + float(i) * delta;
//            float y = vTexureCoor.y + float(i) * delta;
//            maxColor = max(texture2D(colorMap0, vec2(x, y)), maxColor);
//        }
//    }
//
//    maxColor = max(texture2D(colorMap0, vec2(0.1, 0.1)), maxColor);
//    gl_FragColor = maxColor;
}
