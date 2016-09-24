//
//  LKAnimation.h
//  LKAnimationDemo
//
//  Created by Shadow on 2016/9/24.
//  Copyright © 2016年 HoneyLuka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const CGFloat kLKAnimationDefaultDuration;

typedef void(^LKAnimationBlock)(void);

@interface LKAnimation : NSObject

/**
 Default is UIViewAnimationOptionCurveEaseInOut.
 If you want use this, set it before call method.
 */
@property (nonatomic, assign) UIViewAnimationOptions defaultAnimationOptions;

/**
 Default is 0.25s.
 If you want use this, set it before call method.
 */
@property (nonatomic, assign) NSTimeInterval defaultDuration;

/**
 Add one animation.
 If call it mutiple times, all the animation blocks will execute at the same time.

 @param animation Animation block.
 */
- (void)add:(LKAnimationBlock)animation;


/**
 After animations execute end, execute this animation.
 In most cases you can just use this method.

 @param animation Animation block.
 */
- (void)then:(LKAnimationBlock)animation;


/**
 After animations execute end, delay some seconds.

 @param delay Delay seconds.
 */
- (void)delay:(NSTimeInterval)delay;


/**
 Set animation duration for current animation.
 If set this, 'defaultDuration' will be ignore.

 @param duration Animation duration.
 */
- (void)duration:(NSTimeInterval)duration;


/**
 Set animation options for current animation.
 If set this, 'defaultAnimationOptions' will be ignore.
 
 @param options Animation Options
 */
- (void)animationOptions:(UIViewAnimationOptions)options;


/**
 When all animations execute end, will call this block.

 @param onFinish OnFinishBlock
 */
- (void)onAllFinished:(LKAnimationBlock)onFinish;


/**
 Start animation.
 */
- (void)start;

+ (instancetype)animation;

@end
