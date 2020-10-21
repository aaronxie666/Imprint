//
//  FactoryMachineView.h
//  Imprint
//
//  Created by Geoff Baker on 10/12/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FactoryMachineView : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, retain) NSDictionary *selectedData;
@end

NS_ASSUME_NONNULL_END
