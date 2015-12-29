//
//  UIButton+ColorForState.m
//  nback5d
//
//  Created by Candy on 12/27/15.
//  Copyright © 2015 jon-1. All rights reserved.
//

#import "UIButton+ColorForState.h"

@implementation UIButton (ColorForState)

- (void)setColor:(UIColor *)color forState:(UIControlState)state
{
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:colorImage forState:state];
}

@end
