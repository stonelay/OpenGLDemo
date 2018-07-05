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
        [self setupData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!isInited) {
        isInited = YES;
        [self clear];
    }
}

#pragma mark - context
- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexture11v";
    self.program.fShaderFile = @"shaderTexture11f";
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
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 750, 0, 1334, -1, 1);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
    //    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODEL_MATRIX], 1, GL_FALSE, modelViewMatrix.m);
    glUniformMatrix4fv(uniforms[UNIFORM_PROJECTION_MATRIX], 1, GL_FALSE, projectionMatrix.m);
    
    glGenBuffers(1, &aBuffer);
    glGenTextures(1, &textureBuffer);
    
    [self setupTexture:GL_TEXTURE0 buffer:textureBuffer fileName:@"point"];
}

#pragma mark - render

- (void)clear {
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    [self presentRenderbuffer];
}

- (void)render {
//
//    [self.program useProgrm];
    [self updateData];
    [self draw];
    [self presentRenderbuffer];
}

- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
    
    [self setupFramebuffer];//
    
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
    
    glBindBuffer(GL_ARRAY_BUFFER, aBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * 2 * sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    [self presentRenderbuffer];
}

- (void)updateData {
    
}
- (void)draw {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    location = [touch locationInView:self];
    location.y = bounds.size.height - location.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    
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
    
    [self renderLineFromPoint:previousLocation toPoint:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    if (firstTouch) {
        firstTouch = NO;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
        [self renderLineFromPoint:previousLocation toPoint:location];
    }
}



@end
