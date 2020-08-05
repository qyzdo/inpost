//
//  DetailsVC.m
//  inpost
//
//  Created by Oskar Figiel on 22/07/2020.
//

#import "DetailsVC.h"
#import "StringExtension.h"

@interface DetailsVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DetailsVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.trackingDetailsArray = [[NSMutableArray<ParcelTrackingDetail *> alloc] init];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:self.parcel.trackingNumber];
    self.trackingDetailsArray = self.parcel.trackingDetails;
    self.trackingNumberLabel.text = self.parcel.trackingNumber;
    self.statusLabel.text = self.parcel.status.statusRefactor;
    self.sizeLabel.text = self.parcel.customAttributes.size;
    self.sizeLabel.text = self.parcel.customAttributes.size;
    self.targetMachineIDLabel.text = self.parcel.customAttributes.targetMachineID;
    self.dropoffMachineIDLabel.text = self.parcel.customAttributes.dropoffMachineID;
    self.targetAddresLine1Label.text = self.parcel.customAttributes.targetMachineDetail.address.line1;
    self.targetAddresLine2Label.text = self.parcel.customAttributes.targetMachineDetail.address.line2;
    self.dropOffAddresLine1Label.text = self.parcel.customAttributes.dropoffMachineDetail.address.line1;
    self.dropOffAddresLine2Label.text = self.parcel.customAttributes.dropoffMachineDetail.address.line2;
    self.targetDescriptionLabel.text = self.parcel.customAttributes.targetMachineDetail.locationDescription;
    self.dropOffDescriptionLabel.text = self.parcel.customAttributes.dropoffMachineDetail.locationDescription;

}


#pragma mark - numberOfRowsInSection
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trackingDetailsArray.count;
}

#pragma mark - cellForRowAtIndexPath
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
    NSDate *date = [dateFormatter dateFromString:self.trackingDetailsArray[indexPath.row].datetime];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateChanged = [dateFormatter stringFromDate:date];
    
    cell.detailTextLabel.text = dateChanged;
    cell.textLabel.text = self.trackingDetailsArray[indexPath.row].status.statusRefactor;

    return cell;
}


@end
