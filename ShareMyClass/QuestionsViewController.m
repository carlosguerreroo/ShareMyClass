//
//  QuestionsViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "QuestionsViewController.h"

@interface QuestionsViewController ()

@end

@implementation QuestionsViewController

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
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(addQuestion)]];
    self.questions = [[NSArray alloc]init];
    self.title = @"Preguntas";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{

    [self getQuestion:self.courseId];

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
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSLog(@"%@",);
    cell.textLabel.text = [[self.questions objectAtIndex:[indexPath row]] objectForKey:@"tituloPregunta"];
    cell.detailTextLabel.text= [[self.questions objectAtIndex:[indexPath row]] objectForKey:@"tituloPregunta"];

    return cell;
}

-(void)addQuestion
{
        if(!self.addQuestionViewController)
        {
            self.addQuestionViewController = [[AddQuestionViewController alloc] initWithNibName:@"AddQuestionViewController" bundle:nil];
            //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            //self.addQuestionViewController.managedObjectContext = appDelegate.managedObjectContext;
        }
        //self.addReminderViewController.detailItem = nil;
        //self.addReminderViewController.delegateReminder = self;
    self.addQuestionViewController.courseId = self.courseId;
        [self.navigationController pushViewController:self.addQuestionViewController animated:YES];

    
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
    
    self.questions = jsonCourses;
    
    [self.tableView reloadData];
    
    
    NSLog(@" recibo %@", jsonCourses);
    
    if(![jsonCourses count])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"No hay preguntas, puedes hacer una en el boton de +"
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    self.receivedData = nil;}

-(void)getQuestion:(NSString*)courseId
{
    
    
    //NSLog(@"joinToCourse");
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSLog(@"%@",courseId);
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=getquestion&curso=%@",courseId];
    
    NSData * paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:paramData];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (theConnection)
    {
        self.receivedData = [[NSMutableData alloc] init];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alerta"
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
        //NSLog(@"Back");
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
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
    if(!self.displayAnswersViewController)
    {
        self.displayAnswersViewController  = [[DisplayAnswersViewController alloc] initWithNibName:@"DisplayAnswersViewController" bundle:nil];
    
    }
       // Pass the selected object to the new view controller.
    self.displayAnswersViewController.questionId = [[self.questions objectAtIndex:[indexPath row]] objectForKey:@"idPregunta"];
    self.displayAnswersViewController.title =[[self.questions objectAtIndex:[indexPath row]] objectForKey:@"tituloPregunta"];
    NSLog(@"%@",[[self.questions objectAtIndex:[indexPath row]] objectForKey:@"tituloPregunta"]);
    // Push the view controller.
    [self.navigationController pushViewController:self.displayAnswersViewController animated:YES];
}
 


@end
