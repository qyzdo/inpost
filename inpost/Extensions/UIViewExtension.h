//
//  UIViewExtension.h
//  inpost
//
//  Created by Oskar Figiel on 20/07/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (AnimateHidden)

- (void)setHiddenAnimated:(BOOL)hide
                    delay:(NSTimeInterval)delay
                 duration:(NSTimeInterval)duration;

@end
