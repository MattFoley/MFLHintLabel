//
//  UILabel+Lines.m
//  MFLHintLabel
//
//  Created by teejay on 2/27/13.
//  Thanks to:
//  http://stackoverflow.com/questions/4421267/how-to-get-text-from-nth-line-of-uilabel
//


#import "UILabel+Lines.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Lines)

- (NSArray*) linesForWidth:(CGFloat)width
{
    
    UIFont   *font = self.font;
    CGRect    rect = self.frame;
    
    NSMutableAttributedString *attStr;
    if (self.attributedText) {
        attStr = [self.attributedText mutableCopy];
    } else {
        attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
        CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
        [attStr addAttribute:(NSString *)kCTFontAttributeName
                       value:(__bridge id)myFont
                       range:NSMakeRange(0, attStr.length)];
    }
    
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    if (self.attributedText) {
        for (id line in lines)
        {
            CTLineRef lineRef = (__bridge CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            NSAttributedString *lineString = [self.attributedText attributedSubstringFromRange:range];
            [linesArray addObject:lineString];
        }
    }else{
        for (id line in lines)
        {
            CTLineRef lineRef = (__bridge CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            
            NSString *lineString = [self.text substringWithRange:range];
            [linesArray addObject:lineString];
        }
    }
    
    return (NSArray *)linesArray;
}

@end
