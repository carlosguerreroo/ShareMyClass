//
//  NewFileViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "NewFileViewController.h"

@interface NewFileViewController ()

@end

@implementation NewFileViewController

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
    self.title = @"Subir archivo";// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseImage:(id)sender
{
    if	([UIImagePickerController	isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary])	{
        
        UIImagePickerController	*picker	=	[[UIImagePickerController	alloc]
                                             init];
        picker.delegate	=	self;
        picker.sourceType	=	UIImagePickerControllerSourceTypePhotoLibrary;
        [self	presentViewController:picker	animated:YES	completion:	NULL];
    }
    else
    {
        NSLog(@"0");
   
    }
}

- (IBAction)takePhoto:(id)sender
{
    if	([UIImagePickerController	isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController	*picker	=[[UIImagePickerController alloc]init];
        picker.delegate	=	self;
        picker.sourceType	= UIImagePickerControllerSourceTypeCamera;
        [self	presentViewController:picker	animated:YES	completion:
         NULL];
    }
    else
    {
        NSLog(@"0");

    }
}

- (IBAction)uploadPhoto:(id)sender {
    
    if(self.showImageOutlet.image == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                            message:@"Selecciona o toma una imagen para continuar"
                            delegate:nil
                            cancelButtonTitle:@"Aceptar"
                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSData *imageData = UIImagePNGRepresentation(self.showImageOutlet.image);
        NSString *urlString = @"http://localhost/share/upload.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog([NSString stringWithFormat:@"Image Return String: %@", returnString]);
    }
}



-(void)	imagePickerController:	(UIImagePickerController	*)	picker
didFinishPickingMediaWithInfo:	(NSDictionary	*)	info
{
    self.showImageOutlet.image	=	[info	objectForKey:
                             UIImagePickerControllerOriginalImage	];
    [self	dismissViewControllerAnimated:	YES	completion:	NULL];
}

-	(void)	imagePickerControllerDidCancel:
(UIImagePickerController	*)	picker
{
	[self	dismissViewControllerAnimated:	YES	completion:	NULL];
}
@end
