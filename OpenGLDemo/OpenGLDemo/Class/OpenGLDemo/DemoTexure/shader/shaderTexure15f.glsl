varying lowp vec2 TexCoordOut;

uniform sampler2D SamplerY;
uniform sampler2D SamplerU;
uniform sampler2D SamplerV;

void main(void)
{
    mediump vec3 yuv;
    lowp vec3 rgb;
    
//    if (TexCoordOut.x > TexCoordOut.y) {
        yuv.x = texture2D(SamplerY, TexCoordOut).r;
        yuv.y = texture2D(SamplerU, TexCoordOut).r - 0.5;
        yuv.z = texture2D(SamplerV, TexCoordOut).r - 0.5;
//    }
//    } else {
//        yuv.x = texture2D(SamplerY, TexCoordOut).r;
//        yuv.y = 128.0;
//        yuv.z = 128.0;
//    }
    
    // yuv --> rgb
    rgb = mat3( 1,       1,         1,
               0,       -0.39465,  2.03211,
               1.13983, -0.58060,  0) * yuv;
    
    // rgb --> yuv
    //    rgb = mat3( 0.299,       0.587,         0.114,
    //               -0.169,       -0.331,  0.5,
    //               0.5, 0.419,  0.081) * yuv;
    
    gl_FragColor = vec4(rgb, 1);
    
}
