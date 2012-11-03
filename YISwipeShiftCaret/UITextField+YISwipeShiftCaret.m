//
//  UITextField+YISwipeShiftCaret.m
//  YISwipeShiftCaret
//
//  Created by Yasuhiro Inami on 2012/11/03.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "UITextField+YISwipeShiftCaret.h"

@implementation UITextField (YISwipeShiftCaret)

// http://stackoverflow.com/questions/11867436/get-a-range-of-selected-text-in-uitextfield-as-an-nsrange-is-ios-4
- (NSRange)selectedRange
{
    UITextRange *selectedTextRange = self.selectedTextRange;
    NSUInteger location = [self offsetFromPosition:self.beginningOfDocument
                                        toPosition:selectedTextRange.start];
    NSUInteger length = [self offsetFromPosition:selectedTextRange.start
                                      toPosition:selectedTextRange.end];
    NSRange selectedRange = NSMakeRange(location, length);
    
    return selectedRange;
}

// http://stackoverflow.com/questions/9126709/create-uitextrange-from-nsrange
- (void)setSelectedRange:(NSRange)range
{
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
    
    self.selectedTextRange = textRange;
}

@end
