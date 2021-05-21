//
//  NSString+Utilities.h
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utilities)

- (BOOL)isNumeric;

- (NSString *)substringFromRight:(int)count;
- (NSString *)substringFromLeft:(int)count;
- (unsigned int)indexOf:(NSString *)searchChar;
- (NSDictionary *)toDictionaryFromJSON;
- (NSArray *)toArrayFromJSON;

// class methods
+ (NSString *)uuidString;
+ (NSString *)uuidStringShort;
+ (NSString *)stringWithRepeatString:(NSString *)inputString joinString:(NSString *)joinString count:(int)count;

+ (NSString *)CGPointToString:(CGPoint)point;

- (NSMutableAttributedString *)mutableStringWithColor:(UIColor *)color withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize;
+ (NSString *)suffixForNumber:(NSInteger)number;

- (CGSize)stringSizeWithFontName:(NSString *)fontName size:(CGFloat)fontSize;
- (CGSize)stringSizeWithWidth:(CGFloat)widthValue fontName:(NSString *)fontName size:(CGFloat)fontSize;

@end
