##MFLHintLabel

MFLHintLabel is the product of trying to find a playful, simple, reusable and unique way to communicate with users. It provides nine highly customizable animation types to display and dismiss text, all based on manipulating the individual characters.

Animations Include:

• Linear presentation ie: Falling in, Flying out, Sliding in

• Exploding

• Implosion

• Trailing text, a la old school Windows Solitaire Win Animation

• Many more, and combinations of these.

####Video Examples

Actual app integration in MapCraft
http://www.youtube.com/watch?v=PN5uaTX8X0Q

Sample App included here
http://www.youtube.com/watch?v=puE_riiUuuk

For now these animations are mostly 2D, but I plan to add 3D animations soon.

The sample project contains examples of all nine animations. If you want to leap right in, MFLHintLabel.h contains documentation on all the available properties for customization, and the sample project contains a dozen example animations. See below for a more thorough explanation.

##Integration

 1. Include the files in MFLHintLabel subfolder in your project

 2. Ensure you're including the CoreText, CoreGraphics, and QuartzCore frameworks in your project.
 
 3. Go go go text animations.

##How-To Long Form

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

### Notes

##### Displaying without running
Be sure to call prepareToRun after you finish setting up your MFLHintLabel. This will create the structure for your animation, add it to the targetView view hierarchy and ready it to be run. Call this if you want to show your animation at it's startPosition for some time before running the animation.

##### Memory Warning:
If you dictate only an On animation, you'll need to call:

    [hintLabel cleanAndRemoveAnimation]

To remove the hintLabel from the target view, and ensure it is deallocated.

##### One Way Animation

If you wish to run only an On animation or an Off animation you must dictate either kMFLAnimateOnNone or kMFLAnimateOffNone

##### Completion Block

You may run your animation with a completion block like so:

    [self.hintAnimation runWithCompletion:^{
        [[[UIAlertView alloc]initWithTitle:@"Completed"
                                   message:@"This was fired from the completion block"
                                  delegate:nil
                         cancelButtonTitle:@"Cool!"
                         otherButtonTitles:nil] show];
    }];

##LICENSE

This repo is under the BeerWare License, but if you feel like this saved you some time, feel free to pay for the repo at Binpress.com

http://www.binpress.com/app/mflhintlabel-animated-character-label/1333
