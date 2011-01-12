//
//  _DDFunctionExpression.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "_DDFunctionExpression.h"
#import "DDMathEvaluator.h"
#import "DDMathEvaluator+Private.h"
#import "_DDNumberExpression.h"
#import "_DDVariableExpression.h"

@implementation _DDFunctionExpression

- (id) initWithFunction:(NSString *)f arguments:(NSArray *)a {
	self = [super init];
	if (self) {
		for (id arg in a) {
			if ([arg isKindOfClass:[DDExpression class]] == NO) {
				[NSException raise:NSInvalidArgumentException format:@"function arguments must be DDExpression objects"];
				[self release];
				return nil;
			}
		}
		
		function = [f copy];
		arguments = [a copy];
	}
	return self;
}
- (void) dealloc {
	[function release];
	[arguments release];
	[super dealloc];
}
- (DDExpressionType) expressionType { return DDExpressionTypeFunction; }

- (NSString *) function { return [function lowercaseString]; }
- (NSArray *) arguments { return arguments; }

- (DDExpression *) simplifiedExpressionWithEvaluator:(DDMathEvaluator *)evaluator {
	BOOL canSimplify = YES;
	for (DDExpression * e in [self arguments]) {
		DDExpression * a = [e simplifiedExpressionWithEvaluator:evaluator];
		if ([a expressionType] != DDExpressionTypeNumber) {
			canSimplify = NO;
		}
	}
	
	if (canSimplify) {
		if (evaluator == nil) { evaluator = [DDMathEvaluator sharedMathEvaluator]; }
		
		_DDMathEvaluatorFunctionContainer * mathFunction = [evaluator functionWithName:[self function]];
		id result = [mathFunction invokeWithArguments:[self arguments] variables:nil evaluator:evaluator];
		
		if ([result isKindOfClass:[_DDNumberExpression class]]) {
			return result;
		} else if ([result isKindOfClass:[NSNumber class]]) {
			return [DDExpression numberExpressionWithNumber:result];
		}		
	}
	
	return self;
}

- (NSNumber *) evaluateWithSubstitutions:(NSDictionary *)substitutions evaluator:(DDMathEvaluator *)evaluator {
	if (evaluator == nil) { evaluator = [DDMathEvaluator sharedMathEvaluator]; }
	
	_DDMathEvaluatorFunctionContainer * mathFunction = [evaluator functionWithName:[self function]];
	
	if (mathFunction != nil) {
		id result = [mathFunction invokeWithArguments:[self arguments] variables:nil evaluator:evaluator];
		
		while ([result isKindOfClass:[_DDVariableExpression class]]) {
			result = [result evaluateWithSubstitutions:substitutions evaluator:evaluator];
		}
		
		NSNumber * numberValue = nil;
		if ([result isKindOfClass:[_DDNumberExpression class]]) {
			numberValue = [result number];
		} else if ([result isKindOfClass:[NSNumber class]]) {
			numberValue = result;
		} else {
			[NSException raise:NSInvalidArgumentException format:@"invalid return type from %@ function", [self function]];
			return nil;
		}
		return numberValue;
	} else {
		[evaluator functionExpressionFailedToResolve:self];
		return nil;
	}
	
}

- (NSExpression *) expressionValueForEvaluator:(DDMathEvaluator *)evaluator {
	NSString * nsexpressionFunction = [evaluator nsexpressionFunctionWithName:[self function]];
	NSMutableArray * expressionArguments = [NSMutableArray array];
	for (DDExpression * argument in [self arguments]) {
		[expressionArguments addObject:[argument expressionValueForEvaluator:evaluator]];
	}
	
	if (nsexpressionFunction != nil) {
		return [NSExpression expressionForFunction:nsexpressionFunction arguments:expressionArguments];
	} else {
		NSExpression * target = [NSExpression expressionForConstantValue:evaluator];
		NSExpression * functionExpression = [NSExpression expressionForConstantValue:[self function]];
		[expressionArguments insertObject:functionExpression atIndex:0];
		
		NSExpression * argumentsExpression = [NSExpression expressionForConstantValue:expressionArguments];
		return [NSExpression expressionForFunction:target selectorName:@"performFunction:" arguments:[NSArray arrayWithObject:argumentsExpression]];
	}
}

- (NSString *) description {
	return [NSString stringWithFormat:@"%@(%@)", [self function], [[[self arguments] valueForKey:@"description"] componentsJoinedByString:@","]];
}

@end
