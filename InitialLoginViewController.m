//
//  InitialLoginViewController.m
//  Imprint
//
//  Created by Geoff Baker on 19/09/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import "InitialLoginViewController.h"
//#import <Parse/Parse.h>
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "Flurry.h"

#import "SWRevealViewController.h"
#import "ImprintDatabase.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "Reachability.h"
#import "MBProgressHUD.h"

@interface InitialLoginViewController ()

@end

@implementation InitialLoginViewController{
    //Deside the orientation of the device
    UIDeviceOrientation Orientation;
    
    UIView *mainView;
    UIView *buttonView;
    UIScrollView *theScrollView;
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    UIAlertController *alert;                                    //--changed UIAlertView to UIAlertController
    UIAlertAction *defaultAction;
    NSString *emailString;
    NSString *passwordString;
    
    // Loading Animation
    MBProgressHUD *Hud;
    UIImageView *activityImageView;
    UIActivityIndicatorView *activityView;
}

-(void)showLoading
{
    Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.labelText = NSLocalizedString(@"Loading", nil);
    //Start the animation
    [activityImageView startAnimating];
    
    
    //Add your custom activity indicator to your current view
    [mainView addSubview:activityImageView];
    Hud.customView = activityImageView;
}

- (void)viewDidLoad {
    
    [Flurry logEvent:@"User Opened Login Page" timed:YES];
    
    //Log out from all accounts and delete cookies.
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
    
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
    
    
    
    
    
    
    //    [FBSDKAccessToken setCurrentAccessToken:nil];
    //    [[FBSDKLoginManager new] logOut];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"userId"];
    //    [[PFInstallation currentInstallation] saveInBackground];
    //    [PFUser logOut];
    theScrollView = [[UIScrollView alloc] init];
    theScrollView.bounces = NO;
    theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height); //Position of the button
    theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    //    //Reachability (Checking Internet Connection)
    //    //Delete local notifications
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"user"];
    //    [[PFInstallation currentInstallation] removeObjectForKey:@"userId"];
    //    [[PFInstallation currentInstallation] saveInBackground];
    //    [PFUser logOut];
    [_sidebarButton setEnabled:NO];
    self.navigationController.navigationBarHidden = YES;
    
    //    UIImageView *bg = [[UIImageView alloc] init];
    //    bg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 100);
    //    bg.image = [UIImage imageNamed:@"proBG-01"];
    //    bg.contentMode = UIViewContentModeScaleAspectFill;
    //    [theScrollView addSubview:bg];
    //
    
    
    mainView = [[UIView alloc] init];
    mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:mainView];
    
    //Background Image
    UIImageView *background = [[UIImageView alloc] init];
    background.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        background.image = [UIImage imageNamed:@"bg-splash_ipad"];
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        background.image = [UIImage imageNamed:@"bg-splash_ipad"];
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        background.image = [UIImage imageNamed:@"bg-splash_ipad"];
    } else {
        background.image = [UIImage imageNamed:@"bg-splash_ipad"];
    }
    [mainView addSubview:background];
    
    
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
    
    //Load Inital View
    if(Orientation == UIDeviceOrientationPortrait){
        [self loadMain];
    }else if(Orientation == UIDeviceOrientationLandscapeLeft || Orientation ==  UIDeviceOrientationLandscapeRight){
        [self loadMainHorizontal];
        
    } else {
        [self loadMain];
    }
    
    //reset user detail
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
}



