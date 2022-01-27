//
//  GraphManager.m
//  GraphTutorial
//
//  Copyright (c) Microsoft. All rights reserved.
//  Licensed under the MIT license. See LICENSE.txt in the project root for license information.
//

#import "GraphManager.h"

@interface GraphManager()

@property MSHTTPClient* graphClient;
@property NSString* graphTimeZone;
@end

@implementation GraphManager

+ (id) instance {
    static GraphManager *singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        singleInstance = [[self alloc] init];
    });

    return singleInstance;
}

- (id) init {
    if (self = [super init]) {
        // Create the Graph client
        self.graphClient = [MSClientFactory
                            createHTTPClientWithAuthenticationProvider:AuthenticationManager.instance];
        self.graphTimeZone=@"Asia/Kolkata";
    }

    return self;
}

- (void) getMeWithCompletionBlock:(GetMeCompletionBlock)completionBlock {
    // GET /me
    NSString* meUrlString = [NSString stringWithFormat:@"%@/me", MSGraphBaseURL];
    NSURL* meUrl = [[NSURL alloc] initWithString:meUrlString];
    NSMutableURLRequest* meRequest = [[NSMutableURLRequest alloc] initWithURL:meUrl];

    MSURLSessionDataTask* meDataTask =
    [[MSURLSessionDataTask alloc]
        initWithRequest:meRequest
        client:self.graphClient
        completion:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                completionBlock(nil, error);
                return;
            }

            // Deserialize the response as a user
            NSError* graphError;
            MSGraphUser* user = [[MSGraphUser alloc] initWithData:data error:&graphError];

            if (graphError) {
                completionBlock(nil, graphError);
            } else {
                completionBlock(user, nil);
            }
        }];

    // Execute the request
    [meDataTask execute];
}

// <GetEventsSnippet>
- (void) getEventsWithCompletionBlock:(GetEventsCompletionBlock)completionBlock {
    // GET /me/events?$select='subject,organizer,start,end'$orderby=createdDateTime DESC
    NSString* eventsUrlString =
    [NSString stringWithFormat:@"%@/me/events?%@&%@",
     MSGraphBaseURL,
     // Only return these fields in results
     @"$select=subject,organizer,start,end",
     // Sort results by when they were created, newest first
     @"$orderby=createdDateTime+DESC"];

    NSURL* eventsUrl = [[NSURL alloc] initWithString:eventsUrlString];
    NSMutableURLRequest* eventsRequest = [[NSMutableURLRequest alloc] initWithURL:eventsUrl];

    MSURLSessionDataTask* eventsDataTask =
    [[MSURLSessionDataTask alloc]
     initWithRequest:eventsRequest
     client:self.graphClient
     completion:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (error) {
             completionBlock(nil, error);
             return;
         }

         NSError* graphError;

         // Deserialize to an events collection
         MSCollection* eventsCollection = [[MSCollection alloc] initWithData:data error:&graphError];
         if (graphError) {
             completionBlock(nil, graphError);
             return;
         }

         // Create an array to return
         NSMutableArray* eventsArray = [[NSMutableArray alloc]
                                     initWithCapacity:eventsCollection.value.count];

         for (id event in eventsCollection.value) {
             // Deserialize the event and add to the array
             MSGraphEvent* graphEvent = [[MSGraphEvent alloc] initWithDictionary:event];
             [eventsArray addObject:graphEvent];
         }

         completionBlock(eventsArray, nil);
     }];

    // Execute the request
    [eventsDataTask execute];
}
// </GetEventsSnippet>


// Create Meeting Events

