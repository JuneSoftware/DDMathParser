//
//  DDMathEvaluator.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTypes.h"

@class DDMathEvaluator;
@class DDExpression;

@interface DDMathEvaluator : NSObject {
	NSMutableDictionary * functions;
}

+ (id) sharedMathEvaluator;

- (BOOL) registerTarget:(id)target action:(SEL)action asFunction:(NSString *)functionName;
- (void) unregisterFunctionWithName:(NSString *)functionName;
- (NSArray *) registeredFunctions;

- (NSNumber *) evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)substitutions;

- (BOOL) addAlias:(NSString *)alias forFunctionName:(NSString *)functionName;
- (void) removeAlias:(NSString *)alias;

@end
