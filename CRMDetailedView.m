//
//  CRMDetailedView.m
//  Imprint
//
//  Created by Geoff Baker on 14/12/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "CRMDetailedView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "Reachability.h"
#import "MBProgressHUD.h"
//#import <Parse/Parse.h>
#import "Flurry.h"
#import "ImprintDatabase.h"

@interface CRMDetailedView ()

@end

@implementation CRMDetailedView {
    //Decide the orientation of the device
    UIDeviceOrientation Orientation;
    NSUserDefaults *defaults;
    
    UIScrollView *mainDetailCont;
    
    //Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
}
@synthesize selectedData;
@synthesize tabSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    //Decide the orientation of the device
    Orientation = [[UIDevice currentDevice]orientation];
    
    /*
     Observer For App Background Handling
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    //Header
    [self.navigationController.navigationBar  setBarTintColor:[UIColor colorWithRed:172/255.0f
                                                                              green:200/255.0f
                                                                               blue:55/255.0f
                                                                              alpha:1.0f]];
    [_sidebarButton setEnabled:NO];
    [_sidebarButton setTintColor: [UIColor clearColor]];
    
    self.navigationController.navigationBarHidden = NO;
    
    UIImageView *navigationImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 38)];
    if(Orientation == UIDeviceOrientationLandscapeRight || Orientation == UIDeviceOrientationLandscapeLeft){
        if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
        {
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
        {
            [navigationImage setFrame:CGRectMake(-30, -12, 170, 53)];
        }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
        {
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
        }else{
            [navigationImage setFrame:CGRectMake(25, 4, 100, 28)];
        }
        
    }
    navigationImage.image=[UIImage imageNamed:@"logo"];
    
    UIImageView *workaroundImageView = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    } else if ([[UIScreen mainScreen] bounds].size.height >= 812) //iPhone X size
    {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    } else {
        workaroundImageView.frame = CGRectMake(0, 0, 110, 40);
    }
    
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView=workaroundImageView;
    self.navigationItem.titleView.center = self.view.center;
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"ic_back"];
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(0, 0, 5, 5);
    leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 30);
    [leftBarButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchDown];
    [leftBarButton setImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    BackgroundImage
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [background setBackgroundColor:[UIColor whiteColor]];
    background.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:background];
    
    [self loadParseContent];
}

-(void) loadParseContent{
    //Loading Animation UIImageView
    
    //Create the first status image and the indicator view
    UIImage *statusImage = [UIImage imageNamed:@"load_anim000"];
    activityImageView = [[UIImageView alloc]
                         initWithImage:statusImage];
    
    
    //Add more images which will be used for the animation
    activityImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"load_anim000"],
                                         [UIImage imageNamed:@"load_anim001"],
                                         [UIImage imageNamed:@"load_anim002"],
                                         [UIImage imageNamed:@"load_anim003"],
                                         [UIImage imageNamed:@"load_anim004"],
                                         [UIImage imageNamed:@"load_anim005"],
                                         [UIImage imageNamed:@"load_anim006"],
                                         [UIImage imageNamed:@"load_anim007"],
                                         [UIImage imageNamed:@"load_anim008"],
                                         [UIImage imageNamed:@"load_anim009"],
                                         nil];
    
    //Set the duration of the animation (play with it
    //until it looks nice for you)
    activityImageView.animationDuration = 0.5;
    
    activityImageView.animationRepeatCount = 0;
    
    
    //Position the activity image view somewhere in
    //the middle of your current view
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -25,
                                         self.view.frame.size.height/2
                                         -25,
                                         50,
                                         50);
    
    //Start the animation
    [activityImageView startAnimating];
    
    if(Orientation == UIDeviceOrientationPortrait){
        [self loadUser];
    }else if(Orientation == UIDeviceOrientationLandscapeLeft || Orientation ==  UIDeviceOrientationLandscapeRight){
        //[self loadUserHorizontal];
        
    } else {
        [self loadUser];
    }
    //[Hud removeFromSuperview];
    
}

-(void)loadUser{
    
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        header.frame = CGRectMake(0, 70, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    } else {
        header.frame = CGRectMake(0, 80, self.view.frame.size.width, 80);
    }
    [header setBackgroundColor:[UIColor colorWithRed:192/255.0f
                                               green:29/255.0f
                                                blue:74/255.0f
                                               alpha:1.0f]];
    [self.view addSubview:header];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        headImg.frame = CGRectMake(150, 5, 70, 70);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    }
    headImg.image = [UIImage imageNamed:@"brand-logo"];
    [header addSubview:headImg];
    
    
    UILabel *LtdLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        LtdLable.frame = CGRectMake(250, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    } else {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    }
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    LtdLable.textAlignment = NSTextAlignmentLeft;
    [LtdLable setFont:[UIFont boldSystemFontOfSize:16]];
    [data getCompanyDetails:nil completion:^(NSMutableArray *companyDetails, NSError *error) {
        if(!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                LtdLable.text = [companyDetails objectAtIndex:0][@"CompanyName"];
            });
        }
    }];
    
    
    //LtdLable.text = @"Pretend Printers Ltd";
    LtdLable.textColor = [UIColor whiteColor];
    [header addSubview:LtdLable];
    
    UILabel *userLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        userLable.frame = CGRectMake(500, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    } else {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    }
    userLable.text = [NSString stringWithFormat:@"Welcome %@", [defaults stringForKey:@"userEmail"]];
    [userLable setFont:[UIFont boldSystemFontOfSize:16]];
    userLable.textColor = [UIColor whiteColor];
    userLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:userLable];
    
    
    UIImageView *BILable = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 15);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 20);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        BILable.frame = CGRectMake(200, 190, self.view.frame.size.width-400, 20);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    } else {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 20);
    }
    BILable.image = [UIImage imageNamed:@"title_crm"];
    [self.view addSubview:BILable];
    
    UIView *buttonsCont = [[UIView alloc] init];
    buttonsCont.frame = CGRectMake(0, 220, self.view.frame.size.width, 140);
    //[buttonsCont setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:buttonsCont];
    
    UIButton *workInstructionsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonsCont.frame.size.width/4, 65)];
    [workInstructionsBtn setBackgroundImage:[UIImage imageNamed:@"btn_workinstructions"] forState:UIControlStateNormal];
    [buttonsCont addSubview:workInstructionsBtn];
    
    UIButton *costSheetBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4, 0, buttonsCont.frame.size.width/4, 65)];
    [costSheetBtn setBackgroundImage:[UIImage imageNamed:@"btn_costsheet"] forState:UIControlStateNormal];
    [buttonsCont addSubview:costSheetBtn];
    
    UIButton *ViewEstWorkingsBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4*2, 0, buttonsCont.frame.size.width/4, 65)];
    [ViewEstWorkingsBtn setBackgroundImage:[UIImage imageNamed:@"btn_viewestimateworkings"] forState:UIControlStateNormal];
    [buttonsCont addSubview:ViewEstWorkingsBtn];

    UIButton *purchaseOrdersBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4*3, 0, buttonsCont.frame.size.width/4, 65)];
    [purchaseOrdersBtn setBackgroundImage:[UIImage imageNamed:@"btn_purchaseorders"] forState:UIControlStateNormal];
    [buttonsCont addSubview:purchaseOrdersBtn];
    
    UIButton *deliveriesBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 65, buttonsCont.frame.size.width/4, 65)];
    [deliveriesBtn setBackgroundImage:[UIImage imageNamed:@"btn_deliveries"] forState:UIControlStateNormal];
    [buttonsCont addSubview:deliveriesBtn];
    
    UIButton *invoicesBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4, 65, buttonsCont.frame.size.width/4, 65)];
    [invoicesBtn setBackgroundImage:[UIImage imageNamed:@"btn_invoices"] forState:UIControlStateNormal];
    [buttonsCont addSubview:invoicesBtn];
    
    UIButton *documentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4*2,65, buttonsCont.frame.size.width/4, 65)];
    [documentsBtn setBackgroundImage:[UIImage imageNamed:@"btn_documents"] forState:UIControlStateNormal];
    [buttonsCont addSubview:documentsBtn];
    
    UIButton *extDocumentsBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonsCont.frame.size.width/4*3, 65, buttonsCont.frame.size.width/4, 65)];
    [extDocumentsBtn setBackgroundImage:[UIImage imageNamed:@"btn_externaldocuments"] forState:UIControlStateNormal];
    [buttonsCont addSubview:extDocumentsBtn];
    
    mainDetailCont = [[UIScrollView alloc] init];
    mainDetailCont.frame = CGRectMake(0, 360, self.view.frame.size.width, self.view.frame.size.height - 370);
    //mainDetailCont.contentSize = CGSizeMake(mainDetailCont.frame.size.width, 530);
    //mainDetailCont setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:mainDetailCont];
    
    UIView *container1 = [[UIView alloc] initWithFrame:CGRectMake(5, 0, mainDetailCont.frame.size.width / 2 - 10, 80)];
    // corner radius
    [container1.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container1.layer setShadowColor:[UIColor blackColor].CGColor];
    [container1.layer setShadowOpacity:0.8];
    [container1.layer setShadowRadius:3.0];
    [container1.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container1.tag = 1;
    [mainDetailCont addSubview:container1];
    
    UIView *container2 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 0, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container2 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container2.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container2.layer setShadowColor:[UIColor blackColor].CGColor];
    [container2.layer setShadowOpacity:0.8];
    [container2.layer setShadowRadius:3.0];
    [container2.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container2.tag = 2;
    [mainDetailCont addSubview:container2];
    
    UIView *container3 = [[UIView alloc] initWithFrame:CGRectMake(5, 90, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container3 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container3.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container3.layer setShadowColor:[UIColor blackColor].CGColor];
    [container3.layer setShadowOpacity:0.8];
    [container3.layer setShadowRadius:3.0];
    [container3.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container3.tag = 3;
    [mainDetailCont addSubview:container3];
    
    UIView *container4 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 90, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container4 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container4.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container4.layer setShadowColor:[UIColor blackColor].CGColor];
    [container4.layer setShadowOpacity:0.8];
    [container4.layer setShadowRadius:3.0];
    [container4.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container4.tag = 4;
    [mainDetailCont addSubview:container4];
    
    UIView *container5 = [[UIView alloc] initWithFrame:CGRectMake(5, 180, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container5 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container5.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container5.layer setShadowColor:[UIColor blackColor].CGColor];
    [container5.layer setShadowOpacity:0.8];
    [container5.layer setShadowRadius:3.0];
    [container5.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container5.tag = 5;
    [mainDetailCont addSubview:container5];
    
    UIView *container6 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 180, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container6 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container6.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container6.layer setShadowColor:[UIColor blackColor].CGColor];
    [container6.layer setShadowOpacity:0.8];
    [container6.layer setShadowRadius:3.0];
    [container6.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container6.tag = 6;
    [mainDetailCont addSubview:container6];
    
    UIView *container7 = [[UIView alloc] initWithFrame:CGRectMake(5, 270, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container7 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container7.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container7.layer setShadowColor:[UIColor blackColor].CGColor];
    [container7.layer setShadowOpacity:0.8];
    [container7.layer setShadowRadius:3.0];
    [container7.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container7.tag = 7;
    [mainDetailCont addSubview:container7];
    
    UIView *container8 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 270, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container8 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container8.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container8.layer setShadowColor:[UIColor blackColor].CGColor];
    [container8.layer setShadowOpacity:0.8];
    [container8.layer setShadowRadius:3.0];
    [container8.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container8.tag = 8;
    [mainDetailCont addSubview:container8];
    
    UIView *container9 = [[UIView alloc] initWithFrame:CGRectMake(5, 360, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container9 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container9.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container9.layer setShadowColor:[UIColor blackColor].CGColor];
    [container9.layer setShadowOpacity:0.8];
    [container9.layer setShadowRadius:3.0];
    [container9.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container9.tag = 9;
    [mainDetailCont addSubview:container9];
    
    UIView *container10 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 360, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container10 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container10.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container10.layer setShadowColor:[UIColor blackColor].CGColor];
    [container10.layer setShadowOpacity:0.8];
    [container10.layer setShadowRadius:3.0];
    [container10.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container10.tag = 10;
    [mainDetailCont addSubview:container10];
    
    UIView *container11 = [[UIView alloc] initWithFrame:CGRectMake(5, 450, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container11 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container11.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container11.layer setShadowColor:[UIColor blackColor].CGColor];
    [container11.layer setShadowOpacity:0.8];
    [container11.layer setShadowRadius:3.0];
    [container11.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container11.tag = 11;
    [mainDetailCont addSubview:container11];
    
    UIView *container12 = [[UIView alloc] initWithFrame:CGRectMake(mainDetailCont.frame.size.width / 2 + 5, 450, mainDetailCont.frame.size.width / 2 - 10, 80)];
    //[container12 setBackgroundColor:[UIColor whiteColor]];
    // corner radius
    [container12.layer setCornerRadius:10.0f];
    
    // drop shadow
    [container12.layer setShadowColor:[UIColor blackColor].CGColor];
    [container12.layer setShadowOpacity:0.8];
    [container12.layer setShadowRadius:3.0];
    [container12.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    container12.tag = 12;
    [mainDetailCont addSubview:container12];
    
    NSLog(@"%@", selectedData);
    if(tabSelected == 0) {
        [self loadJob];
    } else if (tabSelected == 1) {
        [self loadEstimate];
    } else if (tabSelected == 2) {
        [self loadAct];
    } else {
        
    }
    
}

-(void)loadJob {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumberFormatter *formatterCurrency = [NSNumberFormatter new];
    [formatterCurrency setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 180, 250, 30);
    title.text = [NSString stringWithFormat:@"%@", selectedData[@"Title"]];
    title.font = [UIFont fontWithName:@"OpenSans-Regular" size:18];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:title];
    
    UILabel *jobNo = [[UILabel alloc] init];
    jobNo.frame = CGRectMake(self.view.frame.size.width-110, 180, 100, 30);
    jobNo.text = [NSString stringWithFormat:@"%@", selectedData[@"JobNo"]];
    jobNo.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:18];
    jobNo.textColor = [UIColor blackColor];
    jobNo.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:jobNo];
    
    //Takes one of the containers to use as constraints for sizing (container should be sized to phone screen already/ and be the same size)
    UIView *sizeTemplate = [self.view viewWithTag:1];
    
    NSDateFormatter *ISO8601DateFormatter = [[NSDateFormatter alloc] init];
    ISO8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    ISO8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    ISO8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"d MMM, yyyy"];
    
    int contNm = 1;
    
    if(![selectedData[@"Position"] isEqualToString:@""]) {
    
        UIView *positionCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        positionCont.layer.cornerRadius = 10;
        positionCont.layer.masksToBounds = TRUE;
        UILabel *positionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        /*
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: positionTitle.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
        positionTitle.layer.mask = maskLayer;
         */
        positionTitle.text = [NSString stringWithFormat:@"Position"];
        [positionTitle setFont:[UIFont systemFontOfSize:12]];
        positionTitle.textColor = [UIColor blackColor];
        positionTitle.textAlignment = NSTextAlignmentCenter;
        [positionTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [positionCont addSubview:positionTitle];
        
        UILabel *positionValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, positionCont.frame.size.height - positionTitle.frame.size.height)];
        /*
        CAShapeLayer * maskLayer2 = [CAShapeLayer layer];
        maskLayer2.path = [UIBezierPath bezierPathWithRoundedRect: positionValue.bounds byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
        positionValue.layer.mask = maskLayer2;
         */
        positionValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Position"]];
        [positionValue setFont:[UIFont systemFontOfSize:20]];
        positionValue.textColor = [UIColor blackColor];
        positionValue.textAlignment = NSTextAlignmentCenter;
        [positionValue setBackgroundColor:[UIColor whiteColor]];
        [positionCont addSubview:positionValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:positionCont];
        contNm++;
    }
    
    if(![selectedData[@"Date"] isEqualToString:@""]) {
    
        UIView *dateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        dateCont.layer.cornerRadius = 10;
        dateCont.layer.masksToBounds = TRUE;
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        dateTitle.text = [NSString stringWithFormat:@"Date"];
        [dateTitle setFont:[UIFont systemFontOfSize:12]];
        dateTitle.textColor = [UIColor blackColor];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        [dateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [dateCont addSubview:dateTitle];
        
        UILabel *dateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, dateCont.frame.size.height - dateTitle.frame.size.height)];
        NSDate *date =  [ISO8601DateFormatter dateFromString:selectedData[@"Date"]];
        dateValue.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        [dateValue setFont:[UIFont systemFontOfSize:20]];
        dateValue.textColor = [UIColor blackColor];
        dateValue.textAlignment = NSTextAlignmentCenter;
        [dateValue setBackgroundColor:[UIColor whiteColor]];
        [dateCont addSubview:dateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:dateCont];
        contNm++;
    }
    
    if(!(selectedData[@"Quantity"] == nil )) {
        
        UIView *quantityCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        quantityCont.layer.cornerRadius = 10;
        quantityCont.layer.masksToBounds = TRUE;
        UILabel *quantityTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        quantityTitle.text = [NSString stringWithFormat:@"Quantity"];
        [quantityTitle setFont:[UIFont systemFontOfSize:12]];
        quantityTitle.textColor = [UIColor blackColor];
        quantityTitle.textAlignment = NSTextAlignmentCenter;
        [quantityTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [quantityCont addSubview:quantityTitle];
        
        UILabel *quantityValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, quantityCont.frame.size.height - quantityTitle.frame.size.height)];
        double quantity = [[NSString stringWithFormat:@"%@", selectedData[@"Quantity"]] integerValue];
        NSString *formattedQuantity = [formatter stringFromNumber:[NSNumber numberWithInteger:quantity]];
        quantityValue.text = [NSString stringWithFormat:@"%@", formattedQuantity];
        [quantityValue setFont:[UIFont systemFontOfSize:20]];
        quantityValue.textColor = [UIColor blackColor];
        quantityValue.textAlignment = NSTextAlignmentCenter;
        [quantityValue setBackgroundColor:[UIColor whiteColor]];
        [quantityCont addSubview:quantityValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:quantityCont];
        contNm++;
    }
    
    if(![selectedData[@"EstimateNo"] isEqualToString:@""]) {
        
        UIView *estimateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        estimateCont.layer.cornerRadius = 10;
        estimateCont.layer.masksToBounds = TRUE;
        UILabel *estimateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        estimateTitle.text = [NSString stringWithFormat:@"Estimate No"];
        [estimateTitle setFont:[UIFont systemFontOfSize:12]];
        estimateTitle.textColor = [UIColor blackColor];
        estimateTitle.textAlignment = NSTextAlignmentCenter;
        [estimateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [estimateCont addSubview:estimateTitle];
        
        UILabel *estimateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, estimateCont.frame.size.height - estimateTitle.frame.size.height)];
        estimateValue.text = [NSString stringWithFormat:@"%@", selectedData[@"EstimateNo"]];
        [estimateValue setFont:[UIFont systemFontOfSize:20]];
        estimateValue.textColor = [UIColor blackColor];
        estimateValue.textAlignment = NSTextAlignmentCenter;
        [estimateValue setBackgroundColor:[UIColor whiteColor]];
        [estimateCont addSubview:estimateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:estimateCont];
        contNm++;
    }
    
    if(![selectedData[@"Extent"] isEqualToString:@""]) {
        
        UIView *extentCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        extentCont.layer.cornerRadius = 10;
        extentCont.layer.masksToBounds = TRUE;
        UILabel *extentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        extentTitle.text = [NSString stringWithFormat:@"Extent"];
        [extentTitle setFont:[UIFont systemFontOfSize:12]];
        extentTitle.textColor = [UIColor blackColor];
        extentTitle.textAlignment = NSTextAlignmentCenter;
        [extentTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                        green:200/255.0f
                                                         blue:55/255.0f
                                                        alpha:1.0f]];
        [extentCont addSubview:extentTitle];
        
        UILabel *extentValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, extentCont.frame.size.height - extentTitle.frame.size.height)];
        extentValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Extent"]];
        [extentValue setFont:[UIFont systemFontOfSize:20]];
        extentValue.textColor = [UIColor blackColor];
        extentValue.textAlignment = NSTextAlignmentCenter;
        [extentValue setBackgroundColor:[UIColor whiteColor]];
        [extentCont addSubview:extentValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:extentCont];
        contNm++;
    }
    
    if(![selectedData[@"CustomerRef"] isEqualToString:@""]) {
        
        UIView *orderNmCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        orderNmCont.layer.cornerRadius = 10;
        orderNmCont.layer.masksToBounds = TRUE;
        UILabel *orderNmTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        orderNmTitle.text = [NSString stringWithFormat:@"Order No"];
        [orderNmTitle setFont:[UIFont systemFontOfSize:12]];
        orderNmTitle.textColor = [UIColor blackColor];
        orderNmTitle.textAlignment = NSTextAlignmentCenter;
        [orderNmTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [orderNmCont addSubview:orderNmTitle];
        
        UILabel *orderNmValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, orderNmCont.frame.size.height - orderNmTitle.frame.size.height)];
        orderNmValue.text = [NSString stringWithFormat:@"%@", selectedData[@"CustomerRef"]];
        [orderNmValue setFont:[UIFont systemFontOfSize:20]];
        orderNmValue.textColor = [UIColor blackColor];
        orderNmValue.textAlignment = NSTextAlignmentCenter;
        [orderNmValue setBackgroundColor:[UIColor whiteColor]];
        [orderNmCont addSubview:orderNmValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:orderNmCont];
        contNm++;
    }
    
    if(!(selectedData[@"SellingPrice"] == nil )) {
        
        UIView *sellingCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sellingCont.layer.cornerRadius = 10;
        sellingCont.layer.masksToBounds = TRUE;
        UILabel *sellingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sellingTitle.text = [NSString stringWithFormat:@"Selling Price"];
        [sellingTitle setFont:[UIFont systemFontOfSize:12]];
        sellingTitle.textColor = [UIColor blackColor];
        sellingTitle.textAlignment = NSTextAlignmentCenter;
        [sellingTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [sellingCont addSubview:sellingTitle];
        
        UILabel *sellingValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sellingCont.frame.size.height - sellingTitle.frame.size.height)];
        double price = [[NSString stringWithFormat:@"%@", selectedData[@"SellingPrice"]] integerValue];
        NSString *formattedPrice = [formatterCurrency stringFromNumber:[NSNumber numberWithInteger:price]];
        sellingValue.text = [NSString stringWithFormat:@"%@", formattedPrice];
        [sellingValue setFont:[UIFont systemFontOfSize:20]];
        sellingValue.textColor = [UIColor blackColor];
        sellingValue.textAlignment = NSTextAlignmentCenter;
        [sellingValue setBackgroundColor:[UIColor whiteColor]];
        [sellingCont addSubview:sellingValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sellingCont];
        contNm++;
    }
    
    if(![selectedData[@"SalesExec"] isEqualToString:@""]) {
        
        UIView *salesExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        salesExCont.layer.cornerRadius = 10;
        salesExCont.layer.masksToBounds = TRUE;
        UILabel *salesExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        salesExTitle.text = [NSString stringWithFormat:@"Sales Exec"];
        [salesExTitle setFont:[UIFont systemFontOfSize:12]];
        salesExTitle.textColor = [UIColor blackColor];
        salesExTitle.textAlignment = NSTextAlignmentCenter;
        [salesExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [salesExCont addSubview:salesExTitle];
        
        UILabel *salesExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, salesExCont.frame.size.height - salesExTitle.frame.size.height)];
        salesExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"SalesExec"]];
        [salesExValue setFont:[UIFont systemFontOfSize:20]];
        salesExValue.textColor = [UIColor blackColor];
        salesExValue.textAlignment = NSTextAlignmentCenter;
        [salesExValue setBackgroundColor:[UIColor whiteColor]];
        [salesExCont addSubview:salesExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:salesExCont];
        contNm++;
    }
    
    if(![selectedData[@"AccountExec"] isEqualToString:@""]) {
        
        UIView *accountExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        accountExCont.layer.cornerRadius = 10;
        accountExCont.layer.masksToBounds = TRUE;
        UILabel *accountExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        accountExTitle.text = [NSString stringWithFormat:@"Account Exec"];
        [accountExTitle setFont:[UIFont systemFontOfSize:12]];
        accountExTitle.textColor = [UIColor blackColor];
        accountExTitle.textAlignment = NSTextAlignmentCenter;
        [accountExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                           green:200/255.0f
                                                            blue:55/255.0f
                                                           alpha:1.0f]];
        [accountExCont addSubview:accountExTitle];
        
        UILabel *accountExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, accountExCont.frame.size.height - accountExTitle.frame.size.height)];
        accountExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"AccountExec"]];
        [accountExValue setFont:[UIFont systemFontOfSize:20]];
        accountExValue.textColor = [UIColor blackColor];
        accountExValue.textAlignment = NSTextAlignmentCenter;
        [accountExValue setBackgroundColor:[UIColor whiteColor]];
        [accountExCont addSubview:accountExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:accountExCont];
        contNm++;
    }
    
    if(![selectedData[@"Size"] isEqualToString:@""]) {
        
        UIView *sizeCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sizeCont.layer.cornerRadius = 10;
        sizeCont.layer.masksToBounds = TRUE;
        UILabel *sizeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sizeTitle.text = [NSString stringWithFormat:@"Size"];
        [sizeTitle setFont:[UIFont systemFontOfSize:12]];
        sizeTitle.textColor = [UIColor blackColor];
        sizeTitle.textAlignment = NSTextAlignmentCenter;
        [sizeTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [sizeCont addSubview:sizeTitle];
        
        UILabel *sizeValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sizeCont.frame.size.height - sizeTitle.frame.size.height)];
        sizeValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Size"]];
        [sizeValue setFont:[UIFont systemFontOfSize:20]];
        sizeValue.textColor = [UIColor blackColor];
        sizeValue.textAlignment = NSTextAlignmentCenter;
        [sizeValue setBackgroundColor:[UIColor whiteColor]];
        [sizeCont addSubview:sizeValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sizeCont];
        contNm++;
    }
    
    if(![selectedData[@"ProductCode"] isEqualToString:@""]) {
        
        UIView *productCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        productCont.layer.cornerRadius = 10;
        productCont.layer.masksToBounds = TRUE;
        UILabel *productTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        productTitle.text = [NSString stringWithFormat:@"Product Code"];
        [productTitle setFont:[UIFont systemFontOfSize:12]];
        productTitle.textColor = [UIColor blackColor];
        productTitle.textAlignment = NSTextAlignmentCenter;
        [productTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [productCont addSubview:productTitle];
        
        UILabel *productValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, productCont.frame.size.height - productTitle.frame.size.height)];
        productValue.text = [NSString stringWithFormat:@"%@", selectedData[@"ProductCode"]];
        [productValue setFont:[UIFont systemFontOfSize:20]];
        productValue.textColor = [UIColor blackColor];
        productValue.textAlignment = NSTextAlignmentCenter;
        [productValue setBackgroundColor:[UIColor whiteColor]];
        [productCont addSubview:productValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:productCont];
        contNm++;
    }
    
    if(![selectedData[@"DeliveryDate"] isEqualToString:@""]) {
        
        UIView *deliveryDateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        deliveryDateCont.layer.cornerRadius = 10;
        deliveryDateCont.layer.masksToBounds = TRUE;
        UILabel *deliveryDateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        deliveryDateTitle.text = [NSString stringWithFormat:@"Delivery Date"];
        [deliveryDateTitle setFont:[UIFont systemFontOfSize:12]];
        deliveryDateTitle.textColor = [UIColor blackColor];
        deliveryDateTitle.textAlignment = NSTextAlignmentCenter;
        [deliveryDateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                              green:200/255.0f
                                                               blue:55/255.0f
                                                              alpha:1.0f]];
        [deliveryDateCont addSubview:deliveryDateTitle];
        
        UILabel *deliveryDateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, deliveryDateCont.frame.size.height - deliveryDateTitle.frame.size.height)];
        NSDate *date =  [ISO8601DateFormatter dateFromString:selectedData[@"DeliveryDate"]];
        deliveryDateValue.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        [deliveryDateValue setFont:[UIFont systemFontOfSize:20]];
        deliveryDateValue.textColor = [UIColor blackColor];
        deliveryDateValue.textAlignment = NSTextAlignmentCenter;
        [deliveryDateValue setBackgroundColor:[UIColor whiteColor]];
        [deliveryDateCont addSubview:deliveryDateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:deliveryDateCont];
        contNm++;
    }
    
    contNm--;
    int count = contNm / 2;
    NSLog(@"%d",count);
    if(contNm % 2 == 1) {
        count++;
    }
    mainDetailCont.contentSize = CGSizeMake(mainDetailCont.frame.size.width, 90*count);
}

