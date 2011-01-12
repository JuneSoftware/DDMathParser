//
//  DDMathEvaluator.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDMathEvaluator.h"
#import "DDMathEvaluator+Private.h"
#import "DDParser.h"
#import "DDExpression.h"
#import "_DDFunctionUtilities.h"

@implementation _DDMathEvaluatorFunctionContainer
@synthesize target, action;

- (void) dealloc {
	[target release];
	[super dealloc];
}

- (DDExpression *) invokeWithArguments:(NSArray *)arguments variables:(NSDictionary *)variables evaluator:(DDMathEvaluator *)evaluator {
	NSInvocation * i = [NSInvocation invocationWithMethodSignature:[[self target] methodSignatureForSelector:[self action]]];
	
	[i setTarget:[self target]];
	[i setSelector:[self action]];
	[i setArgument:&arguments atIndex:2];
	[i setArgument:&variables atIndex:3];
	[i setArgument:&evaluator atIndex:4];
	
	[i invoke];
	
	DDExpression * returnValue = nil;
	[i getReturnValue:&returnValue];
	
	return returnValue;
}

@end



@interface DDMathEvaluator ()

- (NSSet *) _standardFunctions;
- (NSDictionary *) _standardAliases;
- (void) _registerStandardFunctions;

@end


@implementation DDMathEvaluator

static DDMathEvaluator * _sharedEvaluator = nil;

+ (id) sharedMathEvaluator {
	if (_sharedEvaluator == nil) {
		_sharedEvaluator = [[DDMathEvaluator alloc] init];
	}
	return _sharedEvaluator;
}

- (id) init {
	self = [super init];
	if (self) {
		functions = [[NSMutableDictionary alloc] init];
		[self _registerStandardFunctions];
	}
	return self;
}

- (void) dealloc {
	if (self == _sharedEvaluator) {
		_sharedEvaluator = nil;
	}
	[functions release];
	[super dealloc];
}

- (BOOL) registerTarget:(id)target action:(SEL)action asFunction:(NSString *)functionName {
	if ([self functionWithName:functionName] != nil) { return NO; }
	if ([[self _standardFunctions] containsObject:[functionName lowercaseString]]) { return NO; }
	if (target == nil || action == NULL) { return NO; }
	if ([target respondsToSelector:action] == NO) { return NO; }
	
	NSMethodSignature * actionSignature = [target methodSignatureForSelector:action];
	if (actionSignature == nil) { return NO; }
	//self, _cmd, arguments, variables, evaluator:
	if ([actionSignature numberOfArguments] != 5) { return NO; }
	const char * v = [actionSignature methodReturnType];
	if (strcmp(v, @encode(DDExpression *)) != 0) { return NO; }
	v = [actionSignature getArgumentTypeAtIndex:2];
	if (strcmp(v, @encode(NSArray *)) != 0) { return NO; }
	v = [actionSignature getArgumentTypeAtIndex:3];
	if (strcmp(v, @encode(NSDictionary *)) != 0) { return NO; }
	v = [actionSignature getArgumentTypeAtIndex:4];
	if (strcmp(v, @encode(DDMathEvaluator *)) != 0) { return NO; }
	
	_DDMathEvaluatorFunctionContainer * container = [[_DDMathEvaluatorFunctionContainer alloc] init];
	[container setTarget:target];
	[container setAction:action];
	[functions setObject:container forKey:[functionName lowercaseString]];
	[container release];
	
	return YES;
}

- (void) unregisterFunctionWithName:(NSString *)functionName {
	//can't unregister built-in functions
	if ([[self _standardFunctions] containsObject:[functionName lowercaseString]]) { return; }
	
	[functions removeObjectForKey:[functionName lowercaseString]];
}

- (_DDMathEvaluatorFunctionContainer *) functionWithName:(NSString *)functionName {
	return [functions objectForKey:[functionName lowercaseString]];
}

- (NSArray *) registeredFunctions {
	return [functions allKeys];
}

- (NSString *) nsexpressionFunctionWithName:(NSString *)functionName {
	return nil;
	//	NSDictionary * map = [DDMathFunctionContainer nsexpressionFunctions];
	//	NSString * function = [map objectForKey:[functionName lowercaseString]];
	//	return function;
}

- (void) functionExpressionFailedToResolve:(_DDFunctionExpression *)functionExpression {
	[NSException raise:NSInvalidArgumentException format:@"unknown function: %@", [functionExpression function]];
}

- (BOOL) addAlias:(NSString *)alias forFunctionName:(NSString *)functionName {
	//we can't add an alias for a function that already exists
	_DDMathEvaluatorFunctionContainer * function = [self functionWithName:alias];
	if (function != nil) { return NO; }
	
	function = [self functionWithName:functionName];
	return [self registerTarget:[function target] action:[function action] asFunction:alias];
}

- (void) removeAlias:(NSString *)alias {
	//you can't unregister a standard alias (like "avg")
	if ([[self _standardAliases] objectForKey:[alias lowercaseString]] != nil) { return; }
	[self unregisterFunctionWithName:alias];
}

