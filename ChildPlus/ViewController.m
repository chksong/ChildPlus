//
//  ViewController.m
//  ChildPlus
//
//  Created by chksong on 2017/6/22.
//  Copyright © 2017年 cn.goipc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVSpeechSynthesizerFacade.h"

@interface ViewController () <AVSpeechSynthesizerDelegate> {
    AVSpeechSynthesizerFacade* mySpeechSynthesizer;
}

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong)    NSString  *stringRead ;


@property (weak, nonatomic) IBOutlet UILabel *labelOpt1;
@property (weak, nonatomic) IBOutlet UILabel *labelOpt2;


@property(nonatomic , strong) NSMutableSet *mutaSetOptResult ;
@property(nonatomic ,strong)  NSMutableArray   *mutaArrayResult ;

@property (nonatomic ,strong)  NSString   *strAnwser  ;

@property (nonatomic , strong) AVSpeechSynthesizer *speechSynthesizer ;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI]  ;
    
    _mutaSetOptResult = [NSMutableSet new] ;
    _mutaArrayResult  = [NSMutableArray new]  ;
    
    [_btnNext setTitle:@"开始" forState:UIControlStateNormal];
    
    if (mySpeechSynthesizer == nil)
    {
        mySpeechSynthesizer = [[AVSpeechSynthesizerFacade alloc] init];
        mySpeechSynthesizer.playDelegate = self ;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES ;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO ;

}


-(void) setupUI  {
    // ArialRoundedMTBold
    
    
    _labelText.font  = [UIFont fontWithName:@"ArialRoundedMTBold" size:48] ;
    _labelText.textColor = [UIColor whiteColor]  ;
    
    [_btnNext.titleLabel setFont: [UIFont fontWithName:@"ArialRoundedMTBold" size:15]] ;
    [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnNext.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] ;
    _btnNext.layer.cornerRadius = 10.0f ;
    _btnNext.layer.borderColor = [[UIColor redColor] CGColor] ;
    _btnNext.layer.borderWidth  = 2 ;
  
    //UIFont(name: "ArialRoundedMTBold", size: 18.0)  ;
    
    _labelOpt1.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2] ;
    _labelOpt1.layer.cornerRadius = 10.0f ;
    _labelOpt1.layer.borderColor = [[UIColor whiteColor] CGColor] ;
    _labelOpt1.layer.borderWidth  = 2 ;
    _labelOpt1.font  = [UIFont fontWithName:@"ArialRoundedMTBold" size:26] ;
    _labelOpt1.textColor = [UIColor whiteColor]  ;
    _labelOpt1.userInteractionEnabled  =  YES  ;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLableShowAnswer:)] ;
    [_labelOpt1 addGestureRecognizer:tap1];
    
    
    _labelOpt2.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2] ;
    _labelOpt2.layer.cornerRadius = 10.0f ;
    _labelOpt2.layer.borderColor = [[UIColor whiteColor] CGColor] ;
    _labelOpt2.layer.borderWidth  = 2 ;
    
    _labelOpt2.font  = [UIFont fontWithName:@"ArialRoundedMTBold" size:26] ;
    _labelOpt2.textColor = [UIColor whiteColor] ;
    _labelOpt2.userInteractionEnabled = YES  ;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLableShowAnswer:)];
    [_labelOpt2 addGestureRecognizer:tap2];
    
    
    
    _labelOpt2.hidden  = YES  ;
    _labelOpt1.hidden =  YES  ;
    _labelText.hidden = YES  ;

}


-(void) newExercises  {
    [self p_PlusSumLessNumber:10];
    

    
}

