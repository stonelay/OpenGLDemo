//
//  GLRender11View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/3/8.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender11View.h"

#import <GLKit/GLKit.h>

#import "PanSetting11View.h"
#import "DrawModel.h"

#define PointSize 50


static GLfloat brushColor[4];          // brush color

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


@property (nonatomic, strong) NSMutableArray *paintingArray;
@property (nonatomic, strong) NSMutableArray *pointArray;

@property (nonatomic, strong) PanSetting11View *settingView;


@end

@implementation GLRender11View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
        [self setupData];
        [self addSubview:self.settingView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self clear];
    
    self.drawElement = self.settingView.drawElement;
}

- (PanSetting11View *)settingView {
    if (!_settingView) {
        _settingView = [[PanSetting11View alloc] initWithFrame:CGRectMake(0, NAVBARHEIGHT, SCREENWIDTH, 200)];
        _settingView.renderView = self;
    }
    return _settingView;
}

- (NSMutableArray *)paintingArray {
    if (!_paintingArray) {
        _paintingArray = [[NSMutableArray alloc] init];
    }
    return _paintingArray;
}

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc] init];
    }
    return _pointArray;
}

- (void)setDrawElement:(DrawElement *)drawElement {
    _drawElement = drawElement;
    [self updateData];
}

#pragma mark - context
- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexture11v";
    self.program.fShaderFile = @"shaderTexture11f";
    [self.program addAttribute:@"position"];
    [self.program addUniform:@"vertexColor"];
    [self.program addUniform:@"colorMap0"];
    [self.program addUniform:@"model"];
    [self.program addUniform:@"projection"];
    [self.program addUniform:@"pointSize"];
//    [self.program addUniform:@"mvp"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    uniforms[UNIFORM_COLOR] = [self.program uniformID:@"vertexColor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    uniforms[UNIFORM_MODEL_MATRIX] = [self.program uniformID:@"model"];
    uniforms[UNIFORM_PROJECTION_MATRIX] = [self.program uniformID:@"projection"];
    uniforms[UNIFORM_POINT_SIZE] = [self.program uniformID:@"pointSize"];
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
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0); // 默认第一个
}

- (void)updateData {
    glUniform1f(uniforms[UNIFORM_POINT_SIZE], self.drawElement.pointSize);
    
    brushColor[0] = self.drawElement.r;
    brushColor[1] = self.drawElement.g;
    brushColor[2] = self.drawElement.b;
    brushColor[3] = 0.6;
    
    glUniform4fv(uniforms[UNIFORM_COLOR], 1, brushColor);
}

#pragma mark - render

- (void)propareClear {
    glClearColor(0.2, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
}

- (void)render {
}

- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end realTime:(BOOL)isRealTime {
    
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
    if (isRealTime) {
        [self presentRenderbuffer];
    }
}

//- (void)updateData {
//
//}
//- (void)draw {
//
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateData];
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    previousLocation = [touch locationInView:self];
    previousLocation.y = bounds.size.height - previousLocation.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    if (firstTouch) {
        firstTouch = NO;
        location = [touch locationInView:self];
        location.y = bounds.size.height - location.y;
    } else {
        location = [touch locationInView:self];
        location.y = bounds.size.height - location.y;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
    }
    
    [self renderLineFromPoint:previousLocation toPoint:location realTime:YES];
    [self.paintingArray addObject:[LineModel lineWithBeginPoint:previousLocation endPoint:location]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect bounds = [self bounds];
    UITouch *touch = [[event touchesForView:self] anyObject];
    if (firstTouch) {
        firstTouch = NO;
        location = [touch locationInView:self];
        location.y = bounds.size.height - location.y;
        [self renderLineFromPoint:previousLocation toPoint:location realTime:YES];
        [self.paintingArray addObject:[LineModel lineWithBeginPoint:previousLocation endPoint:location]];
    }
    
    DrawModel *drawModel = [[DrawModel alloc] init];
    drawModel.lineArray = [self.paintingArray copy];
    drawModel.drawElement = self.drawElement;
    
    [self.pointArray addObject:drawModel];
    [self.paintingArray removeAllObjects];
}

#pragma mark - public
- (void)clear {
    [self propareClear];
    [self presentRenderbuffer];
}

- (void)replay {
    [self clear];
    for (DrawModel *model in self.pointArray) {
        self.drawElement = model.drawElement;
        for (LineModel *lineModel in model.lineArray) {
            [self renderLineFromPoint:lineModel.beginPoint toPoint:lineModel.endPoint realTime:YES];
        }
    }
    self.drawElement = self.settingView.drawElement;
}

- (void)undo {
    [self propareClear];
    
    [self.pointArray removeLastObject];
    for (DrawModel *model in self.pointArray) {
        self.drawElement = model.drawElement;
        for (LineModel *lineModel in model.lineArray) {
            [self renderLineFromPoint:lineModel.beginPoint toPoint:lineModel.endPoint realTime:NO];
        }
    }
    [self presentRenderbuffer];
    self.drawElement = self.settingView.drawElement;
}

@end
