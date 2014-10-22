//
//  Item.m
//  CharactersChallenge
//
//  Created by GLBMXM0002 on 10/21/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    if (self ) {
        self.actor = [dictionary objectForKey:@"actor"];
        self.passenger = [dictionary objectForKey:@"passenger"];
    }
    
    return self;
    
}

@end
