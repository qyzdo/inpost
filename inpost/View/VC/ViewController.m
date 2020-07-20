//
//  ViewController.m
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import "ViewController.h"
#import "ParcelModel.h"
#import "CustomTableViewCell.h"
#import "StringExtension.h"
#import "UIViewExtension.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.array = [[NSMutableArray alloc] init];

    [self downloadData:(@"https://api-shipx-pl.easypack24.net/v1/tracking/687100708024170011003255")];
}

- (void)viewWillAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self setupOnboardingScreen];
    }
}

- (IBAction) clickedButton:(id)sender {
    NSString * myString = @"String";
    NSLog(@"%@", myString);
}


- (void)setupOnboardingScreen {
    NSLog(@"FIRST LAUNCH");
    [self.tableView setHidden:YES];
    
    UILayoutGuide * guide = self.view.safeAreaLayoutGuide;

    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = false;
    self.label.backgroundColor = [UIColor systemYellowColor];
    [self.label setFont:[UIFont systemFontOfSize:30]];
    [self.label setTextColor:[UIColor blackColor]];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.text = @"Witaj w aplikacji inpost!";
    self.label.layer.cornerRadius = 15;
    self.label.layer.masksToBounds = true;
    [self.view addSubview:self.label];
    

    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.translatesAutoresizingMaskIntoConstraints = false;
    self.button.backgroundColor = [UIColor systemYellowColor];
    [self.button setTitle:@" Kliknij tutaj i zacznij korzystać z aplikacji! " forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];

    self.button.layer.cornerRadius = 10;
    [self.button addTarget:self action:@selector(finishOnboardingScreenClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.animationView = [LOTAnimationView animationNamed:@"box"];
    self.animationView.contentMode = UIViewContentModeScaleAspectFit;
    self.animationView.translatesAutoresizingMaskIntoConstraints = false;
    self.animationView.loopAnimation = true;
    [self.view addSubview:self.animationView];
    [self.animationView playWithCompletion:^(BOOL animationFinished) {
    }];
    

    [self.label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.label.topAnchor constraintEqualToAnchor:guide.topAnchor constant:5].active = YES;
    [self.label.widthAnchor constraintEqualToConstant:350].active = YES;
    [self.label.heightAnchor constraintEqualToConstant:50].active = YES;
    

    [self.animationView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.animationView.topAnchor constraintGreaterThanOrEqualToAnchor:self.label.bottomAnchor constant:5].active = YES;
    [self.animationView.bottomAnchor constraintEqualToAnchor:self.button.topAnchor constant:-5].active = YES;
    
    [self.button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20].active = YES;
    [self.button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.button.widthAnchor constraintEqualToConstant:350].active = YES;
    [self.button.heightAnchor constraintEqualToConstant:50].active = YES;
}

- (void)finishOnboardingScreenClicked:(UIButton *)sender {
    [self.tableView setHiddenAnimated:NO delay:0 duration:2];
    [self.animationView setHiddenAnimated:YES delay:0 duration:0.5];
    [self.label setHiddenAnimated:YES delay:0 duration:0.5];
    [self.button setHiddenAnimated:YES delay:0 duration:0.5];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)downloadData:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            ParcelModel *modelObject = [ParcelModel new];
            modelObject.trackingNumber = [parsedJSONArray valueForKey:@"tracking_number"];
            modelObject.status = [parsedJSONArray valueForKey:@"status"];
            
            
            NSLog(@"%@", modelObject.trackingNumber);
            [self.array addObject:modelObject];
            unsigned long size = [self.array count];
            
            NSLog(@"there are %lu objects in the array", size);
            NSLog(@"%@", [self.array[0] trackingNumber]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
    [dataTask resume];
}




- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.trackingNumberLabel.text = [[self.array objectAtIndex:indexPath.row] trackingNumber];
    cell.statusLabel.text = [[[self.array objectAtIndex:indexPath.row] status] statusRefactor];
    
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}


@end
