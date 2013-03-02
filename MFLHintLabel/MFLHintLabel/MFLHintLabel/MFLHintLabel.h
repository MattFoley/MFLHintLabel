//
//  MFLHintLabel.h
//  MFLHintLabel
//
//  Created by teejay on 2/27/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//

#import <Foundation/Foundation.h>
#warning This class only works for UILineBreakWordWrapping or NSLineBreakByWordWrapping
#warning This class only works for alignments left/center

typedef enum {
    kMFLAnimationCurvedExplode,    // Scrolls left first, then back right to the original position
    kMFLAnimationExplode,        // Scrolls right first, then back left to the original position
    kMFLAnimationLinear,
    kMFLAnimationImplode// Continuously scrolls left (with a pause at the original position if animationDelay is set)
} kMFLAnimationType;

@interface MFLHintLabel : NSObject

@property (nonatomic, strong) UIView *targetView;

@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSArray *lineArray;
@property (nonatomic, strong) NSString *stringToDisplay;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat displayTime;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) UIViewAnimationOptions options;

@property (nonatomic, assign) CGPoint startPosition;
@property (nonatomic, assign) CGPoint displayPosition;
@property (nonatomic, assign) CGPoint endPosition;

@property (nonatomic, assign) CGFloat widthConstraint;

@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) kMFLAnimationType animationType;

@property (nonatomic, assign) BOOL shouldFade;



- (void)run;
- (void)stop;
- (void)prepareToRun;

- (MFLHintLabel *)createHintAnimationForText:(NSString*)text
                                    withFont:(UIFont*)font
                                 beginningAt:(CGPoint)startPoint
                                displayingAt:(CGPoint)displayPoint
                                    endingAt:(CGPoint)endPoint
                                inTargetView:(UIView*)view;

- (MFLHintLabel *)createHintAnimationForLabel:(UILabel*)label
                                  beginningAt:(CGPoint)startPoint
                                 displayingAt:(CGPoint)displayPoint
                                     endingAt:(CGPoint)endPoint
                                 inTargetView:(UIView*)view;

@end
