//
//  ApiCaller.h
//  inpost
//
//  Created by Oskar Figiel on 21/07/2020.
//

#import <Foundation/Foundation.h>
#import "ParcelModel.h"

@interface ApiCaller : NSObject

- (void)downloadData: (NSString *)urlString :(NSMutableArray *)array completion:(void (^)(NSMutableArray *parcelList))completionBlock;


@end
