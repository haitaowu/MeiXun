//
//  ContactsSearchController.h
//  MeiXun
//
//  Created by taotao on 2017/8/18.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;

@interface ContactsSearchController : UITableViewController
@property (nonatomic,copy) void(^selectedPersonBlock)(PersonModel* model);
- (void)searchWithKeyword:(NSString*)keyword;
@end
