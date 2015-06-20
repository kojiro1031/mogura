//
//  MoguraManager.h
//  mogura
//
//  Created by 室田翔太 on 2015/05/23.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mogura.h"

@interface MoguraManager : NSObject
{
    NSMutableArray *moguraArray;
}

@property (strong, nonatomic) NSMutableArray *moguraCountArray;

+ (MoguraManager *)sharedManager;
- (void)addMogura:(Class)moguraClass;
- (Mogura *)getRandomMoguraInstance:(BOOL)isFever;
- (void)countUp:(int)type;
- (void)initMoguraCount;

@end
