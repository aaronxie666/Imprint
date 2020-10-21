//
//  BusinessIntelligenceViewController.m
//  Imprint
//
//  Created by Geoff Baker on 27/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "BusinessIntelligenceViewController.h"
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

@interface BusinessIntelligenceViewController ()
//Reachability
//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;
@end

@implementation BusinessIntelligenceViewController{
    //Decide the orientation of the device
    UIDeviceOrientation Orientation;
    UIView *tmpView;
    UIView *popUpView;
    UIImageView *profilePicture;
    UIImage *selectedProfileImage;
    UIScrollView *sideScroller;
    UIScrollView *pageScroller;
    NSUserDefaults *defaults;
    UIButton *findParksButton;
    //    CLLocationManager *locationManager;
    int iteration;
    bool refreshView;
    bool userIsOnOverlay;
    bool libraryPicked;
    bool viewHasFinishedLoading;
    bool isFindingNearestParkOn;
    int distanceMovedScroll;
    
    
    IBOutlet UITextField *userTextField;
    
    //Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
    
    UIImageView *activePageView;
    
    //PFObjects
    //    PFObject *selectedMatchObject;
    //    PFObject *selectedOpponent;
    //    PFObject *achievementsObject;
    //    NSMutableArray *locationsObj;
    
    //AnimationImage
    UIImageView *glowImageView;
    
    //NEW
    NSString *URLString;
    UIButton *dailyReward;
    
    int videoCount;
    
    //Graph
    int firstVotes;
    int secondVotes;
    int thirdVotes;
    int forthVotes;
    int fifthVotes;
    
    int x;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    userIsOnOverlay = NO;
    viewHasFinishedLoading = NO;
    // Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    //Decide the Orientation of the device
    Orientation = [[UIDevice currentDevice] orientation];
    
    
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
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
//    [backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
//    [backButton setShowsTouchWhenHighlighted:TRUE];
//    [backButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.hidesBackButton = TRUE;
//    self.navigationItem.leftBarButtonItem = barBackItem;
    
    
    
    
    //    BackgroundImage
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [background setBackgroundColor:[UIColor whiteColor]];
    background.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:background];
    //
    [self loadParseContent];
}


-(void)loadParseContent{
    // Create the UI Scroll View
    
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = @"Loading";
    
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
    
    
    //Add your custom activity indicator to your current view
    [self.view addSubview:activityImageView];
    
    // Add stuff to view here
    Hud.customView = activityImageView;
    
    
    if(!true){
        [self showLoginView];
    }else{
        if(Orientation == UIDeviceOrientationPortrait){
            [self loadUser];
        }else if(Orientation == UIDeviceOrientationLandscapeLeft || Orientation ==  UIDeviceOrientationLandscapeRight){
            [self loadUserHorizontal];
        }
        else {
            [self loadUser];
        }
        [Hud removeFromSuperview];
    }
    
}


-(void)showLoginView{
    SWRevealViewController *LoginControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"InitialLogin"];
    
    [self.navigationController pushViewController:LoginControl animated:NO];
}

-(void)checkForLoginDate{
    [self loadUser];
}



