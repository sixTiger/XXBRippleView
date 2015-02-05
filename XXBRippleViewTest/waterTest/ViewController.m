//
//  ViewController.m
//  waterTest
//
//  Created by Jinhong on 15/2/5.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "ViewController.h"
#import "XXBRippleView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet XXBRippleView *rippleView;

@end

@implementation ViewController
- (IBAction)start:(id)sender {
    [self.rippleView startRippleAnimation];
}
- (IBAction)stop:(id)sender {
    [self.rippleView stopRippleAnimation];
}

@end