-(void)loadMainHorizontal{
    //Logo
    UIImageView *logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake((self.view.frame.size.width/2) - 140, 45, 280, 90);
    logo.image = [UIImage imageNamed:@"logo-splash_ipad"];
    [mainView addSubview:logo];
    
    //Email
    UIColor *color = [UIColor whiteColor];
    email = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.width == 480) //iPhone 4S size
    {
        email.frame = CGRectMake(40, 245, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 568) //iPhone 5 size
    {
        email.frame = CGRectMake(40, 265, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 667) //iPhone 6 size
    {
        email.frame = CGRectMake(50, 135, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 736) //iPhone 6+ size
    {
        email.frame = CGRectMake(70, 355, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.width == 812) //iPhone X size
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        email.frame = CGRectMake(50, 150, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33);
    } else {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    email.textAlignment = NSTextAlignmentLeft;
    email.textColor = [UIColor blackColor];
    email.backgroundColor = [UIColor clearColor];
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, email.frame.size.height - borderWidthEmail, email.frame.size.width, email.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [email.layer addSublayer:borderEmail];
    email.layer.masksToBounds = YES;
    email.placeholder = @"Username...";
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    email.returnKeyType = UIReturnKeyDone;
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.keyboardType = UIKeyboardAppearanceDark;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.clipsToBounds = YES;
    email.returnKeyType = UIReturnKeyDone;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    [email setDelegate:self];
    email.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [mainView addSubview:email];
    
    
    //Password
    
    password = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.width == 480) //iPhone 4S size
    {
        password.frame = CGRectMake(40, 280, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 568) //iPhone 5 size
    {
        password.frame = CGRectMake(40, 300, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 667) //iPhone 6 size
    {
        password.frame = CGRectMake(50, 180, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 736) //iPhone 6+ size
    {
        password.frame = CGRectMake(70, 400, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.width == 812) //iPhone X size
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        password.frame = CGRectMake(50, 190, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33);
    } else {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    password.textAlignment = NSTextAlignmentLeft;
    password.textColor = [UIColor blackColor];
    password.backgroundColor = [UIColor clearColor];
    CALayer *borderPassword = [CALayer layer];
    CGFloat borderWidthPassword = 1;
    borderPassword.borderColor = [UIColor darkGrayColor].CGColor;
    borderPassword.frame = CGRectMake(0, password.frame.size.height - borderWidthPassword, password.frame.size.width, password.frame.size.height);
    borderPassword.borderWidth = borderWidthPassword;
    [password.layer addSublayer:borderPassword];
    password.layer.masksToBounds = YES;
    password.placeholder = @"Password...";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.returnKeyType = UIReturnKeyDone;
    password.keyboardType = UIKeyboardAppearanceDark;
    password.clipsToBounds = YES;
    password.secureTextEntry = YES;
    [password setDelegate:self];
    [password addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    password.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [mainView addSubview:password];
    
    buttonView = [[UIView alloc] init];
    buttonView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    [mainView addSubview:buttonView];
    
    
    if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        UIImageView *cube = [[UIImageView alloc] init];
        cube.frame = CGRectMake(325, 250, self.view.frame.size.width-650, self.view.frame.size.width-650);
        cube.image = [UIImage imageNamed:@"rubix-cube_ipad"];
        [mainView addSubview:cube];
        
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        
    }else{
        
    }
    
    //Login Buttons
    UIButton *loginBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.width == 568) //iPhone 5 size
    {
        loginBtn.frame = CGRectMake(40, 30, self.view.frame.size.width - 80, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 667) //iPhone 6 size
    {
        loginBtn.frame = CGRectMake(200, 100, self.view.frame.size.width - 400, 45);
    }
    else if ([[UIScreen mainScreen] bounds].size.width == 736) //iPhone 6+ size
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else if ([[UIScreen mainScreen] bounds].size.width == 812) //iPhone X size
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }else if([[UIScreen mainScreen] bounds].size.width == 1024)  //ipad Air/Mini
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }else if([[UIScreen mainScreen] bounds].size.width == 1112)  //ipad pro 10.5
    {
        loginBtn.frame = CGRectMake(300, 80, self.view.frame.size.width - 600, 65);
    }else if([[UIScreen mainScreen] bounds].size.width == 1366)  //ipad pro 12.9
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }
    //    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"Bebas Neue" size:20];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_ipad"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tappedLogin) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:loginBtn];
    
    //    UIButton *registerBtn = [[UIButton alloc]init];
    //    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    //    {
    //        registerBtn.frame = CGRectMake(40, 90, self.view.frame.size.width - 80, 40);
    //    }
    //    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    //    {
    //        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
    //    }
    //    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    //    {
    //        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
    //    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    //    {
    //        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
    //    }
    //    //    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
    //    registerBtn.titleLabel.font = [UIFont fontWithName:@"Bebas Neue" size:20];
    //    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_register"] forState:UIControlStateNormal];
    //    [registerBtn addTarget:self action:@selector(tappedRegister) forControlEvents:UIControlEventTouchUpInside];
    //    [buttonView addSubview:registerBtn];
    
    [UIView animateWithDuration:0.5f animations:^{
        buttonView.frame = CGRectMake(0, self.view.frame.size.height - 185, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            buttonView.frame = CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180);
        }];
    }];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self autoLogin];
}



