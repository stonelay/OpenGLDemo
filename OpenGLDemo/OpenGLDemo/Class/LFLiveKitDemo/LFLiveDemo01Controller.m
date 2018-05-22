////
////  LFLiveDemo01Controller.m
////  OpenGLDemo
////
////  Created by LayZhang on 2018/2/24.
////  Copyright © 2018年 Zhanglei. All rights reserved.
////
//
//#import "LFLiveDemo01Controller.h"
//#import "LFLiveKit.h"
//
//@interface LFLiveDemo01Controller ()
//@property (nonatomic, strong) LFLiveSession *session;
//@end
//
//@implementation LFLiveDemo01Controller
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self requestAccessForAudio];
//    [self requestAccessForVideo];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
////        stream.url = @"rtmp://172.17.44.151:1935/hls/abc";
//        stream.url = @"rtmp://192.168.0.135:1935/hls/abc";
//        NSLog(@"strt");
//        [self.session startLive:stream];
//    });
//}
//
//
//- (void)requestAccessForVideo{
//    __weak typeof(self) weakSelf = self;
//    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    switch (status) {
//        case AVAuthorizationStatusNotDetermined:{
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if (granted) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf startSession];
//                    });
//                }
//            }];
//            break;
//        }
//        case AVAuthorizationStatusAuthorized:{
//            [weakSelf startSession];
//            break;
//        }
//        case AVAuthorizationStatusDenied:
//        case AVAuthorizationStatusRestricted:
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)requestAccessForAudio{
//    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    switch (status) {
//        case AVAuthorizationStatusNotDetermined:{
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:nil];
//            break;
//        }
//        case AVAuthorizationStatusAuthorized:{
//            break;
//        }
//        case AVAuthorizationStatusDenied:
//        case AVAuthorizationStatusRestricted:
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)startSession {
//    if(!self.session){
//        self.session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
//        self.session.preView = self.view;
//    }
//    [self.session setRunning:YES];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

