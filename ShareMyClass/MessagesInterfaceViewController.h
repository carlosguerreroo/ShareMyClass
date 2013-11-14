//
//  MessagesInterfaceViewController.h
//  ShareMyClass
//
//  Created by carlos omana on 11/11/13.
//  Copyright (c) 2013 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"


@interface MessagesInterfaceViewController : UIViewController <UIBubbleTableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;

@end
