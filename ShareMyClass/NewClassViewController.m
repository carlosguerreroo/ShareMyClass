//
//  NewClassViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "NewClassViewController.h"
#import "AddNewClassViewController.h"


@interface NewClassViewController ()

@end

@implementation NewClassViewController

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
	self.title = @"Nueva clase";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(newClass)]];
}
-(void)newClass
{
    if(!self.addNewClassViewController){
        self.addNewClassViewController = [[AddNewClassViewController alloc] initWithNibName:@"AddNewClassViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:self.addNewClassViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
