//
//  AddViewController.h
//  CharactersChallenge
//
//  Created by GLBMXM0002 on 10/21/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface AddViewController : UIViewController

@property Item *item;

- (Item *) getItem;

@end