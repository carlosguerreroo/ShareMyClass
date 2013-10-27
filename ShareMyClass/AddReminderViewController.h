//
//  AddReminderViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 26/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindersViewController.h"

@interface AddReminderViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) RemindersViewController *delegateReminder;

@end
