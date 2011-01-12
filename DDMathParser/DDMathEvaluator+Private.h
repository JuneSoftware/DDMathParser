//
//  DDMathEvaluator+Private.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMathEvaluator.h"
#import "_DDFunctionExpression.h"

@interface _DDMathEvaluatorFunctionContainer : NSObject {
	id target;
	SEL action;
}

@property (nonatomic, retain) id target;
@property (nonatomic) SEL action;

- (DDExpression *) invokeWithArguments:(NSArray *)arguments variables:(NSDictionary *)variables evaluator:(DDMathEvaluator *)evaluator;

@end

@interface DDMathEvaluator ()

- (_DDMathEvaluatorFunctionContainer *) functionWithName:(NSString *)functionName;

- (NSString *) nsexpressionFunctionWithName:(NSString *)functionName;

- (void) functionExpressionFailedToResolve:(_DDFunctionExpression *)functionExpression;

@end
