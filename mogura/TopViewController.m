//
//  TopViewController.m
//  mogura
//
//  Created by 室田翔太 on 2015/03/21.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "TopViewController.h"
#import "Constants.h"

@interface TopViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self authenticateLocalPlayer];
    // 初回起動時の処理
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isStarted = [userDefaults boolForKey:APP_STARTED_KEY];
    if (!isStarted) {
        [userDefaults setFloat:1 forKey:BGM_VOLUME_KEY];
        [userDefaults setFloat:1 forKey:SE_VOLUME_KEY];
        [userDefaults setBool:YES forKey:APP_STARTED_KEY];
        [userDefaults setBool:NO forKey:DEBUG_MODE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)authenticateLocalPlayer {
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
        if (error)
        { /* エラー処理 */ }
        else
        { /* 認証済みユーザーを使ってハイスコアとか処理 */ }
    })];
}

@end
