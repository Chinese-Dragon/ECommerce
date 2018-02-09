//
//  NSString+NSString_Extension.m
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import "NSString+NSString_Extension.h"

@implementation NSString (NSString_Extension)

-(BOOL)isBlank {
	if([[self stringByStrippingWhitespace] isEqualToString:@""])
		return YES;
	return NO;
}

-(BOOL)contains:(NSString *)string {
	NSRange range = [self rangeOfString:string];
	return (range.location != NSNotFound);
}

-(NSString *)stringByStrippingWhitespace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
	NSString *rightPart = [self substringFromIndex:from];
	return [rightPart substringToIndex:to-from];
}

@end
