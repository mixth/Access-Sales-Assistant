//
//  UICRouteAnnotation.m
//  MapDirections
//
//  Created by KISHIKAWA Katsumi on 09/08/10.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "UICRouteAnnotation.h"

@implementation UICRouteAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize annotationType;
@synthesize number;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord 
				   title:(NSString *)aTitle 
		  annotationType:(UICRouteAnnotationType)type number:(NSUInteger)newNumber {
	self = [super init];
	if (self != nil) {
		coordinate = coord;
		title = aTitle;
		annotationType = type;
		number = newNumber;
	}
	return self;
}


@end
