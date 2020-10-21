//
//  WIPCustomerTotals.h
//  Imprint
//
//  Created by Geoff Baker on 01/11/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#ifndef WIPCustomerTotals_h
#define WIPCustomerTotals_h

//
//  Top10Customers.h
//  Imprint
//
//  Created by Geoff Baker on 12/10/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface WIPCustomerTotals : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CPTPlotDataSource, CPTPieChartDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end


#endif /* WIPCustomerTotals_h */
