//
//  YISwipeShiftCaret.m
//  YISwipeShiftCaret
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "YISwipeShiftCaret.h"
#import "YISwipeShiftCaretGestureRecognizer.h"
#import <objc/runtime.h>


@implementation YISwipeShiftCaret

+ (void)swizzleSelector:(SEL)oldSel withSelector:(SEL)newSel forClass:(Class)c
{
    Method oldMethod = class_getInstanceMethod(c, oldSel);
    Method newMethod = class_getInstanceMethod(c, newSel);
    
    if(class_addMethod(c, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    else
        method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)install;
{
    [YISwipeShiftCaret swizzleSelector:@selector(becomeFirstResponder)
                          withSelector:@selector(yi_becomeFirstResponder)
                              forClass:[UIView class]];
}

@end


@implementation UIView (YISwipeShiftCaret)

- (BOOL)yi_becomeFirstResponder
{
    if ([YISwipeShiftCaretGestureRecognizer isValidTextInput:self]) {
        
        BOOL alreadyInstalled = NO;
        for (UIGestureRecognizer* gesture in self.gestureRecognizers) {
            if ([gesture isKindOfClass:[YISwipeShiftCaretGestureRecognizer class]]) {
                alreadyInstalled = YES;
                break;
            }
        }
        
        if (!alreadyInstalled) {
            YISwipeShiftCaretGestureRecognizer* gesture = [[YISwipeShiftCaretGestureRecognizer alloc] initWithTextInput:(UIView <UITextInput> *)self];
            [self addGestureRecognizer:gesture];
        }
        
    }
    
    return [self yi_becomeFirstResponder];
}

@end