- (void) CreateMeetingWithCompletionBlock:(NSMutableDictionary*) reqData
                          Success:(CreateMeetingCompletionBlock)completionBlock {
    // GET /me
    NSString* meUrlString = [NSString stringWithFormat:@"%@/me/onlineMeetings/createOrGet", MSGraphBaseURL];
    NSURL* meUrl = [[NSURL alloc] initWithString:meUrlString];
    NSMutableURLRequest* meRequest = [[NSMutableURLRequest alloc] initWithURL:meUrl];
    [meRequest setHTTPMethod:@"POST"];
    [meRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *ndata = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
    [meRequest setHTTPBody:ndata];
    
    MSURLSessionDataTask* meDataTask =
    [[MSURLSessionDataTask alloc]
        initWithRequest:meRequest
        client:self.graphClient
        completion:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                completionBlock(nil,nil, error);
                return;
            }

            NSError* graphError;
            // Deserialize to an events collection
            MSCollection* eventsCollection = [[MSCollection alloc] initWithData:data error:&graphError];
            if (graphError) {
                completionBlock(nil,nil, graphError);
                return;
            }
            
            // Create an array to return
            NSMutableArray* eventsArray = [[NSMutableArray alloc]
                                        initWithCapacity:eventsCollection.value.count];
            for (id event in eventsCollection.value) {
                // Deserialize the event and add to the array
                MSGraphEvent* graphEvent = [[MSGraphEvent alloc] initWithDictionary:event];
                [eventsArray addObject:graphEvent];
            }

            completionBlock(eventsCollection.additionalData,eventsArray, nil);
        }];

    // Execute the request
    [meDataTask execute];
}

- (void) createEventWithSubject: (NSString*) subject
                       andStart: (NSDate*) start
                         andEnd: (NSDate*) end
                   andAttendees: (NSArray<NSString*>* _Nullable) attendees
                        andBody: (NSString* _Nullable) body
             andCompletionBlock: (CreateEventCompletionBlock) completion {
    NSDateFormatter* isoFormatter = [[NSDateFormatter alloc] init];
    isoFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm";
    
    // Create a dictionary to represent the event
    // Current version of the Graph SDK models don't serialize properly
    // see https://github.com/microsoftgraph/msgraph-sdk-objc-models/issues/27
    NSMutableDictionary* eventDict = [NSMutableDictionary dictionary];
    
    [eventDict setObject:subject forKey:@"subject"];
    
    NSDictionary* startDict = @{
        @"dateTime": [isoFormatter stringFromDate:start],
        @"timeZone": self.graphTimeZone
    };
    [eventDict setObject:startDict forKey:@"start"];
    
    NSDictionary* endDict = @{
        @"dateTime": [isoFormatter stringFromDate:end],
        @"timeZone": self.graphTimeZone
    };
    [eventDict setObject:endDict forKey:@"end"];
    
    if (attendees != nil && attendees.count > 0) {
        NSMutableArray* attendeeArray = [NSMutableArray array];
        
        for (id email in attendees) {
            NSDictionary* attendeeDict = @{
                @"type": @"required",
                @"emailAddress": @{
                    @"address": email
                }
            };
            
            [attendeeArray addObject:attendeeDict];
        }
        
        [eventDict setObject:attendeeArray forKey:@"attendees"];
    }
    
    if (body != nil) {
        NSDictionary* bodyDict = @{
            @"content": body,
            @"contentType": @"text"
        };
        
        [eventDict setObject:bodyDict forKey:@"body"];
    }
    
    NSError* error = nil;
    NSData* eventData = [NSJSONSerialization dataWithJSONObject:eventDict
                                                        options:kNilOptions
                                                          error:&error];
    
    // Prepare Graph request
    NSString* eventsUrlString =
    [NSString stringWithFormat:@"%@/me/events", MSGraphBaseURL];
    NSURL* eventsUrl = [[NSURL alloc] initWithString:eventsUrlString];
    NSMutableURLRequest* eventsRequest = [[NSMutableURLRequest alloc] initWithURL:eventsUrl];
    
    eventsRequest.HTTPMethod = @"POST";
    eventsRequest.HTTPBody = eventData;
    [eventsRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    MSURLSessionDataTask* createEventDataTask =
    [[MSURLSessionDataTask alloc]
     initWithRequest:eventsRequest
     client:self.graphClient
     completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        NSError* graphError;

        // Deserialize to an event
        MSGraphEvent* event = [[MSGraphEvent alloc] initWithData:data
                                                           error:&graphError];
        if (graphError) {
            completion(nil, graphError);
            return;
        }

        completion(event, nil);
    }];

    // Execute the request
    [createEventDataTask execute];
}
@end