-(void)loadUserHorizontal{
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        header.frame = CGRectMake(0, 70, self.view.frame.size.width, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }else {
        header.frame = CGRectMake(0, 30, self.view.frame.size.width, 60);
    }
    [header setBackgroundColor:[UIColor colorWithRed:192/255.0f
                                               green:29/255.0f
                                                blue:74/255.0f
                                               alpha:1.0f]];
    [self.view addSubview:header];
    
    UIImageView *headImg = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        headImg.frame = CGRectMake(220, 5, 70, 70);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        headImg.frame = CGRectMake(120, 5, 50, 50);
    } else {
        headImg.frame = CGRectMake(70, 5, 50, 50);
    }
    headImg.image = [UIImage imageNamed:@"brand-logo"];
    [header addSubview:headImg];
    
    
    UILabel *LtdLable = [[UILabel alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        LtdLable.frame = CGRectMake(350, 20, self.view.frame.size.width-350, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    } else {
        LtdLable.frame = CGRectMake(200, 5, 300, 50);
    }
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    LtdLable.textAlignment = NSTextAlignmentLeft;
    [LtdLable setFont:[UIFont boldSystemFontOfSize:16]];
    LtdLable.lineBreakMode = NSLineBreakByWordWrapping;
    LtdLable.numberOfLines = 1;
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
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        userLable.frame = CGRectMake(700, 20, self.view.frame.size.width, 50);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    } else {
        userLable.frame = CGRectMake(300, 30, self.view.frame.size.width, 50);
    }
    userLable.text = [NSString stringWithFormat:@"Welcome %@", [defaults stringForKey:@"userEmail"]];
    [userLable setFont:[UIFont boldSystemFontOfSize:16]];
    userLable.textColor = [UIColor whiteColor];
    userLable.textAlignment = NSTextAlignmentLeft;
    [header addSubview:userLable];
    
    UIImageView *BILable = [[UIImageView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        BILable.frame = CGRectMake(300, 200, self.view.frame.size.width-600, 30);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    } else {
        BILable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    }
    BILable.image = [UIImage imageNamed:@"title_business-intel"];
    [self.view addSubview:BILable];
    
    
    UIScrollView *mainPart = [[UIScrollView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        mainPart.frame = CGRectMake(0, 330, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    } else {
        mainPart.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }
    mainPart.bounces = NO;
    [mainPart setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:mainPart];
    
    
    
    
    
    
    
    UIButton *top10customersBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 150);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    } else {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 80);
    }
    [top10customersBtn setBackgroundImage:[UIImage imageNamed:@"btn_top-10_ipad"] forState:UIControlStateNormal];
    [top10customersBtn addTarget:self action:@selector(tapTop10CustomersBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:top10customersBtn];
    
    
    UIButton *saleForecastBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        saleForecastBtn.frame = CGRectMake(0, 130, self.view.frame.size.width/2,130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    } else {
        saleForecastBtn.frame = CGRectMake(0, 80, self.view.frame.size.width/2, 80);
    }
    [saleForecastBtn setBackgroundImage:[UIImage imageNamed:@"invoicesCostsByCustomer"] forState:UIControlStateNormal];
    [saleForecastBtn addTarget:self action:@selector(tapInvoicesCostByCustomerBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:saleForecastBtn];
    
    
    UIButton *costbyjobBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        costbyjobBtn.frame = CGRectMake(0, 260, self.view.frame.size.width/2, 130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    } else {
        costbyjobBtn.frame = CGRectMake(0, 160, self.view.frame.size.width/2, 80);
    }
    [costbyjobBtn setBackgroundImage:[UIImage imageNamed:@"WIPCustomerTotals"] forState:UIControlStateNormal];
    [costbyjobBtn addTarget:self action:@selector(tapWIPCustomerTotalsBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:costbyjobBtn];
    
    
    UIButton *businessIntel = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    } else {
        businessIntel.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 80);
    }
    [businessIntel setBackgroundImage:[UIImage imageNamed:@"business-intel"] forState:UIControlStateNormal];
    [businessIntel addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel];
    
    
    UIButton *businessIntel2 = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 130, self.view.frame.size.width/2, 130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    } else {
        businessIntel2.frame = CGRectMake(self.view.frame.size.width/2, 80, self.view.frame.size.width/2, 80);
    }
    [businessIntel2 setBackgroundImage:[UIImage imageNamed:@"business-intel_2"] forState:UIControlStateNormal];
    [businessIntel2 addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel2];
    
    
    
    
    UIButton *businessIntel3 = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 4S size
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 320) //iPhone 5 size
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone 6 size
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 414) //iPhone 6+ size
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    } else if ([[UIScreen mainScreen] bounds].size.height == 375) //iPhone X size
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 260, self.view.frame.size.width/2, 130);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    } else {
        businessIntel3.frame = CGRectMake(self.view.frame.size.width/2, 160, self.view.frame.size.width/2, 80);
    }
    [businessIntel3 setBackgroundImage:[UIImage imageNamed:@"business-intel_3"] forState:UIControlStateNormal];
    [businessIntel3 addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel3];
    
    //    [Hud removeFromSuperview];
    
    
    
    
    
    
    
}


