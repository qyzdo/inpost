//
//  ParcelModel.h
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import <Foundation/Foundation.h>

@class Parcel;
@class ParcelCustomAttributes;
@class ParcelMachineDetail;
@class ParcelAddress;
@class ParcelLocation;
@class ParcelTrackingDetail;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface Parcel : NSObject
@property (nonatomic, copy)   NSString *trackingNumber;
@property (nonatomic, copy)   NSString *service;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, strong) ParcelCustomAttributes *customAttributes;
@property (nonatomic, copy)   NSArray<ParcelTrackingDetail *> *trackingDetails;
@property (nonatomic, copy)   NSArray *expectedFlow;
@property (nonatomic, copy)   NSString *createdAt;
@property (nonatomic, copy)   NSString *updatedAt;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface ParcelCustomAttributes : NSObject
@property (nonatomic, copy)   NSString *size;
@property (nonatomic, copy)   NSString *targetMachineID;
@property (nonatomic, copy)   NSString *dropoffMachineID;
@property (nonatomic, strong) ParcelMachineDetail *targetMachineDetail;
@property (nonatomic, strong) ParcelMachineDetail *dropoffMachineDetail;
@property (nonatomic, assign) BOOL isEndOfWeekCollection;
@end

@interface ParcelMachineDetail : NSObject
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *openingHours;
@property (nonatomic, copy)   NSString *locationDescription;
@property (nonatomic, strong) ParcelLocation *location;
@property (nonatomic, strong) ParcelAddress *address;
@property (nonatomic, copy)   NSArray<NSString *> *type;
@property (nonatomic, assign) BOOL isLocation247;
@end

@interface ParcelAddress : NSObject
@property (nonatomic, copy) NSString *line1;
@property (nonatomic, copy) NSString *line2;
@end

@interface ParcelLocation : NSObject
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@end

@interface ParcelTrackingDetail : NSObject
@property (nonatomic, copy)           NSString *status;
@property (nonatomic, copy)           NSString *originStatus;
@property (nonatomic, nullable, copy) id agency;
@property (nonatomic, copy)           NSString *datetime;
@end

NS_ASSUME_NONNULL_END

