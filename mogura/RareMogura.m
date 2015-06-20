//
//  NormalMogura.m
//  mogura
//
//  Created by 室田翔太 on 2015/05/23.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "RareMogura.h"
#import "Constants.h"
#import "SoundManager.h"
#import "MoguraManager.h"

@implementation RareMogura

- (id)init
{
    self = [super init];
    self.hoge = @"hit2.aiff";
    UIImage *mogura = [UIImage imageNamed:@"299r"];
    CGRect frame = self.frame;
    frame.size.width = MOGURA_WIDTH;
    frame.size.height = MOGURA_HEIGHT;
    self.frame = frame;
    self.point = MOGURA_B_POINT;
    self.disSec = MOGURA_B_DIS_TIME;
    [self setBackgroundImage:mogura
                    forState:UIControlStateNormal];
    return self;
}

@end
