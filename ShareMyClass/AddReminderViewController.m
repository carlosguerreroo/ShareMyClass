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
/*
 Nombre: viewDidLoad
 Uso: Método que se llama cuando se carga la vista
 */
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
        self.keyDate = object.date;
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
        
        NSArray* localNotifications = [[UIApplication sharedApplication]
                                       scheduledLocalNotifications];
        for (UILocalNotification *notification in localNotifications)
        {
            //NSString* notificationID =
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
            [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            
            NSString *newTime = [timeFormatter stringFromDate:self.keyDate ];
            NSString *keytime = [notification.userInfo objectForKey:@"IDkey"];
            if([newTime isEqualToString:keytime])
            {
                notification.fireDate = self.datePicker.date;
                [[UIApplication sharedApplication]scheduleLocalNotification:notification ];
                NSLog(@"newtime : %@, %@",newTime,keytime);

            }

        }
    }
    else
    {
        [self scheduleNotificationWithTitle:self.titleTextField.text withMessage:self.messageTextField.text andDate:self.datePicker.date];
        [self.delegateReminder insertNewObjectWithTitle:self.titleTextField.text withMessage:self.messageTextField.text withDate:self.datePicker.date andCheck:NO];
    }
    
    [self.delegateReminder removeView];

}


-(void)scheduleNotificationWithTitle:(NSString*)title withMessage:(NSString*)message andDate:(NSDate*)date{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm:ss zzz"];
    //NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeInterval:10 sinceDate:date]];
    //NSLog(@"%@",dateString);
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    //localNotif.userInfo = infoDict;
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    //[NSDate dateWithTimeInterval:10 sinceDate:date];
    localNotification.alertBody = message;
    //NSLog(@"%@",message);
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"sas%@",localNotification.fireDate);
    NSDictionary *infoDict=[NSDictionary dictionaryWithObject:localNotification.fireDate forKey:@"IDkey"];
    localNotification.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


@end
