//
//  StringExtension.m
//  inpost
//
//  Created by Oskar Figiel on 19/07/2020.
//

#import "StringExtension.h"

@implementation NSString(StatusFormatter)

- (NSString*)statusRefactor {
    NSString *string = self;
     
    if ([string isEqualToString:@"out_for_delivery"])
        string = @"Wydano do doręczenia";
    
       else if ([string isEqualToString:@"sent_from_source_branch"])
           string = @"Wysłana z oddziału";
    
       else if ([string isEqualToString:@"ready_to_pickup"])
           string = @"Gotowa do odbioru";
    
       else if ([string isEqualToString:@"404"])
           string = @"Podana przesyłka nie istnieje";
    
       else if ([string isEqualToString:@"delivered"])
           string = @"Przesyłka dostarczona";
    
       else if ([string isEqualToString:@"confirmed"])
           string = @"Gotowa do nadania";
    
       else if ([string isEqualToString:@"adopted_at_source_branch"])
           string = @"Przyjęta w oddziale";
    
       else if ([string isEqualToString:@"collected_from_sender"])
           string = @"Przejęta od nadawcy";
    
       else if ([string isEqualToString:@"adopted_at_sorting_center"])
           string = @"Przejęta w sortowni";
    
       else if ([string isEqualToString:@"dispatched_by_sender"])
           string = @"Wysłana przez nadawcę";
    
       else if ([string isEqualToString:@"taken_by_courier"])
           string = @"Przejęta przez kuriera";
    
       else if ([string isEqualToString:@"out_for_delivery_to_address"])
           string = @"W doręczeniu";
    
       else
           string = self;
    
    return string;
}

@end
