//
//  UIFont+Mapcraft.m
//  MapCraft
//
//  Created by teejay on 1/7/13.
//
//

#import "UIFont+Mapcraft.h"

@implementation UIFont (Mapcraft)
+ (UIFont *)mapCraftHeaderWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"MineCrafter-2.0" size:size];
}

+ (UIFont *)mapCraftDetailWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Minecraft" size:size];
}

@end
