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
    
//    float block = 150.0;
//    float delta = 1.0/block;
//    vec4 color = vec4(0.0);
//
//    float factor[9];
//    factor[0] = 0.0947416; factor[1] = 0.118318; factor[2] = 0.0947416;
//    factor[3] = 0.118318; factor[4] = 0.147761; factor[5] = 0.118318;
//    factor[6] = 0.0947416; factor[7] = 0.118318; factor[8] = 0.0947416;
//
//    for (int i = -1; i <= 1; i++) {
//        for (int j = -1; j <= 1; j++) {
//            float x = max(0.0, vTexureCoor.x + float(i) * delta);
//            float y = max(0.0, vTexureCoor.y + float(i) * delta);
//            color += texture2D(colorMap0, vec2(x, y)) * factor[(i+1)*3+(j+1)];
//        }
//    }
//
//    //gl_FragColor = texture2D(image, vTexureCoor);
//    gl_FragColor = vec4(vec3(color), 1.0);
}
