//
//  MessagesInterfaceViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 11/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import <CoreData/CoreData.h>
#import "HelperMethods.h"

@interface MessagesInterfaceViewController : UIViewController <UIBubbleTableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (strong, nonatomic) NSDictionary *student;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)sendMessage:(id)sender;

@end
