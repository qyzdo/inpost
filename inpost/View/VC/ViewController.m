//
//  ViewController.m
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import "ViewController.h"
#import "ParcelModel.h"
#import "CustomTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.array = [[NSMutableArray alloc] init];

    [self downloadData];
}
- (IBAction)clickedButton:(id)sender {
    NSString * myString = @"String";
    NSLog(@"%@", myString);
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.trackingNumberLabel.text = [[self.array objectAtIndex:indexPath.row] trackingNumber];
    cell.statusLabel.text = [[self.array objectAtIndex:indexPath.row] status];

    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (void) downloadData {
    NSString *urlString = @"https://api-shipx-pl.easypack24.net/v1/tracking/687100708024170011003255";
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
            int size = [self.array count];

            NSLog(@"there are %d objects in the array", size);
            NSLog(@"%@", [self.array[0] trackingNumber]);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

        }
    }];
    [dataTask resume];
}

@end
