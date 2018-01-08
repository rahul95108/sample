
#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@protocol WebServiceDelegate

@optional

-(void) result:(id) result WebServiceId: (int) webServiceId;
-(void) connectionError:(id) result WebServiceId: (int) webServiceId;
-(void) generalError:(id) result WebServiceId: (int) webServiceId;
-(void) httpError:(id) result WebServiceId: (int) webServiceId ErrorCode: (int) errorCode Message: (NSString *) errorMessage;

-(void) webService:(id) webService result:(id) result;
-(void) webService:(id) webService connectionError:(id) result;
-(void) webService:(id) webService generalError:(id) result;
-(void) webService:(id) webService httpError:(id) result ErrorCode: (int) errorCode Message: (NSString *) errorMessage;

@end

@interface Webservice : NSObject

#pragma mark - Properties

@property (nonatomic) BOOL isBusy;
@property (assign) int webServiceId;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (weak, nonatomic) id <NSObject, WebServiceDelegate> delegate;


#pragma mark - Methods

-(instancetype) init __attribute__((unavailable("Please use this classes designated initilizer initWithUrl")));


- (id) initWithURL: (NSString*) url RequestType: (NSString*) requestType PostDataValuesAndKeys: (NSDictionary*) postData  UrlParameters: (NSDictionary*) urlParameters;

- (id) initWithURL: (NSString*) url RequestType: (NSString*) requestType UrlParameters: (NSDictionary*) urlParameters;

@end
