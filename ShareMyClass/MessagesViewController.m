//
//  MessagesViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesGroupsViewController.h"
#import "AppDelegate.h"
@interface MessagesViewController ()

@end

@implementation MessagesViewController

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
	self.title = @"Mensajes";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(viewGroups)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewGroups
{

    //NSLog(@"View Groups");
    if(!self.messagesGroupsViewController){
        self.messagesGroupsViewController = [[MessagesGroupsViewController alloc] initWithNibName:@"MessagesGroupsViewController" bundle:nil];
    }
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.messagesGroupsViewController.managedObjectContext = appDelegate.managedObjectContext;
    
    //self.addReminderViewController.detailItem = nil;
    //self.addReminderViewController.delegateReminder = self;
    
    [self.navigationController pushViewController:self.messagesGroupsViewController animated:YES];
}

-(NSArray *)checkCourses{
    NSArray *courses = [NSArray alloc];
 
    return courses;
}

@end
