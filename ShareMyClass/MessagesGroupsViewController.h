//
//  MessagesGroupsViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 03/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MessagesStudentsViewController.h"
@interface MessagesGroupsViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedObject;
@property (strong, nonatomic)MessagesStudentsViewController *messagesStudentsViewController;

@end
