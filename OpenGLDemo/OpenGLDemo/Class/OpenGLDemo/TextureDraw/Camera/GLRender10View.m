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

static GLfloat attrArr[] = {
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    -0.5f, -0.5f, -1.0f,    0.0f, 0.0f, // 左下
    0.5f, 0.5f, -1.0f,      1.0f, 1.0f, // 右上
    -0.5f, 0.5f, -1.0f,     0.0f, 1.0f, // 左上
    0.5f, -0.5f, -1.0f,     1.0f, 0.0f, // 右下
};

//static GLfloat positionArr[] = {
//    0.5f, -0.5f, -1.0f,
//    -0.5f, 0.5f, -1.0f,
//    -0.5f, -0.5f, -1.0f,
//    0.5f, 0.5f, -1.0f,
//    -0.5f, 0.5f, -1.0f,
//    0.5f, -0.5f, -1.0f,
//};
//
//static GLfloat corArr[] = {
//    1.0f, 0.0f, // 右下
//    0.0f, 1.0f, // 左上
//    0.0f, 0.0f, // 左下
//    1.0f, 1.0f, // 右上
//    0.0f, 1.0f, // 左上
//    1.0f, 0.0f, // 右下
//};

@interface GLRender10View()<AVCaptureVideoDataOutputSampleBufferDelegate> {
    GLint attributes[NUM_ATTRIBUTES];
    GLint uniforms[NUM_UNIFORMS];
    
    CVOpenGLESTextureCacheRef _videoTextureCache; //cache
    CVOpenGLESTextureRef _videoTexture; // 
    
    CVPixelBufferRef renderTarget;
    
    GLuint _texture;

}

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation GLRender10View


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGLProgram];  // shader
        [self setupData];       // data
        [self setupCache];      // cache
        [self captureDemo];
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
}

#pragma mark - context
- (void)setupGLProgram {
    //加载shader
    self.program = [[ZLGLProgram alloc] init];
    self.program.vShaderFile = @"shaderTexture04v";
    self.program.fShaderFile = @"shaderTexture04f";
    [self.program addAttribute:@"position"];
    [self.program addAttribute:@"textureCoor"];
    [self.program addUniform:@"colorMap0"];
    [self.program compileAndLink];
    attributes[ATTRIBUTE_VERTEX] = [self.program attributeID:@"position"];
    attributes[ATTRIBUTE_TEXTURE_COORD] = [self.program attributeID:@"textureCoor"];
    uniforms[UNIFORM_COLOR_MAP_0] = [self.program uniformID:@"colorMap0"];
}

#pragma mark - data
- (void)setupData {
    // 使用 VBO, 顶点数据在服务端 传偏移量 提高效率
    GLuint attrBuffer;
    glGenBuffers(1, &attrBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    NSLog(@"%u", attrBuffer);
    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
    
    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL + sizeof(GL_FLOAT)*3);
    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
    
    
    glUniform1i(uniforms[UNIFORM_COLOR_MAP_0], 0);
    
    // 不使用 VBO 使用 客户端的数据
//    glVertexAttribPointer(attributes[ATTRIBUTE_VERTEX], 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, positionArr);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_VERTEX]);
//
//    glVertexAttribPointer(attributes[ATTRIBUTE_TEXTURE_COORD], 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 2, corArr);
//    glEnableVertexAttribArray(attributes[ATTRIBUTE_TEXTURE_COORD]);
}

#pragma mark - render
- (void)updateData {}
- (void)draw {
    glDrawArrays(GL_TRIANGLES, 0, 6);
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
    [connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    
    // 5. 启动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [session startRunning];
    });
    
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    //    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //
    //    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    //    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    //    if (!_videoTextureCache)
    //    {
    //        NSLog(@"No video texture cache");
    //        return;
    //    }
    //
    //    if ([EAGLContext currentContext] != self.context) {
    //        [EAGLContext setCurrentContext:self.context];
    //    }
    //    CVReturn err;
    //    err = CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault,
    //                                                        _videoTextureCache,
    //                                                        pixelBuffer,
    //                                                        NULL, // texture attributes
    //                                                        GL_TEXTURE_2D,
    //                                                        GL_RGBA, // opengl format
    //                                                        (int)width,
    //                                                        (int)height,
    //                                                        GL_BGRA, // native iOS format
    //                                                        GL_UNSIGNED_BYTE,
    //                                                        0,
    //                                                        &_videoTexture);
    //    if (err) {
    //        NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    //    }
    //
    //    glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
    //    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    //    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //    [self render];
    //    CFRelease(_videoTexture);
    //    _videoTexture = NULL;
    
    
    
    ////////////
    //     从捕捉到的sampleBuffer中获取基础CVImageBufferRef.
    CVReturn err;
    CVImageBufferRef pixelBuffer =
    CMSampleBufferGetImageBuffer(sampleBuffer);
    // 获取sampleBuffer格式信息中的视频帧维度.
    CMFormatDescriptionRef formatDescription =
    CMSampleBufferGetFormatDescription(sampleBuffer);
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
    
    // 从CVPixelBuffer创建一个OpenGL ES贴图.  (_textureCache  是 由OpenGL的渲染context 生成的 CVOpenGLESTextureCacheRef类型贴图缓存.要用它来显示pixelBuffer)
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _videoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RGBA, //
                                                       dimensions.width,
                                                       dimensions.height,
                                                       GL_BGRA, //
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &_videoTexture);
    
    // 刷新贴图缓存.
    if (_videoTexture) {
        glBindTexture(CVOpenGLESTextureGetTarget(_videoTexture), CVOpenGLESTextureGetName(_videoTexture));
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        [self render];
        CFRelease(_videoTexture);
        _videoTexture = NULL;
    }
    //    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"dropped...");
}


@end