-(void)loadMain {
    //Logo
    UIImageView *logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake((self.view.frame.size.width/2) - 140, 85, 280, 90);
    logo.image = [UIImage imageNamed:@"logo"];
    [mainView addSubview:logo];
    
    //Email
    UIColor *color = [UIColor whiteColor];
    email = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        email.frame = CGRectMake(40, 245, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        email.frame = CGRectMake(40, 265, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        email.frame = CGRectMake(70, 355, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33);
    }else {
        email.frame = CGRectMake(50, 315, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    email.textAlignment = NSTextAlignmentLeft;
    email.textColor = [UIColor blackColor];
    email.backgroundColor = [UIColor clearColor];
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidthEmail = 1;
    borderEmail.borderColor = [UIColor darkGrayColor].CGColor;
    borderEmail.frame = CGRectMake(0, email.frame.size.height - borderWidthEmail, email.frame.size.width, email.frame.size.height);
    borderEmail.borderWidth = borderWidthEmail;
    [email.layer addSublayer:borderEmail];
    email.layer.masksToBounds = YES;
    email.placeholder = @"Username...";
    email.clearButtonMode = UITextFieldViewModeWhileEditing;
    email.returnKeyType = UIReturnKeyDone;
    email.autocorrectionType = UITextAutocorrectionTypeNo;
    email.keyboardType = UIKeyboardAppearanceDark;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.clipsToBounds = YES;
    email.returnKeyType = UIReturnKeyDone;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    [email setDelegate:self];
    email.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [mainView addSubview:email];
    
    
    //Password
    
    password = [ [UITextField alloc ] init];
    if ([[UIScreen mainScreen] bounds].size.height == 480) //iPhone 4S size
    {
        password.frame = CGRectMake(40, 280, self.view.frame.size.width-80, 25); //Position of the Textfield
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        password.frame = CGRectMake(40, 300, self.view.frame.size.width-80, 28); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        password.frame = CGRectMake(70, 400, self.view.frame.size.width-140, 36); //Position of the Textfield
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33);
    } else {
        password.frame = CGRectMake(50, 350, self.view.frame.size.width-100, 33); //Position of the Textfield
    }
    password.textAlignment = NSTextAlignmentLeft;
    password.textColor = [UIColor blackColor];
    password.backgroundColor = [UIColor clearColor];
    CALayer *borderPassword = [CALayer layer];
    CGFloat borderWidthPassword = 1;
    borderPassword.borderColor = [UIColor darkGrayColor].CGColor;
    borderPassword.frame = CGRectMake(0, password.frame.size.height - borderWidthPassword, password.frame.size.width, password.frame.size.height);
    borderPassword.borderWidth = borderWidthPassword;
    [password.layer addSublayer:borderPassword];
    password.layer.masksToBounds = YES;
    password.placeholder = @"Password...";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.returnKeyType = UIReturnKeyDone;
    password.keyboardType = UIKeyboardAppearanceDark;
    password.clipsToBounds = YES;
    password.secureTextEntry = YES;
    [password setDelegate:self];
    [password addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEnd];
    password.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    [mainView addSubview:password];
    
    buttonView = [[UIView alloc] init];
    buttonView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    [mainView addSubview:buttonView];
    
    
    //Login Buttons
    UIButton *loginBtn = [[UIButton alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
    {
        loginBtn.frame = CGRectMake(40, 30, self.view.frame.size.width - 80, 40);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
    {
        loginBtn.frame = CGRectMake(50, 30, self.view.frame.size.width - 100, 45);
    }else if([[UIScreen mainScreen] bounds].size.height == 1024)  //ipad Air/Mini
    {
        loginBtn.frame = CGRectMake(250, 30, self.view.frame.size.width - 500, 45);
    }else if([[UIScreen mainScreen] bounds].size.height == 1112)  //ipad pro 10.5
    {
        loginBtn.frame = CGRectMake(250, 30, self.view.frame.size.width - 500, 45);
    }else if([[UIScreen mainScreen] bounds].size.height == 1366)  //ipad pro 12.9
    {
        loginBtn.frame = CGRectMake(250, 30, self.view.frame.size.width - 500, 45);
    } else {
        loginBtn.frame = CGRectMake(250, 30, self.view.frame.size.width - 500, 45);
    }
    //    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"Bebas Neue" size:20];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tappedLogin) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:loginBtn];
    
//    UIButton *registerBtn = [[UIButton alloc]init];
//    if ([[UIScreen mainScreen] bounds].size.height == 568) //iPhone 5 size
//    {
//        registerBtn.frame = CGRectMake(40, 90, self.view.frame.size.width - 80, 40);
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 667) //iPhone 6 size
//    {
//        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
//    }
//    else if ([[UIScreen mainScreen] bounds].size.height == 736) //iPhone 6+ size
//    {
//        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
//    } else if ([[UIScreen mainScreen] bounds].size.height == 812) //iPhone X size
//    {
//        registerBtn.frame = CGRectMake(50, 90, self.view.frame.size.width - 100, 45);
//    }
//    //    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
//    registerBtn.titleLabel.font = [UIFont fontWithName:@"Bebas Neue" size:20];
//    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_register"] forState:UIControlStateNormal];
//    [registerBtn addTarget:self action:@selector(tappedRegister) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:registerBtn];
    
    [UIView animateWithDuration:0.5f animations:^{
        buttonView.frame = CGRectMake(0, self.view.frame.size.height - 185, self.view.frame.size.width, 180);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            buttonView.frame = CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180);
        }];
    }];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self autoLogin];
}

