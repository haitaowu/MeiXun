//
//  IAPTableViewController.m
//  MeiXun
//
//  Created by taotao on 2017/8/31.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "IAPTableViewController.h"
#import "MProductButton.h"
#import <StoreKit/StoreKit.h>


@interface IAPTableViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property(nonatomic,strong) IBOutletCollection(MProductButton) NSArray* products;
@property (nonatomic,strong)MProductButton *selectedProduct;
@end

@implementation IAPTableViewController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if([SKPaymentQueue canMakePayments]){
        [self requestAppleProductList];
    }else{
        NSLog(@"不允许程序内付费");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark - private methods
//请求苹果商品
- (void)requestAppleProductList
{
    // 7.这里的com.mei.myi就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
    NSArray *product = @[@"com.mei.mer",@"com.mei.myi"];
    NSSet *nsset = [NSSet setWithArray:product];
    // 8.初始化请求
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    // 9.开始请求
    [request start];
}



#pragma mark - SKProductsRequestDelegate
// 10.接收到产品的返回信息,然后用返回的商品信息
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    //如果服务器没有产品
    if([products count] == 0){
        NSLog(@"nothing");
        return;
    }
    
//    SKProduct *requestProduct = nil;
    for (SKProduct *pro in products) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        // 11.如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if([pro.productIdentifier isEqualToString:@"com.mei.mer"]){
            HTLog(@"com.mei.mer");
        }
    }
    
    // 12.发送购买请求
//    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKRequestDelegate 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"error:%@", error);
}

//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"信息反馈结束");
}

#pragma mark - SKPaymentTransactionObserver
// 13.监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                break;
        }
    }
}


#pragma mark - selectors
- (IBAction)tapProduct:(MProductButton*)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.selectedProduct = sender;
        for (MProductButton *product in self.products) {
            if (product.tag != sender.tag) {
                product.selected = NO;
            }
        }
    }
}

#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end
