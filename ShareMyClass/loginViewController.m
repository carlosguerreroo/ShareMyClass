//
//  mainWindow.m
//  ShareMyClass
//
//  Created by carlos omana on 08/10/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "loginViewController.h"
#import "AppDelegate.h"

@interface loginViewController ()

- (IBAction)performLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation loginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
 Nombre: performLogin
 Uso: Método para iniciar el inicio de sesión
 */
- (IBAction)performLogin:(id)sender
{

    [self.spinner startAnimating];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];

}

/*
 Nombre: loginFailed
 Uso: Método por si fallo el inicio de sesión
 */
- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
    [self.spinner stopAnimating];
}
@end
