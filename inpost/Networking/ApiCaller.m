//
//  ApiCaller.m
//  inpost
//
//  Created by Oskar Figiel on 21/07/2020.
//

#import "ApiCaller.h"

@implementation ApiCaller

- (void)downloadData:(NSString *)urlString :(NSMutableArray *)array completion:(void (^)(NSMutableArray *parcelList))completionBlock{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray *parsedJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            ParcelModel *modelObject = [ParcelModel new];
            modelObject.trackingNumber = [parsedJSONArray valueForKey:@"tracking_number"];
            modelObject.status = [parsedJSONArray valueForKey:@"status"];
            
            NSLog(@"%@", modelObject.trackingNumber);
            [array addObject:modelObject];
            unsigned long size = [array count];
            
            NSLog(@"there are %lu objects in the array", size);
            NSLog(@"%@", [array[0] trackingNumber]);
            
            completionBlock(array);
        }
    }];
    [dataTask resume];
}

@end
