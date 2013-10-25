//
//  MyAccountViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

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
	self.title = @"Mi cuenta";
    //Creates close session button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cerrar sesión" style:UIBarButtonItemStyleBordered target:self action:@selector(closeSession)]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeSession
{
    UIAlertView *closeSessionPopUp = [[UIAlertView alloc]initWithTitle:@"Cerrar Sesión" message:@"Seguro que deseas cerrar sesión." delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Aceptar", nil];
    
    [closeSessionPopUp show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [FBSession.activeSession closeAndClearTokenInformation];

    }
}

@end
