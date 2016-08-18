//
//  PortalService.m
//  aeExchange
//
//  Created by Mahaboobsab Nadaf on 01/07/16.
//  Copyright © 2016 com.NeoRays. All rights reserved.
//

#import "PortalService.h"
#import "Helper.h"
#import "allConstants.h"
@implementation PortalService


+ (id)sharedManager{

    static PortalService *sharedMyManager =  nil;
    
    @synchronized (self) {
        if (sharedMyManager == nil)
            
            sharedMyManager = [[self alloc] init];
    }

    return sharedMyManager;
}


-(void)getToken{


    NSString *requestURL = [Helper createUrl:GET_TOKEN];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"YourUserName" password:@"yourPassword"];
    
    NSDictionary *parameters = @{@"grant_type":@"client_credentials"};
    
    [manager POST:requestURL parameters:parameters constructingBodyWithBlock:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"JSON Object is : %@",jsonObject);
        
        if (jsonObject != nil) {
            [self.delegate successfullGotToken:jsonObject];
        }
        else{
            [self.delegate failedToGetToken:error];
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate failedToGetToken:error];
        
    }];
}

-(void)AEPensionCalculator:(NSDictionary *)dictValues accessToken:(NSString *)accessToken{



    NSString *requestURL = [Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",CALCULATE,accessToken]];
    
    NSLog(@"Request url : %@",requestURL);
    
    NSError *error;
    NSString *jsonString;
  
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictValues options:NSJSONWritingPrettyPrinted error:&error];
    

    if (! jsonData) {
        NSLog(@"Got Error in Getting JSON : %@",error);
    }
    else{
    
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    


    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request  completionHandler:^(NSURLResponse *  response, id  responseObject, NSError *  error) {
        if (error) {
            [self.delegate failedToCalculate:error];
        }
        
        else{
        
            
            NSError *error;
            
            NSDictionary *jsonObject = responseObject;
            
            if (jsonObject != nil) {
                [self.delegate successCalculate:jsonObject];
            }
            else{
            
                [self.delegate failedToGetToken:error];
            }
        }
        
    }];
    
    [dataTask resume];
}

-(void)receivePensionProviderDetails:(NSString*)pensionProviderName accessToken:(NSString*)accessToken{
    
    
    NSString *requestURL=[Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",PENSION_DETAILS,accessToken]];
    
    NSData *postData = [pensionProviderName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"field:%@",request.allHTTPHeaderFields);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSDictionary *userInfo = [error userInfo];
            NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"The error is: %@", str);
            [self.delegate failedForPension:error];
        } else {
            
            
            
            NSError *error;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if (jsonObject!=nil) {
                
                [self.delegate successForPension:jsonObject];
                
            }else
            {
                [self.delegate failedForPension:error];
            }
            
        }
    }];
    [dataTask resume];
    
    
}

-(void)receiveEmployersList:(NSString*)EmployerName accessToken:(NSString*)accessToken{
    
    
    NSString *requestURL=[Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",EMPLOYERS_LIST,accessToken]];
    
    
    NSData *postData = [EmployerName dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"field:%@",request.allHTTPHeaderFields);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSDictionary *userInfo = [error userInfo];
            NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"The error is: %@", str);
            [self.delegate failedForEmprDetails:error];
        } else {
            
            
            
            NSError *error;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if (jsonObject!=nil) {
                
                [self.delegate successForEmprDetails:jsonObject];
                
            }else
            {
                [self.delegate failedForEmprDetails:error];
            }
            
        }
    }];
    [dataTask resume];
    
    
}

-(void)EmailLetter:(NSDictionary*)dictValues accessToken:(NSString*)accessToken{
    
    NSString *requestURL=[Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",EMAIL,accessToken]];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictValues
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    NSLog(@"Got an json: %@", jsonString);
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"field:%@",request.allHTTPHeaderFields);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSDictionary *userInfo = [error userInfo];
            NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"The error is: %@", str);
            [self.delegate failedForEmail:error];
        } else {
            
            
            
            NSError *error;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            
            if (jsonObject!=nil) {
                
                [self.delegate successForEmail:jsonObject];
                
            }else
            {
                [self.delegate failedForEmail:error];
            }
            
        }
    }];
    [dataTask resume];
    
    
}

-(void)PDFLetter:(NSDictionary*)dictValues accessToken:(NSString*)accessToken{
    
    NSString *requestURL=[Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",PDF,accessToken]];
    
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictValues
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    NSLog(@"Got an json: %@", jsonString);
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"field:%@",request.allHTTPHeaderFields);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSDictionary *userInfo = [error userInfo];
            NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString * str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"The error is: %@", str);
            [self.delegate failedForPdf:error];
        } else {
            
            
            
            NSError *error;
            NSDictionary *jsonObject = responseObject;
            
            if (jsonObject!=nil) {
                
                [self.delegate successForPdf:responseObject];
                
            }else
            {
                [self.delegate failedForPdf:error];
            }
            
        }
    }];
    [dataTask resume];
    
    
}

-(void)receiveCompanyDetails:(NSString*)crn token:(NSString*)accessToken{
    
    NSString *requestURL=[Helper createUrl:[NSString stringWithFormat:@"%@?access_token=%@",COMPANY_DET,accessToken]];
    
    
    NSData *postData = [crn dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"field:%@",request.allHTTPHeaderFields);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            [self.delegate failedForEmail:error];
        } else {
            
            
            
            NSError *error;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if (jsonObject!=nil) {
                
                [self.delegate successForPdf:responseObject];
                
            }else
            {
                [self.delegate failedForPdf:error];
            }
            
        }
    }];
    [dataTask resume];
    
    
}


-(void)googlePlaces:(NSString*)placeId{
    
    NSString *requestURL=[NSString stringWithFormat:@"%@&placeid=%@&key=%@",GOOGLE_PLACES,placeId,API];
    
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        
        if (error!=nil) {
            [self.delegate failedForGoogle:error.localizedDescription];
        }else{
            NSError *err=nil;
            NSJSONSerialization* json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            [self.delegate successForGoogle:[json valueForKey:@"result"]];
        }
        
        
    }];
    
    [dataTask resume];
    
}
@end
