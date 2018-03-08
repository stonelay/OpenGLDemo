//
//  GLRender11View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/26.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender11View.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "ZLGLProgram.h"

#define VERTEXCOUNT  51


@interface GLRender11View() {
    GLuint attrBuffer;
    
    GLint attributes[1];
    GLint uniforms[1];
    
    BOOL firstTouch;
    CGPoint location;
    CGPoint previousLocation;
    BOOL isInited;
    
    GLuint defaultFramebuffer, depthRenderbuffer, colorRenderbuffer;

    GLint framebufferWidth, framebufferHeight;
//    @property (nonatomic, assign) GLint framebufferWidth;
//    @property (nonatomic, assign) GLint framebufferHeight;
    EAGLContext *context;
}

@property (nonatomic, strong) NSMutableArray *pointArray;


@property (nonatomic, strong) ZLGLProgram *program;
//@property (nonatomic, strong) EAGLContext *context;

//@property (nonatomic, assign) GLint framebufferWidth;
//@property (nonatomic, assign) GLint framebufferHeight;


//@property (nonatomic, assign) GLuint defaultFramebuffer;
//@property (nonatomic, assign) GLuint colorRenderbuffer;
//@property (nonatomic, assign) GLuint depthRenderbuffer;

//- (void)setupFramebuffer;
//- (BOOL)presentRenderbuffer;

@end

@implementation GLRender11View

////

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
//        [self setupLayer];
        
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES; // CALayer 默认是透明的，必须将它设为不透明才能让其可见
        // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
        eaglLayer.drawableProperties =
        
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
//        [self setupContext];

        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

        if (!context || ![EAGLContext setCurrentContext:context]) {
                    return nil;
        }
        [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
//        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
//
//        eaglLayer.opaque = YES;
//        // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
//        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
//
//        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//
//        if (!context || ![EAGLContext setCurrentContext:context]) {
//            return nil;
//        }
        
        // Set the view's scale factor as you wish
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"clear");
//            [self clearData];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"draw");
//            [self render];
//        });
    }
    return self;
}

- (void)setupLayer {
    
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.opaque = YES; // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
//    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
//    context = [[EAGLContext alloc] initWithAPI:api];
//    if (!context) {
//        NSLog(@"Failed to initialize OpenGLES 2.0 context");
//        return;
//    }
//
//    if (![EAGLContext setCurrentContext:context]) {
//        NSLog(@"Failed to set OpenGLES 2.0 context");
//        return;
//    }
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!context || ![EAGLContext setCurrentContext:context]) {
//        return nil;
    }
}

//#pragma mark - property
//- (void)setContext:(EAGLContext *)context {
//    if (_context == context) return;
//
//    [self deleteFramebuffer];
//    _context = context;
//    [EAGLContext setCurrentContext:_context];
//}

#pragma mark - public
//- (void)setupFramebuffer {
//    NSLog(@"setupFramebuffer context %@", _context);
//    if (_context) {
//        [EAGLContext setCurrentContext:_context];
//        
//        if (!defaultFramebuffer)
//            [self createFramebuffer];
//        
//        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
//        glViewport(0, 0, framebufferWidth, framebufferHeight);
//    }
//}
//
//- (BOOL)presentRenderbuffer {
//    NSLog(@"%@", [EAGLContext currentContext]);
//    NSLog(@"present context %@", _context);
//    if (!_context) {
//        return NO;
//    }
//    
//    [EAGLContext setCurrentContext:_context];
//    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
//    return [_context presentRenderbuffer:GL_RENDERBUFFER];
//}

#pragma mark - framebuffer creater

- (void)createFramebuffer {
        NSLog(@"framebuffer is %d, current thread is %@", defaultFramebuffer, [NSThread currentThread]);
        [EAGLContext setCurrentContext:context];
        
        // framebuffer
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        //建立颜色缓冲区
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        
        
        //建立深度缓冲区
        //        glGenRenderbuffers(1, &depthRenderbuffer);
        //        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        //        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        //
        //        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        //        glEnable(GL_DEPTH_TEST);
        NSLog(@"framebuffer is %d", defaultFramebuffer);
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
            NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
}

- (void)deleteFramebuffer {
    if (context) {
        [EAGLContext setCurrentContext:context];
        NSLog(@"deleteframebuffer");
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
    }
}

////

//- (instancetype)init {
//    if (self = [super init]) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"clear");
//            [self clearData];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"draw");
//            [self render];
//        });
//        self.contentScaleFactor = [[UIScreen mainScreen] scale];
//    }
//    return self;
//}

- (void)layoutSubviews {
//    [super layoutSubviews];
    [EAGLContext setCurrentContext:context];
    if (!isInited) {
        isInited = YES;
        [self setUp];
        
//        [self clearData];
//        [self render];
    }
}

- (void)setUp {
//    [self setupFramebuffer];
    [self createFramebuffer];
    [self initTexture];
    [self setupGLProgram];  // shader
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    [self performSelector:@selector(render) withObject:nil afterDelay:5];
}

