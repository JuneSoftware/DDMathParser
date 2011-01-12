//
//  __DDFunctionUtilities.m
//  DDMathParser
//
//  Created by Dave DeLong on 12/21/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "_DDFunctionUtilities.h"
#import "_DDDecimalFunctions.h"
#import "DDExpression.h"

#define REQUIRE_N_ARGS(__n) { \
if ([arguments count] != __n) { \
	[NSException raise:NSGenericException format:@"%@ requires %d arguments", NSStringFromSelector(_cmd), __n]; \
	return nil; \
} \
}

#define REQUIRE_GTOE_N_ARGS(__n) { \
if ([arguments count] < __n) { \
	[NSException raise:NSGenericException format:@"%@ requires at least %d arguments", NSStringFromSelector(_cmd), __n]; \
	return nil; \
} \
}

@implementation _DDFunctionUtilities

+ (DDExpression *) add:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * secondValue = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result;
	NSDecimal lhs = [firstValue decimalValue];
	NSDecimal rhs = [secondValue decimalValue];
	NSDecimalAdd(&result, &lhs, &rhs, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) subtract:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * secondValue = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result;
	NSDecimal lhs = [firstValue decimalValue];
	NSDecimal rhs = [secondValue decimalValue];
	NSDecimalSubtract(&result, &lhs, &rhs, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) multiply:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * secondValue = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result;
	NSDecimal lhs = [firstValue decimalValue];
	NSDecimal rhs = [secondValue decimalValue];
	NSDecimalMultiply(&result, &lhs, &rhs, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) divide:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * secondValue = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result;
	NSDecimal lhs = [firstValue decimalValue];
	NSDecimal rhs = [secondValue decimalValue];
	NSDecimalDivide(&result, &lhs, &rhs, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) mod:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * secondValue = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result = DDDecimalMod([firstValue decimalValue], [secondValue decimalValue]);
	
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) negate:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	
	NSDecimal result;
	NSDecimal a = [firstValue decimalValue];
	NSDecimal nOne = DDDecimalNegativeOne();
	NSDecimalMultiply(&result, &nOne, &a, NSRoundBankers);
	
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) factorial:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * firstValue = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithDouble:tgamma([firstValue doubleValue]+1)];
	return [DDExpression numberExpressionWithNumber:result];
}

+ (DDExpression *) pow:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * base = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * exponent = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * power = [NSNumber numberWithDouble:pow([base doubleValue], [exponent doubleValue])];
	return [DDExpression numberExpressionWithNumber:power];
}

+ (DDExpression *) and:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * second = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:([first integerValue] & [second integerValue])];
	return [DDExpression numberExpressionWithNumber:result];
}

+ (DDExpression *) or:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * second = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:([first integerValue] | [second integerValue])];
	return [DDExpression numberExpressionWithNumber:result];
}

+ (DDExpression *) not:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:(~[first integerValue])];
	return [DDExpression numberExpressionWithNumber:result];	
}

+ (DDExpression *) xor:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * second = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:([first integerValue] ^ [second integerValue])];
	return [DDExpression numberExpressionWithNumber:result];	
}

+ (DDExpression *) rshift:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * second = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:([first integerValue] >> [second integerValue])];
	return [DDExpression numberExpressionWithNumber:result];
}

+ (DDExpression *) lshift:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(2);
	NSNumber * first = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * second = [[arguments objectAtIndex:1] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSNumber * result = [NSNumber numberWithInteger:([first integerValue] << [second integerValue])];
	return [DDExpression numberExpressionWithNumber:result];
}

+ (DDExpression *) sum:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	NSDecimal result = [[NSDecimalNumber zero] decimalValue];
	for (DDExpression * argument in arguments) {
		NSNumber * value = [argument evaluateWithSubstitutions:variables evaluator:evaluator];
		NSDecimal number = [value decimalValue];
		NSDecimalAdd(&result, &result, &number, NSRoundBankers);
	}
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) average:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	DDExpression * sumExpression = [_DDFunctionUtilities sum:arguments :variables :evaluator];
	NSDecimalNumber * sum = (NSDecimalNumber *)[sumExpression number];
	NSDecimalNumber * count = [NSDecimalNumber decimalNumberWithMantissa:[arguments count] exponent:0 isNegative:NO];
	NSDecimalNumber * avg = [sum decimalNumberByDividingBy:count];
	return [DDExpression numberExpressionWithNumber:avg];	
}

