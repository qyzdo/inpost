//
//  ParcelModel.m
//  inpost
//
//  Created by Oskar Figiel on 11/07/2020.
//

#import "ParcelModel.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Private model interfaces

@interface Parcel (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface ParcelCustomAttributes (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface ParcelMachineDetail (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface ParcelAddress (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface ParcelLocation (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

@interface ParcelTrackingDetail (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
@end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization

Parcel *_Nullable ParcelFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [Parcel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

Parcel *_Nullable ParcelFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return ParcelFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable ParcelToData(Parcel *_, NSError **error)
{
    @try {
        id json = [_ JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable ParcelToJSON(Parcel *_, NSStringEncoding encoding, NSError **error)
{
    NSData *data = ParcelToData(_, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation Parcel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"tracking_number": @"trackingNumber",
        @"service": @"service",
        @"type": @"type",
        @"status": @"status",
        @"custom_attributes": @"customAttributes",
        @"tracking_details": @"trackingDetails",
        @"expected_flow": @"expectedFlow",
        @"created_at": @"createdAt",
        @"updated_at": @"updatedAt",
    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return ParcelFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return ParcelFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[Parcel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _customAttributes = [ParcelCustomAttributes fromJSONDictionary:(id)_customAttributes];
        _trackingDetails = map(_trackingDetails, λ(id x, [ParcelTrackingDetail fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = Parcel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:Parcel.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in Parcel.properties) {
        id propertyName = Parcel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"custom_attributes": [_customAttributes JSONDictionary],
        @"tracking_details": map(_trackingDetails, λ(id x, [x JSONDictionary])),
    }];

    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return ParcelToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return ParcelToJSON(self, encoding, error);
}
@end

@implementation ParcelCustomAttributes
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"size": @"size",
        @"target_machine_id": @"targetMachineID",
        @"dropoff_machine_id": @"dropoffMachineID",
        @"target_machine_detail": @"targetMachineDetail",
        @"dropoff_machine_detail": @"dropoffMachineDetail",
        @"end_of_week_collection": @"isEndOfWeekCollection",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[ParcelCustomAttributes alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _targetMachineDetail = [ParcelMachineDetail fromJSONDictionary:(id)_targetMachineDetail];
        _dropoffMachineDetail = [ParcelMachineDetail fromJSONDictionary:(id)_dropoffMachineDetail];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = ParcelCustomAttributes.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:ParcelCustomAttributes.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in ParcelCustomAttributes.properties) {
        id propertyName = ParcelCustomAttributes.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"target_machine_detail": [_targetMachineDetail JSONDictionary],
        @"dropoff_machine_detail": [_dropoffMachineDetail JSONDictionary],
        @"end_of_week_collection": _isEndOfWeekCollection ? @YES : @NO,
    }];

    return dict;
}
@end

@implementation ParcelMachineDetail
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"name": @"name",
        @"opening_hours": @"openingHours",
        @"location_description": @"locationDescription",
        @"location": @"location",
        @"address": @"address",
        @"type": @"type",
        @"location247": @"isLocation247",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[ParcelMachineDetail alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _location = [ParcelLocation fromJSONDictionary:(id)_location];
        _address = [ParcelAddress fromJSONDictionary:(id)_address];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = ParcelMachineDetail.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:ParcelMachineDetail.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in ParcelMachineDetail.properties) {
        id propertyName = ParcelMachineDetail.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    // Map values that need translation
    [dict addEntriesFromDictionary:@{
        @"location": [_location JSONDictionary],
        @"address": [_address JSONDictionary],
        @"location247": _isLocation247 ? @YES : @NO,
    }];

    return dict;
}
@end

@implementation ParcelAddress
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"line1": @"line1",
        @"line2": @"line2",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[ParcelAddress alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = ParcelAddress.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:ParcelAddress.properties.allValues];
}
@end

@implementation ParcelLocation
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"latitude": @"latitude",
        @"longitude": @"longitude",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[ParcelLocation alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = ParcelLocation.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    return [self dictionaryWithValuesForKeys:ParcelLocation.properties.allValues];
}
@end

@implementation ParcelTrackingDetail
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
        @"status": @"status",
        @"origin_status": @"originStatus",
        @"agency": @"agency",
        @"datetime": @"datetime",
    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[ParcelTrackingDetail alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = ParcelTrackingDetail.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:ParcelTrackingDetail.properties.allValues] mutableCopy];

    // Rewrite property names that differ in JSON
    for (id jsonName in ParcelTrackingDetail.properties) {
        id propertyName = ParcelTrackingDetail.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }

    return dict;
}
@end

NS_ASSUME_NONNULL_END
