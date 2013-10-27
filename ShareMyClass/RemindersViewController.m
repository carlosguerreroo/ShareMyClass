//
//  RemindersViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "RemindersViewController.h"
#import "AddReminderViewController.h"

@interface RemindersViewController ()

@end

@implementation RemindersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"Recordatorios";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(addReminder)]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addReminder
{
    NSLog(@"Add Reminder");
    
    if(!self.addReminderViewController){
        self.addReminderViewController = [[AddReminderViewController alloc] initWithNibName:@"AddReminderViewController" bundle:nil];
    }
    
    self.addReminderViewController.detailItem = nil;
    self.addReminderViewController.delegateReminder = self;
    
    [self.navigationController pushViewController:self.addReminderViewController animated:YES];
    
}
@end
