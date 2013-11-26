//
//  MessagesInterfaceViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 11/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesInterfaceViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface MessagesInterfaceViewController ()
{
        NSMutableArray *bubbleData;
}
@end

@implementation MessagesInterfaceViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboard"]];
    
    self.textInputView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sendBar"]];
    
    bubbleData = [[NSMutableArray alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action: @selector(refresh)]];
}


-(void)refresh
{
    [self loadMessageTable];
    [self.bubbleTable reloadData];
    NSLog(@"sas");

}


-(void)viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"@%@:",[self.student objectForKey:@"nombre"]];
    //[self getMessages];
    [self loadMessageTable];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.textInputView.frame;
        frame.origin.y -= kbSize.height;
        self.textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
        frame.size.height -= kbSize.height;
        self.bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.textInputView.frame;
        frame.origin.y += kbSize.height;
        self.textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
        frame.size.height += kbSize.height;
        self.bubbleTable.frame = frame;
    }];
}

- (IBAction)sendMessage:(id)sender
{
    if(self.textField.text != nil)
    {
        NSDictionary *bodyMessage = [[NSDictionary alloc]
                                     initWithObjects:
                                     [[NSArray alloc]initWithObjects: [[HelperMethods alloc] userId], [self.student objectForKey:@"idAlumno"],[NSDate date],self.textField.text,nil]
                                    forKeys:
                                     [[NSArray alloc]initWithObjects:@"from",@"to",@"date",@"message", nil]];
        NSLog(@"%@",bodyMessage);
        [self sendBodyMessage:bodyMessage];
        NSBubbleData *heyBubble = [NSBubbleData dataWithText: self.textField.text date: [NSDate date] type:BubbleTypeMine];
        heyBubble.avatar = [[HelperMethods alloc]profilePicture];
        [bubbleData addObject:heyBubble];
        [self inserNewMessageWithFrom:[[HelperMethods alloc] userId] To:[self.student objectForKey:@"idAlumno"] Date:[NSDate date] andMessage:self.textField.text];

        [self.bubbleTable reloadData];

        self.textField.text = @"";
    }
 
    if([self checkUser]){
    
        NSLog(@"TRUE");
        
    }else{
        [self inserNewStudentWithName:[self.student objectForKey:@"nombre"] lastName:[self.student objectForKey:@"apellidos"] andId: [[NSNumber alloc] initWithInt:[[self.student objectForKey:@"idAlumno"] intValue]]];
        NSLog(@"false");
    }
    
    [self.textField resignFirstResponder];
}


-(void)loadMessageTable
{
    NSLog(@"Estudiante con id %@, nombre %@, apellido %@",[self.student objectForKey:@"idAlumno"],[self.student objectForKey:@"nombre"],[self.student objectForKey:@"apellidos"]);
    
   // NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                             @"(from = %@ and to = %@) OR (from = %@ and to = %@ )",[[HelperMethods alloc] userId],[self.student objectForKey:@"idAlumno"],[self.student objectForKey:@"idAlumno"],[[HelperMethods alloc] userId]];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        //Handle the error
        NSLog(@"Error");
    }else{
        
        bubbleData = [[NSMutableArray alloc]init];
        for(NSManagedObject* object in array){
            
            //NSLog(@"%@",[object valueForKey:@"from"]);
            NSBubbleData *heyBubble = [NSBubbleData dataWithText:[object valueForKey:@"message"] date:[object valueForKey:@"date"]  type:([[object valueForKey:@"from"] isEqualToString:[[HelperMethods alloc] userId]])?BubbleTypeMine:BubbleTypeSomeoneElse];
            heyBubble.avatar = ([[object valueForKey:@"from"] isEqualToString:[[HelperMethods alloc] userId]])?[[HelperMethods alloc]profilePicture]:nil;
           

            [bubbleData addObject:heyBubble];
        }
        self.bubbleTable.showAvatars = YES;

        [self.bubbleTable reloadData];
    }

}


-(void)sendBodyMessage:(NSDictionary*)message
{
    
    NSLog(@"sendMessage");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString
                                  stringWithFormat:@"cmd=sendmessage&idAlumno=%@&to=%@&message=%@&date=%@",
                                  [[HelperMethods alloc] userId],[message objectForKey:@"to"],[message objectForKey:@"message"],[message objectForKey:@"date"]];
    //NSLog(@" la llamada al web service %@ ", paramDataString);
    
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
    
    NSString *recieved =  [[NSString alloc ]initWithData: self.receivedData encoding:NSUTF8StringEncoding];
   // NSString *body = [[[NSString alloc] initWithData: connection.originalRequest.HTTPBody
   //                                         encoding:NSUTF8StringEncoding] substringToIndex:23];
    
    
    if(recieved)
    {
    
    
    
    }
    
    // NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
    // NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
       
    self.receivedData = nil;
        
    

}

-(void)inserNewMessageWithFrom:(NSString*)from To:(NSString*)to Date:(NSDate*)date andMessage:(NSString*)message
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *courseObject = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Message"
                                     inManagedObjectContext:context];
    
    [courseObject setValue: from  forKey:@"from"];
    [courseObject setValue: to forKey:@"to"];
    [courseObject setValue: message forKey:@"message"];
    [courseObject setValue: date forKey:@"date"];
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(void)inserNewStudentWithName:(NSString*)name lastName:(NSString*)last andId:(NSNumber*)andId{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *courseObject = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"Student"
                                     inManagedObjectContext:context];
    
    [courseObject setValue: name  forKey:@"name"];
    [courseObject setValue: last forKey:@"lastname"];
    [courseObject setValue: andId forKey:@"id"];
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(BOOL)checkUser
{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Student" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(id = %@)",[NSNumber numberWithInteger: [[self.student objectForKey:@"idAlumno"] intValue]]];
    [request setPredicate:predicate];
    NSLog(@"%@",[NSNumber numberWithInteger: [[self.student objectForKey:@"idAlumno"] intValue]]);
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        //Error
    }else{
    
        NSLog(@"%d = = =",array.count);
        if(!array.count)
        {
            return NO;

            
        }else{
        
        
            return YES;

        }
    
    }
    return NO;
}

@end
