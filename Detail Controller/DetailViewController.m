//
//  DetailViewController.m
//  DemoApp
//
//  Created by ambab on 3/19/18.
//  Copyright © 2018 Nelson. All rights reserved.
//

#import "DetailViewController.h"
#import "CountryDetailModel.h"

@interface DetailViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loaderView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [self.titleLbl setText:self.model.webTitle];
    
    [self.loaderView startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.webUrl]]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loaderView stopAnimating];
    [self.loaderView setHidden:true];
}

#pragma mark - button event

-(IBAction)backBtnClicked:(id)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self.webView stopLoading];
        [self.navigationController popViewControllerAnimated:true];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
