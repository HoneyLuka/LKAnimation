//
//  DemoViewController.m
//  LKAnimationDemo
//
//  Created by Shadow on 2016/9/24.
//  Copyright © 2016年 HoneyLuka. All rights reserved.
//

#import "DemoViewController.h"
#import "LKAnimation.h"

@interface DemoViewController ()

@property (nonatomic, weak) IBOutlet UIView *testView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testAnimation];
}

- (void)testAnimation
{
    LKAnimation *animation = [LKAnimation animation];
    
    [animation add:^{
        CGRect frame = self.testView.frame;
        frame.origin.x += 50;
        self.testView.frame = frame;
    }];
    
    [animation add:^{
        self.testView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 1);
    }];
    
    [animation delay:3];
    
    [animation then:^{
        self.testView.transform = CGAffineTransformIdentity;
    }];
    
    [animation delay:3];
    
    [animation then:^{
        CGRect frame = self.testView.frame;
        frame.origin.y += 50;
        self.testView.frame = frame;
        self.testView.backgroundColor = [UIColor orangeColor];
    }];
    [animation duration:0.5];
    
    [animation onAllFinished:^{
        NSLog(@"finished!");
    }];
    
    [animation start];
}

@end
