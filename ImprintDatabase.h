//
//  LWDatabase.h
//  LittleWickets
//
//  Created by Geoff Baker on 27/04/2018.
//  Copyright © 2018 ICN. All rights reserved.
//

#ifndef LWDatabase_h
#define LWDatabase_h
@interface ImprintDatabase:NSObject
{
    NSString *ImprintID;
    NSString *ImprintSecret;
}

/* ************************************* BASIC FUNCTIONS *********************************** */

-(void) getToken:(int)parameter completion:(void (^)(NSString *token, NSError *error))completionHandler;

-(void) getClientInfoByLoginPassword:(NSString*)email
                                    :(NSString*)password
                          completion:(void (^)(NSDictionary *clientInfo,NSError *error))completionHandler;

-(void) getUserDetailsList:(int)parameter completion:(void (^)(NSDictionary *userList,NSError *error))completionHandler;

-(void) getTopCustomerInvoices:(int)count: (int)year completion:(void (^)(NSDictionary *topCustomerInvoices,NSError *error))completionHandler;

-(void) getInvoicesAndCostsByCustomer:(int)count: (int)year completion:(void (^)(NSDictionary *invoicesAndCostsByCustomer,NSError *error))completionHandler;

-(void) getWIPCustomerTotals:(int)count completion:(void (^)(NSDictionary *WIPCustomerTotal,NSError *error))completionHandler;

-(void) getCompanyDetails:(int)parameter completion:(void (^)(NSMutableArray *companyDetails,NSError *error))completionHandler;

-(void) getLiveFactoryView:(NSString*)customerName completion:(void (^)(NSMutableArray *data, NSError *error))completionHandler;

-(void) getMagicFilter:(NSString*)filter completion:(void (^)(NSDictionary *magicFilter, NSError *error))completionHandler;

-(void) getCustomerList:(NSString*)customer: (NSString*)reference completion:(void (^)(NSDictionary *customerList,NSError *error))completionHandler;

-(void) getJobColourCodes:(int)parameter completion:(void (^)(NSDictionary *JobColourCodes,NSError *error))completionHandler;

-(void) getEstimateColourCodes:(int)parameter completion:(void (^)(NSDictionary *EstimateColourCodes,NSError *error))completionHandler;

-(void) getCustomerStatusCodes:(int)parameter completion:(void (^)(NSDictionary *CustomerStatusCodes,NSError *error))completionHandler;

-(void) getDockets:(NSString*)shopStation: (NSString*)startDate: (NSString*)endDate completion:(void (^)(NSDictionary *docketsList,NSError *error))completionHandler;

-(void) getOperationCodes:(int)parameter completion:(void (^)(NSDictionary *OperationCodes,NSError *error))completionHandler;

-(void) getJobCollections:(NSString*)jobNo completion:(void (^)(NSDictionary *JobCollections,NSError *error))completionHandler;

-(void) getWorkDocument:(NSString*)jobNo completion:(void (^)(NSData *pdfData,NSError *error))completionHandler;

-(void) getExtDocument:(NSString*)jobNo: (NSString*)exePath completion:(void (^)(NSData *pdfData,NSError *error))completionHandler;

-(void) getProductionEvents:(int)parameter completion:(void (^)(NSDictionary *CustomerStatusCodes,NSError *error))completionHandler;

-(void) getProductionControls:(NSData*)dataToSend completion:(void (^)(NSDictionary *ProductionControls,NSError *error))completionHandler;

-(void) getCustomerDetails:(NSString*)customerCode completion:(void (^)(NSDictionary *CustomerDetails,NSError *error))completionHandler;

-(void) saveProspect:(NSData*)dataToSend completion:(void (^)(NSDictionary *ProspectResponse,NSError *error))completionHandler;

-(void) getDesktopParameters:(int)parameter completion:(void (^)(NSDictionary *DesktopParameters,NSError *error))completionHandler;

@end

#endif /* LWDatabase_h */
