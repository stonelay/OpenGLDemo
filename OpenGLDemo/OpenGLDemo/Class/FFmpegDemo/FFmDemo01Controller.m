//
//  FFmDemo01Controller.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/2/22.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "FFmDemo01Controller.h"
#import "avformat.h"
#import "imgutils.h"
#import "swscale.h"

#import "GLRender15View.h"

// ffmpeg 解封装 解编码

@interface FFmDemo01Controller ()

@end

@implementation FFmDemo01Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[GLRender15View alloc] init];
//    [self decode];
    
    
//    GLRender15View *view = (GLRender15View *)self.view;


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self decode];
    });
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"176x144_yuv420p" ofType:@"yuv"];
    
//    NSData *reader = [NSData dataWithContentsOfFile:filePath];
//    NSLog(@"the reader length is %i", reader.length);
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [view displayYUV420pData:[reader bytes] width:256 height:256];
//    [view displayYUV420pData:[reader bytes] width:176 height:144];
//    //    });
//
//    [view bk_whenTapped:^{
//        [view displayYUV420pData:[reader bytes] width:176 height:144];
//    }];
}

- (void)decode {
    AVFormatContext *pFormatCtx;
    int             i, videoindex;
    AVCodecContext  *pCodecCtx;
    AVCodec         *pCodec;
    AVFrame *pFrame,*pFrameYUV;
    uint8_t *out_buffer;
    AVPacket *packet;
    int y_size;
    int ret, got_picture;
    struct SwsContext *img_convert_ctx;
    FILE *fp_yuv;
    int frame_cnt;
    clock_t time_start, time_finish;
    double  time_duration = 0.0;
    
    char input_str_full[500]={0};
    char output_str_full[500]={0};
    char info[1000]={0};
    
    NSString *input_str= [NSString stringWithFormat:@"SourceBundle.bundle/%@", @"hello.mp4"];
    NSString *output_str= [NSString stringWithFormat:@"%@", @"test.yuv"];
//    NSString *output_str = [NSString stringWithFormat:@"%@/%@", [self getFilePath], @"test.yuv"];
    
    NSString *input_nsstr=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:input_str];
