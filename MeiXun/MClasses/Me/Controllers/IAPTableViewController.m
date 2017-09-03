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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - setup UI 
- (void)setupProductsViewWithArray:(NSArray*)productsArras
{
    [self.products enumerateObjectsUsingBlock:^(MProductButton  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < productsArras.count) {
            SKProduct *productObj = productsArras[idx];
            [obj setProductData:productObj];
        }
    }];
}

#pragma mark - private methods
//请求苹果商品
- (void)requestAppleProductList
{
    [SVProgressHUD showWithStatus:@"加载产品信息中..."];
    // 7.这里的com.mei.myi就对应着苹果后台的商品ID,他们是通过这个ID进行联系的。
    NSArray *product = @[@"com.mei.mer",@"com.mei.myi"];
    NSSet *nsset = [NSSet setWithArray:product];
    // 8.初始化请求
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    // 9.开始请求
    [request start];
}

// 14.交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了。
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString * str=[[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    /**
     20      BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     21      BASE64是可以编码和解码的
     22      */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    
    //此方法为将这一次操作上传给我本地服务器,记得在上传成功过后一定要记得销毁本次操作。调用
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma mark - SKProductsRequestDelegate
// 10.接收到产品的返回信息,然后用返回的商品信息
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [SVProgressHUD dismiss];
    NSArray *products = response.products;
    //如果服务器没有产品
    if([products count] == 0){
        NSLog(@"nothing");
        return;
    }
    products = [[products reverseObjectEnumerator] allObjects];
    [self setupProductsViewWithArray:products];
    
}

#pragma mark - SKRequestDelegate 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [SVProgressHUD dismiss];
    NSLog(@"error:%@", error);
}

//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request{
    [SVProgressHUD dismiss];
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
- (IBAction)tapConfirmBtn:(id)sender {
    if (self.selectedProduct == nil) {
        [SVProgressHUD showInfoWithStatus:@"选择充值卡先"];
        return;
    }
    // 12.发送购买请求
    SKProduct *requestProduct = (SKProduct*)self.selectedProduct.productData;
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


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
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end
