//
//  UIViewExtension.m
//  inpost
//
//  Created by Oskar Figiel on 20/07/2020.
//

#import <Foundation/Foundation.h>
#import "UIViewExtension.h"

@implementation UIView (AnimateHidden)

- (void)setHiddenAnimated:(BOOL)hide
                    delay:(NSTimeInterval)delay
                 duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if (hide) {
                             self.alpha = 0;
                         } else {
                             self.alpha = 0;
                             self.hidden = NO; // We need this to see the animation 0 -> 1
                             self.alpha = 1;
                         }
    } completion:^(BOOL finished) {
        self.hidden = hide;
    }];
}

@end
