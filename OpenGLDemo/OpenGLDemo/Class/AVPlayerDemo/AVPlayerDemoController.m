//
//  AVPlayerDemoController.m
//  OpenGLDemo
//
//  Created by LayZhang on 2018/5/25.
//  Copyright © 2018年 Zhanglei. All rights reserved.
//

#import "AVPlayerDemoController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerDemoController ()

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *palyerItems;

@end

@implementation AVPlayerDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"]];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] pathForResource:@"move" ofType:@"mp4"]];
    //添加监听
//    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    self.avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0, 100, SCREENWIDTH, 200);
    [self.view.layer addSublayer:playerLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.avPlayer play];
    });
    
}
//监听回调
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    AVPlayerItem *playerItem = (AVPlayerItem *)object;
//
//    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
//
//    }else if ([keyPath isEqualToString:@"status"]){
//        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
//            NSLog(@"playerItem is ready");
//            [self.avPlayer play];
//        } else{
//            NSLog(@"load break");
//        }
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
