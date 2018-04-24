//
//  MyColorHolder.m
//  UltimoTeste
//
//  Created by camila oliveira on 4/10/15.
//  Copyright (c) 2015 camila oliveira. All rights reserved.
//

#import "MyColorHolder.h"

@implementation MyColorHolder


- (BOOL)isEqual:(id)other
{

    if (other == self) {
        return YES;
//    } else if (![super isEqual:other]) {
//        return NO;
    } else {
        CGFloat r1, g1,b1,a1,r2,g2,b2,a2;
        [[self theColor] getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
//        NSLog(@"1: r %f - g %f - b %f - a %f", r1, g1, b1, a1);

        [[other theColor] getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
//        NSLog(@"2: r %f - g %f - b %f - a %f", r2, g2, b2, a2);
        if (r1 == r2 && b1 == b2 && g1 == g2) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[self theColor] hash];
}
- (instancetype)initWithColor:(UIColor*)myColor
{
    self = [super init];
    if (self) {
        self.theColor = myColor;
    }
    return self;
}
-(NSString *)description{
    CGFloat r1, g1,b1,a1;
    [[self theColor] getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    return [NSString stringWithFormat:@"Color r %f - g %f - b %f - a %f", r1, g1, b1, a1];
}
@end