-(void)loadEstimate {
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 180, 250, 30);
    title.text = [NSString stringWithFormat:@"%@", selectedData[@"Title"]];
    title.font = [UIFont fontWithName:@"OpenSans-Regular" size:18];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:title];
    
    UILabel *jobNo = [[UILabel alloc] init];
    jobNo.frame = CGRectMake(self.view.frame.size.width-110, 180, 100, 30);
    jobNo.text = [NSString stringWithFormat:@"%@", selectedData[@"Ref"]];
    jobNo.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:18];
    jobNo.textColor = [UIColor blackColor];
    jobNo.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:jobNo];
    
    //Takes one of the containers to use as constraints for sizing (container should be sized to phone screen already/ and be the same size)
    UIView *sizeTemplate = [self.view viewWithTag:1];
    
    NSDateFormatter *ISO8601DateFormatter = [[NSDateFormatter alloc] init];
    ISO8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    ISO8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    ISO8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"d MMM, yyyy"];
    
    int contNm = 1;
    
    if(![selectedData[@"Date"] isEqualToString:@""]) {
        
        UIView *dateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        dateCont.layer.cornerRadius = 10;
        dateCont.layer.masksToBounds = TRUE;
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        dateTitle.text = [NSString stringWithFormat:@"Date"];
        [dateTitle setFont:[UIFont systemFontOfSize:12]];
        dateTitle.textColor = [UIColor blackColor];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        [dateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [dateCont addSubview:dateTitle];
        
        UILabel *dateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, dateCont.frame.size.height - dateTitle.frame.size.height)];
        NSDate *date =  [ISO8601DateFormatter dateFromString:selectedData[@"Date"]];
        dateValue.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        [dateValue setFont:[UIFont systemFontOfSize:20]];
        dateValue.textColor = [UIColor blackColor];
        dateValue.textAlignment = NSTextAlignmentCenter;
        [dateValue setBackgroundColor:[UIColor whiteColor]];
        [dateCont addSubview:dateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:dateCont];
        contNm++;
    }
    
    if(!(selectedData[@"Quantity"] == nil )) {
        
        UIView *quantityCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        quantityCont.layer.cornerRadius = 10;
        quantityCont.layer.masksToBounds = TRUE;
        UILabel *quantityTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        quantityTitle.text = [NSString stringWithFormat:@"Quantity"];
        [quantityTitle setFont:[UIFont systemFontOfSize:12]];
        quantityTitle.textColor = [UIColor blackColor];
        quantityTitle.textAlignment = NSTextAlignmentCenter;
        [quantityTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [quantityCont addSubview:quantityTitle];
        
        UILabel *quantityValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, quantityCont.frame.size.height - quantityTitle.frame.size.height)];
        quantityValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Quantity"]];
        [quantityValue setFont:[UIFont systemFontOfSize:20]];
        quantityValue.textColor = [UIColor blackColor];
        quantityValue.textAlignment = NSTextAlignmentCenter;
        [quantityValue setBackgroundColor:[UIColor whiteColor]];
        [quantityCont addSubview:quantityValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:quantityCont];
        contNm++;
    }
    
    if(![selectedData[@"EstimateNo"] isEqualToString:@""]) {
        
        UIView *estimateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        estimateCont.layer.cornerRadius = 10;
        estimateCont.layer.masksToBounds = TRUE;
        UILabel *estimateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        estimateTitle.text = [NSString stringWithFormat:@"Estimate No"];
        [estimateTitle setFont:[UIFont systemFontOfSize:12]];
        estimateTitle.textColor = [UIColor blackColor];
        estimateTitle.textAlignment = NSTextAlignmentCenter;
        [estimateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [estimateCont addSubview:estimateTitle];
        
        UILabel *estimateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, estimateCont.frame.size.height - estimateTitle.frame.size.height)];
        estimateValue.text = [NSString stringWithFormat:@"%@", selectedData[@"EstimateNo"]];
        [estimateValue setFont:[UIFont systemFontOfSize:20]];
        estimateValue.textColor = [UIColor blackColor];
        estimateValue.textAlignment = NSTextAlignmentCenter;
        [estimateValue setBackgroundColor:[UIColor whiteColor]];
        [estimateCont addSubview:estimateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:estimateCont];
        contNm++;
    }
    
    if(![selectedData[@"Extent"] isEqualToString:@""]) {
        
        UIView *extentCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        extentCont.layer.cornerRadius = 10;
        extentCont.layer.masksToBounds = TRUE;
        UILabel *extentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        extentTitle.text = [NSString stringWithFormat:@"Extent"];
        [extentTitle setFont:[UIFont systemFontOfSize:12]];
        extentTitle.textColor = [UIColor blackColor];
        extentTitle.textAlignment = NSTextAlignmentCenter;
        [extentTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                        green:200/255.0f
                                                         blue:55/255.0f
                                                        alpha:1.0f]];
        [extentCont addSubview:extentTitle];
        
        UILabel *extentValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, extentCont.frame.size.height - extentTitle.frame.size.height)];
        extentValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Extent"]];
        [extentValue setFont:[UIFont systemFontOfSize:20]];
        extentValue.textColor = [UIColor blackColor];
        extentValue.textAlignment = NSTextAlignmentCenter;
        [extentValue setBackgroundColor:[UIColor whiteColor]];
        [extentCont addSubview:extentValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:extentCont];
        contNm++;
    }
    
    if(!(selectedData[@"Price"] == nil )) {
        
        UIView *sellingCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sellingCont.layer.cornerRadius = 10;
        sellingCont.layer.masksToBounds = TRUE;
        UILabel *sellingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sellingTitle.text = [NSString stringWithFormat:@"Price"];
        [sellingTitle setFont:[UIFont systemFontOfSize:12]];
        sellingTitle.textColor = [UIColor blackColor];
        sellingTitle.textAlignment = NSTextAlignmentCenter;
        [sellingTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [sellingCont addSubview:sellingTitle];
        
        UILabel *sellingValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sellingCont.frame.size.height - sellingTitle.frame.size.height)];
        sellingValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Price"]];
        [sellingValue setFont:[UIFont systemFontOfSize:20]];
        sellingValue.textColor = [UIColor blackColor];
        sellingValue.textAlignment = NSTextAlignmentCenter;
        [sellingValue setBackgroundColor:[UIColor whiteColor]];
        [sellingCont addSubview:sellingValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sellingCont];
        contNm++;
    }
    
    if(![selectedData[@"SalesExec"] isEqualToString:@""]) {
        
        UIView *salesExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        salesExCont.layer.cornerRadius = 10;
        salesExCont.layer.masksToBounds = TRUE;
        UILabel *salesExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        salesExTitle.text = [NSString stringWithFormat:@"Sales Exec"];
        [salesExTitle setFont:[UIFont systemFontOfSize:12]];
        salesExTitle.textColor = [UIColor blackColor];
        salesExTitle.textAlignment = NSTextAlignmentCenter;
        [salesExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [salesExCont addSubview:salesExTitle];
        
        UILabel *salesExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, salesExCont.frame.size.height - salesExTitle.frame.size.height)];
        salesExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"SalesExec"]];
        [salesExValue setFont:[UIFont systemFontOfSize:20]];
        salesExValue.textColor = [UIColor blackColor];
        salesExValue.textAlignment = NSTextAlignmentCenter;
        [salesExValue setBackgroundColor:[UIColor whiteColor]];
        [salesExCont addSubview:salesExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:salesExCont];
        contNm++;
    }
    
    if(![selectedData[@"Estimator"] isEqualToString:@""]) {
        
        UIView *accountExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        accountExCont.layer.cornerRadius = 10;
        accountExCont.layer.masksToBounds = TRUE;
        UILabel *accountExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        accountExTitle.text = [NSString stringWithFormat:@"Estimator"];
        [accountExTitle setFont:[UIFont systemFontOfSize:12]];
        accountExTitle.textColor = [UIColor blackColor];
        accountExTitle.textAlignment = NSTextAlignmentCenter;
        [accountExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                           green:200/255.0f
                                                            blue:55/255.0f
                                                           alpha:1.0f]];
        [accountExCont addSubview:accountExTitle];
        
        UILabel *accountExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, accountExCont.frame.size.height - accountExTitle.frame.size.height)];
        accountExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Estimator"]];
        [accountExValue setFont:[UIFont systemFontOfSize:20]];
        accountExValue.textColor = [UIColor blackColor];
        accountExValue.textAlignment = NSTextAlignmentCenter;
        [accountExValue setBackgroundColor:[UIColor whiteColor]];
        [accountExCont addSubview:accountExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:accountExCont];
        contNm++;
    }
    
    if(![selectedData[@"FinishedSize"] isEqualToString:@""]) {
        
        UIView *sizeCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sizeCont.layer.cornerRadius = 10;
        sizeCont.layer.masksToBounds = TRUE;
        UILabel *sizeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sizeTitle.text = [NSString stringWithFormat:@"Finished Size"];
        [sizeTitle setFont:[UIFont systemFontOfSize:12]];
        sizeTitle.textColor = [UIColor blackColor];
        sizeTitle.textAlignment = NSTextAlignmentCenter;
        [sizeTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [sizeCont addSubview:sizeTitle];
        
        UILabel *sizeValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sizeCont.frame.size.height - sizeTitle.frame.size.height)];
        sizeValue.text = [NSString stringWithFormat:@"%@", selectedData[@"FinishedSize"]];
        [sizeValue setFont:[UIFont systemFontOfSize:20]];
        sizeValue.textColor = [UIColor blackColor];
        sizeValue.textAlignment = NSTextAlignmentCenter;
        [sizeValue setBackgroundColor:[UIColor whiteColor]];
        [sizeCont addSubview:sizeValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sizeCont];
        contNm++;
    }
    
    if(![selectedData[@"ProductCode"] isEqualToString:@""]) {
        
        UIView *productCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        productCont.layer.cornerRadius = 10;
        productCont.layer.masksToBounds = TRUE;
        UILabel *productTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        productTitle.text = [NSString stringWithFormat:@"Product Code"];
        [productTitle setFont:[UIFont systemFontOfSize:12]];
        productTitle.textColor = [UIColor blackColor];
        productTitle.textAlignment = NSTextAlignmentCenter;
        [productTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [productCont addSubview:productTitle];
        
        UILabel *productValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, productCont.frame.size.height - productTitle.frame.size.height)];
        productValue.text = [NSString stringWithFormat:@"%@", selectedData[@"ProductCode"]];
        [productValue setFont:[UIFont systemFontOfSize:20]];
        productValue.textColor = [UIColor blackColor];
        productValue.textAlignment = NSTextAlignmentCenter;
        [productValue setBackgroundColor:[UIColor whiteColor]];
        [productCont addSubview:productValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:productCont];
        contNm++;
    }
    
    if(![selectedData[@"FSCCode"] isEqualToString:@""]) {
        
        UIView *orderNmCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        orderNmCont.layer.cornerRadius = 10;
        orderNmCont.layer.masksToBounds = TRUE;
        UILabel *orderNmTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        orderNmTitle.text = [NSString stringWithFormat:@"FSC Code"];
        [orderNmTitle setFont:[UIFont systemFontOfSize:12]];
        orderNmTitle.textColor = [UIColor blackColor];
        orderNmTitle.textAlignment = NSTextAlignmentCenter;
        [orderNmTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [orderNmCont addSubview:orderNmTitle];
        
        UILabel *orderNmValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, orderNmCont.frame.size.height - orderNmTitle.frame.size.height)];
        orderNmValue.text = [NSString stringWithFormat:@"%@", selectedData[@"FSCCode"]];
        [orderNmValue setFont:[UIFont systemFontOfSize:20]];
        orderNmValue.textColor = [UIColor blackColor];
        orderNmValue.textAlignment = NSTextAlignmentCenter;
        [orderNmValue setBackgroundColor:[UIColor whiteColor]];
        [orderNmCont addSubview:orderNmValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:orderNmCont];
        contNm++;
    }
    
    contNm--;
    int count = contNm / 2;
    NSLog(@"%d",count);
    if(contNm % 2 == 1) {
        count++;
    }
    mainDetailCont.contentSize = CGSizeMake(mainDetailCont.frame.size.width, 90*count -10);
}

