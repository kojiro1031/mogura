//
//  MoguraManager.m
//  mogura
//
//  Created by 室田翔太 on 2015/05/23.
//  Copyright (c) 2015年 室田翔太. All rights reserved.
//

#import "MoguraManager.h"
#import "Constants.h"
#import "Mogura.h"
#import "RareMogura.h"

@implementation MoguraManager

static MoguraManager *sharedData_ = nil;

+ (MoguraManager *)sharedManager
{
    @synchronized(self)
    {
        if (!sharedData_) {
            sharedData_ = [[MoguraManager alloc] init];
        }
    }
    return sharedData_;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        moguraArray = [[NSMutableArray alloc] init];
        self.moguraCountArray = [[NSMutableArray alloc] init];
        [self addMogura:[Mogura class]];
        [self addMogura:[RareMogura class]];
    }
    return self;
}

- (void)addMogura:(Class)moguraClass
{
    [moguraArray setObject:moguraClass atIndexedSubscript:moguraArray.count];
    [self.moguraCountArray setObject:[NSNumber numberWithInt:0] atIndexedSubscript:self.moguraCountArray.count];
}

- (Mogura *)getRandomMoguraInstance:(BOOL)isFever
{
    int normalRate = isFever? FEVER_NORMAL_RATE: NORMAL_RATE;
    int rareRate = isFever? FEVER_RARE_RATE: RARE_RATE;
    int random = arc4random() % (normalRate + rareRate - 1);
    int index = random < normalRate? 0: 1;
    Mogura *result = [[moguraArray[index] alloc] init];
    result.type = index;
    return result;
}

- (void)countUp:(int)type
{
    NSNumber *value = [self.moguraCountArray objectAtIndex:type];
    int count = [value intValue];
    value = [NSNumber numberWithInt:++count];
    [self.moguraCountArray setObject:value atIndexedSubscript:type];
}

- (void)initMoguraCount
{
    int len = (int)self.moguraCountArray.count;
    for (int i = 0; i < len; i++) {
        [self.moguraCountArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }
}

@end
