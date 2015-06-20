//
//  ViewController.m
//  mogura
//
//  Created by 室田翔太 on 2015/03/07.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "GameViewController.h"
#import "ResultViewController.h"
#import "PauseView.h"
#import "SoundManager.h"
#import "MoguraManager.h"
#import "Mogura.h"
#import "Constants.h"

#define END @"END"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *comboLabel;
@property (weak, nonatomic) IBOutlet UILabel *comboTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *addSecLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIImageView *stage;
@property (strong, nonatomic) PauseView *pauseView;
@property (weak, nonatomic) IBOutlet UIProgressView *feverProgressView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *comboTimer;
@property (strong, nonatomic) NSTimer *feverTimer;
@property (strong, nonatomic) NSTimer *countUpTimer;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (nonatomic) int time;
@property (nonatomic) float comboTime;
@property (nonatomic) float feverTime;
@property (nonatomic) int score;
@property (nonatomic) int tempScore;
@property (nonatomic) int count;
@property (nonatomic) int combo;
@property (nonatomic) int maxCombo;
@property (nonatomic) float feverCount;
@property (nonatomic) BOOL isFever;
@property (nonatomic) BOOL isDebug;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初期化処理
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.formatter.groupingSeparator = @",";
    self.formatter.groupingSize = 3;
    self.time = TIME;
    self.timeLabel.text = [NSString stringWithFormat:@"%d", self.time];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
    self.comboLabel.hidden = YES;
    self.comboTopLabel.hidden = YES;
    self.addSecLabel.hidden = YES;
    self.feverProgressView.progress = 0;
    self.isFever = NO;
    self.isDebug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_MODE];
    [[MoguraManager sharedManager] initMoguraCount];
    [self.pauseButton addTarget:self
                        action:@selector(tapPause:)
              forControlEvents:UIControlEventTouchUpInside];
    UINib *nib = [UINib nibWithNibName:@"PauseView" bundle:nil];
    self.pauseView = [nib instantiateWithOwner:self options:nil][0];
    [self.pauseView.playButton addTarget:self
                                  action:@selector(tapPlay:)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.pauseView.quitButton addTarget:self
                                  action:@selector(tapQuit:)
                        forControlEvents:UIControlEventTouchUpInside];
    [[SoundManager sharedManager] playBgm:@"bgm.mp3"];
    self.stage.multipleTouchEnabled = YES;
    [self startTimer];
}

/**
 * タイマースタート
 */
