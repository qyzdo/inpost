//
//  ViewController.m
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import "MainVC.h"
#import "ParcelModel.h"
#import "CustomTableViewCell.h"
#import "StringExtension.h"
#import "UIViewExtension.h"
#import "ApiCaller.h"
#import "DetailsVC.h"

@interface MainVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MainVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.parcelsArray = [[NSMutableArray alloc] init];
    
    ApiCaller *apiCaller = [ApiCaller alloc];
    [apiCaller downloadData:@"687100708024170011003255" :self.parcelsArray completion:^(NSMutableArray *parcelList) {
        self.parcelsArray = parcelList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [apiCaller downloadData:@"686065008024170117168137" :self.parcelsArray completion:^(NSMutableArray *parcelList) {
        self.parcelsArray = parcelList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self setupOnboardingScreen];
    }
    
}

#pragma mark - prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"segue"]) {
         DetailsVC *details = (DetailsVC *)segue.destinationViewController;
         details.parcel = [self.parcelsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
      }
}

#pragma mark - setupOnboardingScreen
- (void)setupOnboardingScreen {
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

#pragma mark - finishOnboardingScreenClicked
- (void)finishOnboardingScreenClicked:(UIButton *)sender {
    [self.tableView setHiddenAnimated:NO delay:0 duration:2];
    [self.animationView setHiddenAnimated:YES delay:0 duration:0.5];
    [self.label setHiddenAnimated:YES delay:0 duration:0.5];
    [self.button setHiddenAnimated:YES delay:0 duration:0.5];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segue" sender:self];
}

#pragma mark - cellForRowAtIndexPath
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.trackingNumberLabel.text = [[self.parcelsArray objectAtIndex:indexPath.row] trackingNumber];
    cell.statusLabel.text = [[[self.parcelsArray objectAtIndex:indexPath.row] status] statusRefactor];
    
    
    return cell;
}

#pragma mark - numberOfRowsInSection
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parcelsArray.count;
}


@end
