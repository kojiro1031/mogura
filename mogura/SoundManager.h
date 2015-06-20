//
//  SoundManager.h
//  mogura
//
//  Created by 室田翔太 on 2015/05/09.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject
{
    NSMutableArray *seArray;
    NSMutableArray *bgmArray;
}

+ (SoundManager *)sharedManager;
//-(void)addSoundEffect:(int)soundNo url:(NSURL*)url;
//-(void)playSoundEffect:(int)soundNo;
-(void)playSE:(NSString *)soundName;
-(void)playBgm:(NSString *)soundName;
-(void)stopBgm;

@end
