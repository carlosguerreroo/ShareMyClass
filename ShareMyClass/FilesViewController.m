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
#import "QuestionsViewController.h"

@interface FilesViewController ()
@property (nonatomic, strong) NSMutableData* receivedData;
@property (nonatomic, strong) NSArray* files;


@end
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@implementation FilesViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        

    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Archivos";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(newFile)]];
    //[self getFiles];
    //[self.navigationController.view r]
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getFiles];

    [self.tableView reloadData];
    
    self.tabBarView = [[UITabBar alloc] initWithFrame:CGRectMake(0, 430, 320, 50)];
    self.tabBarView.delegate = self;
    NSArray* tabbarItems = [[NSArray alloc] initWithObjects:[[UITabBarItem alloc] initWithTitle:@"Archivos" image:nil tag:1],[[UITabBarItem alloc] initWithTitle:@"Preguntas" image:nil tag:2], nil];
    [[self.tabBarController.tabBar.items objectAtIndex:1]  setTag:2];
    
    self.tabBarView.items = tabbarItems;
    [self.tabBarView setSelectedItem:[tabbarItems objectAtIndex:0]];
    [self.navigationController.view addSubview:self.tabBarView];

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
    self.NewFileViewController.courseId = self.courseId;
    self.NewFileViewController.managedObjectContext = appDelegate.managedObjectContext;
    [self.navigationController pushViewController:self.NewFileViewController animated:YES];
    
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
    
    //NSString *course = [[NSString alloc]initWithString:self.courseId];
  //  NSInteger *course = self.courseId;
    
    NSString *paramDataString = [NSString stringWithFormat:@"cmd=getfiles&idCurso=%d", self.courseId];
    
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
    
    NSInteger row = [indexPath row];
    NSDictionary *file = [self.files objectAtIndex:row];
    
    self.ViewFileViewController.date = [file objectForKey:@"fechaArchivo"];
    self.ViewFileViewController.url = [file objectForKey:@"nombreArchivo"];
    self.ViewFileViewController.name = [file objectForKey:@"tituloArchivo"];
    self.ViewFileViewController.description = [file objectForKey:@"descripcionArchivo"];


    [self.navigationController pushViewController:self.ViewFileViewController animated:YES];
}

-(void)removeView{
	
	[self.navigationController popViewControllerAnimated:YES]; //modal se quita con dismiss
	//Como en este lo estamos agregando a la pila del navigation controller se usa el pop
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag)
    {
        case 2:
            self.QuestionsViewController = [[QuestionsViewController alloc] initWithNibName:@"QuestionsViewController" bundle:nil];
            [self.navigationController pushViewController:self.QuestionsViewController animated:YES];
            break;
            
        default:
            break;
    }
    
  
}

@end
