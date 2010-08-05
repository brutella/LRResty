//
//  LRRestyResponse.m
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyResponse.h"
#import "LRRestyRequest.h"

NSDictionary *extractCookiesFromHeaders(NSDictionary *headers, NSURL *url)
{
  NSMutableDictionary *cookies = [NSMutableDictionary dictionary];
  for (NSHTTPCookie *cookie in [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:url]) {
    [cookies setObject:cookie forKey:cookie.name];
  }
  return [cookies copy];
}

@implementation LRRestyResponse

- (id)initWithStatus:(NSInteger)statusCode responseData:(NSData *)data headers:(NSDictionary *)theHeaders originalRequest:(LRRestyRequest *)originalRequest;
{
  if (self = [super init]) {
    status = statusCode;
    responseData = [data retain];
    headers = [theHeaders copy];
    cookies = extractCookiesFromHeaders(headers, originalRequest.URL);
  }
  return self;
}

- (void)dealloc
{
  [headers release];
  [responseData release];
  [super dealloc];
}

- (NSUInteger)status;
{
  return status;
}

- (NSString *)asString;
{
  return [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%d Response | text/plain (%d bytes)", [self status], [responseData length]];
}

- (NSHTTPCookie *)cookieNamed:(NSString *)name;
{
  return [cookies objectForKey:name];
}

- (NSString *)valueForHeader:(NSString *)header;
{
  return [headers objectForKey:header];
}

- (NSString *)valueForCookie:(NSString *)cookieNamed;
{
  return [[self cookieNamed:cookieNamed] value];
}

@end
