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

- (void) setupSplashScreen;

@end

