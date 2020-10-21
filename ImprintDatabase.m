//
//  LWDatabase.m
//  LittleWickets
//
//  Created by Geoff Baker on 27/04/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ImprintDatabase:NSObject
{
    NSString *ImprintID;
    NSString *ImprintSecret;
}
//@property(nonatomic, readwrite) NSData *data; // Property

@end

@implementation ImprintDatabase

//@synthesize data;


-(id)init
{
    self = [super init];
    ImprintID = @"WBun2S88Pb2edjd1jpBUosKL5+sAb+5D4tx5ua2rdcU=";
    ImprintSecret = @"/6r292chpZ2UAMKmbs7CWaGLMGZ8ke3Wa6QmGfwj4BA=";
    return self;
}

//NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//NSLog(@"-- %@", strData);

/*-(void) getToken:(int)parameter completion:(void (^)(NSString *token,NSError *error))completionHandler{
    NSString *urlString = @"https://user-api.simplybook.me/login";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *data = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"method\":\"getToken\",\"params\" :[\"%@\",\"%@\"],\"id\":1}", loginName, apiKey];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            token = results[@"result"];
            completionHandler(results[@"result"], error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}*/

/*-(void) getClientInfoByLoginPassword:(NSString*)email: (NSString*)password completion:(void (^)(NSDictionary *clientInfo,NSError *error))completionHandler{
    NSString *urlString = @"https://user-api.simplybook.me";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:@"littlewickets" forHTTPHeaderField:@"X-Company-Login"];
    [request addValue:token forHTTPHeaderField:@"X-Token"];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *data = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"method\":\"getClientInfoByLoginPassword\",\"params\" :[\"%@\",\"%@\"],\"id\":1}", email, password];
    //NSLog(@"-- %@", data);
    
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *clientInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(clientInfo[@"result"], error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}*/

-(void) getUserDetailsList:(int)parameter completion:(void (^)(NSDictionary *userList,NSError *error))completionHandler{
    NSString *urlString = @"http://mail.imprint-mis.co.uk:9092/API_deploy/api/UserDetail/UserDetailsList";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *userList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(userList[@"Users"], error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getTopCustomerInvoices:(int)count: (int)year completion:(void (^)(NSDictionary *topCustomerInvoices,NSError *error))completionHandler{
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Reporting/Invoicing/TopCustomerInvoices?count=%d&year=%d", count, year];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *topCustomerInvoices = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(topCustomerInvoices, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getInvoicesAndCostsByCustomer:(int)count: (int)year completion:(void (^)(NSDictionary *invoicesAndCostsByCustomer,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Reporting/Jobs/InvoicesAndCostsByCustomer?count=%d&year=%d", count, year];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *invoicesAndCostsByCustomer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(invoicesAndCostsByCustomer, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getCompanyDetails:(int)parameter completion:(void (^)(NSMutableArray *companyDetails,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Settings/CompanyDetails"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSMutableArray *companyDetails = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(companyDetails, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}
-(void) getWIPCustomerTotals:(int)count completion:(void (^)(NSDictionary *WIPCustomerTotal,NSError *error))completionHandler{
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Reporting/WIP/WIPCustomerTotals?count=%d", count];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *WIPCustomerTotal = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(WIPCustomerTotal, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getLiveFactoryView:(NSString*)customerName completion:(void (^)(NSMutableArray *fvData, NSError *error))completionHandler{
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Sfdc/SentinelLiveFactoryView"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *tmp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *fvData = [[NSMutableArray alloc] init];
            
            for(NSDictionary *dic in tmp[@"shopstationObjects"]) {
                if([dic[@"CustomerName"] isEqualToString:customerName]) {
                    [fvData addObject:dic];
                }
            }
            completionHandler(fvData, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getMagicFilter:(NSString*)filter completion:(void (^)(NSDictionary *MagicFilter,NSError *error))completionHandler{
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Customer/MagicSearch?search=%@", filter];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *MagicFilter = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(MagicFilter, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getCustomerList:(NSString*)customer: (NSString*)reference completion:(void (^)(NSDictionary *CustomerList,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Customer/GetJobsAndEstimates/?customerCode=%@&addressReference=%@", customer, reference];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *CustomerList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(CustomerList, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getJobColourCodes:(int)parameter completion:(void (^)(NSDictionary *JobColourCodes,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Settings/GetjobStatusList"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *JobColourCodes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(JobColourCodes, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getEstimateColourCodes:(int)parameter completion:(void (^)(NSDictionary *EstimateColourCodes,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Estimate/GetEstimateStatusList"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *EstimateColourCodes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(EstimateColourCodes, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getCustomerStatusCodes:(int)parameter completion:(void (^)(NSDictionary *CustomerStatusCodes,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Customer/GetStatusCodes"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *CustomerStatusCodes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(CustomerStatusCodes, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getDockets:(NSString*)shopStation: (NSString*)startDate: (NSString*)endDate completion:(void (^)(NSDictionary *DocketsList,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Sfdc/GetSfdcDockets?shopStation=%@&startDate=%@&endDate=%@", shopStation, startDate, endDate];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *DocketsList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(DocketsList, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getOperationCodes:(int)parameter completion:(void (^)(NSDictionary *OperationCodes,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/costing/OperationCodes/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *OperationCodes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(OperationCodes, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getJobCollections:(NSString*)jobNo completion:(void (^)(NSDictionary *JobCollections,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Internal/JobCollections/%@", jobNo];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *JobCollections = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(JobCollections, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getWorkDocument:(NSString*)jobNo completion:(void (^)(NSData *pdfData,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Internal/Job/GetPDF?jobNo=%@", jobNo];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* URL = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            completionHandler(data, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getExtDocument:(NSString*)jobNo: (NSString*)exePath completion:(void (^)(NSData *pdfData,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Internal/Job/GetExternalDocument?jobNo=%@&path=%@", jobNo, exePath];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* URL = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            completionHandler(data, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getProductionEvents:(int)parameter completion:(void (^)(NSDictionary *ProductionEvents,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/ProductionSchedule/GetProductionEvents"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *ProductionEvents = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(ProductionEvents, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getProductionControls:(NSData*)dataToSend completion:(void (^)(NSDictionary *ProductionControls,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/ProductionSchedule/GetProductionControls"];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* URL = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *ProductionControls = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(ProductionControls, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) getCustomerDetails:(NSString*)customerCode completion:(void (^)(NSDictionary *CustomerDetails,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Customer/%@",customerCode];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* URL = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"GET"];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *CustomerDetails = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(CustomerDetails, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

-(void) saveProspect:(NSData*)dataToSend completion:(void (^)(NSDictionary *ProspectResponse,NSError *error))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"http://mail.imprint-mis.co.uk:9092/API_deploy/api/Prospect"];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString* URL = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:ImprintID forHTTPHeaderField:@"ImprintID"];
    [request addValue:ImprintSecret forHTTPHeaderField:@"ImprintSecret"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataToSend];
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSString *data = @"{\"jsonrpc\":\"2.0\",\"method\":\"getEventList\",\"params\" :[],\"id\":1}";
    //NSLog(@"-- %@", data);
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *queryData = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(!error) {
            NSDictionary *ProspectResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            completionHandler(ProspectResponse, error);
        } else {
            completionHandler(nil, error);
        }
    }];
    [queryData resume];
}

@end

