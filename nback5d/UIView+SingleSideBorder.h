//
//  UIView+SingleSideBorder.h
//  
//
//  Created by Candy on 7/17/15.
//  //

#import <UIKit/UIKit.h>

@interface UIView (SingleSideBorder)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

@end
