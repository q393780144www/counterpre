//
//  YGHRootViewController.m
//  File
//
//  Created by YGH on 14-10-8.
//  Copyright (c) 2014年 ___YGH___. All rights reserved.
//

#import "YGHRootViewController.h"

@interface YGHRootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UITextField *Url;
- (IBAction)File:(UIButton *)sender;

@end
UIActivityIndicatorView *act;
@implementation YGHRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count.textAlignment=NSTextAlignmentCenter;
    _count.textColor=[UIColor redColor];
    _count.text=@"代码行数";
    _count.font=[UIFont systemFontOfSize:25];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidd)];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:tap];
    act=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 60, 30, 30)];
    act.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray ;
//    NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
//    [cen addObserver:self selector:@selector(ani) name:UIKeyboardWillHideNotification object:nil];
    //act.hidden=YES;
    //[act startAnimating];
    [self.view addSubview:act];
    // Do any additional setup after loading the view from its nib.
}
-(void)ani
{
    [act startAnimating];
}
-(void)hidd
{
    self.view.backgroundColor=[UIColor blueColor];
    NSLog(@"%@",[NSThread currentThread]);
    [self.view endEditing:YES];
}
-(NSUInteger)code:(NSString *)path
{
    NSFileManager *file=[NSFileManager defaultManager];
    BOOL dir=NO;
    BOOL exit=[file fileExistsAtPath:path isDirectory:&dir];
    if(!exit)
    {
        UIAlertView *alr=[[UIAlertView alloc]initWithTitle:@"警告" message:@"路径不存在，请重新输入" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alr show];
        return 0;
    }
    else
    {
       
        if (dir==YES) {
            int count=0;
            NSArray *fil=[file contentsOfDirectoryAtPath:path error:nil];
           
            for (NSString *full in fil) {
                NSString *fullname=[NSString stringWithFormat:@"%@/%@",path,full];
               
                count= [self code:fullname]+count;
               
            }
          
           
            return count;
            
        }
        else
        {
            NSString *extr=[[path pathExtension] lowercaseString];
            if ([extr isEqualToString:@"h"]||[extr isEqualToString:@"c"]||[extr isEqualToString:@"m"]) {
                NSString *cont=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                NSArray *ary=[cont componentsSeparatedByString:@"\n"];
//                 NSLog(@"%@",path);
//                NSLog(@"%d",ary.count);
                return ary.count;
            }
            else
                return 0;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)coun
{
    NSLog(@"%@",[NSThread currentThread]);
    NSUInteger i=[self code:_Url.text];
    NSOperationQueue *main=[NSOperationQueue mainQueue];
    NSBlockOperation *op1=[NSBlockOperation blockOperationWithBlock:^{
        
         _count.text=[NSString stringWithFormat:@"%d行代码",i];
          NSLog(@"%@",[NSThread currentThread]);
        [act stopAnimating];
    }];
    [main addOperation:op1];
//    _count.text=[NSString stringWithFormat:@"%d行代码",i];
           NSLog(@"%@",[NSThread currentThread]);
   //[act stopAnimating];
    
    
}
- (IBAction)File:(UIButton *)sender {
    NSInvocationOperation *oper=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(coun) object:nil];
    NSOperationQueue *que=[[NSOperationQueue alloc]init];
    [que addOperation:oper];
    [self ani];
       NSLog(@"%@",[NSThread currentThread]);
    [self.view endEditing:YES];
    
    
    //[act stopAnimating];
    
}
@end
