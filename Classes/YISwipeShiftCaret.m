//
//  YISwipeShiftCaret.m
//  YISwipeShiftCaret
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "YISwipeShiftCaret.h"
#import "YISwipeShiftCaretGestureRecognizer.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>


@implementation YISwipeShiftCaret

+ (void)install;
{
    [UIView jr_swizzleMethod:@selector(becomeFirstResponder)
                  withMethod:@selector(yi_becomeFirstResponder)
                       error:NULL];
}

@end


@implementation UIView (YISwipeShiftCaret)

- (BOOL)yi_becomeFirstResponder
{
    if ([YISwipeShiftCaretGestureRecognizer isValidTextInput:self]) {
        
        UIView* installingView = self;
        
        //
        // For UITextView, conflicting with UIScrollViewPanGestureRecognizer is an annoying issue,
        // so let's add caret-gesture to its superview instead for better performance & simpler code.
        //
        if ([self isKindOfClass:[UIScrollView class]]) {
            installingView = self.superview;
        }
        
        BOOL alreadyInstalled = NO;
        for (UIGestureRecognizer* gesture in installingView.gestureRecognizers) {
            if ([gesture isKindOfClass:[YISwipeShiftCaretGestureRecognizer class]]) {
                alreadyInstalled = YES;
                break;
            }
        }
        
        if (!alreadyInstalled) {
            YISwipeShiftCaretGestureRecognizer* gesture = [[YISwipeShiftCaretGestureRecognizer alloc] initWithTextInput:(UIView <UITextInput> *)self];
            [installingView addGestureRecognizer:gesture];
        }
        
    }
    
    return [self yi_becomeFirstResponder];
}

@end
