//
//  AddReminderViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 26/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindersViewController.h"
#import "Reminder.h"
@interface AddReminderViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) RemindersViewController *delegateReminder;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;
@property (strong, nonatomic) NSDate *keyDate;
- (IBAction)saveReminder:(id)sender;

@end
