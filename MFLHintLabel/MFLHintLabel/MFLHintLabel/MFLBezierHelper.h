//
//  MFLBezierHelper.h
//  MFLHintLabel
//
//  Created by teejay on 3/2/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFLBezierHelper : NSObject

extern void MoveToPointsPathApplierFunction(void* info, const CGPathElement* element);

extern NSArray* getAllPointsFromCGPath(CGPathRef path);

extern inline CGPathRef CGPathCreatePointWideDashingPath(CGPathRef path,
                                                         CGFloat phase,
                                                         const CGFloat lengths[],
                                                         size_t count);

extern NSArray* getUniformPointsFromCGPath(CGPathRef path, int spacing);

@end
