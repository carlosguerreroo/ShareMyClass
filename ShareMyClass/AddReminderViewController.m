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
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
        //[self.delegateMaster modifyObject: self.name.text  withDate: self.datePicker.date];
        //modifyObject: self.name.text withDate: self.dateSaved];
    }
    else
    {
        [self.delegateReminder insertNewObjectWithTitle:self.titleTextField.text withMessage:self.messageTextField.text withDate:self.datePicker.date andCheck:NO];
        
    }

}
@end
