//
//  ApiCaller.m
//  inpost
//
//  Created by Oskar Figiel on 21/07/2020.
//

#import "ApiCaller.h"

@implementation ApiCaller

- (void)downloadData:(NSString *)parcelNumber :(NSMutableArray *)array completion:(void (^)(NSMutableArray *parcelList))completionBlock{
    NSString *base = @"https://api-shipx-pl.easypack24.net/v1/tracking/";
    NSMutableString *urlString = [NSMutableString new];
    [urlString appendString:base];
    [urlString appendString:parcelNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        Parcel *modelObject = [Parcel alloc];

        if (!error && [httpResponse statusCode] == 200) {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            modelObject = [Parcel fromJSON:jsonString encoding:NSUTF8StringEncoding error:&error];
            
        } else {
            modelObject.trackingNumber = parcelNumber;
            modelObject.status = @"BŁĄD PRZESYŁKI";
        }
        
        [array addObject:modelObject];
        unsigned long size = [array count];
        NSLog(@"Added parcel with tracking number:  %@", modelObject.trackingNumber);
        NSLog(@"There are %lu objects in the array", size);
        
        completionBlock(array);
    }];
    [dataTask resume];
}

@end
