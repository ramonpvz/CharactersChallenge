//
//  Item.h
//  CharactersChallenge
//
//  Created by GLBMXM0002 on 10/21/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property NSString *actor;
@property NSString *passenger;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
