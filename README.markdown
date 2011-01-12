# DDMathParser

You have an `NSString`.  You want an `NSNumber`.  Previously, you would have to rely on [abusing `NSPredicate`](http://tumblr.com/xqopow93r) to turn your string into an `NSExpression` that you could then evaluate.  However, this has a major flaw:  extending it to support functions that aren't built-in to `NSExpression` provided for some awkward syntax.  So if you really need `sin()`, you have to jump through some intricate hoops to get it.

You could also have used [`GCMathParser`](http://apptree.net/parser.htm).  This, however, isn't extensible at all.  So if you really needed a `stddev()` function, you're out of luck.

Thus, `DDMathParser`.  It is written to be identical to `NSExpression` in all the ways that matter (in fact, it actually uses `NSExpression` to evaluate many of its built-in functions), but with the major addition that you can define new functions as you need.

## Features

### Registering Functions

Registering new functions is easy.  You just need an object and a method.  For example:

    - (DDExpression *) multiplyBy42:(NSArray *)args variables:(NSDictionary *)variables evaluator:(DDMathEvaluator *)evaluator {
      NSNumber * n = [[args objectAtIndex:0] evaluateWithSubstitutions:variables evaluator:evaluator];
      NSNumber * result = [NSNumber numberWithDouble:[n doubleValue] * 42.0f];
      return [DDExpression numberExpressionWithNumber:result];
    };
    
    //elsewhere
    [[DDMathEvaluator sharedMathEvaluator] registerTarget:anObject action:@selector(multiplyBy42:variables:evaluator:) asFunction:@"multiplyBy42"];
    
    NSLog(@"%@", [[DDMathEvaluator sharedMathEvaluator] evaluateString:@"multiplyBy42(3)" withSubstitutions:nil]);  //logs "126"
    
You can also unregister added functions.  You cannot unregister built-in functions, nor can they be overridden.  The evaluator retains the target.
    
Function names must begin with a letter, and can contain letters and digits.  Functions are case-insensitive.  (`mUlTiPlYbY42` is the same as `multiplyby42`)

Functions are registered with a specific instance of `DDMathEvaluator`.  The simplest approach is to register everything with the shared instance (`[DDMathEvaluator sharedMathEvaluator]`).  However, should you only need certain functions available in certain contexts, you can allocate and initialize any number of `DDMathEvaluator` objects.  All math evaluators recognize the built-in functions.
    
### Variables

If you don't know what the value of a particular term should be when the string is constructed, that's ok; simply use a variable:

    NSString * math = @"6 * $a";
    
Then when you figure out what the value is supposed to be, you can pass it along in the substitution dictionary:

    NSDictionary * variableSubstitutions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:7] forKey:@"a"];
    NSLog(@"%@", [[DDMathEvaluator sharedMathEvaluator] evaluateString:math withSubstitutions:variableSubstitutions]); //logs "42"
    
Variables are denoted in the source string as beginning with `$` and can contain numbers or letters.  They are case sensitive.  (`$a` is not the same as `$A`)
    
### Associativity

By default, all binary operators are left associative.  That means if you give a string, such as `@"1 - 2 - 3"`, it will be parsed as `@"(1 - 2) - 3`.

