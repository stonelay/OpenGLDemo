//
//  GLRender10View.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/12.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "GLRender10View.h"
#import <AVFoundation/AVFoundation.h>
#import "ZLGLProgram.h"

#import "MAsync.h"

@interface GLRender10View()<AVCaptureVideoDataOutputSampleBufferDelegate> {
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    CVOpenGLESTextureCacheRef _videoTextureCache;
    
    CVOpenGLESTextureRef _videoTexture;
    CVPixelBufferRef renderTarget;
    
    GLuint _texture;
    
    dispatch_semaphore_t semaphore;
}

//@property (nonatomic, strong) ZLGLProgram *program;

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation GLRender10View


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
//        [self setupData];       // data
        [self setupCache];
        [self captureDemo];
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)setupCache {
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    if (_videoTextureCache) {
        return;
    }
    
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, self.context, NULL, &_videoTextureCache);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        return;
    }
    
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupFramebuffer];
    [self render];
}

#pragma mark - context

- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    self.program.vShaderFile = @"shaderTexure04v";
    self.program.fShaderFile = @"shaderTexure04f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"texureCoor"];
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"texureCoor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
    
}

#pragma mark - data
- (void)setupData {
    GLfloat attrArr[] = {
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
        -0.5f, -0.5f, -1.0f,    0.0f, 0.0f, // 左下
        0.5f, 0.5f, -1.0f,      1.0f, 1.0f, // 右上
        -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
        0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
    };
    
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
//    if (a) {
//    GLuint texture = [self setupTexture:@"for_test02"];
//    }
    
   
    
    
    
//    GLuint buffer1;
//    glGenTextures(1, &buffer1);
//    glBindTexture(GL_TEXTURE_2D, buffer1);
//
//
//    float fw = width, fh = height;
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
//    glActiveTexture(GL_TEXTURE0);
//
//    glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//
//
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_videoTexture), 0);
    
    
//    glActiveTexture(GL_TEXTURE0);
//
//    GLuint buffer1;
//    glGenTextures(1, &buffer1);
//    glBindTexture(GL_TEXTURE_2D, buffer1);
//
    glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
//    float fw = width, fh = height;
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    
}

#pragma mark - render

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.program useProgrm];
    [self setupData];
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [self presentRenderbuffer];
}

- (GLuint)setupTexture:(NSString *)fileName {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    glActiveTexture(GL_TEXTURE0);
    
    GLuint buffer1;
    glGenTextures(1, &buffer1);
    glBindTexture(GL_TEXTURE_2D, buffer1);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
    return buffer1;
}

#pragma mark - avssion

- (void)captureDemo {
    
    // 1. 初始化session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    // 2. 输入设备 摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    // 3. 输出
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
//    [output setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
//                                                         forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [output setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    // 如果有延迟，是否丢掉这一帧
    [output setAlwaysDiscardsLateVideoFrames:YES];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    // 4. 旋转屏幕
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    // 5. 启动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [session startRunning];
    });
    
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFRetain(sampleBuffer);
    NSLog(@".....ppp");
    
    NSLog(@"1");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    runAsync(^{
    NSLog(@".....ppp...");
        
        
        NSLog(@"2");
        
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        size_t width = CVPixelBufferGetWidth(pixelBuffer);
        size_t height = CVPixelBufferGetHeight(pixelBuffer);
        if (!_videoTextureCache)
        {
            NSLog(@"No video texture cache");
            return;
        }
        
        if ([EAGLContext currentContext] != self.context) {
            [EAGLContext setCurrentContext:self.context];
        }
        CVReturn err;
        err = CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault,
                                                            _videoTextureCache,
                                                            pixelBuffer,
                                                            NULL, // texture attributes
                                                            GL_TEXTURE_2D,
                                                            GL_RGBA, // opengl format
                                                            (int)width,
                                                            (int)height,
                                                            GL_BGRA, // native iOS format
                                                            GL_UNSIGNED_BYTE,
                                                            0,
                                                            &_videoTexture);
        if (err) {
            NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
        }
        
        //        glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
        //        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        //        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
//        [self render];
//        sleep(1);
        
        CFRelease(sampleBuffer);
        dispatch_semaphore_signal(semaphore);
        NSLog(@"3");
    });
    
    
//    glActiveTexture(GL_TEXTURE0);
    

    
//    glActiveTexture(GL_TEXTURE1);
//    glGenTextures(1, &_texture);
//    glBindTexture(GL_TEXTURE_2D, _texture);
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//
//    glBindTexture(GL_TEXTURE_2D, _texture);
//
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_BGRA, GL_UNSIGNED_BYTE, 0);
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
    
//
//    glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(_videoTexture), 0);
    
//    a = NO;
//    [self setupTexture:@"for_test01"];
//    [self render];
//        glActiveTexture(GL_TEXTURE0);
    //
    //    GLuint buffer1;
    //    glGenTextures(1, &buffer1);
    //    glBindTexture(GL_TEXTURE_2D, buffer1);
    //
//    glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    [self presentRenderbuffer];
//    if ([EAGLContext currentContext] == _context) {
//        [_context presentRenderbuffer:GL_RENDERBUFFER];
//    }
//    [self presentRenderbuffer];
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"dropped...");
}


@end
