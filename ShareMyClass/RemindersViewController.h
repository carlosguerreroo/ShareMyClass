//
//  RemindersViewController.h
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class AddReminderViewController;

@interface RemindersViewController : UIViewController

@property (strong, nonatomic) AddReminderViewController *addReminderViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedObject;

@end
