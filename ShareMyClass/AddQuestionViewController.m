//
//  AddQuestionViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 25/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AddQuestionViewController.h"

@interface AddQuestionViewController ()

@property(strong, nonatomic)NSMutableData *receivedData;

@end

@implementation AddQuestionViewController

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
    self.title = @"Agregar";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Nombre: closekeyboard
 Uso: Escoder el teclado al usuario
 */
- (IBAction)closekeyboard:(id)sender
{
    [self.question resignFirstResponder];
    [self.titleQuestion resignFirstResponder];
}

/*
 Nombre: sendquestion
 Uso: Envia la pregunta al servidor cuando el usuario presiona el boton de enviar
 */
- (IBAction)sendquestion:(id)sender
{
    
    [self sendQuestionWithTitle:self.titleQuestion.text Question:self.question.text StudentId:[[HelperMethods alloc] userId] andCourseId:self.courseId];
    [self.navigationController popViewControllerAnimated:YES];
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

    self.receivedData = nil;
}
/*
 Nombre: sendQuestionWithTitle:(NSString *)title Question:(NSString*)question StudentId:(NSString*)studentId andCourseId:(NSString*)
 Uso: registra la pregunta en el servidor
 */

-(void)sendQuestionWithTitle:(NSString *)title Question:(NSString*)question StudentId:(NSString*)studentId andCourseId:(NSString*)courseId
{
    
    
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=sendquestion&curso=%@&idAlumno=%@&title=%@&question=%@",courseId,studentId,title,question];
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No se pudo enlazar con el servicio web!"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
