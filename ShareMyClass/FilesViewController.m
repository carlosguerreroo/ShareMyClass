//
//  FilesViewController.m
//  ShareMyClass
//
//  Created by Vicente Balderas Martínez on 11/24/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "FilesViewController.h"
#import "AppDelegate.h"
#import "HelperMethods.h"


@interface FilesViewController ()
@property (nonatomic, strong) NSMutableData* receivedData;
@property (nonatomic, strong) NSArray* files;


@end
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@implementation FilesViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Archivos";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(newFile)]];
    //[self getFiles];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self getFiles];

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newFile
{
    if(!self.NewFileViewController){
        self.NewFileViewController = [[NewFileViewController alloc] initWithNibName:@"NewFileViewController" bundle:nil];
    }
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.NewFileViewController.managedObjectContext = appDelegate.managedObjectContext;
    [self.navigationController pushViewController:self.NewFileViewController animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"idCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    NSInteger row = [indexPath row];
    NSDictionary *file = [self.files objectAtIndex:row];
    cell.detailTextLabel.text =[file objectForKey:@"fechaArchivo"];
    cell.textLabel.text = [file objectForKey:@"tituloArchivo"];
    
    return cell;
}




-(void)getFiles
{
    
    NSURL *url = [[NSURL alloc] initWithString: @"http://192.241.224.160/ShareMyClass/ShareMyClassApi/api.php?"];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [req setHTTPMethod:@"POST"];
    
    NSString *course = [[NSString alloc]initWithString:self.courseId];
    
    NSString *paramDataString = [NSString stringWithFormat:@"cmd=getfiles&idCurso=%@", course];
    
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
   
        NSError *error = [[NSError alloc] init];
        NSArray *jsonFiles = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        self.files = jsonFiles;
        [self.tableView reloadData];
        self.receivedData = nil;

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

    if (!self.ViewFileViewController) {
        self.ViewFileViewController = [[ViewFileViewController alloc] initWithNibName:@"ViewFileViewController" bundle:nil];
    }
    
	
    self.ViewFileViewController.imageName = @"nombre";

    [self.navigationController pushViewController:self.ViewFileViewController animated:YES];
}
 


@end
