//
//  DDMath.h
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

enum { DDMathFunctionUnlimitedArguments = -1 };

extern NSString * const DDMathFunctionAdd;
extern NSString * const DDMathFunctionSubtract;
extern NSString * const DDMathFunctionMultiply;
extern NSString * const DDMathFunctionDivide;
extern NSString * const DDMathFunctionModulo;
extern NSString * const DDMathFunctionFactorial;
extern NSString * const DDMathFunctionPower;

extern NSString * const DDMathFunctionBitwiseAnd;
extern NSString * const DDMathFunctionBitwiseOr;
extern NSString * const DDMathFunctionBitwiseXor;
extern NSString * const DDMathFunctionBitwiseRshift;
extern NSString * const DDMathFunctionBitwiseLshift;

extern NSString * const DDMathFunctionAverage;
extern NSString * const DDMathFunctionSum;
extern NSString * const DDMathFunctionCount;
extern NSString * const DDMathFunctionMinimum;
extern NSString * const DDMathFunctionMaximum;
extern NSString * const DDMathFunctionMedian;
extern NSString * const DDMathFunctionStandardDeviation;
extern NSString * const DDMathFunctionRandom;

extern NSString * const DDMathFunctionNegate;
extern NSString * const DDMathFunctionBitwiseNot;
extern NSString * const DDMathFunctionSquareRoot;
extern NSString * const DDMathFunctionLog;
extern NSString * const DDMathFunctionNaturalLog;
extern NSString * const DDMathFunctionLogBase2;
extern NSString * const DDMathFunctionExp;
extern NSString * const DDMathFunctionCeiling;
extern NSString * const DDMathFunctionFloor;
extern NSString * const DDMathFunctionAbsoluteValue;

extern NSString * const DDMathFunctionSin;
extern NSString * const DDMathFunctionCos;
extern NSString * const DDMathFunctionTan;
extern NSString * const DDMathFunctionAsin;
extern NSString * const DDMathFunctionAcos;
extern NSString * const DDMathFunctionAtan;
extern NSString * const DDMathFunctionSinh;
extern NSString * const DDMathFunctionCosh;
extern NSString * const DDMathFunctionTanh;
extern NSString * const DDMathFunctionAsinh;
extern NSString * const DDMathFunctionAcosh;
extern NSString * const DDMathFunctionAtanh;

extern NSString * const DDMathFunctionCsc;
extern NSString * const DDMathFunctionSec;
extern NSString * const DDMathFunctionCotan;
extern NSString * const DDMathFunctionAcsc;
extern NSString * const DDMathFunctionAsec;
extern NSString * const DDMathFunctionAcotan;
extern NSString * const DDMathFunctionCsch;
extern NSString * const DDMathFunctionSech;
extern NSString * const DDMathFunctionCotanh;
extern NSString * const DDMathFunctionAcsch;
extern NSString * const DDMathFunctionAsech;
extern NSString * const DDMathFunctionAcotanh;

extern NSString * const DDMathFunctionDtor;
extern NSString * const DDMathFunctionRtod;

extern NSString * const DDMathFunctionPi;
extern NSString * const DDMathFunctionPiOver2;
extern NSString * const DDMathFunctionPiOver4;
extern NSString * const DDMathFunctionSquareRootOf2;
extern NSString * const DDMathFunctionE;
extern NSString * const DDMathFunctionLogBase2OfE;
extern NSString * const DDMathFunctionLogBase10OfE;
extern NSString * const DDMathFunctionNaturalLogOf2;
extern NSString * const DDMathFunctionNaturalLogOf10;