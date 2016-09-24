//
//  LKAnimation.m
//  LKAnimationDemo
//
//  Created by Shadow on 2016/9/24.
//  Copyright © 2016年 HoneyLuka. All rights reserved.
//

#import "LKAnimation.h"

typedef NS_ENUM(NSUInteger, LKAnimationGroupType) {
    LKAnimationGroupTypeNone,
    LKAnimationGroupTypeAnimation,
    LKAnimationGroupTypeDelay,
};

@interface LKAnimationGroup : NSObject

@property (nonatomic, assign) LKAnimationGroupType type;
@property (nonatomic, strong) NSMutableArray *animations;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions options;

@property (nonatomic, assign) NSTimeInterval delay;

@end

@implementation LKAnimationGroup

+ (instancetype)group
{
    return [LKAnimationGroup new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animations = [NSMutableArray array];
    }
    return self;
}

@end

const CGFloat kLKAnimationDefaultDuration = 0.25f;

@interface LKAnimation ()

@property (nonatomic, strong) NSMutableArray<LKAnimationGroup *> *animationGroups;
@property (nonatomic, copy) LKAnimationBlock finishedBlock;

@end

@implementation LKAnimation

#pragma mark - Init

+ (instancetype)animation
{
    return [LKAnimation new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.animationGroups = [NSMutableArray array];
    self.defaultDuration = kLKAnimationDefaultDuration;
    self.defaultAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
}

#pragma mark - Method

- (void)add:(LKAnimationBlock)animation
{
    if (!animation) {
        return;
    }
    
    LKAnimationGroup *group = [self currentGroup];
    
    if (group.type != LKAnimationGroupTypeAnimation) {
        [self then:animation];
        return;
    }
    
    [group.animations addObject:[animation copy]];
}

- (void)then:(LKAnimationBlock)animation
{
    if (!animation) {
        return;
    }
    
    LKAnimationGroup *group = [self createGroup];
    group.type = LKAnimationGroupTypeAnimation;
    [self.animationGroups addObject:group];
    
    [group.animations addObject:[animation copy]];
}

- (void)duration:(NSTimeInterval)duration
{
    if (duration < 0) {
        duration = 0;
    }
    
    LKAnimationGroup *group = [self currentGroup];
    
    if (group.type != LKAnimationGroupTypeAnimation) {
        return;
    }
    
    group.duration = duration;
}

- (void)animationOptions:(UIViewAnimationOptions)options
{
    LKAnimationGroup *group = [self currentGroup];
    
    if (group.type != LKAnimationGroupTypeAnimation) {
        return;
    }
    
    group.options = options;
}

- (void)delay:(NSTimeInterval)delay
{
    LKAnimationGroup *group = [self currentGroup];
    
    if (delay <= 0) {
        if (group.type == LKAnimationGroupTypeDelay) {
            [self.animationGroups removeObject:group];
        }
        
        return;
    }
    
    if (group.type != LKAnimationGroupTypeDelay) {
        group = [self createGroup];
        group.type = LKAnimationGroupTypeDelay;
        [self.animationGroups addObject:group];
    }
    
    group.delay = delay;
}

- (void)onAllFinished:(LKAnimationBlock)onFinish
{
    if (!onFinish) {
        self.finishedBlock = nil;
        return;
    }
    
    self.finishedBlock = [onFinish copy];
}

#pragma mark - Execute animation

- (void)start
{
    if (!self.animationGroups.count) {
        [self animationFinished];
        return;
    }
    
    [self execute:0];
}

- (void)executeWithIndexNumber:(NSNumber *)index
{
    [self execute:index.integerValue];
}

- (void)execute:(NSInteger)index
{
    if (index >= self.animationGroups.count) {
        [self animationFinished];
        return;
    }
    
    LKAnimationGroup *group = self.animationGroups[index];
    if (group.type == LKAnimationGroupTypeDelay) {
        [self performSelector:@selector(executeWithIndexNumber:) withObject:@(index + 1) afterDelay:group.delay];
        return;
    }
    
    [UIView animateWithDuration:group.duration
                          delay:0
                        options:group.options
                     animations:
     ^{
         for (LKAnimationBlock animationBlock in group.animations) {
             animationBlock();
         }
    } completion:^(BOOL finished) {
        [self execute:index + 1];
    }];
}

- (void)animationFinished
{
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}

#pragma mark - Utils

- (LKAnimationGroup *)currentGroup
{
    LKAnimationGroup *group = self.animationGroups.lastObject;
    return group;
}

- (LKAnimationGroup *)createGroup
{
    LKAnimationGroup *group = [LKAnimationGroup group];
    group.duration = self.defaultDuration;
    group.options = self.defaultAnimationOptions;
    
    return group;
}

@end
