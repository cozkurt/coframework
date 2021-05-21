//
//  NSMutableAttributedString+Utilities.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 10/07/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "NSMutableAttributedString+Utilities.h"

@implementation NSMutableAttributedString (Utilities)

- (void)addColor:(UIColor *)color substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (void)addBackgroundColor:(UIColor *)color substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
    }
}

- (void)addUnderlineForSubstring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute: NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    }
}

- (void)addStrikeThrough:(CGFloat)thickness substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute: NSStrikethroughStyleAttributeName value:@(thickness) range:range];
    }
}

- (void)addShadowColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height radius:(NSInteger)radius substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        NSShadow *shadow = [[NSShadow alloc] init];
        
        [shadow setShadowColor:color];
        [shadow setShadowOffset:CGSizeMake (width, height)];
        [shadow setShadowBlurRadius:radius];
        
        [self addAttribute: NSShadowAttributeName value:shadow range:range];
    }
}

- (void)addFontWithName:(NSString *)fontName size:(CGFloat)fontSize substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        
        [self addAttribute: NSFontAttributeName value:font range:range];
    }
}

- (void)addAlignment:(NSTextAlignment)alignment substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc] init];
        style.alignment = alignment;
        
        [self addAttribute: NSParagraphStyleAttributeName value:style range:range];
    }
}

- (void)addLineBreakMode:(NSLineBreakMode)lineBreakMode substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = lineBreakMode;
        
        [self addAttribute: NSParagraphStyleAttributeName value:style range:range];
    }
}

- (void)addStrokeColor:(UIColor *)color thickness:(CGFloat)thickness substring:(NSString *)substring
{
    NSRange range = [self.string rangeOfString:substring];
    
    if (range.location != NSNotFound)
    {
        [self addAttribute:NSStrokeColorAttributeName value:color range:range];
        [self addAttribute:NSStrokeWidthAttributeName value:@(thickness) range:range];
    }
}

@end
