//
//  NewFileViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "NewFileViewController.h"
#import "HelperMethods.h"

@interface NewFileViewController ()

@end

@implementation NewFileViewController
@synthesize scrollView;
@synthesize activeField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

/* Método que se invoca cuando se carga la vista */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];
    self.title = @"Subir archivo";
    [self registerForKeyboardNotifications];

}



- (void)viewDidDisappear:(BOOL)animated
{
    self.showImageOutlet.image = nil;
    self.titleOutlet.text = @"";
    self.descriptionOutlet.text = @"";

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
 Nombre: chooseImage
 Uso: Elige la imagen deseada
 */
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
    
    if(self.showImageOutlet.image == NULL || self.titleOutlet.text == NULL || self.descriptionOutlet.text == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                            message:@"Agrega la imagen y llena los campos para continuar"
                            delegate:nil
                            cancelButtonTitle:@"Aceptar"
                            otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        NSString *filePath = [[HelperMethods alloc] dataFilePath];
        NSString *studentId;
        
        CFStringRef title = CFURLCreateStringByAddingPercentEscapes(
                                                                   kCFAllocatorDefault,
                                                                   (CFStringRef)[[NSString alloc]initWithString:self.titleOutlet.text],
                                                                   NULL,
                                                                   (CFStringRef)@"@",
                                                                   kCFStringEncodingUTF8
                                                                   );
        
        CFStringRef description = CFURLCreateStringByAddingPercentEscapes(
                                                                   kCFAllocatorDefault,
                                                                   (CFStringRef)[[NSString alloc]initWithString:self.descriptionOutlet.text],
                                                                   NULL,
                                                                   (CFStringRef)@"@",
                                                                   kCFStringEncodingUTF8
                                                                   );
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
            studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
        }
        
        
        NSData *imageData = UIImagePNGRepresentation(self.showImageOutlet.image);
     
         NSString *urlString = [NSString stringWithFormat:@"http://192.241.224.160/shareMyClass/ShareMyClassApi/api.php?cmd=uploadimage&idAlumno=%@&idCurso=%d&tituloArchivo=%@&descripcionArchivo=%@",studentId,self.courseId,title,description];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];

        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"img.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if(returnString.intValue){
            self.showImageOutlet.image = nil;
            self.titleOutlet.text = @"";
            self.descriptionOutlet.text = @"";
        }
        
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }
}

- (IBAction)dismiss:(id)sender {
    [self.titleOutlet resignFirstResponder];
    [self.descriptionOutlet resignFirstResponder];
    [self.showImageOutlet resignFirstResponder];
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{   
    activeField = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