-(void)loadUser{
    
    //Profile Group View
    UIView *header = [[UIView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        header.frame = CGRectMake(0, 60, self.view.frame.size.width, 80);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
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
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        headImg.frame = CGRectMake(70, 20, 50, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        headImg.frame = CGRectMake(100, 20, 50, 50);
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
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        LtdLable.frame = CGRectMake(140, 10, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        LtdLable.frame = CGRectMake(170, 10, self.view.frame.size.width, 50);
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
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        userLable.frame = CGRectMake(140, 30, self.view.frame.size.width, 50);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        userLable.frame = CGRectMake(170, 30, self.view.frame.size.width, 50);
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
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 30);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        BILable.frame = CGRectMake(0, 150, self.view.frame.size.width, 30);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 30);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 30);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        BILable.frame = CGRectMake(200, 190, self.view.frame.size.width-400, 25);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 30);
    } else {
        BILable.frame = CGRectMake(0, 170, self.view.frame.size.width, 30);
    }
    BILable.image = [UIImage imageNamed:@"title_business-intel"];
    [self.view addSubview:BILable];
    
    UIScrollView *mainPart = [[UIScrollView alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        mainPart.frame = CGRectMake(10, 250, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    } else {
        mainPart.frame = CGRectMake(10, 190, self.view.frame.size.width, self.view.frame.size.height);
        mainPart.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+280);
    }
    mainPart.bounces = NO;
    [mainPart setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:mainPart];
    
    
    
    
    
    
    
    UIButton *top10customersBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    } else {
        top10customersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 90);
    }
    [top10customersBtn setBackgroundImage:[UIImage imageNamed:@"top-10"] forState:UIControlStateNormal];
    [top10customersBtn addTarget:self action:@selector(tapTop10CustomersBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:top10customersBtn];

    
    UIButton *saleForecastBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        saleForecastBtn.frame = CGRectMake(0, 180, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    } else {
        saleForecastBtn.frame = CGRectMake(0, 100, self.view.frame.size.width-20, 90);
    }
    [saleForecastBtn setBackgroundImage:[UIImage imageNamed:@"invoicesCostsByCustomer"] forState:UIControlStateNormal];
    [saleForecastBtn addTarget:self action:@selector(tapInvoicesCostByCustomerBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:saleForecastBtn];


    UIButton *costbyjobBtn = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        costbyjobBtn.frame = CGRectMake(0, 360, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    } else {
        costbyjobBtn.frame = CGRectMake(0, 200, self.view.frame.size.width-20, 90);
    }
    [costbyjobBtn setBackgroundImage:[UIImage imageNamed:@"WIPCustomerTotals"] forState:UIControlStateNormal];
    [costbyjobBtn addTarget:self action:@selector(tapWIPCustomerTotalsBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:costbyjobBtn];


    UIButton *businessIntel = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        businessIntel.frame = CGRectMake(0, 540, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    } else {
        businessIntel.frame = CGRectMake(0, 300, self.view.frame.size.width-20, 90);
    }
    [businessIntel setBackgroundImage:[UIImage imageNamed:@"business-intel"] forState:UIControlStateNormal];
    [businessIntel addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel];
    
    
    UIButton *businessIntel2 = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        businessIntel2.frame = CGRectMake(0, 720, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    } else {
        businessIntel2.frame = CGRectMake(0, 400, self.view.frame.size.width-20, 90);
    }
    [businessIntel2 setBackgroundImage:[UIImage imageNamed:@"business-intel_2"] forState:UIControlStateNormal];
    [businessIntel2 addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel2];
    
    
    
    
    UIButton *businessIntel3 = [[UIButton alloc] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        businessIntel3.frame = CGRectMake(0, 900, self.view.frame.size.width-20, 180);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    } else {
        businessIntel3.frame = CGRectMake(0, 500, self.view.frame.size.width-20, 90);
    }
    [businessIntel3 setBackgroundImage:[UIImage imageNamed:@"business-intel_3"] forState:UIControlStateNormal];
    [businessIntel3 addTarget:self action:@selector(tapMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainPart addSubview:businessIntel3];
    
    //    [Hud removeFromSuperview];
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


-(void) tapInvoicesCostByCustomerBtn{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"InvoicesAndCostsByCustomer"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}


-(void)tapTop10CustomersBtn{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Top10Customers"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
    
}


-(void)tapWIPCustomerTotalsBtn{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WIPCustomerTotals"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
}

-(void)tapMoreBtn{
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController pushViewController:vc animated:NO];
    [Hud removeFromSuperview];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
