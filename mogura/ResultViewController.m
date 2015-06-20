//
//  ResultViewController.m
//  mogura
//
//  Created by 室田翔太 on 2015/03/21.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *comboLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    NSNumber *scoreNum = [NSNumber numberWithInt:self.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",
                            [formatter stringFromNumber:scoreNum]];
    self.comboLabel.text = [NSString stringWithFormat:@"%d", self.maxCombo];
    NSString *counts = @"";
//    NSLog(@"%d", self.countArray.count);
    if (self.countArray != nil && self.countArray.count > 0) {
        for (NSNumber *value in self.countArray) {
            if (counts.length > 0) {
                counts = [counts stringByAppendingString:@","];
            }
            counts = [counts stringByAppendingString:[NSString stringWithFormat:@"%@", value]];
        }
    }
    self.countLabel.text = counts;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
