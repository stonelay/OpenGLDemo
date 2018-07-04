//
//  GLRender11View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/8.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender11View.h"

#import <GLKit/GLKit.h>

#define PointSize 50

@interface GLRender11View() {
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    GLuint aBuffer;
    GLuint textureBuffer;
    
    BOOL isInited;
    
    BOOL firstTouch;
    CGPoint location;
    CGPoint previousLocation;
}

@property (nonatomic, strong) NSMutableArray *pointArray;

@end

@implementation GLRender11View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (!isInited) {
        isInited = YES;
        
        [self setupFramebuffer];
        [self clear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self render];
        });
        
//    }
}

#pragma mark - context

- (void)setupGLProgram {
    glGenBuffers(1, &aBuffer);
    glGenTextures(1, &textureBuffer);
    
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"pic_earth"];
    
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexure11v";
    self.program.fShaderFile = @"shaderTexure11f";
    [self.program addAttribute:@"position"];
    [self.program addUniform:@"colorMap0"];
    [self.program addUniform:@"model"];
    [self.program addUniform:@"projection"];
//    [self.program addUniform:@"mvp"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"model"];
    uniforms[UNIFORM_PROJECTION_MATRIX] = [self.program uniformID:@"projection"];
//    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"mvp"];
    
    [self.program useProgrm];
    
    
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}


#pragma mark - data
- (void)setupData {
    for (int i = 0; i + 1 < self.pointArray.count; i ++) {
        [self renderLineFromPoint:[self.pointArray[i] CGPointValue] toPoint:[self.pointArray[i + 1] CGPointValue]];
    }
//    glGenBuffers(1, &attrBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
//
//    //    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
//    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
//
//    //    GLuint texureCoor = glGetAttribLocation(self.myProgram, "texureCoor");
//    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
//
//    GLuint txure01 = [self setupTexture:@"for_test01" texure:GL_TEXTURE0];
//    GLuint txure02 = [self setupTexture:@"for_test02" texure:GL_TEXTURE1];
//
//    //    GLuint buffer0 = glGetUniformLocation(self.myProgram, "colorMap0");
//    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
//
//    //    GLuint buffer1 = glGetUniformLocation(self.myProgram, "colorMap1");
//    glUniform1i(uniforms[UNIFORM_COLOR_MAP_1], 1);
}

#pragma mark - render

- (void)clear {
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    
    
    [self presentRenderbuffer];
}

- (void)render {
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 750, 0, 1334, -1, 1);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
//    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, modelViewMatrix.m);
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, projectionMatrix.m);
    
    [self.program useProgrm];
    [self setupData];
    
//    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    
}


- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray new];
        NSInteger count = PointSize;
        
        float a = 0.8; // 水平方向的半径
        float b = a * SCREENWIDTH / SCREENHEIGHT;
        float delta = 2.0*M_PI/count;
        
        for (int i = 0; i < count; i++) {
            [_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(a * cos(delta * i), b * sin(delta * i))]];
        }
    }
    return _pointArray;
}


- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
    
    [self setupFramebuffer];
    
    static GLfloat*        vertexBuffer = NULL;
//    static GLfloat        vertexBuffer[2 * 1];
    static NSUInteger    vertexMax = 64;
    NSUInteger            vertexCount = 0,
    count,
    i;
    
//    Convert locations from Points to Pixels
    CGFloat scale = self.contentScaleFactor;
    start.x *= scale;
    start.y *= scale;
    end.x *= scale;
    end.y *= scale;
    
//    Allocate vertex array buffer
    if(vertexBuffer == NULL)
        vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
    
//    Add points to the buffer so there are drawing points every X pixels
    count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / 3),
                1);
    for(i = 0; i < count; ++i) {
        if(vertexCount == vertexMax) {
            vertexMax = 2 * vertexMax;
            vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
        }
        
        vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
        vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
        vertexCount += 1;
    }
    
    
//    vertexBuffer[0] = start.x;
//    vertexBuffer[1] = start.y;
//    NSLog(@"x,%f y,%f, count, %lu", start.x, start.y, (unsigned long)vertexCount);
    // Load data to the Vertex Buffer Object
    glBindBuffer(GL_ARRAY_BUFFER, aBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * 2 * sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    // Draw
    //    glUseProgram(program[PROGRAM_POINT].id);
    [self.program useProgrm];
    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    
    [self presentRenderbuffer];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect                bounds = [self bounds];
    UITouch*            touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    location = [touch locationInView:self];
    location.y = bounds.size.height - location.y;
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect                bounds = [self bounds];
    UITouch*            touch = [[event touchesForView:self] anyObject];
    
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    if (firstTouch) {
        firstTouch = NO;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
    } else {
        location = [touch locationInView:self];
        location.y = bounds.size.height - location.y;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
    }
    
    // Render the stroke
    [self renderLineFromPoint:previousLocation toPoint:location];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect                bounds = [self bounds];
    UITouch*            touch = [[event touchesForView:self] anyObject];
    if (firstTouch) {
        firstTouch = NO;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
        [self renderLineFromPoint:previousLocation toPoint:location];
    }
}



@end
