//
//  NSString+Utilities.m
//  COLibrary
//
//  Created by Cenker Ozkurt on 7/16/13.
//  Copyright (c) 2013 Cenker Ozkurt, Inc. All rights reserved.
//

#import "NSMutableAttributedString+Utilities.h"
#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)isNumeric
{
    NSScanner *sc = [NSScanner scannerWithString: self];
    
    if ( [sc scanFloat:NULL] )
    {
        return [sc isAtEnd];
    }
    
    return NO;
}

- (NSString *)substringFromRight:(int)count
{
    return [self substringFromIndex:([self length] - count)];
}

- (NSString *)substringFromLeft:(int)count
{
    return [self substringToIndex:count];
}
                    
- (unsigned int)indexOf:(NSString *)searchChar
{
    NSRange range = [self rangeOfString:searchChar];
    
    return (int) range.location;
}

- (NSDictionary *)toDictionaryFromJSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error)
    {
        NSLog(@"Error converting JSON to dictionary : %@", [error description]);
    }
    
    return jsonDictionary;
}

- (NSArray *)toArrayFromJSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error)
    {
        NSLog(@"Error converting JSON to array : %@", [error description]);
    }
    
    return array;
}

+ (NSString *)CGPointToString:(CGPoint)point
{
    return [NSString stringWithFormat:@"{%f,%f}", point.x, point.y];
}

+ (NSString *)uuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}

+ (NSString *)uuidStringShort
{
    NSString *uuidStr = [self uuidString];
    
    return [[uuidStr componentsSeparatedByString:@"-"] objectAtIndex:0];
}

+ (NSString *)stringWithRepeatString:(NSString *)inputString joinString:(NSString *)joinString count:(int)count
{
    NSMutableArray *repetitions = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0UL; i < count; ++i)
        [repetitions addObject:inputString];
    
    return [repetitions componentsJoinedByString:joinString];
}

- (NSMutableAttributedString *)mutableStringWithColor:(UIColor *)color withFontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributes addColor:color substring:self];
    [attributes addFontWithName:fontName size:fontSize substring:self];
    
    return attributes;
}

+ (NSString *)suffixForNumber:(NSInteger)number
{
    NSString *suffix;
    NSInteger ones = number % 10;
    NSInteger tens = (number/10) % 10;
    
    if (tens == 0 || tens == 1) {
        suffix = @"th";
    } else if (ones == 1) {
        suffix = @"st";
    } else if (ones == 2) {
        suffix = @"nd";
    } else if (ones == 3) {
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    
    return [NSString stringWithFormat:@"%ld%@", (long)number, suffix];
}


- (CGSize)stringSizeWithFontName:(NSString *)fontName size:(CGFloat)fontSize
{
    return [self sizeWithAttributes: @{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize] }];
}

- (CGSize)stringSizeWithWidth:(CGFloat)widthValue fontName:(NSString *)fontName size:(CGFloat)fontSize
{
    CGSize size = CGSizeZero;
    CGRect frame = [self boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize] } context:nil];
    
    size = CGSizeMake(frame.size.width, frame.size.height);
    
    return size;
}

@end
