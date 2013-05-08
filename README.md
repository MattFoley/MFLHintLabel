MFLHintLabel
============

MFLHintLabel is the product of trying to find a playful, simple, reusable and unique way to communicate with my users. It provides nine highly customizable animation types to display and dismiss text to that end.

Primarily, this was built as a reusable tool for helping to onboard a new user to an app, something eye catching, but informative. It can be used to explain the flow of an application, a subtle control/feature, or convey the result of an interaction to your user. 

By making use of original design assets, subviews, clipping, and positioning, this could be used to create incredibly eye popping and entirely unique dialogues for your users. Almost all properties of a UILabel are supported by accessing the internal properties of MFLHintLabel.

By setting up the properties of the MFLHintLabel, all these problems are handled for you:

 - Alignment and Width is calculated dynamically
 - View hierarchy is constructed and cleaned up on demand
 - Intro animation, display time, and outro animation are all tailored to your needs
 - Further customization is provided in the form of one sided animations that allow you to animate on screen, display for a time and animate offscreen all in separate animations.

Animations Include:

• Linear presentation ie: Falling in, Flying out, Sliding in

• Exploding

• Implosion

• Trailing text, a la old school Windows Solitaire Win Animation

• Many more, and combinations of these.

For now these animations are mostly 2D, but I plan to add 3D animations soon.

Integrating this framework is simple and the sample project contains examples of all nine animations. If you want to leap right in, MFLHintLabel.h contains documentation on all the available properties for customization, and the sample project contains a dozen example animations. See below for a more thorough explanation.


Integrating this framework is simple:
============

 1. Include libMFLAnimatedLabel.a file and header files in your project.

 2. Make sure your header search paths are pointing to the folder you included libMFLAnimatedLabel.a in.

 3. Ensure you're including the CoreText, CoreGraphics, and QuartzCore frameworks in your project.

How-To Long Form
============

There are two main methods to create an animation.

This allows you to just pass in a font and string:

    - (MFLHintLabel *)createHintAnimationForText:(NSString*)text
                                        withFont:(UIFont*)font
                                     beginningAt:(CGPoint)startPoint
                                    displayingAt:(CGPoint)displayPoint
                                        endingAt:(CGPoint)endPoint
                                    inTargetView:(UIView*)view;

This allows you to pass in an already created label:                                


    - (MFLHintLabel *)createHintAnimationForLabel:(UILabel*)label
                                      beginningAt:(CGPoint)startPoint
                                     displayingAt:(CGPoint)displayPoint
                                         endingAt:(CGPoint)endPoint
                                     inTargetView:(UIView*)view;

Your target view is the view you want your animation to display in.

Your startPoint is the position the animation will start from, if applicable to the animate on type you set.

Your display point is where your animation will display at, this is also the endpoint of your initial animation.

Your endpoint is the position your label will animate out to after displaying if applicable to the animate out type you set.

# Notes

## Displaying without running
Be sure to call prepareToRun after you finish setting up your MFLHintLabel. This will create the structure for your animation, add it to the targetView view hierarchy and ready it to be run. Call this if you want to show your animation at it's startPosition for some time before running the animation.

## Memory Warning:
If you dictate only an On animation, you'll need to call:

    [hintLabel cleanAndRemoveAnimation]

To remove the hintLabel from the target view, and ensure it is deallocated.

## One Way Animation

If you wish to run only an On animation or an Off animation you must dictate either kMFLAnimateOnNone or kMFLAnimateOffNone

## Completion Block

You may run your animation with a completion block like so:

    [self.hintAnimation runWithCompletion:^{
        [[[UIAlertView alloc]initWithTitle:@"Completed"
                                   message:@"This was fired from the completion block"
                                  delegate:nil
                         cancelButtonTitle:@"Cool!"
                         otherButtonTitles:nil] show];
    }];

Beerware License