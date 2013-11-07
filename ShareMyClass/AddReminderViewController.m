//
//  AddReminderViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 26/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
    }
    
   [self configureView];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self configureView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    [self.titleTextField resignFirstResponder];
    [self.messageTextField resignFirstResponder];
}

-(void)configureView
{
    if (self.detailItem)
    {
        Reminder *object = (Reminder*) self.detailItem;
        self.titleTextField.text = object.title;
        self.messageTextField.text = object.message;
        self.datePicker.date = object.date;
        self.editing = YES;
    }
    else
    {
        self.titleTextField.text = @"";
        self.messageTextField.text = @"";
        self.datePicker.date = [NSDate date];
        self.editing = NO;
    }
}

- (IBAction)saveReminder:(id)sender
{
    if	(self.editing)
    {
        //To-Do //Create editNotification
        [self.delegateReminder editObjectWithTitle:self.titleTextField.text withMessage:self.messageTextField.text withDate:self.datePicker.date andCheck:NO];
    }
    else
    {
        [self scheduleNotificationWithTitle:self.titleTextField.text withMessage:self.messageTextField.text andDate:self.datePicker.date];
        [self.delegateReminder insertNewObjectWithTitle:self.titleTextField.text withMessage:self.messageTextField.text withDate:self.datePicker.date andCheck:NO];
    }
}


-(void)scheduleNotificationWithTitle:(NSString*)title withMessage:(NSString*)message andDate:(NSDate*)date{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm:ss zzz"];
    //NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeInterval:10 sinceDate:date]];
    //NSLog(@"%@",dateString);
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    //localNotif.userInfo = infoDict;
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeInterval:10 sinceDate:date];
    localNotification.alertBody = message;
    //NSLog(@"%@",message);
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


@end
