//
//  ViewController.m
//  YISwipeShiftCaretDemo
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self findFirstResponderAndResignInView:self.view];
}

- (void)findFirstResponderAndResignInView:(UIView*)view
{
    for (UIView* subview in view.subviews) {
        if ([subview isFirstResponder]) {
            [subview resignFirstResponder];
            break;
        }
        else {
            [self findFirstResponderAndResignInView:subview];
        }
    }
}

@end