+ (DDExpression *) count:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithMantissa:[arguments count] exponent:0 isNegative:NO]];
}

+ (DDExpression *) min:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	NSDecimal result;
	for (NSUInteger index = 0; index < [arguments count]; ++index) {
		DDExpression * obj = [arguments objectAtIndex:index];
		NSNumber * value = [obj evaluateWithSubstitutions:variables evaluator:evaluator];
		NSDecimal decimalValue = [value decimalValue];
		if (index == 0 || NSDecimalCompare(&result, &decimalValue) == NSOrderedDescending) {
			//result > decimalValue (or is first index)
			//decimalValue is smaller
			result = decimalValue;
		}
	}
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) max:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	NSDecimal result;
	for (NSUInteger index = 0; index < [arguments count]; ++index) {
		DDExpression * obj = [arguments objectAtIndex:index];
		NSNumber * value = [obj evaluateWithSubstitutions:variables evaluator:evaluator];
		NSDecimal decimalValue = [value decimalValue];
		if (index == 0 || NSDecimalCompare(&result, &decimalValue) == NSOrderedAscending) {
			//result < decimalValue (or is first index)
			//decimalValue is larger
			result = decimalValue;
		}
	}
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:result]];
}

+ (DDExpression *) median:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	NSMutableArray * evaluatedNumbers = [NSMutableArray array];
	for (DDExpression * e in arguments) {
		[evaluatedNumbers addObject:[e evaluateWithSubstitutions:variables evaluator:evaluator]];
	}
	[evaluatedNumbers sortUsingSelector:@selector(compare:)];
	
	NSNumber * median = nil;
	if (([evaluatedNumbers count] % 2) == 1) {
		NSUInteger index = floor([evaluatedNumbers count] / 2);
		median = [evaluatedNumbers objectAtIndex:index];
	} else {
		NSUInteger lowIndex = floor([evaluatedNumbers count] / 2);
		NSUInteger highIndex = floor([evaluatedNumbers count] / 2);
		NSDecimal lowDecimal = [[evaluatedNumbers objectAtIndex:lowIndex] decimalValue];
		NSDecimal highDecimal = [[evaluatedNumbers objectAtIndex:highIndex] decimalValue];
		NSDecimal result = DDDecimalAverage2(lowDecimal, highDecimal);
		median = [NSDecimalNumber decimalNumberWithDecimal:result];
	}
	return [DDExpression numberExpressionWithNumber:median];
}

+ (DDExpression *) stddev:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_GTOE_N_ARGS(1);
	DDExpression * avgExpression = [_DDFunctionUtilities average:arguments :variables :evaluator];
	NSDecimal avg = [[avgExpression number] decimalValue];
	NSDecimal stddev = DDDecimalZero();
	for (DDExpression * arg in arguments) {
		NSDecimal n = [[arg evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
		NSDecimal diff;
		NSDecimalSubtract(&diff, &avg, &n, NSRoundBankers);
		NSDecimalMultiply(&diff, &diff, &diff, NSRoundBankers);
		NSDecimalAdd(&stddev, &stddev, &diff, NSRoundBankers);
	}
	NSDecimal count = DDDecimalFromInteger([arguments count]);
	NSDecimalDivide(&stddev, &stddev, &count, NSRoundBankers);
	stddev = DDDecimalSqrt(&stddev);
	
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:stddev]];
}

+ (DDExpression *) sqrt:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * n = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	NSDecimal number = [n decimalValue];
	NSDecimal s = DDDecimalSqrt(&number);
	
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:s]];
}