-(void)autoLogin {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
    
    NSString *keyChainStr = [NSString stringWithFormat:@"%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]];
    
    if([keyChainStr isEqualToString:@""]) {
        
    } else {
        email.text = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
        
        //because label uses NSString and password is NSData object, conversion necessary
        NSData *pwdData = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        NSString *passwordStr = [[NSString alloc] initWithData:pwdData encoding:NSUTF8StringEncoding];
        password.text = passwordStr;
        
        [self CheckDetails];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [password resignFirstResponder];
    if([email isFirstResponder]) {
        [email resignFirstResponder];
        [password becomeFirstResponder];
    } else {
        //[self tappedLogin];
    }
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [email resignFirstResponder];
    [password resignFirstResponder];
}

-(void)tappedLogin {
    BOOL wrongEmail = [self validateEmail:email.text];
     
//     Checks if all fields have been completed
     if ([email.text isEqualToString:@""]) {
     [self alertEmptyFields];
     }else {
     
//     if (wrongEmail == false) {  //Checks if the emails don't match
//     [self alertWrongEmail];
//     }
     
//     if ([password.text isEqualToString: @""]) {
//     [self alertEmptyFields];
//     } else{
//     emailString = email.text;
//     passwordString = password.text;
//
//     emailString = [emailString lowercaseString];
//     email.text = emailString;
//
//     [self CheckDetails];
//     }
     }
    
    [self CheckDetails];
}

-(void)tappedRegister {
    /*BOOL wrongEmail = [self validateEmail:email.text];
    
    //Checks if all fields have been completed
    if ([email.text isEqualToString:@""] || [password.text isEqualToString:@""]) {
        [self alertEmptyFields];
    }else {
        
        if (wrongEmail == false) { // Checks if the emails don't match
            [self alertWrongEmail];
        } else {
            if ([password.text isEqualToString: @""]) {
                [self alertEmptyFields];
            } else{
                emailString = email.text;
                passwordString = password.text;
                
                emailString = [emailString lowercaseString];
                email.text = emailString;
                
                //                [self completeRegister];
            }
        }
    }*/
}


-(void)CheckDetails{
    [self showLoading];
    ImprintDatabase *data = [[ImprintDatabase alloc]init];
    [data getUserDetailsList:nil completion:^(NSDictionary *userList, NSError *error) {
        if(!error) {
            NSLog(@"-------%@", userList);
            bool isUserExist = false;
            bool isUserDetailMatch = false;
            NSDictionary *currentUser;
            for (NSDictionary *userDetail in userList) {
                if([userDetail[@"UserID"] isEqualToString:email.text]){
                    isUserExist = true;
                if([userDetail[@"UserID"] isEqualToString:email.text] && [userDetail[@"Password"] isEqualToString:password.text]) {
                    isUserDetailMatch = true;
                    currentUser = userDetail;
                    break;
                }
                }
            }
            
            if(isUserExist){
                
            if(isUserDetailMatch) {
                NSLog(@"Logged In!");
                [Flurry logEvent:@"User logged in" timed:YES];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:currentUser[@"UserID"] forKey:@"userEmail"];
                [defaults setObject:currentUser[@"Password"] forKey:@"userPassword"];
                
                //because keychain saves password as NSData object
                NSData *pwdData = [passwordString dataUsingEncoding:NSUTF8StringEncoding];
                KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"Imprint Login" accessGroup:nil];
                [keychainItem setObject:pwdData forKey:(__bridge id)(kSecValueData)];
                [keychainItem setObject:emailString forKey:(__bridge id)(kSecAttrAccount)];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationController.navigationBar.alpha = 1;
                    self.navigationController.navigationBar.hidden = NO;
                    
                    SWRevealViewController *offersControl = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"Home"];
                    [self.navigationController pushViewController:offersControl animated:NO];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertInvalidCredential];
                });
            }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertUserDoesNotExist];
                });
            }
            
        } else {
            NSLog(@"------- Error: %@",[error description]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Hud removeFromSuperview];
        });
    }];
    
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.hidden = NO;
    
    
}






-(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

//Handles the alerts on empty fields
- (void) alertEmptyFields{
    
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Username must be completed!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//Handles missmatched email fields
- (void) alertWrongEmail{
    
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Not a valid email!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) alertUserLoginSuccessfull{
    alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"The user: %@ has been added to the database!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void) alertInvalidCredential{
    
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Not a valid password!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) alertUserDoesNotExist{
    
    alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"The Username does not Exist!" preferredStyle:UIAlertControllerStyleAlert];
    defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            [self viewDidLoad];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [self viewDidLoad];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self viewDidLoad];
            break;
            
        default:
            break;
    };
}

@end
