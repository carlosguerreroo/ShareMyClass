//
//  MessagesViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesGroupsViewController.h"
#import "AppDelegate.h"
@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    //[self.tableView reloadData];
    [self getMessages];

}

- (void)viewDidLoad
{
    self.students = [[NSMutableArray alloc]init];
    [super viewDidLoad];
	self.title = @"Mensajes";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(viewGroups)]];
    [self searchStudents];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Jala para refrescar"];
    [refresh addTarget:self
            action:@selector(refreshView:)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    refresh.tintColor = [UIColor brownColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewGroups
{

    if(!self.messagesGroupsViewController)
    {
        self.messagesGroupsViewController = [[MessagesGroupsViewController alloc] initWithNibName:@"MessagesGroupsViewController" bundle:nil];
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.messagesGroupsViewController.managedObjectContext = appDelegate.managedObjectContext;
    }
    //self.addReminderViewController.detailItem = nil;
    //self.addReminderViewController.delegateReminder = self;
    
    [self.navigationController pushViewController:self.messagesGroupsViewController animated:YES];
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.students count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)searchStudents
{

    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Student" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    self.students = Nil;
    self.students = [[NSMutableArray alloc]init];
    if (array == nil)
    {
        //Error
    }else{
        if(!array.count)
        {
            
            
        }else{
            
            for(NSManagedObject* object in array){
                
                [self.students addObject:object];
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.students objectAtIndex:[indexPath row]];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    cell.detailTextLabel.text = [[object valueForKey:@"lastname"] description];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.messageInterfaceViewController)
    {
        self.messageInterfaceViewController = [[MessagesInterfaceViewController alloc] initWithNibName:@"MessagesInterfaceViewController" bundle:nil];
    }
    // Pass the selected object to the new view controller.
    self.messageInterfaceViewController.managedObjectContext = self.managedObjectContext;
    NSManagedObject *object = [self.students objectAtIndex:[indexPath row]];
    NSDictionary *student = [[NSDictionary alloc] initWithObjects: [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%@",[object valueForKey:@"id"]],[object valueForKey:@"name"],[object valueForKey:@"lastname"], nil] forKeys:    [[NSArray alloc] initWithObjects:@"idAlumno",@"nombre",@"apellidos", nil]
];
    
    
    self.messageInterfaceViewController.student = student;
    
    // Push the view controller.
    [self.navigationController pushViewController:self.messageInterfaceViewController animated:YES];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Obteniendo nuevos mensajes..."];
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Ultima actualización %@",
    [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self getMessages];

    [refresh endRefreshing];
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
    NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
    NSDictionary *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
    
    for(NSDictionary* object in [jsonCourses objectForKey:@"students"])
    {
        if([self checkUser:[object objectForKey:@"idAlumno"]]){
            
            
        }else{
            NSLog(@"%@",[object objectForKey:@"idAlumno"]);
            [self inserNewStudentWithName:[object objectForKey:@"nombre"] lastName:[object objectForKey:@"apellidos"] andId: [[NSNumber alloc] initWithInt:[[object objectForKey:@"idAlumno"] intValue]]];
        }

    
    
    }
    
    for(NSDictionary* object in [jsonCourses objectForKey:@"messages"])
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *myDate = [df dateFromString: [NSString stringWithFormat:@"%@",[object objectForKey:@"fechaMensaje"]]];
        [self inserNewMessageWithFrom:[object objectForKey:@"idAlumno"] To:[object objectForKey:@"idAlumnoPara"] Date:[NSDate date] andMessage:[object objectForKey:@"mensaje"]];
        NSLog(@"1%@",[object objectForKey:@"fechaMensaje"]);
        NSLog(@"2%@",myDate);

        
    }
    [self searchStudents];
    self.receivedData = nil;
    
}

-(void)getMessages
{
    
    NSLog(@"remainingCourses");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];

    [req setHTTPMethod:@"POST"];
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=getnewmessages&idAlumno=%@",[[HelperMethods alloc] userId] ];
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
-(BOOL)checkUser:(NSString*)userid
{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Student" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(id = %@)",[NSNumber numberWithInteger: [userid intValue]]];
    [request setPredicate:predicate];
    NSLog(@" User id %@",userid);
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
