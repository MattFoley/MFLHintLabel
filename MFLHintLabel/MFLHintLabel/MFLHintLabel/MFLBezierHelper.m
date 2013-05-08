//
//  MFLBezierHelper.m
//  MFLHintLabel
//
//  Created by teejay on 3/2/13.
//  Mostly taken from http://iphonedevsdk.com/forum/iphone-sdk-development/101053-cgpath-help.html
//

#import "MFLBezierHelper.h"

@implementation MFLBezierHelper

void MoveToPointsPathApplierFunction(void* info, const CGPathElement* element)
{
    NSMutableArray* moveToPoints = (__bridge NSMutableArray*)info;
    
    CGPoint* points = element->points;
    CGPathElementType type = element->type;
    if (type == kCGPathElementMoveToPoint) {
        [moveToPoints addObject:[NSValue valueWithCGPoint:points[0]]];
    }
}

NSArray* getAllPointsFromCGPath(CGPathRef path)
{
    NSMutableArray* points1 = [[NSMutableArray alloc] init];
    NSMutableArray* points2 = [[NSMutableArray alloc] init];
    
    CGFloat lengths[] = {1, 1};
    // retrieve the even numbered points in the path
    CGPathRef dashingPath = CGPathCreateCopyByDashingPath(path, NULL, 0, lengths, 2);
    CGPathApply(dashingPath, (__bridge void*)points1, MoveToPointsPathApplierFunction);
    CGPathRelease(dashingPath);
    dashingPath = NULL;
    
    // retrieve the odd numbered points in the path by changing phase value.
    dashingPath = CGPathCreateCopyByDashingPath(path, NULL, 1.0, lengths, 2);
    CGPathApply(dashingPath, (__bridge void*)points2, MoveToPointsPathApplierFunction);
    CGPathRelease(dashingPath);
    
    // combine the 2 points arrays
    NSMutableArray* allPoints = [[NSMutableArray alloc] init];
    int points2Count = [points2 count];
    for (int i = 0; i < [points1 count]; i++) {
        [allPoints addObject:[points1 objectAtIndex:i]];
        if (i < points2Count) {
            [allPoints addObject:[points2 objectAtIndex:i]];
        }
    }
    return allPoints;
}

NSArray* getUniformPointsFromCGPath(CGPathRef path, int spacing)
{
    NSMutableArray* uniformPoints = [[NSMutableArray alloc] init];
    
    CGFloat lengths[] = {1, (spacing - 1)};
    CGPathRef dashingPath = CGPathCreateCopyByDashingPath(path, NULL, 0, lengths, 2);
    if (dashingPath != NULL) {
        CGPathApply(dashingPath, (__bridge void*)uniformPoints, MoveToPointsPathApplierFunction);
        CGPathRelease(dashingPath);
    }
    
    return uniformPoints;
}

@end
