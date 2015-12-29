/**
 *  Copyright 2014 Nest Labs Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "NestWebViewAuthController.h"
//#import "UIColor+Custom.h"
#import "Constants.h"

@interface NestWebViewAuthController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) id <NestWebViewAuthControllerDelegate> delegate;

@end

#define QUESTION_MARK @"?"
#define SLASH @"/"
#define HASHTAG @"#"
#define EQUALS @"="
#define AMPERSAND @"&"
#define EMPTY_STRING @""

@implementation NestWebViewAuthController

+ (instancetype)controllerWithDelegate:(id<NestWebViewAuthControllerDelegate>)delegate
{
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NestWebViewAuthController* inst = [s instantiateViewControllerWithIdentifier:@"NestWebViewAuthController"];
    inst.delegate = delegate;
    return inst;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the URL in the web view
    [self loadAuthURL];
}

/**
 * Load's the auth url in the web view.
 */
- (void)loadAuthURL
{
    NSString* authURL = [NSString stringWithFormat:@"https://%@/login/oauth2?client_id=%@&state=%@", NestCurrentAPIDomain, NestClientID, NestState];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:authURL]];
    [self.webView loadRequest:request];
}

#pragma mark UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/**
 * Intercept the requests to get the authorization code.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSURL *redirectURL = [[NSURL alloc] initWithString:RedirectURL];
        
	if ([[url host] isEqualToString:[redirectURL host]]) {
		
        // Clean the string
		NSString *urlResources = [url resourceSpecifier];
		urlResources = [urlResources stringByReplacingOccurrencesOfString:QUESTION_MARK withString:EMPTY_STRING];
		urlResources = [urlResources stringByReplacingOccurrencesOfString:HASHTAG withString:EMPTY_STRING];
		
		// Seperate the /
		NSArray *urlResourcesArray = [urlResources componentsSeparatedByString:SLASH];
		
		// Get all the parameters after /
		NSString *urlParamaters = [urlResourcesArray objectAtIndex:([urlResourcesArray count]-1)];
		
		// Separate the &
		NSArray *urlParamatersArray = [urlParamaters componentsSeparatedByString:AMPERSAND];
        NSString *keyValue = [urlParamatersArray lastObject];
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:EQUALS];
        
        // We found the code
        if([[keyValueArray objectAtIndex:(0)] isEqualToString:@"code"]) {
            
            // Send it to the delegate
            [self.delegate foundAuthorizationCode:[keyValueArray objectAtIndex:1]];
            
		} else {
			NSLog(@"Error retrieving the authorization code.");
		}

		return NO;
	}
	
	return YES;
}




@end