//    NSString *output_nsstr=[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:output_str];
    NSString *output_nsstr=[NSString stringWithFormat:@"%@/%@", [self getFilePath], output_str];
    
    
    sprintf(input_str_full,"%s",[input_nsstr UTF8String]);
    sprintf(output_str_full,"%s",[output_nsstr UTF8String]);
    
    printf("Input Path:%s\n",input_str_full);
    printf("Output Path:%s\n",output_str_full);
    
    // 1. regist all
    /** 在使用FFMPEG解码媒体文件之前，我们首先需要注册FFMPEG的各种组件，通过
     这个函数，可以注册所有支持的容器和对应的codec。**/
    av_register_all();
    avformat_network_init(); //？
    
    // 2.统领全局的基本结构体。主要用于处理封装格式（FLV/MKV/RMVB等）
    /** 打开一个媒体文件，并获得媒体文件封装格式的上下文。之后我们就可以通过遍历定义在libavformat/avformat.h里保存着媒体文件中封装的流数量的nb_streams在媒体文件中分离出音视频流。 **/
    pFormatCtx = avformat_alloc_context();
    if(avformat_open_input(&pFormatCtx,input_str_full,NULL,NULL)!=0){
        printf("Couldn't open input stream.\n");
        return ;
    }
    if(avformat_find_stream_info(pFormatCtx,NULL)<0){
        printf("Couldn't find stream information.\n");
        return;
    }
    
    /** 分离出音视频流之后，就可以对音视频流分别进行解码了。
     我们可以遍历AVStream找到codec_type为AVMEDIA_TYPE_VIDEO的的AVStream即为视频流的索引值。
     这里先以视频解码为例。**/
    videoindex=-1;
    NSLog(@"=== %d", pFormatCtx->nb_streams);
    for(i=0; i<pFormatCtx->nb_streams; i++) {
        if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
            videoindex=i;
            break;
        }
    }
    
    if(videoindex==-1){
        printf("Couldn't find a video stream.\n");
        return;
    }
    
    /** 然后我们就可以通过AVStream来找到对应的AVCodecContext即编解码器的上下文 **/
    pCodecCtx=pFormatCtx->streams[videoindex]->codec;
    
    /** 之后就可以通过这个上下文，来找到对应的解码器。 **/
    pCodec=avcodec_find_decoder(pCodecCtx->codec_id);
    if(pCodec==NULL){
        printf("Couldn't find Codec.\n");
        return;
    }
    
    /** 再打开解码器 **/
    if(avcodec_open2(pCodecCtx, pCodec,NULL)<0){
        printf("Couldn't open codec.\n");
        return;
    }
    
    // frame 分配内存
    pFrame=av_frame_alloc();
    pFrameYUV=av_frame_alloc();
    
    NSLog(@"===--- %d %d", pCodecCtx->width, pCodecCtx->height);
    // 缓冲区 分配内存
    out_buffer=(unsigned char *)av_malloc(av_image_get_buffer_size(AV_PIX_FMT_YUV420P,  pCodecCtx->width, pCodecCtx->height,1));
    // 初始化
    av_image_fill_arrays(pFrameYUV->data, pFrameYUV->linesize,out_buffer,
                         AV_PIX_FMT_YUV420P,pCodecCtx->width, pCodecCtx->height,1);
    packet=(AVPacket *)av_malloc(sizeof(AVPacket));
    
    // 用于缩放
    img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt,
                                     pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_YUV420P, SWS_BICUBIC, NULL, NULL, NULL);
    
    
    sprintf(info,   "[Input     ]%s\n", [input_str UTF8String]);
    sprintf(info, "%s[Output    ]%s\n",info,[output_str UTF8String]);
    sprintf(info, "%s[Format    ]%s\n",info, pFormatCtx->iformat->name);
    sprintf(info, "%s[Codec     ]%s\n",info, pCodecCtx->codec->name);
    sprintf(info, "%s[Resolution]%dx%d\n",info, pCodecCtx->width,pCodecCtx->height);
    
    
    fp_yuv=fopen(output_str_full,"wb+");
    if(fp_yuv==NULL){
        printf("Cannot open output file.\n");
        return;
    }
    
    frame_cnt=0;
    time_start = clock();
    
    while(av_read_frame(pFormatCtx, packet)>=0){
        NSLog(@"%d", packet->stream_index);
        if(packet->stream_index==videoindex){
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if(ret < 0){
                printf("Decode Error.\n");
                return;
            }
            if(got_picture){
                sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height,
                          pFrameYUV->data, pFrameYUV->linesize);
                
                y_size=pCodecCtx->width*pCodecCtx->height;
                fwrite(pFrameYUV->data[0],1,y_size,fp_yuv);    //Y
                fwrite(pFrameYUV->data[1],1,y_size/4,fp_yuv);  //U
                fwrite(pFrameYUV->data[2],1,y_size/4,fp_yuv);  //V
                //Output info
                char pictype_str[10]={0};
                switch(pFrame->pict_type){
                    case AV_PICTURE_TYPE_I:sprintf(pictype_str,"I");break;
                    case AV_PICTURE_TYPE_P:sprintf(pictype_str,"P");break;
                    case AV_PICTURE_TYPE_B:sprintf(pictype_str,"B");break;
                    default:sprintf(pictype_str,"Other");break;
                }
                printf("Frame Index: %5d. Type:%s\n",frame_cnt,pictype_str);
                frame_cnt++;
                
                [(GLRender15View *)self.view displayYUV420pData:pFrameYUV->data[0] width:544 height:960];
            }
        }
        av_free_packet(packet);
    }
    //flush decoder
    //FIX: Flush Frames remained in Codec
    while (1) {
        ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
        if (ret < 0)
            break;
        if (!got_picture)
            break;
        sws_scale(img_convert_ctx, (const uint8_t* const*)pFrame->data, pFrame->linesize, 0, pCodecCtx->height,
                  pFrameYUV->data, pFrameYUV->linesize);
        int y_size=pCodecCtx->width*pCodecCtx->height;
        fwrite(pFrameYUV->data[0],1,y_size,fp_yuv);    //Y
        fwrite(pFrameYUV->data[1],1,y_size/4,fp_yuv);  //U
        fwrite(pFrameYUV->data[2],1,y_size/4,fp_yuv);  //V
        //Output info
        char pictype_str[10]={0};
        switch(pFrame->pict_type){
            case AV_PICTURE_TYPE_I:sprintf(pictype_str,"I");break;
            case AV_PICTURE_TYPE_P:sprintf(pictype_str,"P");break;
            case AV_PICTURE_TYPE_B:sprintf(pictype_str,"B");break;
            default:sprintf(pictype_str,"Other");break;
        }
        printf("Frame Index: %5d. Type:%s\n",frame_cnt,pictype_str);
        frame_cnt++;
    }
    time_finish = clock();
    time_duration=(double)(time_finish - time_start);
    
    sprintf(info, "%s[Time      ]%fus\n",info,time_duration);
    sprintf(info, "%s[Count     ]%d\n",info,frame_cnt);
    
    sws_freeContext(img_convert_ctx);
    
    fclose(fp_yuv);
    
    av_frame_free(&pFrameYUV);
    av_frame_free(&pFrame);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
    
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
//    self.infomation.text=info_ns;
}

- (NSString *)getFilePath {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *tmpPath = [path stringByAppendingPathComponent:@"move"];
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:tmpPath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil
                            error:NULL];
    }
    return tmpPath;
}

@end
