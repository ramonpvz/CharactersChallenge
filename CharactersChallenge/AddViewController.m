//
//  AddViewController.m
//  CharactersChallenge
//
//  Created by GLBMXM0002 on 10/21/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "AddViewController.h"
#import "Item.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtActor;
@property (weak, nonatomic) IBOutlet UITextField *txtPassenger;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)save:(id)sender {
    
//    NSDictionary  *dty = [[NSDictionary alloc] initWithObjectsAndKeys:self.txtActor.text , @"actor", self.txtPassenger.text,@"passenger", nil];
//    
//    self.item = [[Item alloc] initWithDictionary:dty];
//    
//    NSLog(@"1) Item: %@",self.item);

}

- (Item *) getItem {
    
    NSDictionary  *dty = [[NSDictionary alloc] initWithObjectsAndKeys:self.txtActor.text , @"actor", self.txtPassenger.text,@"passenger", nil];
    
    self.item = [[Item alloc] initWithDictionary:dty];
    
    return self.item;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
