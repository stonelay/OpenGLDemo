

uniform sampler2D colorMap0;
//varying lowp vec4 vVertexColor;

void main()
{
//    gl_FragColor = vec4(0, 0, 0, 0) * texture2D(colorMap0, gl_PointCoord);
    gl_FragColor = texture2D(colorMap0, gl_PointCoord);
//    gl_FragColor = vec4(1, 0, 0, 1);
}
