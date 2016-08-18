//
//  PortalService.h
//  aeExchange
//
//  Created by Mahaboobsab Nadaf on 01/07/16.
//  Copyright © 2016 com.NeoRays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@protocol serviceDelegate <NSObject>
@optional
-(void)successfullGotToken:(NSDictionary*)SucsessDict;
-(void)failedToGetToken:(NSError*)error;

-(void)successCalculate:(NSDictionary*)dict;
-(void)failedToCalculate:(NSError *)error;

//Pension Provider

-(void)successForPension:(NSDictionary*)dict;
-(void)failedForPension:(NSError*)error;

//Employers
-(void)successForEmprDetails:(NSDictionary*)dict;
-(void)failedForEmprDetails:(NSError*)dict;

//PDF
-(void)successForEmail:(NSDictionary*)dict;
-(void)failedForEmail:(NSError*)error;

-(void)successForPdf:(NSData*)data;
-(void)failedForPdf:(NSError*)error;

-(void)successForGoogle:(NSDictionary*)dict;
-(void)failedForGoogle:(NSString*)error;
@end


@interface PortalService : NSObject

@property(nonatomic, weak)id<serviceDelegate>delegate;

+ (id)sharedManager;
-(void)getToken;
-(void)AEPensionCalculator:(NSDictionary*)dictValues accessToken:(NSString*)accessToken;

-(void)receivePensionProviderDetails:(NSString*)pensionProviderName accessToken:(NSString*)accessToken;

-(void)receiveEmployersList:(NSString*)EmployerName accessToken:(NSString*)accessToken;

//PDF
-(void)EmailLetter:(NSDictionary*)dictValues accessToken:(NSString*)accessToken;
-(void)PDFLetter:(NSDictionary*)dictValues accessToken:(NSString*)accessToken;

-(void)googlePlaces:(NSString*)placeId;
@end
