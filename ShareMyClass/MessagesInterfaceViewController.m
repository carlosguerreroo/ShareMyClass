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


}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = [NSString stringWithFormat:@"@%@:",[self.student objectForKey:@"nombre"]];
    [self getMessages];
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
    NSLog(@"Send");
    [self.textField resignFirstResponder];
}

-(void)getMessages
{
    //Pido los mensajes
    
    
    
    //recorro los mensajes
    
    
    
    //reload table
    
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
            
            NSLog(@"%@",[object valueForKey:@"from"]);
            NSBubbleData *heyBubble = [NSBubbleData dataWithText:[object valueForKey:@"message"] date:[object valueForKey:@"date"]  type:([[object valueForKey:@"from"] isEqualToString:[[HelperMethods alloc] userId]])?BubbleTypeMine:BubbleTypeSomeoneElse];
            heyBubble.avatar = ([[object valueForKey:@"from"] isEqualToString:[[HelperMethods alloc] userId]])?[[HelperMethods alloc]profilePicture]:nil;
           

            [bubbleData addObject:heyBubble];
        }
        self.bubbleTable.showAvatars = YES;

        [self.bubbleTable reloadData];
    }

}
@end
