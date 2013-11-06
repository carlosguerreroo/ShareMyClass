//
//  AddNewClassViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AddNewClassViewController.h"
#import "HelperMethods.h"

@interface AddNewClassViewController ()

@property(strong, nonatomic)NSMutableData *receivedData;

@end

@implementation AddNewClassViewController

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
    self.title=@"Agregar clase";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewClass:(id)sender
{
    [self registerClass];
}


- (IBAction)hideKeyboard:(id)sender
{
    [self.className resignFirstResponder];
    [self.classId resignFirstResponder];

}

#pragma mark NSURLConnection
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse * )response
{
	[self.receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData = nil;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[NSString stringWithFormat:
                                                              @"No se pudo crear la conexión - %@",
                                                              [error localizedDescription]]
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *infoRecibidaString = [[NSString alloc] initWithData: self.receivedData
                                                         encoding:NSUTF8StringEncoding];
    
    if([infoRecibidaString isEqualToString:@"YES"]){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    infoRecibidaString = nil;
    self.receivedData = nil;
}


-(void)registerClass{
   
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    NSString *filePath = [[HelperMethods alloc] dataFilePath];
    NSString *studentId;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
    }
    
    NSString *className = [[NSString alloc]initWithString:self.className.text];
    NSString *classId = [[NSString alloc]initWithString:self.classId.text];

    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=newcourse&nombreCurso=%@&idCursoReal=%@&idAlumno=%@",className,classId,studentId];
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No se pudo enlazar con el servicio web!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
        [alert show];
    }
}

@end
