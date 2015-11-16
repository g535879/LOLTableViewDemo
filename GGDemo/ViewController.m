//
//  HeroDetailViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "ViewController.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    UIScrollView * _scrollview; //滚动视图
    UIImageView * _heroBigImageView; //英雄图片
    UITableView * _heroTableView;   //父表格视图
    UIView * _headView;  //4个按钮容器
    UITableView * _currentTableView; //当前活动的子视图
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationRefer]; //设置导航栏
    [self createLayout]; //布局
    self.title = @"卡牌大师";
    
    //英雄图片
    _heroBigImageView.image = [UIImage imageNamed:@"hero_bg.jpg"];
    
}


//导航栏设置
- (void)setNavigationRefer {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

#pragma mark - createLayout
- (void)createLayout {
    
    
    //scrollView
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50)];
    _scrollview.delegate = self;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentOffset = CGPointMake(0, 0);
    _scrollview.pagingEnabled = YES;
    _scrollview.contentSize = CGSizeMake(MAX_WIDTH * 4, 2 * MAX_HEIGHT / 3);
    
    //4个子tableview
    for ( int i = 0; i < 4; i++) {
        //作为子tableview 的容器
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(MAX_WIDTH * i, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50)];
        [v setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1]];
        [_scrollview addSubview:v];
        
        //子tableview
        UITableView  *_skillTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        
        _skillTableView.delegate = self;
        _skillTableView.dataSource = self;
        _skillTableView.scrollEnabled = NO;
        
        if (!i) { //第0个
            //当前表格视图
            _currentTableView = _skillTableView;
        }
        //默认第一个视图
        [v addSubview:_skillTableView];
    }
    //顶部图片
    //headImageView
    _heroBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -MAX_HEIGHT / 3, MAX_WIDTH, MAX_HEIGHT / 3)];
    _heroBigImageView.image = [UIImage imageNamed:@"bindLogo"];
    
    
    _heroTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, MAX_WIDTH, MAX_HEIGHT+64) style:UITableViewStylePlain];
    _heroTableView.delegate = self;
    _heroTableView.dataSource = self;
    _heroTableView.showsVerticalScrollIndicator = NO;
    [_heroTableView addSubview:_heroBigImageView];
    _heroTableView.contentInset = UIEdgeInsetsMake(MAX_HEIGHT / 3, 0, 0, 0);
    [self.view addSubview:_heroTableView];
    
    //中间4个按钮
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, 50)];
    NSArray * titleArray = @[@"技能",@"出装加点",@"故事",@"攻略"];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MAX_WIDTH / 4 * idx, 0, MAX_WIDTH / 4, 50);
        [btn setTitle:titleArray[idx] forState:UIControlStateNormal];
        btn.tag = 100 + idx;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:36 / 255.0 green:119/ 255.0 blue:255/ 255.0 alpha:1] forState:UIControlStateSelected];
        if (!idx) {//第一个默认选中
            [btn setSelected:YES];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        }
        [_headView addSubview:btn];
    }];
    
    [_headView setBackgroundColor:[UIColor lightGrayColor]];
    _heroTableView.tableHeaderView  = _headView;
    
}

//根据颜色生成图片
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);  //图片尺寸
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect); //联系显示区域
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    UIGraphicsEndImageContext(); //消除画笔
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _heroTableView) {
        return 1;
    }
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //父tableview
    if (tableView == _heroTableView) {
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:_scrollview];
        return cell;
    }
    
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger index = [_scrollview.subviews indexOfObject:_currentTableView.superview];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组测试数据%ld",index,indexPath.row];
    return cell;
    
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _heroTableView) {
        return MAX_HEIGHT - 64 - 50 + 200;
    }
    return 240;
}


#pragma mark -  srcollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //获取当前活动的tableview
    UITableView * _skillTableView = _currentTableView;
    CGFloat  y = scrollView.contentOffset.y;
    
    
    //父表格移动
    if (scrollView == _heroTableView) {
        
        if (y > -65) { //滑动到顶端。固定位置
            //固定位置-65
            scrollView.contentOffset = CGPointMake(0, -65);
            CGFloat offsetY = _skillTableView.contentOffset.y;
            //子表格联动
            //控制偏移量
            if (_skillTableView.contentOffset.y < (_skillTableView.contentSize.height - 64 -500)) {
                _skillTableView.contentOffset = CGPointMake(0, offsetY + y + 65);
            }
            _skillTableView.scrollEnabled = YES;
        }
        //往下滑动。判断自表格是否移动到0.如到0 移动父表格。否则。移动子表格
        if (y < -65) {
            
            //判断子表格偏移量
            if (_skillTableView.contentOffset.y > 0) {
                
                //固定位置-65
                _heroTableView.contentOffset = CGPointMake(0, -65);
                
                CGFloat offsetY = _skillTableView.contentOffset.y;
                //子表格联动
                _skillTableView.contentOffset = CGPointMake(0, offsetY + y + 65);
                
            }
        }
        //顶部图片偏移量
        if (y < - MAX_HEIGHT / 3) {
            CGRect frame = _heroBigImageView.frame;
            frame.size.height =  - y ;
            frame.origin.y = y;
            _heroBigImageView.frame = frame;
        }
    }
    
    //技能栏相关，子表格
    else if (scrollView == _skillTableView) {
        
        //内部表格偏移量小于0.固定位置
        if (_skillTableView.contentOffset.y <= 0) {
            _skillTableView.contentOffset = CGPointMake(0, 0);
            _skillTableView.scrollEnabled = NO;
        }
        
    }
    //标题栏滚动视图联动
    else if (scrollView == _scrollview) { //滚动视图
        CGFloat  x = scrollView.contentOffset.x;
        [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * b = (UIButton *)obj;
                CGFloat offSet = x / MAX_WIDTH * 1.0;
                if (fabs(b.tag - 100 - offSet) < 1) {
                    b.selected  = YES;
                    [b.titleLabel setFont:[UIFont systemFontOfSize:16]];
                    
                    if (b.tag - 100 == offSet) {
                        [b.titleLabel setFont:[UIFont systemFontOfSize:18]];
                    }
                }
                else{
                    b.selected = NO;
                    [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
                }
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != _scrollview) {
        return;
    }
    //取消其他按钮选中状态
    [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * b = (UIButton *)obj;
            if (b.selected) {
                b.selected = NO;
                [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }
            if (idx == scrollView.contentOffset.x / MAX_WIDTH) {
                b.selected = YES;
                [b.titleLabel setFont:[UIFont systemFontOfSize:18]];
                //当前表格视图
                _currentTableView = [[_scrollview.subviews[idx] subviews]firstObject];
                //刷新表格
                [_currentTableView reloadData];
            }
        }
    }];
    
}

#pragma mark - titleBtnClick
- (void)titleBtnClick:(UIButton *)btn {
    //取消其他按钮选中状态
    [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * b = (UIButton *)obj;
            if (b.selected) {
                b.selected = NO;
                [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }
        }
    }];
    btn.selected = !btn.selected;
    
    [UIView animateWithDuration:0.5f animations:^{
        //字体变大
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        
        //设置滚动视图偏移量
        _scrollview.contentOffset = CGPointMake(MAX_WIDTH * (btn.tag - 100), 0);
        
        
    }];
    
    //当前表格视图
    _currentTableView = [[_scrollview.subviews[btn.tag - 100] subviews]firstObject];
    //刷新表格
    [_currentTableView reloadData];
    
}

@end
