//
//  MasterViewController.m
//  CharactersChallenge
//
//  Created by GLBMXM0002 on 10/21/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"
#import "Item.h"
#import "CtmUITableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *characters;
@property NSString *PATH;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self testLoad];
    if (self.characters == nil) {
        self.characters = [NSMutableArray array];
    }
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(NSURL *) documetsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager]; //Returns a "Singletone"
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]; //As for a URL using Domain Mask
    return files.firstObject; //Asking for all the local directories (Universal Resource Locator)
}

-(void) testLoad {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *pList = [[self documetsDirectory] URLByAppendingPathComponent:@"lost.plist"];
    
    NSLog(@"----------------> pList: %@", pList);
    
    //self.adoredToothpastes = [NSMutableArray arrayWithContentsOfURL:pList]; //This will allows to load our pList
    NSLog(@"date: %@", [userDefaults objectForKey:@"LastSaved"]);
    
}

- (void) loadData {
    NSArray *repository;
    NSError *err;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    repository = [self.managedObjectContext executeFetchRequest:request error:&err];
    
    if (!err && [repository count] == 0)
    {
        self.PATH = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
        
        self.characters = [[NSMutableArray alloc] initWithContentsOfFile:self.PATH];
        
        for (NSDictionary *dict in self.characters)
        {
            NSLog(@"Adding: %@",dict);
            NSManagedObject *item = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Item"
                                     inManagedObjectContext:self.managedObjectContext];
            [item setValue:[dict objectForKey:@"actor"] forKey:@"actor"];
            [item setValue:[dict objectForKey:@"passenger"] forKey:@"passenger"];
            [item setValue:[dict objectForKey:@"age"] forKey:@"age"];
            [item setValue:[dict objectForKey:@"gender"] forKey:@"gender"];
            [item setValue:[dict objectForKey:@"planeSeat"] forKey:@"planeSeat"];
            [item setValue:[dict objectForKey:@"convicted"] forKey:@"convicted"];
            [item setValue:[dict objectForKey:@"hairColor"] forKey:@"hairColor"];
            [self.managedObjectContext save:nil];
        }
    }
    else
    {
        NSLog(@"*** Item is not empty: %@",err);
        self.characters = [[NSMutableArray alloc] initWithArray:repository];
        [self.tableView reloadData];
    }

}


- (IBAction)unwindImageViewController:(UIStoryboardSegue *)segue {
    
    AddViewController *viewController = segue.sourceViewController;
    Item *myItem = [viewController getItem];
    
    NSManagedObject *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [item setValue:myItem.actor forKey:@"actor"];
    [item setValue:myItem.passenger forKey:@"passenger"];
    
    [self.characters addObject:item];
    [self.managedObjectContext save:nil];
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.characters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *item = [self.characters objectAtIndex:indexPath.row];
    
    CtmUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    }
    
    cell.leftTextLabel.text = [item valueForKey:@"actor"];
    
    NSString *strCenterLabel = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    [item valueForKey:@"hairColor"],
                                    [item valueForKey:@"planeSeat"],
                                    [item valueForKey:@"gender"],
                                    [item valueForKey:@"age"],
                                    [item valueForKey:@"convicted"]];
    
    cell.centerTextLabel.text = strCenterLabel;
    cell.rightTextLabel.text = [item valueForKey:@"passenger"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSManagedObject *item = [self.characters objectAtIndex:indexPath.row];
        [context deleteObject:item];
        //[self loadData];
        
        //[context save:nil];
        //[self.characters removeObjectAtIndex:indexPath.row];
        //[self loadData];
        //[self.characters writeToFile:self.PATH atomically:NO];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"actor" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
