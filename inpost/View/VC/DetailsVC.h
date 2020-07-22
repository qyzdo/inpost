//
//  DetailsVC.h
//  inpost
//
//  Created by Oskar Figiel on 22/07/2020.
//

#import <UIKit/UIKit.h>
#import "ParcelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsVC : UIViewController
@property (weak, nonatomic) IBOutlet Parcel *parcel;
@property (weak, nonatomic) IBOutlet UILabel *trackingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetMachineIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropoffMachineIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetAddresLine1Label;
@property (weak, nonatomic) IBOutlet UILabel *dropOffAddresLine1Label;
@property (weak, nonatomic) IBOutlet UILabel *dropOffAddresLine2Label;
@property (weak, nonatomic) IBOutlet UILabel *targetAddresLine2Label;
@property (weak, nonatomic) IBOutlet UILabel *targetDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropOffDescriptionLabel;
@property (strong, nonatomic, nullable) NSArray<ParcelTrackingDetail *> *trackingDetailsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
