//
//  NSMutableAttributedString+Utilities.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 10/07/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Utilities)

- (void)addColor:(UIColor *)color substring:(NSString *)substring;
- (void)addBackgroundColor:(UIColor *)color substring:(NSString *)substring;
- (void)addUnderlineForSubstring:(NSString *)substring;
- (void)addStrikeThrough:(CGFloat)thickness substring:(NSString *)substring;
- (void)addShadowColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height radius:(NSInteger)radius substring:(NSString *)substring;
- (void)addFontWithName:(NSString *)fontName size:(CGFloat)fontSize substring:(NSString *)substring;
- (void)addAlignment:(NSTextAlignment)alignment substring:(NSString *)substring;
- (void)addLineBreakMode:(NSLineBreakMode)lineBreakMode substring:(NSString *)substring;
- (void)addStrokeColor:(UIColor *)color thickness:(CGFloat)thickness substring:(NSString *)substring;

@end
