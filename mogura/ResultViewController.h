//
//  ResultViewController.h
//  mogura
//
//  Created by 室田翔太 on 2015/03/21.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (nonatomic) int score;
@property (nonatomic) int maxCombo;
@property (strong, nonatomic) NSMutableArray *countArray;

@end
