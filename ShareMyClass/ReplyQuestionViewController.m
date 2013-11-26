//
//  ReplyQuestionViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 25/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "ReplyQuestionViewController.h"

@interface ReplyQuestionViewController ()

@end

@implementation ReplyQuestionViewController

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
    self.title = @"Responde";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reply:(id)sender
{
    [self replyAnswerWithIdReply:self.idReply andResponse:self.bodyReply.text];
    [self.bodyReply resignFirstResponder];
    [self.navigationController popViewControllerAnimated:TRUE];

}
- (IBAction)hideKeyboard:(id)sender
{
    [self.bodyReply resignFirstResponder];
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

/*
 Nombre: connectionDidFinishLoading
 Uso: reinicia la variable received data
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{

    self.receivedData = nil;}

/*
 Nombre: replyAnswerWithIdReply
 Uso: Contesta a alguna de las preguntas
 */
-(void)replyAnswerWithIdReply:(NSString*)idReply andResponse:(NSString*)response
{
    
    
    //NSLog(@"joinToCourse");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    //NSLog(@"%@",answerId);
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=replyquestion&idPregunta=%@&respuesta=%@",idReply,response];
    
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
