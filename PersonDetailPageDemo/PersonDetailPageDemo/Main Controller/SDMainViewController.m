//
//  SDMainViewController.m
//  微博个人详情页
//
//  Created by Sunny on 16/2/20.
//  Copyright © 2016年 Sunny. All rights reserved.
//

#import "SDMainViewController.h"
#import "UIImage+Image.h"

static CGFloat const kHeaderViewHeight = 200;
static CGFloat const kHeaderViewMinHeight = 64;
static CGFloat const kChooseViewHeight = 44;
static CGFloat const originalOffset = -(kHeaderViewHeight + kChooseViewHeight);
static NSString *const ID = @"cell";


@interface SDMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (nonatomic ,weak) UILabel *contentLabel;

@end

@implementation SDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setNavgationBarHide];
    
    [self.contentTableView registerClass:[UITableViewCell class]forCellReuseIdentifier:ID];
    
}

- (void) setNavgationBarHide {
    
    /** 把tableview视图整体往下移动244个单位,因为这一部分是头部视图还有选项卡的大小 */
    self.contentTableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight+kChooseViewHeight,0, 0, 0);
    
    /** 不要自动往下滚动64个单位.(64是原本状态栏还有导航栏的高度合) */
    self.automaticallyAdjustsScrollViewInsets = NO;

    /** 设置导航栏为透明,其原理就是传入一个没有图片,但又不为空的UIImage给导航栏 */
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];

    /** 把导航栏上的分隔线用一个没有图片,但又不为空的UIImage给覆盖掉 */
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    /** 添加自定义title */
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.text = @"微博个人详情页面";
    /** 让label根据文字的大小自己调整大小 */
    [contentLable sizeToFit];
    self.navigationItem.titleView = contentLable;
    
    /** 默认隐藏title */
    contentLable.textColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.contentLabel = contentLable;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    /** 计算偏移量 */
    CGFloat offset = scrollView.contentOffset.y - originalOffset ;

    /** 偏移高度 = 默认高度 - 偏移量*/
    CGFloat offsetHeight = kHeaderViewHeight - offset;

    /** 悬停效果,其实就是不让图片的高度继续减小,最小只能是64 */
    if (offsetHeight < kHeaderViewMinHeight) {
        offsetHeight = kHeaderViewMinHeight;
    }
    
    /** 通过修改Height达到效果,当向上滚动时,选项卡向上滚动的速度比头部视图的还要快一点 */
    self.headViewHeightConstraint.constant = offsetHeight;

    /** alpha 值计算 : 偏移量 / (headView默认高度 - headView最小高度) ,当大于1时,导航栏和contentLabel就会完全显示*/
    CGFloat alpha = offset / (kHeaderViewHeight - kHeaderViewMinHeight);
    
    self.contentLabel.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    
    /** 这里直接使用袁峥的Category方法,返回一张通过传入颜色,返回一张1*1的图片 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
}

@end
