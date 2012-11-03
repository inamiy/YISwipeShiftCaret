//
//  YISwipeShiftCaretGestureRecognizer.h
//  YISwipeShiftCaret
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface YISwipeShiftCaretGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) UIView <UITextInput> * textInput;

- (id)initWithTextInput:(UIView <UITextInput> *)textInput;

+ (BOOL)isValidTextInput:(id)textInput;

@end