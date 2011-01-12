//
//  DDOperatorTerm.m
//  DDMathParser
//
//  Created by Dave DeLong on 12/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "DDOperatorTerm.h"
#import "DDTypes.h"

static NSDictionary * operatorNames = nil;

@implementation DDOperatorTerm

- (DDOperator) operatorType {
	if ([[self tokenValue] tokenType] != DDTokenTypeOperator) {
		[NSException raise:NSGenericException format:@"not an operator term"];
	}
	return [[self tokenValue] operatorType];
}

- (DDPrecedence) operatorPrecedence {
	if ([[self tokenValue] tokenType] != DDTokenTypeOperator) {
		[NSException raise:NSGenericException format:@"not an operator term"];
	}
	return [[self tokenValue] operatorPrecedence];
}

- (NSString *) operatorFunction {
	if ([[self tokenValue] tokenType] != DDTokenTypeOperator) {
		[NSException raise:NSGenericException format:@"not an operator term"];
	}
	
	if (operatorNames == nil) {
		operatorNames = [[NSDictionary alloc] initWithObjectsAndKeys:
						 DDMathFunctionBitwiseOr, @"|",
						 DDMathFunctionBitwiseXor, @"^", 
						 DDMathFunctionBitwiseAnd, @"&", 
						 DDMathFunctionBitwiseLshift, @"<<", 
						 DDMathFunctionBitwiseRshift, @">>", 
						 DDMathFunctionSubtract, @"-",
						 DDMathFunctionAdd, @"+", 
						 DDMathFunctionDivide, @"/", 
						 DDMathFunctionMultiply, @"*", 
						 DDMathFunctionModulo, @"%", 
						 DDMathFunctionBitwiseNot, @"~", 
						 DDMathFunctionFactorial, @"!", 
						 DDMathFunctionPower, @"**", 
						 nil];
						 
	}
	
	NSString * function = [operatorNames objectForKey:[[self tokenValue] token]];
	if ([[self tokenValue] operatorPrecedence] == DDPrecedenceUnary) {
		if ([[[self tokenValue] token] isEqual:@"-"]) { return @"negate"; }
		if ([[[self tokenValue] token] isEqual:@"+"]) { return @""; }
	}
	
	return function;
}

@end
