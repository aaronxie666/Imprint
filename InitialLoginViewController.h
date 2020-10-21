//
//  InitialLoginViewController.h
//  Imprint
//
//  Created by Geoff Baker on 19/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "DBManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>

@interface InitialLoginViewController : UIViewController <MFMessageComposeViewControllerDelegate>
// Properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
