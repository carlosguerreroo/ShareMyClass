//
//  MyAccountViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MyAccountViewController.h"
#define userDataPlist @"user.plist"

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

    // Initialize the profile picture
    [self manageProfilePicture];
    [self managePersonalData];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

    
    
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

-(void)manageProfilePicture{
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *profilePictureFilePath = [NSString stringWithFormat:@"%@/profilePicture.png",docDir];
    UIImage *profilePicture = [UIImage imageWithData: [[NSData alloc] initWithContentsOfFile:profilePictureFilePath]];
    
    if(!profilePicture)
    {
        [FBRequestConnection
         startWithGraphPath:@"me?fields=picture.height(250)"
         completionHandler:^(FBRequestConnection *connection,
                             id result,
                             NSError *error) {
             if (!error)
             {
                 UIImage *profilePicture  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:result[@"picture"][@"data"][@"url"]]]];
                 NSData *dataPicture = [NSData dataWithData:UIImagePNGRepresentation(profilePicture)];
                 [dataPicture writeToFile:profilePictureFilePath atomically:YES];
                 self.profilePicture.image = profilePicture;
                 
                 
             }
         }];
    }else{
    
        self.profilePicture.image = profilePicture;
    
    }
    
    [self.profilePicture.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profilePicture.layer setBorderWidth: self.view.frame.size.width * .01];
    
}

-(void)managePersonalData
{
    NSString *filePath = [self dataFilePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        //NSLog(@"%@",dataDictionary);
        
        self.firstName.text = [dataDictionary objectForKey:@"first_name"];
        self.lastName.text = [dataDictionary objectForKey:@"last_name"];

    }

}
-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:userDataPlist];
    
}

@end
