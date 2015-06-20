//
//  ConfigViewController.m
//  mogura
//
//  Created by 室田翔太 on 2015/05/09.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "ConfigViewController.h"
#import "Constants.h"

@interface ConfigViewController ()

@property (weak, nonatomic) IBOutlet UISlider *bgmVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *seVolumeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //音量
    self.bgmVolumeSlider.maximumValue = 1.0;
    self.bgmVolumeSlider.minimumValue = 0.0;
    self.seVolumeSlider.maximumValue = 1.0;
    self.seVolumeSlider.minimumValue = 0.0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float bgmVolume = [userDefaults floatForKey:BGM_VOLUME_KEY];
    float seVolume = [userDefaults floatForKey:SE_VOLUME_KEY];
    BOOL isDebug = [userDefaults boolForKey:DEBUG_MODE];
    self.bgmVolumeSlider.value = bgmVolume;
    self.seVolumeSlider.value = seVolume;
    self.debugSwitch.on = isDebug;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:self.bgmVolumeSlider.value forKey:BGM_VOLUME_KEY];
    [userDefaults setFloat:self.seVolumeSlider.value forKey:SE_VOLUME_KEY];
    [userDefaults setBool:self.debugSwitch.on forKey:DEBUG_MODE];
}


@end
