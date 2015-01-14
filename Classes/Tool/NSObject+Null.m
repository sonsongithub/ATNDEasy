//
//  NSObject+Null.m
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Null.h"


@implementation NSObject(Null)

- (BOOL)isNotNull {
	return !(self == [NSNull null]);
}

@end