#pragma mark Evaluation

- (NSNumber *) evaluateString:(NSString *)expressionString withSubstitutions:(NSDictionary *)variables {
	NSNumber * returnValue = nil;
	@try {
		DDParser * parser = [DDParser parserWithString:expressionString];
		DDExpression * parsedExpression = [parser parsedExpression];
		returnValue = [parsedExpression evaluateWithSubstitutions:variables evaluator:self];
	}
	@catch (NSException * e) {
		NSLog(@"caught exception: %@", e);
		returnValue = nil;
	}
	@finally {
		return returnValue;
	}
}

- (id) performFunction:(NSArray *)parameters {
	NSMutableArray * mutableParameters = [parameters mutableCopy];
	NSString * functionName = [[mutableParameters objectAtIndex:0] constantValue];
	[mutableParameters removeObjectAtIndex:0];
	NSLog(@"stuff to %@: %@", functionName, mutableParameters);
	[mutableParameters release];
	return [NSNumber numberWithInt:0];
}

#pragma mark Built-In Functions

- (NSSet *) _standardFunctions {
	return [NSSet setWithObjects:
			//arithmetic functions (2 parameters)
			DDMathFunctionAdd,
			DDMathFunctionSubtract,
			DDMathFunctionMultiply,
			DDMathFunctionDivide,
			DDMathFunctionModulo,
			DDMathFunctionFactorial,
			DDMathFunctionPower,
			
			//bitwise functions (2 parameters)
			DDMathFunctionBitwiseAnd,
			DDMathFunctionBitwiseOr,
			DDMathFunctionBitwiseXor,
			DDMathFunctionBitwiseRshift,
			DDMathFunctionBitwiseLshift,
			
			//functions that take > 0 parameters
			DDMathFunctionAverage,
			DDMathFunctionSum,
			DDMathFunctionCount,
			DDMathFunctionMinimum,
			DDMathFunctionMaximum,
			DDMathFunctionMedian,
			DDMathFunctionStandardDeviation,
			DDMathFunctionRandom,
			
			//functions that take 1 parameter
			DDMathFunctionNegate,
			DDMathFunctionBitwiseNot,
			DDMathFunctionSquareRoot,
			DDMathFunctionLog,
			DDMathFunctionNaturalLog,
			DDMathFunctionLogBase2,
			DDMathFunctionExp,
			DDMathFunctionCeiling,
			DDMathFunctionFloor,
			DDMathFunctionAbsoluteValue,
			
			//trig functions
			DDMathFunctionSin,
			DDMathFunctionCos,
			DDMathFunctionTan,
			DDMathFunctionAsin,
			DDMathFunctionAcos,
			DDMathFunctionAtan,
			DDMathFunctionSinh,
			DDMathFunctionCosh,
			DDMathFunctionTanh,
			DDMathFunctionAsinh,
			DDMathFunctionAcosh,
			DDMathFunctionAtanh,
			
			//trig inverse functions
			DDMathFunctionCsc,
			DDMathFunctionSec,
			DDMathFunctionCotan,
			DDMathFunctionAcsc,
			DDMathFunctionAsec,
			DDMathFunctionAcotan,
			DDMathFunctionCsch,
			DDMathFunctionSech,
			DDMathFunctionCotanh,
			DDMathFunctionAcsch,
			DDMathFunctionAsech,
			DDMathFunctionAcotanh,
			
			DDMathFunctionDtor,
			DDMathFunctionRtod,
			
			//functions that take 0 parameters
			DDMathFunctionPi,
			DDMathFunctionPiOver2,
			DDMathFunctionPiOver4,
			DDMathFunctionSquareRootOf2,
			DDMathFunctionE,
			DDMathFunctionLogBase2OfE,
			DDMathFunctionLogBase10OfE,
			DDMathFunctionNaturalLogOf2,
			DDMathFunctionNaturalLogOf10,
			nil];
	
}

- (NSDictionary *) _standardAliases {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"average", @"avg",
			@"average", @"mean",
			@"floor", @"trunc",
			nil];
}

- (void) _registerStandardFunctions {
	for (NSString * functionName in [self _standardFunctions]) {
		
		NSString * methodName = [NSString stringWithFormat:@"%@:::", [functionName lowercaseString]];
		SEL methodSelector = NSSelectorFromString(methodName);
		
		if ([_DDFunctionUtilities respondsToSelector:methodSelector]) {
			_DDMathEvaluatorFunctionContainer * function = [[_DDMathEvaluatorFunctionContainer alloc] init];
			[function setTarget:[_DDFunctionUtilities class]];
			[function setAction:methodSelector];
			[functions setObject:function forKey:[functionName lowercaseString]];
			[function release];
		} else {
			NSLog(@"error registering function: %@", functionName);
		}
	}
	
	NSDictionary * aliases = [self _standardAliases];
	for (NSString * alias in aliases) {
		NSString * function = [aliases objectForKey:alias];
		(void)[self addAlias:alias forFunctionName:function];
	}
}

@end
