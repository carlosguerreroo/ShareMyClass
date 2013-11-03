//
//  AddNewClassViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/3/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "AddNewClassViewController.h"

@interface AddNewClassViewController ()

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewClass:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                   timeoutInterval:60];
	
	[req setHTTPMethod:@"POST"];
	[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *className = [[NSString alloc]initWithString:self.className.text];
    NSString *classId = [[NSString alloc]initWithString:self.classId.text];
    //Valor del post
    NSString *postData = [NSString stringWithFormat:@"cmd=newcourse&nombreCurso=%@&idCursoReal=%@",className
                          ,classId]; //Mandamos el valor
	
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	[req setValue:length forHTTPHeaderField:@"Content-Length"];   //indicamos en nuestro paquete el tamaño de
    //nuestros datos
	[req setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]]; //Mandamos el contenido de este
    
	NSHTTPURLResponse* urlResponse = nil; //Vemos nuestra respuesta
	NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
    //debugiar algunos errores generados
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:req
                                                 returningResponse:&urlResponse
                                                             error:&error];
    //Guardamos los parametros que obtuvimos en la respuesta
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Guardamos en estring
    NSLog(@"Respueta: %@", responseString); //imprimimos lo obtenido
    
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.className resignFirstResponder];
    [self.classId resignFirstResponder];

}
@end
