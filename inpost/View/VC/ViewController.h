//
//  ViewController.h
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) LOTAnimationView *animationView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;


- (void) setupOnboardingScreen;
- (void) finishOnboardingScreenClicked:UIButton;

@end