// 2个数相加 之和小于 seed  ,比如
-(void) p_PlusSumLessNumber:(NSInteger)sumSeed {
    sumSeed += 1 ;
    NSInteger left  = arc4random() % sumSeed;
    NSInteger right = arc4random() % (sumSeed - left)  ;
    
    _strAnwser  = [NSString stringWithFormat:@"%ld" , (left + right)];
    _stringRead  = [NSString stringWithFormat:@"%ld + %ld = 多少" ,left ,right] ;
    _labelText.text = [NSString stringWithFormat:@"%ld + %ld = ?" ,left ,right] ;
    
//    __weak typeof(self) weakSelf = self ;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        typeof(self) theSelf = weakSelf ;
//        [theSelf speakText:self.stringRead];
//    });
    
    [self speakText:_stringRead];
    
    [_mutaSetOptResult removeAllObjects];
    
    //填入结果
    NSNumber *sum = @(left + right) ;
    [_mutaSetOptResult addObject:sum];
    
    
    //填入另外的结果
    while ([_mutaSetOptResult count] < 2) {
         NSNumber *sum_opt = @(arc4random() % sumSeed) ;
        [_mutaSetOptResult addObject:sum_opt];
    }
   
    
    
    
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    [_mutaArrayResult removeAllObjects];
    _mutaArrayResult = [[_mutaSetOptResult sortedArrayUsingDescriptors:sortDesc] mutableCopy] ;
    

    _labelOpt1.text = [NSString stringWithFormat:@"%@" , _mutaArrayResult[0] ] ;
    _labelOpt2.text = [NSString stringWithFormat:@"%@" , _mutaArrayResult[1] ] ;

    
//    NSEnumerator * en = [_mutaSetOptResult objectEnumerator];
//    NSNumber * value;
//    [_mutaArrayResult removeAllObjects];
//    while (value = [en nextObject]) {
//        //NSLog(@"value %@",value);
//        [_mutaArrayResult addObject:value];
//    }
    
}



//再来一次
- (IBAction)clickAgain:(id)sender {
    if ([_btnNext.titleLabel.text isEqualToString:@"开始"]) {
        [_btnNext setTitle:@"再来一次"  forState:UIControlStateNormal]; 
    }
    
    _labelOpt2.hidden  = YES  ;
    _labelOpt1.hidden =  YES  ;
    _labelText.hidden = YES  ;
    
    
    _labelText.text  =@""  ;
    _labelOpt1.text  = @""  ;
    _labelOpt2.text = @""  ;
    
    _labelOpt1.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2] ;
    _labelOpt2.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2] ;
    
    [self newExercises]  ;
    
    
    [UIView animateWithDuration:1 animations:^{
        _labelOpt1.hidden  =  NO  ;
        _labelOpt2.hidden  =  NO;
        _labelText.hidden  =  NO  ;
    }] ;
    
   
}


-(void) tapLableShowAnswer:(UITapGestureRecognizer*)tap {
    NSLog(@"[tapLableShowAnswer] %@" ,tap)  ;
    UILabel *label = (UILabel*)tap.view  ;
    
    if ([label.text isEqualToString:_strAnwser]) {
        //?
        
        [self speakText:@"Yes"] ;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse  animations:^{
            label.backgroundColor = [UIColor greenColor] ;
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else {
        [self speakText:@"NO"] ;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse  animations:^{
            label.backgroundColor = [UIColor redColor] ;
        } completion:^(BOOL finished) {
            ;
        }];
    }
    
}

-(AVSpeechSynthesizer*) speechSynthesizer {
    if (! _speechSynthesizer ) {
         _speechSynthesizer = [[AVSpeechSynthesizer alloc]init];
    }
    
    return _speechSynthesizer ;
}


-(void) speakText:(NSString*)strText {
    
 //   __weak typeof (self) weakSelf =  self  ;
 //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //   typeof(self) theSelf = weakSelf  ;
//        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:strText];
//        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
//        utterance.voice = voice;
//        utterance.rate= AVSpeechUtteranceDefaultSpeechRate ;  //设置语速
//    
//        [_speechSynthesizer speakUtterance:utterance];
  //  });
    
    
 
    
    [mySpeechSynthesizer speakText:strText];
}

// 测试读取文字
- (IBAction)testReadText:(id)sender {
    
  }


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance  {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _labelOpt1.userInteractionEnabled = NO  ;
        _labelOpt2.userInteractionEnabled = NO  ;
        _btnNext.userInteractionEnabled = NO  ;
        
        _labelOpt2.alpha = 0.3 ;
        _labelOpt1.alpha = 0.3 ;
        _btnNext.alpha = 0.3 ;
    }];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    
    [UIView animateWithDuration:0.3 animations:^{
        _labelOpt1.userInteractionEnabled = YES  ;
        _labelOpt2.userInteractionEnabled = YES   ;
        
        _btnNext.userInteractionEnabled = YES  ;
        
        _labelOpt2.alpha = 1.0 ;
        _labelOpt1.alpha = 1.0 ;
        _btnNext.alpha = 1.0;
    }];
    
    
   
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    [UIView animateWithDuration:0.3 animations:^{
        _labelOpt1.userInteractionEnabled = YES  ;
        _labelOpt2.userInteractionEnabled = YES   ;
        
        _btnNext.userInteractionEnabled = YES  ;
        
        _labelOpt2.alpha = 1.0 ;
        _labelOpt1.alpha = 1.0 ;
        _btnNext.alpha = 1.0;
    }];
}


@end
