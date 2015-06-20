//
//  SoundManager.m
//  mogura
//
//  Created by 室田翔太 on 2015/05/09.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "SoundManager.h"
#import "Constants.h"

@interface SoundManager ()

//登録されたサウンドのSystemSoundIDを保存する
//@property (nonatomic,retain) NSMutableDictionary* soundDir;

@end

@implementation SoundManager

static SoundManager *sharedData_ = nil;

+ (SoundManager *)sharedManager
{
    @synchronized(self)
    {
        if (!sharedData_) {
            sharedData_ = [[SoundManager alloc] init];
        }
    }
    return sharedData_;
}

-(id)init
{
    self = [super init];
    if (self)
    {
//        self.soundDir = [[NSMutableDictionary alloc]init];
        seArray = [[NSMutableArray alloc] init];
        bgmArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//-(void)addSoundEffect:(int)soundNo url:(NSURL*)url
//{
//    SystemSoundID soundId;
//    
//    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)url, &soundId);
//    
//    NSNumber *box = [NSNumber numberWithUnsignedLong:soundId];
//    
//    [self.soundDir setObject:box forKey:[NSString stringWithFormat:@"%d",soundNo]];
//}

//-(void)playSoundEffect:(int)soundNo
//{
//    NSNumber* box = [self.soundDir objectForKey:[NSString stringWithFormat:@"%d",soundNo]];
//    if (box)
//    {
//        SystemSoundID soundId = box.unsignedLongValue;
//        AudioServicesPlaySystemSound (soundId);
//    }
//}

- (void)playSE:(NSString *)soundName{
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:soundName];
    NSURL *urlOfSound = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float seVolume = [userDefaults floatForKey:SE_VOLUME_KEY];
    player.volume = seVolume;
    player.delegate = (id)self;
    [seArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

- (void)playBgm:(NSString *)soundName{
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:soundName];
    NSURL *urlOfSound = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float bgmVolume = [userDefaults floatForKey:BGM_VOLUME_KEY];
    player.volume = bgmVolume;
    player.delegate = (id)self;
    [bgmArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

-(void)stopBgm
{
    AVAudioPlayer* player = [bgmArray objectAtIndex:0];
    [player stop];
    [self audioPlayerDidFinishPlaying:player successfully:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [seArray removeObject:player];
    [bgmArray removeObject:player];
}

@end
