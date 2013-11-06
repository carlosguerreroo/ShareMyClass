//
//  NewClassViewController.m
//  ShareMyClass
//
//  Created by pc01 on 10/20/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import "NewClassViewController.h"
#import "AddNewClassViewController.h"
#import "HelperMethods.h"

@interface NewClassViewController ()

@property (nonatomic, strong) NSMutableData* receivedData;
@property (nonatomic, strong) NSArray* courses;
@property (nonatomic, strong) NSArray* searchResults;
@property (nonatomic) NSInteger selectedCourse;

-(void)remainingCourses;
-(void)joinToCourse;

@end

@implementation NewClassViewController

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
    // Do any additional setup after loading the view from its nib.
	self.title = @"Nueva clase";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(newClass)]];
    [self remainingCourses];
 
}
-(void)newClass
{
    if(!self.addNewClassViewController){
        self.addNewClassViewController = [[AddNewClassViewController alloc] initWithNibName:@"AddNewClassViewController" bundle:nil];
    }
    
    self.addNewClassViewController.className.text = @"";
    self.addNewClassViewController.classId.text = @"";
    [self.navigationController pushViewController:self.addNewClassViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //NSLog(@"%@",connection.originalRequest.URL);
    NSString *body = [[[NSString alloc] initWithData: connection.originalRequest.HTTPBody
                                                         encoding:NSUTF8StringEncoding] substringToIndex:23];
   
    if([body isEqualToString:@"cmd=getremainingcourses"])
    {
        NSError *error = [[NSError alloc] init];  //creamos un parametro valor, donde nos servira mucho para
        NSArray *jsonCourses = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        self.courses = jsonCourses;
        [self.tableView reloadData];
        //NSLog(@"%@",jsonCourses);
        self.receivedData = nil;
        
    }else{
        
        if([[[NSString alloc ]initWithData: self.receivedData encoding:NSUTF8StringEncoding] isEqualToString:@"YES"])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        
        self.receivedData = nil;
        [self remainingCourses];
    }
    
}


-(void)remainingCourses
{
    
    NSLog(@"remainingCourses");
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

    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=getremainingcourses&idAlumno=%@", studentId];
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

-(void)joinToCourse
{
    
    NSLog(@"joinToCourse");
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
    
    
    // TODO: aqui debo obtener la matricula de la persona que quiero consultar
    NSString * paramDataString = [NSString stringWithFormat:@"cmd=joincourse&idAlumno=%@&idCurso=%d", studentId,self.selectedCourse];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
        
    } else {
        return [self.courses count];
        
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *idCell = @"idCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"nombreCurso"];
    }
    else
    {
        NSInteger row = [indexPath row];
        NSDictionary *course = [self.courses objectAtIndex:row];
        cell.detailTextLabel.text = [course objectForKey:@"idCursoReal"];
        cell.textLabel.text = [course objectForKey:@"nombreCurso"];
    }
    

  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Estas a punto de suscribirte al curso de:" message:[NSString stringWithFormat:@"%@",[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]] delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Aceptar",nil];
    
    self.selectedCourse = [[[self.courses objectAtIndex:[indexPath row]] objectForKey:@"idCurso"] integerValue];
    
    [alert show];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.nombreCurso contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.courses filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        //NSLog(@"Register User");
        [self joinToCourse];
    }
}
@end
