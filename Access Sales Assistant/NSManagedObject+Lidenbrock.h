//
//  NSManagedObject+Lidenbrock.h
//  Lidenbrock
//
//  Created by feeef on 08/04/11.
//  Copyright 2011 Six Degrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "LBObjectManager.h"
#import "JSONKit.h"


@interface NSManagedObject (Lidenbrock)

+ (id) newEntity;

+ (id) entityWithId : (NSString *) newId;

+ (id) entityFromJson : (NSString *) json;



+ (NSArray *) fetch : (NSString *) format, ...;



+ (NSArray *) entitiesFromJson : (NSString *) json;

+ (NSArray *) entitiesFromPlist : (NSArray *) array;

- (void) loadFromJson : (NSString *) json;

- (void) loadFromDictionary : (NSDictionary *) dictionary;



- (NSDictionary *) toDictionary;



- (NSString *) getClassNameForKey : (NSString *) key;

@end
