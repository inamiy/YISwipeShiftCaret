//
//  YISwipeShiftCaretGestureRecognizer.m
//  YISwipeShiftCaret
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "YISwipeShiftCaretGestureRecognizer.h"
#import "UITextField+YISwipeShiftCaret.h"

typedef enum {
    CaretShiftDirectionNone,
    CaretShiftDirectionLeft,
    CaretShiftDirectionRight,
} CaretShiftDirection;


@protocol YITextInput <UITextInput>

@property (nonatomic)       NSRange     selectedRange;
@property (nonatomic, copy) NSString*   text;

@end


@implementation YISwipeShiftCaretGestureRecognizer
{
    CGPoint     _panStartLocation;
    NSTimer*    _caretShiftTimer;
    
    CaretShiftDirection  _caretShiftDirection;
}

- (id)initWithTextInput:(UIView <UITextInput> *)textInput
{
    self = [super initWithTarget:nil action:nil];
    if (self) {
        self.textInput = textInput;
    }
    return self;
}

+ (BOOL)isValidTextInput:(id)textInput
{
    if ([textInput respondsToSelector:@selector(selectedRange)] &&
        [textInput respondsToSelector:@selector(text)]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setTextInput:(UIView <UITextInput> *)textInput
{
    if ([[self class] isValidTextInput:textInput] || !textInput)  {
        _textInput = textInput;
    }
    else {
        [NSException raise:NSInvalidArgumentException
                    format:@"YISwipeShiftCaretGestureRecognizer's textInput must respond to \"selectedRange\" and \"text\" methods."];
    }
}

#pragma mark

#pragma mark Gesture

- (void)setState:(UIGestureRecognizerState)state
{
    [super setState:state];
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint translation = [self translationInView:self.view];
            if (translation.x > 0) {
                _caretShiftDirection = CaretShiftDirectionRight;
            }
            else if (translation.x < 0) {
                _caretShiftDirection = CaretShiftDirectionLeft;
            }
            else {
                _caretShiftDirection = CaretShiftDirectionNone;
            }
            
            if (_caretShiftDirection != CaretShiftDirectionNone) {
                _panStartLocation = [self locationInView:self.view];
                [self shiftCaret];
            }
            
            [self performSelector:@selector(startCaretShiftTimer) withObject:nil afterDelay:0.5];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            
            [self stopCaretShiftTimer];
            break;
            
        default:
            break;
    }
}

- (void)reset
{
    [super reset];
    [self stopCaretShiftTimer];
}

#pragma mark -

#pragma mark Timers

- (void)startCaretShiftTimer
{
    if (!_caretShiftTimer) {
        _caretShiftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(shiftCaret) userInfo:nil repeats:YES];
    }
}

- (void)stopCaretShiftTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startCaretShiftTimer) object:nil];
    
    if (_caretShiftTimer) {
        [_caretShiftTimer invalidate];
        _caretShiftTimer = nil;
    }
    
    _caretShiftDirection = CaretShiftDirectionNone;
    _panStartLocation = CGPointZero;
}

- (void)shiftCaret
{
    // update direction
    CGPoint velocity = [self velocityInView:self.view];
    if (velocity.x > 0) {
        _caretShiftDirection = CaretShiftDirectionRight;
    }
    else {
        _caretShiftDirection = CaretShiftDirectionLeft;
    }
    
    id <YITextInput> textInput = (id <YITextInput>)_textInput;
    NSRange range = textInput.selectedRange;
    
    // non-selected
    if (range.length == 0) {
        if (_caretShiftDirection == CaretShiftDirectionRight && range.location < textInput.text.length) {
            range.location += 1;
        }
        else if (_caretShiftDirection == CaretShiftDirectionLeft && range.location > 0) {
            range.location -= 1;
        }
    }
    // selected
    else {
        
        // right caret
        if (_panStartLocation.x > self.view.frame.size.width/2) {
            if (_caretShiftDirection == CaretShiftDirectionRight && range.location+range.length < textInput.text.length) {
                range.length += 1;
            }
            else if (_caretShiftDirection == CaretShiftDirectionLeft && range.length > 0) {
                range.length -= 1;
            }
        }
        // left caret
        else {
            if (_caretShiftDirection == CaretShiftDirectionRight && range.length > 0) {
                range.location +=1;
                range.length -= 1;
            }
            else if (_caretShiftDirection == CaretShiftDirectionLeft && range.location > 0) {
                range.location -=1;
                range.length += 1;
            }
        }
    }
    
    textInput.selectedRange = range;
}

@end
