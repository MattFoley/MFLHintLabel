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
    kMFLAnimateOnLinear,                //Falls onto screen to display point, falls off of screen to end position
    kMFLAnimateOnImplode,               //Explodes and Snaps into place on screen.
    kMFLAnimateOnNone
} kMFLAnimateOnType;

typedef enum {
    kMFLAnimateOffRandomCurvedExplode,  //Curved Explode with randomization
    kMFLAnimateOffCurvedExplode,        //Curved Explodes offscreen
    kMFLAnimateOffSolitare,             //Curved explode plus trails
    kMFLAnimateOffRandomSolitare,       //Curved explode plus trails plus randomization
    kMFLAnimateOffExplode,              //Explodes off screen in all directions
    kMFLAnimateOffLinear,               //Falls off of screen to end position
    kMFLAnimateImplodeStill,            //Explodes and Snaps back into place
    kMFLAnimateOffNone
} kMFLAnimateOffType;


@interface MFLHintLabel : NSObject


#warning Set these properties before calling prepareToRun
@property (nonatomic, strong) NSString *stringToDisplay;
@property (nonatomic, strong) NSAttributedString *attributedStringToDisplay;

@property (nonatomic, strong) NSMutableArray *labelArray;


@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

//Length of time to display at rest.
@property (nonatomic, assign) CGFloat displayTime;

//Length of animation sequences (This is approximate, some will last longer due to staggering)
@property (nonatomic, assign) CGFloat duration;

//Where applicable, these will be used
@property (nonatomic, assign) UIViewAnimationOptions options;

@property (nonatomic, assign) CGPoint startPosition; //Position to start from
@property (nonatomic, assign) CGPoint displayPosition; //Position to display at
@property (nonatomic, assign) CGPoint endPosition; //Position to animate to finish.

@property (nonatomic, assign) CGFloat widthConstraint; //Width of your text

//Characters to move simulatenously per phase. Set to length of your text to move all at once.
@property (nonatomic, assign) NSInteger charactersToMoveSimultaneouslyIn;
@property (nonatomic, assign) NSInteger charactersToMoveSimultaneouslyOut;

//Delay time in between phases
@property (nonatomic, assign) CGFloat phaseDelayTimeIn;
@property (nonatomic, assign) CGFloat phaseDelayTimeOut;


//If your custom font does not properly encode it's lineheight, use this to tweak it. Defaults to 0
//Negative numbers bring lines closer together, positive numbers move them further apart.
@property (nonatomic, assign) CGFloat tweakLineheight;

//If your custom font does not properly encode it's kerning, use this to tweak it. Defaults to 0
//Negative numbers bring letters closer together, positive numbers move them further apart.
@property (nonatomic, assign) CGFloat tweakKerning;

@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) kMFLAnimateOnType animateOnType;
@property (nonatomic, assign) kMFLAnimateOffType animateOffType;

//Where applicable, will apply opacity animation in/out.
@property (nonatomic, assign) BOOL shouldFadeIn;
@property (nonatomic, assign) BOOL shouldFadeOut;

#pragma mark Solitare Animations Only
//Lower numbers mean more trails. Defaults to 10
@property (nonatomic, assign) CGFloat solitareTrailLength;
//Time before trail fades.  Defaults to .1
@property (nonatomic, assign) CGFloat solitareTrailDuration;

//Higher numbers, more random. Defaults to 12
@property (nonatomic, assign) CGFloat randomizationFactor;

#pragma mark Implode Still Only
//This multiplies the labels frame size and implodes within that frame - defaults to 1, the frame of the label.
@property (nonatomic, assign) CGFloat implodeFrameFactor;
//Or set this
@property (nonatomic, assign) CGRect implodeWithinFrame;

- (void)runWithCompletion:(void (^)())animEndsBlock;

- (void)run;
- (void)stop;

- (void)prepareToRun;


- (void)cleanAndRemoveAnimation;

- (MFLHintLabel *)createHintAnimationForText:(NSString*)text
                                    withFont:(UIFont*)font
                                 beginningAt:(CGPoint)startPoint
                                displayingAt:(CGPoint)displayPoint
                                    endingAt:(CGPoint)endPoint
                                inTargetView:(UIView*)view;

- (MFLHintLabel *)createHintAnimationForAttributedText:(NSAttributedString*)text
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
