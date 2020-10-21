//
//  HomeViewController.h
//  Imprint
//
//  Created by Geoff Baker on 14/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
