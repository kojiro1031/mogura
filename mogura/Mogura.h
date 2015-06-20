//
//  Mogura.h
//  mogura
//
//  Created by 室田翔太 on 2015/05/23.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mogura : UIButton

@property (retain, nonatomic) NSTimer *timer;
@property (nonatomic) float time;
@property (nonatomic) int point;
@property (nonatomic) float disSec;
@property (nonatomic) int type;
@property (strong, nonatomic) NSString *hoge;

-(void)play;

@end
