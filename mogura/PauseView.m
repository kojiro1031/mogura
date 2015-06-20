//
//  PauseView.m
//  mogura
//
//  Created by 室田翔太 on 2015/03/21.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "PauseView.h"

@implementation PauseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.playButton addTarget:self
                            action:@selector(tapPlay:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)tapPlay:(id)sender
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
