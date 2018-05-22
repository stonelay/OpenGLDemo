
//
//  UIImageView+ZLEX.m
//  ZLBaseProject
//
//  Created by LayZhang on 2017/9/28.
//  Copyright © 2017年 Zhanglei. All rights reserved.
//

#import "UIImageView+ZLEX.h"

@implementation UIImageView (ZLEX)


- (void)setOnlineImage:(NSString *)url
{
    [self setOnlineImage:url placeHolderImage:[UIImage imageNamed:@"common_placeholer"]];
}

- (void)setOnlineImage:(NSString *)url placeHolderImage:(UIImage *)placeHolderImage
{
    [self setOnlineImage:url placeHolderImage:placeHolderImage animated:NO];
}

- (void)setOnlineImage:(NSString *)url placeHolderImage:(UIImage *)placeHolderImage animated:(BOOL)animated
{
    self.clipsToBounds = YES;
    __weak UIImageView *wself = self;
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image || error) {
            return ;
        }
        wself.contentMode = UIViewContentModeScaleAspectFill;
        
        if (animated && !placeHolderImage) {
            wself.alpha = 0;
            [UIView animateWithDuration:0.7f animations:^{
                wself.alpha = 1.f;
            }];
        }
    }];
}

- (void)setOnlineImage:(NSString *)url placeHolderImage:(UIImage *)placeHolderImage complete:(void (^)(UIImage *image))completedBlock
{
    self.clipsToBounds = YES;
    __weak UIImageView *weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image || error) {
            return ;
        }
        
        weakSelf.contentMode = UIViewContentModeScaleAspectFill;
        
        if (completedBlock) {
            completedBlock(image);
        }
        
    }];
}

- (void)setOnlineImage:(NSString *)url complete:(void (^)(UIImage *image))completedBlock {
    [self setOnlineImage:url placeHolderImage:[UIImage imageNamed:@"common_placeholer"] complete:completedBlock];
}


@end