-(void)loadActivity {
    UILabel *notAvailable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 + 30, self.view.frame.size.width, 30)];
    notAvailable.text = [NSString stringWithFormat:@"Feature Not Available Yet"];
    [notAvailable setFont:[UIFont systemFontOfSize:16]];
    notAvailable.textColor = [UIColor blackColor];
    notAvailable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notAvailable];
}

-(void)loadAct {
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 180, 250, 30);
    title.text = [NSString stringWithFormat:@"%@", selectedData[@"Contact"]];
    title.font = [UIFont fontWithName:@"OpenSans-Regular" size:18];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:title];
    
    UILabel *jobNo = [[UILabel alloc] init];
    jobNo.frame = CGRectMake(self.view.frame.size.width-110, 180, 100, 30);
    jobNo.text = [NSString stringWithFormat:@"%@", selectedData[@"Ref"]];
    jobNo.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:18];
    jobNo.textColor = [UIColor blackColor];
    jobNo.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:jobNo];
    
    //Takes one of the containers to use as constraints for sizing (container should be sized to phone screen already/ and be the same size)
    UIView *sizeTemplate = [self.view viewWithTag:1];
    
    NSDateFormatter *ISO8601DateFormatter = [[NSDateFormatter alloc] init];
    ISO8601DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    ISO8601DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    ISO8601DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"d MMM, yyyy"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [timeFormatter setLocalizedDateFormatFromTemplate:@"h:mm a"];
    
    int contNm = 1;
    
    if(![selectedData[@"ContactDate"] isEqualToString:@""]) {
        
        UIView *dateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        dateCont.layer.cornerRadius = 10;
        dateCont.layer.masksToBounds = TRUE;
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        dateTitle.text = [NSString stringWithFormat:@"Contact Date"];
        [dateTitle setFont:[UIFont systemFontOfSize:12]];
        dateTitle.textColor = [UIColor blackColor];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        [dateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [dateCont addSubview:dateTitle];
        
        UILabel *dateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, dateCont.frame.size.height - dateTitle.frame.size.height)];
        NSDate *date =  [ISO8601DateFormatter dateFromString:selectedData[@"ContactDate"]];
        dateValue.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        [dateValue setFont:[UIFont systemFontOfSize:20]];
        dateValue.textColor = [UIColor blackColor];
        dateValue.textAlignment = NSTextAlignmentCenter;
        [dateValue setBackgroundColor:[UIColor whiteColor]];
        [dateCont addSubview:dateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:dateCont];
        contNm++;
    }
    
    if(![selectedData[@"ContactTime"] isEqualToString:@""]) {
        
        UIView *dateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        dateCont.layer.cornerRadius = 10;
        dateCont.layer.masksToBounds = TRUE;
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        dateTitle.text = [NSString stringWithFormat:@"Contact Time"];
        [dateTitle setFont:[UIFont systemFontOfSize:12]];
        dateTitle.textColor = [UIColor blackColor];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        [dateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                      green:200/255.0f
                                                       blue:55/255.0f
                                                      alpha:1.0f]];
        [dateCont addSubview:dateTitle];
        
        UILabel *dateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, dateCont.frame.size.height - dateTitle.frame.size.height)];
        NSDate *date =  [ISO8601DateFormatter dateFromString:selectedData[@"ContactTime"]];
        dateValue.text = [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:date]];
        [dateValue setFont:[UIFont systemFontOfSize:20]];
        dateValue.textColor = [UIColor blackColor];
        dateValue.textAlignment = NSTextAlignmentCenter;
        [dateValue setBackgroundColor:[UIColor whiteColor]];
        [dateCont addSubview:dateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:dateCont];
        contNm++;
    }
    
    if(![selectedData[@"Subject"] isEqualToString:@""]) {
        
        UIView *estimateCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        estimateCont.layer.cornerRadius = 10;
        estimateCont.layer.masksToBounds = TRUE;
        UILabel *estimateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        estimateTitle.text = [NSString stringWithFormat:@"Subject"];
        [estimateTitle setFont:[UIFont systemFontOfSize:12]];
        estimateTitle.textColor = [UIColor blackColor];
        estimateTitle.textAlignment = NSTextAlignmentCenter;
        [estimateTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                          green:200/255.0f
                                                           blue:55/255.0f
                                                          alpha:1.0f]];
        [estimateCont addSubview:estimateTitle];
        
        UILabel *estimateValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, estimateCont.frame.size.height - estimateTitle.frame.size.height)];
        estimateValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Subject"]];
        [estimateValue setFont:[UIFont systemFontOfSize:20]];
        estimateValue.textColor = [UIColor blackColor];
        estimateValue.textAlignment = NSTextAlignmentCenter;
        [estimateValue setBackgroundColor:[UIColor whiteColor]];
        [estimateCont addSubview:estimateValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:estimateCont];
        contNm++;
    }
    
    if(![selectedData[@"Activity"] isEqualToString:@""]) {
        
        UIView *extentCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        extentCont.layer.cornerRadius = 10;
        extentCont.layer.masksToBounds = TRUE;
        UILabel *extentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        extentTitle.text = [NSString stringWithFormat:@"Activity"];
        [extentTitle setFont:[UIFont systemFontOfSize:12]];
        extentTitle.textColor = [UIColor blackColor];
        extentTitle.textAlignment = NSTextAlignmentCenter;
        [extentTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                        green:200/255.0f
                                                         blue:55/255.0f
                                                        alpha:1.0f]];
        [extentCont addSubview:extentTitle];
        
        UILabel *extentValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, extentCont.frame.size.height - extentTitle.frame.size.height)];
        extentValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Activity"]];
        [extentValue setFont:[UIFont systemFontOfSize:20]];
        extentValue.textColor = [UIColor blackColor];
        extentValue.textAlignment = NSTextAlignmentCenter;
        [extentValue setBackgroundColor:[UIColor whiteColor]];
        [extentCont addSubview:extentValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:extentCont];
        contNm++;
    }
    
    if(![selectedData[@"JobNo"] isEqualToString:@""]) {
        
        UIView *orderNmCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        orderNmCont.layer.cornerRadius = 10;
        orderNmCont.layer.masksToBounds = TRUE;
        UILabel *orderNmTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        orderNmTitle.text = [NSString stringWithFormat:@"Job No"];
        [orderNmTitle setFont:[UIFont systemFontOfSize:12]];
        orderNmTitle.textColor = [UIColor blackColor];
        orderNmTitle.textAlignment = NSTextAlignmentCenter;
        [orderNmTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [orderNmCont addSubview:orderNmTitle];
        
        UILabel *orderNmValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, orderNmCont.frame.size.height - orderNmTitle.frame.size.height)];
        orderNmValue.text = [NSString stringWithFormat:@"%@", selectedData[@"JobNo"]];
        [orderNmValue setFont:[UIFont systemFontOfSize:20]];
        orderNmValue.textColor = [UIColor blackColor];
        orderNmValue.textAlignment = NSTextAlignmentCenter;
        [orderNmValue setBackgroundColor:[UIColor whiteColor]];
        [orderNmCont addSubview:orderNmValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:orderNmCont];
        contNm++;
    }
    
    if(![selectedData[@"EstimateNo"] isEqualToString:@""]) {
        
        UIView *salesExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        salesExCont.layer.cornerRadius = 10;
        salesExCont.layer.masksToBounds = TRUE;
        UILabel *salesExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        salesExTitle.text = [NSString stringWithFormat:@"Estimate No"];
        [salesExTitle setFont:[UIFont systemFontOfSize:12]];
        salesExTitle.textColor = [UIColor blackColor];
        salesExTitle.textAlignment = NSTextAlignmentCenter;
        [salesExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [salesExCont addSubview:salesExTitle];
        
        UILabel *salesExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, salesExCont.frame.size.height - salesExTitle.frame.size.height)];
        salesExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"EstimateNo"]];
        [salesExValue setFont:[UIFont systemFontOfSize:20]];
        salesExValue.textColor = [UIColor blackColor];
        salesExValue.textAlignment = NSTextAlignmentCenter;
        [salesExValue setBackgroundColor:[UIColor whiteColor]];
        [salesExCont addSubview:salesExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:salesExCont];
        contNm++;
    }
    
    if(![selectedData[@"Campaign"] isEqualToString:@""]) {
        
        UIView *accountExCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        accountExCont.layer.cornerRadius = 10;
        accountExCont.layer.masksToBounds = TRUE;
        UILabel *accountExTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        accountExTitle.text = [NSString stringWithFormat:@"Campaign"];
        [accountExTitle setFont:[UIFont systemFontOfSize:12]];
        accountExTitle.textColor = [UIColor blackColor];
        accountExTitle.textAlignment = NSTextAlignmentCenter;
        [accountExTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                           green:200/255.0f
                                                            blue:55/255.0f
                                                           alpha:1.0f]];
        [accountExCont addSubview:accountExTitle];
        
        UILabel *accountExValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, accountExCont.frame.size.height - accountExTitle.frame.size.height)];
        accountExValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Campaign"]];
        [accountExValue setFont:[UIFont systemFontOfSize:20]];
        accountExValue.textColor = [UIColor blackColor];
        accountExValue.textAlignment = NSTextAlignmentCenter;
        [accountExValue setBackgroundColor:[UIColor whiteColor]];
        [accountExCont addSubview:accountExValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:accountExCont];
        contNm++;
    }
    
    NSString *assignTo = [NSString stringWithFormat:@"%@",selectedData[@"AssignTo"]];
    if(!([assignTo isEqualToString:@"<null>"] || [assignTo isEqualToString:@""])) {
        
        UIView *sellingCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sellingCont.layer.cornerRadius = 10;
        sellingCont.layer.masksToBounds = TRUE;
        UILabel *sellingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sellingTitle.text = [NSString stringWithFormat:@"Assign To"];
        [sellingTitle setFont:[UIFont systemFontOfSize:12]];
        sellingTitle.textColor = [UIColor blackColor];
        sellingTitle.textAlignment = NSTextAlignmentCenter;
        [sellingTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [sellingCont addSubview:sellingTitle];
        
        UILabel *sellingValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sellingCont.frame.size.height - sellingTitle.frame.size.height)];
        sellingValue.text = [NSString stringWithFormat:@"%@", selectedData[@"AssignTo"]];
        [sellingValue setFont:[UIFont systemFontOfSize:20]];
        sellingValue.textColor = [UIColor blackColor];
        sellingValue.textAlignment = NSTextAlignmentCenter;
        [sellingValue setBackgroundColor:[UIColor whiteColor]];
        [sellingCont addSubview:sellingValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sellingCont];
        contNm++;
    }
    
    NSString *notify = [NSString stringWithFormat:@"%@",selectedData[@"Notify"]];
    if(!([notify isEqualToString:@"<null>"] || [notify isEqualToString:@""])) {
        
        UIView *sellingCont = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, sizeTemplate.frame.size.height)];
        sellingCont.layer.cornerRadius = 10;
        sellingCont.layer.masksToBounds = TRUE;
        UILabel *sellingTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizeTemplate.frame.size.width, 15)];
        sellingTitle.text = [NSString stringWithFormat:@"Notify"];
        [sellingTitle setFont:[UIFont systemFontOfSize:12]];
        sellingTitle.textColor = [UIColor blackColor];
        sellingTitle.textAlignment = NSTextAlignmentCenter;
        [sellingTitle setBackgroundColor:[UIColor colorWithRed:172/255.0f
                                                         green:200/255.0f
                                                          blue:55/255.0f
                                                         alpha:1.0f]];
        [sellingCont addSubview:sellingTitle];
        
        UILabel *sellingValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, sizeTemplate.frame.size.width, sellingCont.frame.size.height - sellingTitle.frame.size.height)];
        sellingValue.text = [NSString stringWithFormat:@"%@", selectedData[@"Notify"]];
        [sellingValue setFont:[UIFont systemFontOfSize:20]];
        sellingValue.textColor = [UIColor blackColor];
        sellingValue.textAlignment = NSTextAlignmentCenter;
        [sellingValue setBackgroundColor:[UIColor whiteColor]];
        [sellingCont addSubview:sellingValue];
        
        UIView *cont = [self.view viewWithTag:contNm];
        [cont addSubview:sellingCont];
        contNm++;
    }
    
    contNm--;
    int count = contNm / 2;
    NSLog(@"%d",count);
    if(contNm % 2 == 1) {
        count++;
    }
    mainDetailCont.contentSize = CGSizeMake(mainDetailCont.frame.size.width, 90*count -10);
}

-(void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
        case UIDeviceOrientationLandscapeRight:
            [Hud removeFromSuperview];
            [self viewDidLoad];
            break;
            
        default:
            break;
    };
}

-(void)showLoading
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = NSLocalizedString(@"Loading", nil);
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    Hud.customView = activityImageView;
}

-(void)popViewControllerWithAnimation{
    //    NSLog(@"Back");
    //
    //    [Hud removeFromSuperview];
    //
    //    SWRevealViewController *homeControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    //
    //    [self.navigationController popViewControllerAnimated:homeControl];
    //have to re-load every page because of the oritation
    [self showLoading];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CRM"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}

@end
