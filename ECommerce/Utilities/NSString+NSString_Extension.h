//
//  NSString+NSString_Extension.h
//  ECommerce
//
//  Created by Mark on 2/7/18.
//  Copyright © 2018 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Extension)
-(BOOL)isBlank;
-(BOOL)contains:(NSString *)string;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)stringByStrippingWhitespace;
@end