+ (DDExpression *) random:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	if ([arguments count] > 2) {
		[NSException raise:NSInvalidArgumentException format:@"random() may only have up to 2 arguments"];
		return nil;
	}
	
	NSMutableArray * params = [NSMutableArray array];
	for (DDExpression * argument in arguments) {
		NSNumber * value = [argument evaluateWithSubstitutions:variables evaluator:evaluator];
		[params addObject:value];
	}
	
	NSInteger random = arc4random();
	
	if ([params count] == 1) {
		NSNumber * lowerBound = [params objectAtIndex:0];
		while (random < [lowerBound integerValue]) {
			random += [lowerBound integerValue];
		}} else if ([params count] == 2) {
			NSNumber * lowerBound = [params objectAtIndex:0];
			NSNumber * upperBound = [params objectAtIndex:1];
			
			if ([upperBound integerValue] <= [lowerBound integerValue]) {
				[NSException raise:NSInvalidArgumentException format:@"upper bound (%ld) of random() must be larger than lower bound (%ld)", [upperBound integerValue], [lowerBound integerValue]];
				return nil;
			}
			
			NSInteger range = abs(([upperBound integerValue] - [lowerBound integerValue]) + 1);
			random = random % range;
			random += [lowerBound integerValue];
		}
	
	return [DDExpression numberExpressionWithNumber:[NSNumber numberWithInteger:random]];
}

+ (DDExpression *) log:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * n = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	return [DDExpression numberExpressionWithNumber:[NSNumber numberWithDouble:log10([n doubleValue])]];
}

+ (DDExpression *) ln:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * n = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	return [DDExpression numberExpressionWithNumber:[NSNumber numberWithDouble:log([n doubleValue])]];
}

+ (DDExpression *) log2:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * n = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	return [DDExpression numberExpressionWithNumber:[NSNumber numberWithDouble:log2([n doubleValue])]];
}

+ (DDExpression *) exp:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSNumber * n = [[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
	return [DDExpression numberExpressionWithNumber:[NSNumber numberWithDouble:exp([n doubleValue])]];
}

+ (DDExpression *) ceil:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal ceil = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	NSDecimalRound(&ceil, &ceil, 0, NSRoundUp);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:ceil]];
}

+ (DDExpression *) abs:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal abs = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	abs = DDDecimalAbsoluteValue(abs);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:abs]];
}

+ (DDExpression *) floor:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal n = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	NSDecimalRound(&n, &n, 0, NSRoundDown);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:n]];
}

+ (DDExpression *) sin:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalSin(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) cos:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalCos(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) tan:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalTan(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) asin:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAsin(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acos:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAcos(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) atan:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAtan(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) sinh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalSinh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) cosh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalCosh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) tanh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalTanh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) asinh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAsinh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acosh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAcosh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) atanh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAtanh(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) csc:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalSin(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) sec:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalCos(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) cotan:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalTan(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acsc:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAsin(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) asec:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAcos(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acotan:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAtan(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) csch:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalSinh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) sech:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalCosh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) cotanh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalTanh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acsch:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAsinh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) asech:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAcosh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) acotanh:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal num = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	num = DDDecimalAtanh(num);
	num = DDDecimalInverse(num);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:num]];
}

+ (DDExpression *) dtor:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal n = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	NSDecimal tsz = DDDecimalFromInteger(360);
	NSDecimal tpi = DDDecimal2Pi();
	
	n = DDDecimalMod(n, tsz);
	NSDecimal r;
	NSDecimalDivide(&r, &n, &tsz, NSRoundBankers);
	NSDecimalMultiply(&r, &r, &tpi, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:r]];
}

+ (DDExpression *) rtod:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(1);
	NSDecimal n = [[[arguments objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator] decimalValue];
	NSDecimal tsz = DDDecimalFromInteger(360);
	NSDecimal tpi = DDDecimal2Pi();
	
	n = DDDecimalMod2Pi(n);
	NSDecimal r;
	NSDecimalDivide(&r, &n, &tpi, NSRoundBankers);
	NSDecimalMultiply(&r, &r, &tsz, NSRoundBankers);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:r]];
}

#pragma mark Constant Functions

+ (DDExpression *) pi:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi()]];
}

+ (DDExpression *) pi_2:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi_2()]];
}

+ (DDExpression *) pi_4:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalPi_4()]];
}

+ (DDExpression *) sqrt2:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalSqrt2()]];
}

+ (DDExpression *) e:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalE()]];
}

+ (DDExpression *) log2e:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalLog2e()]];
}

+ (DDExpression *) log10e:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalLog10e()]];
}

+ (DDExpression *) ln2:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalLn2()]];
}

+ (DDExpression *) ln10:(NSArray *)arguments :(NSDictionary *)variables :(DDMathEvaluator *)evaluator {
	REQUIRE_N_ARGS(0);
	return [DDExpression numberExpressionWithNumber:[NSDecimalNumber decimalNumberWithDecimal:DDDecimalLn10()]];
}


@end
