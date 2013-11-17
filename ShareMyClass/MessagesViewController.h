//
//  MessagesViewController.h
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MessagesGroupsViewController.h"

@class MessagesGroupsViewController;

@interface MessagesViewController : UITableViewController

@property (strong, nonatomic) MessagesGroupsViewController *messagesGroupsViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *students;
@property (strong, nonatomic) MessagesInterfaceViewController *messageInterfaceViewController;

@end
