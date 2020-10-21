//
//  FactoryViewController.h
//  Imprint
//
//  Created by Geoff Baker on 30/11/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactoryViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *printingCheckbox;
@end

NS_ASSUME_NONNULL_END