- (void)initTexture {
    // Setup the view port in Pixels
    glViewport(0, 0, framebufferWidth, framebufferHeight);
    
        glGenBuffers(1, &attrBuffer);
    [GLLoadTool setupTexture:@"point" texure:GL_TEXTURE0];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    
    self.program.vShaderFile = @"shaderTexure11v";
    self.program.fShaderFile = @"shaderTexure11f";
    [self.program addAttribute:@"position"];
    [self.program addUniform:@"colorMap0"];
//    [self.program addUniform:@"MVP"];
    [self.program compileAndLink];
    attributes[0] = [self.program attributeID:@"position"];
    uniforms[0] = [self.program uniformID:@"colorMap0"];
//    uniforms[UNIFORM_MVP_MATRIX] = [self.program uniformID:@"MVP"];
    [self.program useProgrm];
    
    // viewing matrices
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 750, 0, 1334, -1, 1);
//    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
//    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
//    glUniformMatrix4fv(uniforms[UNIFORM_MVP_MATRIX], 1, GL_FALSE, MVPMatrix.m);
//
//    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
}

#pragma mark - data

- (NSMutableArray *)pointArray {
    if (!_pointArray) {
        _pointArray = [NSMutableArray new];
        NSInteger count = VERTEXCOUNT;
        GLfloat attrArr[VERTEXCOUNT * 3];
        
        float a = 0.8; // 水平方向的半径
        float b = a * SCREENWIDTH / SCREENHEIGHT;
        float delta = 2.0*M_PI/count;
        
        for (int i = 0; i < count; i++) {
            GLfloat z = 0.0;
            attrArr[i * 3 + 0] = a * cos(delta * i);
            attrArr[i * 3 + 1] = b * sin(delta * i);
            attrArr[i * 3 + 2] = z;
            [_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(a * cos(delta * i), b * sin(delta * i))]];
        }
    }
    return _pointArray;
}

- (void)setupData {
    
    
//    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.framebufferWidth, 0, self.framebufferHeight, -1, 1);
//    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
//    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
//    glUniformMatrix4fv(uniforms[UNIFORM_MVP_MATRIX], 1, GL_FALSE, MVPMatrix.m);
    
    for (int i = 0; i + 1 < self.pointArray.count; i ++) {
//        LYPoint* lyPoint1 = lyArr[i];
//        LYPoint* lyPoint2 = lyArr[i + 1];
//        CGPoint point1, point2;
//        point1.x = lyPoint1.mX.floatValue;
//        point1.y = lyPoint1.mY.floatValue;
//        point2.x = lyPoint2.mX.floatValue;
//        point2.y = lyPoint2.mY.floatValue;

        [self renderLineFromPoint:[self.pointArray[i + 1] CGPointValue] toPoint:[self.pointArray[i] CGPointValue]];
//    current++;
//        if (i == current) {
//            current++;
//            return;
//        }
//
    }
    
//    [self presentRenderbuffer];
    
//    GLuint attrBuffer;
//    glGenBuffers(1, &attrBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
//
////    glEnable(GL_BLEND);
////    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//
//
//
//
//
//    //    GLuint position0 = glGetAttribLocation(self.myProgram, "position");
//    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, NULL);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    
//    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    
    
}

#pragma mark - render

- (void)clearData {
    glClearColor(0.0, 0.0, 1.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    [self.program useProgrm];
    
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//    [self presentRenderbuffer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)render {
//    [self clearData];
//    [self.program useProgrm];
//    [self performSelector:@selector(setupData) withObject:nil afterDelay:6];
    [self setupData];       // data
    
//    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    
//    glDrawArrays(GL_POINTS, 0, VERTEXCOUNT);
    
//    [self presentRenderbuffer];
}


#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect                bounds = [self bounds];
    UITouch*            touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    location = [touch locationInView:self];
    location.y = bounds.size.height - location.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGRect                bounds = [self bounds];
    UITouch*            touch = [[event touchesForView:self] anyObject];
    if (firstTouch) {
        firstTouch = NO;
        previousLocation = [touch previousLocationInView:self];
        previousLocation.y = bounds.size.height - previousLocation.y;
        [self renderLineFromPoint:previousLocation toPoint:location];
    }
//    glDrawArrays(GL_POINTS, 0, VERTEXCOUNT);
//
//    [self presentRenderbuffer];
}


- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
//    [self setupFramebuffer];
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    GLfloat vertexBuffer[2 * 2];
//    static CGFloat *vertexBuffer = NULL;
    
//    NSLog(@"start.x:%f, start.y:%f", start.x, start.y);
    
//    if(vertexBuffer == NULL)
//        vertexBuffer = malloc(100 * 2 * sizeof(GLfloat));

    vertexBuffer[0] = start.x;
    vertexBuffer[1] = start.y;
//    vertexBuffer[2] = -1.0;
//    vertexBuffer[3] = 1.0;
    vertexBuffer[2] = 0.0;
    vertexBuffer[3] = 0.0;
//    vertexBuffer[5] = -1.0;
//    vertexBuffer[7] = 0.0;
//    vertexCount += 1;
    
    // viewing matrices
    
//    glGenBuffers(1, &attrBuffer);
    
    NSLog(@"........ %lu", sizeof(CGFloat));
    
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexBuffer), vertexBuffer, GL_DYNAMIC_DRAW);
    
    NSLog(@"artt %d", attributes[0]);
    
    glEnableVertexAttribArray(attributes[0]);
    glVertexAttribPointer(attributes[0], 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    
    // Draw
    [self.program useProgrm];
    glDrawArrays(GL_POINTS, 0, (int)2);
//    glDrawArrays(GL_LINE_LOOP, 0, 2);
//    GLuint backIndices[] = {0,1};
//    glDrawElements(GL_LINE_LOOP, 2, GL_UNSIGNED_INT, backIndices);
    
//    [self presentRenderbuffer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
