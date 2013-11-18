//
//  MessagesStudentsViewController.m
//  ShareMyClass
//
//  Created by carlos omana on 07/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "MessagesStudentsViewController.h"
#import "HelperMethods.h"

@interface MessagesStudentsViewController ()

@end

@implementation MessagesStudentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Estudiantes";


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

-(void)viewWillAppear:(BOOL)animated
{

    NSString *filePath = [[HelperMethods alloc] dataFilePath];
    NSString *studentId;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        studentId = [[NSString alloc]initWithString:[dataDictionary objectForKey:@"id"]];
        [self getStudentsFromCourse:[self.selectedCourse valueForKey:@"courseId"] andStudentId:studentId];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    cell.textLabel.text = [[self.students objectAtIndex:[indexPath row]] objectForKey:@"nombre"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    if(!self.messageInterfaceViewController)
    {
       self.messageInterfaceViewController = [[MessagesInterfaceViewController alloc] initWithNibName:@"MessagesInterfaceViewController" bundle:nil];
    }
    // Pass the selected object to the new view controller.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.messageInterfaceViewController.managedObjectContext = appDelegate.managedObjectContext;
    self.messageInterfaceViewController.student = [self.students objectAtIndex:[indexPath row]];
    
    // Push the view controller.
    [self.navigationController pushViewController:self.messageInterfaceViewController animated:YES];
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
	//NSString *infoRecibidaString = [[NSString alloc] initWithData: self.receivedData
    //                                                     encoding:NSUTF8StringEncoding];
    NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para

    NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
    
    self.students = jsonCourses;
    [self.tableView reloadData];


    NSLog(@" recibo %d", jsonCourses.count);
    
    if(![jsonCourses count])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Este grupo no contiene alumnos a quien enviarle mensajes"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [alert show];
    
    }
    
    
    self.receivedData = nil;
}

-(void)getStudentsFromCourse:(NSString *)courseId andStudentId:(NSString*)studentId
{


    //NSLog(@"joinToCourse");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=getstudentsfromcourse&idCurso=%@&idAlumno=%@",courseId,studentId];
    NSLog(@" la llamada al web service %@ ", paramDataString);
    
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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Back");
      [self.navigationController popViewControllerAnimated:YES];
       
    }
}


@end
