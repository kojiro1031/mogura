//
//  Mogura.m
//  mogura
//
//  Created by 室田翔太 on 2015/05/23.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "Mogura.h"
#import "Constants.h"
#import "SoundManager.h"
#import "MoguraManager.h"

@implementation Mogura

@synthesize timer = _timer, point = _point, disSec = _disSec;


- (id)init
{
    self = [super init];
    self.hoge = @"hit.aiff";
    UIImage *mogura = [UIImage imageNamed:@"299"];
    CGRect frame = self.frame;
    frame.size.width = MOGURA_WIDTH;
    frame.size.height = MOGURA_HEIGHT;
    self.frame = frame;
    self.point = MOGURA_A_POINT;
    self.disSec = MOGURA_A_DIS_TIME;
    [self setBackgroundImage:mogura
                          forState:UIControlStateNormal];
    [self addTarget:self
                   action:@selector(tapMogura:)
         forControlEvents:UIControlEventTouchDown];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MOGURA_TIMER_PERIOD
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    return self;
}

/**
 * もぐらタップ
 */
- (void)tapMogura:(UIButton *)sender
{
    self.userInteractionEnabled = NO;
    [self.timer invalidate];
    [[SoundManager sharedManager] playSE:self.hoge];
    [[MoguraManager sharedManager] countUp:self.type];
    [UIView animateWithDuration:0.05f
                     animations:^{
                         sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.05f
                                          animations:^{
                                              sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
                                          }
                                          completion:^(BOOL finished) {
                                              [sender removeFromSuperview];
                                          }];
                     }];
}

/**
 * タイマー処理
 */
- (void)onTimer:(NSTimer *)sender
{
    self.time += MOGURA_TIMER_PERIOD;
    if (self.time >= self.disSec) {
        [self.timer invalidate];
        [self removeFromSuperview];
    }
}

/**
 * タイマー再開
 */
- (void)play
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MOGURA_TIMER_PERIOD
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

@end
