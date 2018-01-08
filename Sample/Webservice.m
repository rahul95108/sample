
#import "Webservice.h"

@implementation Webservice

-(instancetype)initWithURL:(NSString *)url RequestType:(NSString *)requestType  UrlParameters:(NSDictionary *)urlParameters
{
    
    [self getSessionManager];
    
    if ([requestType isEqualToString:@"GET"]){
        
        self.isBusy = YES;
        [self.manager GET:url parameters:urlParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            
            int statusCode = (int)response.statusCode;
            
            [self requestDone:responseObject StatusCode:statusCode];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            
            int statusCode = (int)response.statusCode;
            [self requestFailed:error StatusCode:statusCode];
        }];
//        [self.manager GET:url parameters:urlParameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//
//            int statusCode = (int)response.statusCode;
//
//            [self requestDone:responseObject StatusCode:statusCode];
//
//        }failure:^(NSURLSessionDataTask *task, NSError *error){
//
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//
//            int statusCode = (int)response.statusCode;
//            [self requestFailed:error StatusCode:statusCode];
//
//        }];
        
        //--** DELETE Request --**//
        
    }else if ([requestType isEqualToString:@"DELETE"]){
        self.isBusy = YES;
        
        
        [self.manager DELETE:url parameters:urlParameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            
            int statusCode = (int)response.statusCode;
            
            [self requestDone:responseObject StatusCode:statusCode];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            
            int statusCode = (int)response.statusCode;
            [self requestFailed:error StatusCode:statusCode];
        }];
    }
    
    self.isBusy = NO;
    return self;
    
}


-(instancetype)initWithURL:(NSString *)url RequestType:(NSString *)requestType PostDataValuesAndKeys:(NSDictionary *)postData UrlParameters:(NSDictionary *)urlParameters
{
    [self getSessionManager];
    self.isBusy = YES;
    
//    [self.manager POST:url parameters:urlParameters
//               success:^(NSURLSessionDataTask *task, id responseObject){
    
    [self.manager POST:url parameters:urlParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        int statusCode = (int)response.statusCode;
        
        [self requestDone:responseObject StatusCode:statusCode];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        int statusCode = (int)response.statusCode;
        [self requestFailed:error StatusCode:statusCode];
    }];
    
                
    
    
    return self;
}

-(void) requestDone: (id)responseObject StatusCode: (int)statusCode
{
    
    self.isBusy = NO;
    
    if ([responseObject isKindOfClass:[NSData class]]){
        
        if (statusCode == 200)
        {
            NSData *data = [[NSData alloc]initWithData:responseObject];
            
            if (self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(webService:result:)])
                {
                    [self.delegate webService:self result:data];
                }
                else
                {
                    [self.delegate result:data WebServiceId:self.webServiceId];
                }
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(httpError:WebServiceId:ErrorCode:Message:)])
            {
                [self.delegate httpError:nil WebServiceId:self.webServiceId ErrorCode:statusCode Message:@"Web Service Failed!"];
            }
            else if ([self.delegate respondsToSelector:@selector(webService:httpError:ErrorCode:Message:)])
            {
                [self.delegate webService:self httpError:nil ErrorCode:statusCode Message:@"Web Service Failed"];
            }
        }
    }
}

-(void)requestFailed: (NSError *)errorMessage StatusCode: (int)statusCode

{
    self.isBusy = NO;
    
    NSLog (@"Request failed - Status Code: %d Error: %@", statusCode, errorMessage);
    
    if (statusCode == 0){
        
//        UIAlertView *offlineAlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Your internet connection appears to be offline. Please check your settings and try again" delegate:self
//                                                        cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
//        
//        [offlineAlertView show];
        
    }
    if ([self.delegate respondsToSelector:@selector(webService:connectionError:)])
    {
        [self.delegate webService:self connectionError: @"Connection Error!"];
    }
    else
    {
        //Add extra handling here
    }
    
    
    
}

-(AFHTTPSessionManager *)getSessionManager
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return self.manager;
}

@end
