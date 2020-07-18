//
//  CustomTableViewCell.h
//  inpost
//
//  Created by Oskar Figiel on 19/07/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *trackingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

NS_ASSUME_NONNULL_END
