//
//  CRMDetailedView.h
//  Imprint
//
//  Created by Geoff Baker on 14/12/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMDetailedView : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, retain) NSDictionary *selectedData;
@property (nonatomic) NSInteger *tabSelected;
@end

NS_ASSUME_NONNULL_END