The exception to this is the power operator (`**`), which has its associativity determined at runtime.  The reason for this is that the power operator is supposed to be right associative, but is interpreted by `NSPredicate` as left associative ([rdar://problem/8692313](rdar://problem/8692313)).  `DDParser` performs a test to match the associativity used by `NSPredicate`.

If you want this operator to be parsed with specific associativity, you can do so like this:

    DDParser * parser = [DDParser parserWithString:@"2 ** 3 ** 2"];
    [parser setPowerAssociativity:DDOperatorAssociativityRight];
    DDExpression * e = [parser parsedExpression];
   
All binary operators can have their associativity changed this way.  If you want to change the associativity of an operator for all future parsings, you can use the class methods on `DDParser` to do so.  For example:

	[DDParser setDefaultPowerAssociativity:DDOperatorAssociativityRight];
	NSLog(@"%@", [@"2 ** 3 ** 2" numberByEvaluatingString]); //logs 512
	
Changing the default associativity only affects parsers instantiated after the change.  It does not affect existing parsers.

### Operators

`DDMathEvaluator` recognizes all common mathematical operators:

- `+` - addition (also as a unary plus)
- `-` - subtraction (also negation)
- `*` (or `x`) - multiplication
- `/` - division
- `%` - modulus
- `!` - factorial
- `**` - exponentiation
- `&` - bitwise and
- `|` - bitwise or
- `^` - bitwise xor
- `~` - bitwise not
- `<<` - bitwise left shift
- `>>` - bitwise right shift

### Implicit Multiplication

The parser recognizes implicit multiplication.  For example, we can write `3(4)` and understand that the answer should be `12`.  Implicit multiplication is applied when a number, variable, or closing parenthesis are followed by either a number, variable, function, or opening parenthesis.

A full explanation of how the implicit multiplication is handled is in the source of `DDMathStringTokenizer.m`.

### Built-in functions

In addition to the functions defined by the operators above, the following functions are built in:

Functions that take > 1 parameter

- `sum()` - returns a sum of the passed parameters
- `count()` - returns the number of passed parameters
- `min()` - returns the minimum of the passed parameters
- `max()` - returns the maximum of the passed parameters
- `median()` - returns the median of the passed parameters
- `stddev()` - returns the standard deviation of the passed parameters
- `average()` - returns the average of the passed parameters
- `random()` - returns a random integer.  Can take 0, 1, or 2 parameters.  The first parameter (if given) is the lower bound of the random integer.  The second parameter (if given) is the upper bound of the random integer.

Functions that take 1 parameter:

- `sqrt()` - returns the square root of the passed parameter
- `log()` - returns the base 10 log of the passed parameter
- `ln()` - returns the base e log of the passed parameter
- `log2()` - returns the base 2 log of the passed parameter
- `exp()` - returns e raised to the power of the passed parameter
- `ceil()` - returns the passed parameter rounded up
- `floor()` - returns the passed parameter rounded down

- `sin()` - returns the sine of the passed parameter (in radians)
- `cos()` - returns the cosine of the passed parameter (in radians)
- `tan()` - returns the tangent of the passed parameter (in radians)
- `asin()` - returns (in radians) the arcsine of the passed parameter
- `acos()` - returns (in radians) the arccosine of the passed parameter
- `atan()` - returns (in radians) the arctangent of the passed parameter
- `sinh()` - returns the hyperbolic sine of the passed parameter
- `cosh()` - returns the hyperbolic cosine of the passed parameter
- `tanh()` - returns the hyperbolic tangent of the passed parameter
- `asinh()` - returns the hyperbolic arcsine of the passed parameter
- `acosh()` - returns the hyperbolic arccosine of the passed parameter
- `atanh()` - returns the hyperbolic arctangent of the passed parameter
- all the inverses of the above trigonometric functions (`csc`, `sec`, `cotan`, `acsc`, `asec`, `acotan`, `csch`, `sech`, `cotanh`, `acsch`, `asech`, `acotanh`)

- `dtor()` - converts the passed parameter from degrees to radians
- `rtod()` - converts the passed parameter from radians to degrees

Functions that take no parameters:

- `pi()` - returns the value of π
- `pi_2()` - returns the value of π/2
- `pi_4()` - returns the value of π/4
- `sqrt2()` - returns the value of the square root of 2
- `e()` - returns the value of e
- `log2e()` - returns the value of the log base 2 of e
- `log10e()` - returns the value of the log base 10 of e
- `ln2()` - returns the value of the log base e of 2
- `ln10()` - returns the value of the log base e of 10

#### Aliases

Functions can also have aliases.  For example, the following are equivalent:

    average(1,2,3)
    avg(1,2,3)
    mean(1,2,3)
  
You can create your own aliases as well.  If "`acotanh`" is too long to type for you, feel free to do:

    [[DDMathEvaluator sharedMathEvaluator] addAlias:@"acth" forFunctionName:@"acotanh"];

## Usage

Simply copy the "DDMathParser" subfolder into your project, `#import "DDMathParser.h"`, and you're good to go.  A demo target is included as part of the project.  It shows how to evaluate a user-entered string, with support for variables.

There are several ways to evaluate strings, depending on how much customization you want to do:

### NSString

    NSLog(@"%@", [@"1 + 2" numberByEvaluatingString]);
    
Useful for the simplest evaluations (ie, no variables).  Uses the `[DDMathEvaluator sharedMathEvaluator]` and all functions registered with it.

### NSString with substitutions

    NSDictionary * s = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:42] forKey:@"a"];
    NSLog(@"%@", [@"1 + $a" numberByEvaluatingStringWithSubstitutions:s]);
    
Useful for specifying variable substitutions.  Uses the default `[DDMathEvaluator sharedMathEvaluator]`.
    
### DDExpression

	DDExpression * e = [DDExpression expressionFromString:@"1 + 2"];
	NSLog(@"%@", [e evaluateWithSubstitutions:nil evaluator:nil]);
	
Useful for specifying variable substitutions or a custom evaluator.

### DDMathEvaluator

    DDMathEvaluator * eval = [DDMathEvaluator sharedMathEvaluator];
    NSLog(@"%@", [eval evaluateString:@"1 + 2" withSubstitutions:nil]);
    
Useful for specifying variable substitutions or a custom evaluator.

### DDParser

    DDParser * parser = [DDParser parserWithString:@"1 + 2"];
    DDExpression * e = [parser parsedExpression];
    NSLog(@"%@", [e evaluateWithSubstitutions:nil evaluator:nil]);
    
Useful for specifying a custom parser or custom operator associativities, specifying variables, or specifying a custom evaluator.

## Compatibility

`DDMathParser` is compatible with Mac OS X 10.5+ and iOS 3+.

## License

Copyright (c) 2010 Dave DeLong

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## To Do:

- Transform to an `NSError`-based API
- Switch from using `NSNumber` to `NSDecimalNumber` (for higher precision); mostly implemented (except for trig/transcendental functions)