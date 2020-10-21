//
//  CRMViewController.h
//  Imprint
//
//  Created by Geoff Baker on 11/12/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIDatePicker *startDatePicker;
    UIDatePicker *endDatePicker;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end

NS_ASSUME_NONNULL_END