- (void)startTimer
{
    float perSec = 1.0f / MOGURA_SPEED;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:perSec
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

/**
 * カウントダウン処理
 */
- (void)onTimer:(NSTimer *)sender
{
    //タイマーカウントダウン
    if (++self.count >= MOGURA_SPEED) {
        self.count = 0;
        self.timeLabel.text = [NSString stringWithFormat:@"%d", --self.time];
        if (0 >= self.time) {
            [self endTimer];
        } else if (self.time < 5) {
            [[SoundManager sharedManager] playSE:@"mokkin.aiff"];
        }
    }
    //出現抽選
    if (APPEARANCE_RATE < arc4random() % 99) {
        return;
    }
    //もぐら出現
    if (self.stage.subviews.count < MULTIPLE) {
        Mogura *moguraView = [[MoguraManager sharedManager] getRandomMoguraInstance:self.isFever];
        CGRect frame = moguraView.frame;
        CGFloat x;
        CGFloat y;
        BOOL isPlaced;
        do {
            isPlaced = false;
            x = arc4random_uniform(self.stage.bounds.size.width - MOGURA_WIDTH);
            y = arc4random_uniform(self.stage.bounds.size.height - MOGURA_HEIGHT);
            for (UIView *view in self.stage.subviews) {
                CGFloat viewX = view.frame.origin.x;
                CGFloat viewY = view.frame.origin.y;
                // 重なり判定
                if (x < (viewX + MOGURA_WIDTH) && viewX < (x + MOGURA_WIDTH)
                    && y < (viewY + MOGURA_HEIGHT) && viewY < (y + MOGURA_HEIGHT)) {
                    isPlaced = true;
                    break;
                }
            }
        } while (isPlaced);
        frame.origin.x = x;
        frame.origin.y = y;
        moguraView.frame = frame;
        [moguraView addTarget:self
                       action:@selector(tapMogura:)
//             forControlEvents:UIControlEventTouchUpInside];
             forControlEvents:UIControlEventTouchDown];
        [self.stage addSubview:moguraView];
    }
    self.stage.userInteractionEnabled = YES;
}

/**
 * もぐらタップ
 */
- (void)tapMogura:(Mogura *)sender
{
    if (self.comboTimer.isValid) {
        [self.comboTimer invalidate];
    }
    self.combo++;
    if (self.maxCombo < self.combo) {
        self.maxCombo = self.combo;
    }
    self.comboLabel.text = [NSString stringWithFormat:@"%d", self.combo];
    int comboBonus = 1;
    if (self.combo >= COMBO_MIN_RATE) {
        int comboRate = 1;
        self.comboLabel.hidden = NO;
        self.comboTopLabel.hidden = NO;
        // コンボ数に段階をもたせる
        if (self.combo <= COMBO_RATE_2) {//5-10
            comboBonus = 2;
            comboRate = 2;
        } else if (self.combo <= COMBO_RATE_3) {//10-30
            comboBonus = 5;
            comboRate = 3;
        } else if (self.combo <= COMBO_MAX_RATE) {//30-50
            comboBonus = 10;
            comboRate = 4;
        } else {//50-
            comboBonus = 20;
            comboRate = 5;
        }
//        comboBonus = self.combo < MAX_COMBO_BONUS? self.combo: MAX_COMBO_BONUS;
        [self animationComboLabelAndText:comboRate];
    }
    self.comboTime = 0;
    self.comboTimer = [NSTimer scheduledTimerWithTimeInterval:COMBO_TIMER_PERIOD
                                                       target:self
                                                     selector:@selector(onComboTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
    self.tempScore = self.score;
    int addValue = sender.point * ceil(sender.time / sender.disSec * 10) * comboBonus;
    if (self.isFever) {
        addValue *= FEVER_BONUS;
    }
    if (self.isDebug) {
        [sender setTitle:[NSString stringWithFormat:@"%d", addValue] forState:UIControlStateNormal];
    }
    self.score += addValue;
    [self countUpScore];
    // フィーバー
    if (!self.isFever) {
        self.feverCount++;
        self.feverProgressView.progress = self.feverCount / FEVER_COUNT;
        if (self.feverCount >= FEVER_COUNT) {
            self.isFever = YES;
            self.feverCount = 0;
            self.time += FEVER_ADD_TIME;
            self.feverTime = 0;
            self.feverTimer = [NSTimer scheduledTimerWithTimeInterval:FEVER_TIMER_PERIOD
                                                               target:self
                                                             selector:@selector(onFeverTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
            self.view.backgroundColor = [UIColor grayColor];
            self.feverProgressView.progressTintColor = [UIColor redColor];
            [[SoundManager sharedManager] playSE:@"cat.aiff"];
            [[SoundManager sharedManager] stopBgm];
            [[SoundManager sharedManager] playBgm:@"fever.mp3"];
            self.addSecLabel.hidden = NO;
        }
    }
}

/**
 * スコアをカウントアップする
 */
- (void)countUpScore
{
    NSNumber *scoreNum = [NSNumber numberWithInt:self.tempScore++];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",
                            [self.formatter stringFromNumber:scoreNum]];
    if (self.tempScore <= self.score) {
        self.countUpTimer = [NSTimer scheduledTimerWithTimeInterval:0.04f
                                                             target:self
                                                           selector:@selector(countUpScore)
                                                           userInfo:nil
                                                            repeats:NO];
    }
}

/**
 * コンボ表示アニメーション
 */
- (void)animationComboLabelAndText:(int)comboRate
{
    float size = 1.1;
    switch (comboRate) {
        case 2:
            size = 1.2;
            break;
        case 3:
            size = 1.3;
            break;
        case 4:
            size = 1.4;
            break;
        case 5:
            size = 1.5;
            break;
    }
    [UIView animateWithDuration:0.03f
                     animations:^{
                         self.comboLabel.transform = CGAffineTransformMakeScale(size, size);
                         self.comboTopLabel.transform = CGAffineTransformMakeScale(size, size);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.03f
                                          animations:^{
                                              self.comboLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              self.comboTopLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                          }];
                     }];
}

/**
 * コンボ終了
 */
- (void)onComboTimer:(id)sender
{
    self.comboTime += COMBO_TIMER_PERIOD;
    if (self.comboTime >= COMBO_TIME) {
        self.comboLabel.hidden = YES;
        self.comboTopLabel.hidden = YES;
        self.combo = 0;
        [self.comboTimer invalidate];
    }
}

/**
 * フィーバー終了
 */
- (void)onFeverTimer:(id)sender
{
    self.feverTime += FEVER_TIMER_PERIOD;
    self.feverProgressView.progress = 1 - (self.feverTime / FEVER_TIME);
    if (self.feverTime >= FEVER_TIME) {
        [self.feverTimer invalidate];
        self.view.backgroundColor = [UIColor whiteColor];
        self.feverProgressView.progressTintColor = [UIColor blueColor];
        self.isFever = NO;
        [[SoundManager sharedManager] stopBgm];
        [[SoundManager sharedManager] playBgm:@"bgm.mp3"];
    } else if (self.feverTime >= FEVER_ADD_TIME_APPEAR) {
        if (!self.addSecLabel.isHidden) {
            self.addSecLabel.hidden = YES;
        }
    }
}

/**
 * タイムアップ
 */
- (void)endTimer
{
    [self.timer invalidate];
    [self performSegueWithIdentifier:END sender:self];
}

/**
 * ポーズボタンタップ
 */
- (void)tapPause:(id)sender
{
    [self.timer invalidate];
    [self.comboTimer invalidate];
    [self.feverTimer invalidate];
    NSArray *moguras = self.stage.subviews;
    for (Mogura *mogura in moguras) {
        [mogura.timer invalidate];
    }
    [self.view addSubview:self.pauseView];
}

/**
 * 再開ボタンタップ
 */
- (void)tapPlay:(id)sender
{
    [self.pauseView removeFromSuperview];
    NSArray *moguras = self.stage.subviews;
    for (Mogura *mogura in moguras) {
        [mogura play];
    }
    if (self.comboTime > 0) {
        self.comboTimer = [NSTimer scheduledTimerWithTimeInterval:COMBO_TIMER_PERIOD
                                                           target:self
                                                         selector:@selector(onComboTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    if (self.isFever) {
        self.feverTimer = [NSTimer scheduledTimerWithTimeInterval:FEVER_TIMER_PERIOD
                                                           target:self
                                                         selector:@selector(onFeverTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    [self startTimer];
}

/**
 * 終了ボタンタップ
 */
- (void)tapQuit:(id)sender
{
    [self.timer invalidate];
    [self performSegueWithIdentifier:@"QUIT" sender:self];    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[SoundManager sharedManager] stopBgm];
    if ([segue.identifier isEqualToString:END]) {
        ResultViewController *resultVC = segue.destinationViewController;
        resultVC.score = self.score;
        resultVC.maxCombo = self.maxCombo;
        resultVC.countArray = [MoguraManager sharedManager].moguraCountArray;
        [self submitScore:self.score forCategory:LEADERBOARD_ID];
    }
}

-(void)submitScore:(int64_t)score forCategory:(NSString*)category {
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    scoreReporter.value = score;
    NSArray *scorearray=[[NSArray alloc]initWithObjects:scoreReporter, nil];//入れたい点数を配列に入れる。
    [GKScore reportScores:scorearray withCompletionHandler:^(NSError *error) {
        if (error) { /* エラー処理 */ }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
