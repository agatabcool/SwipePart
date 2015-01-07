//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

static const float CARD_HEIGHT = 456; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card

//delegate is instance of ViewController
@synthesize delegate;

@synthesize panGestureRecognizer;
@synthesize information;
@synthesize overlayView;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
//        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
//        imageView = [[UIImageView alloc] initWithFrame:contentView.frame];
//        imageView.image = [UIImage imageNamed:@"nycme"];
//        [self addSubview:imageView];
//        
//       // [self createContentView];
//        
         [self addSubview:[self createContentView]];
        NSLog(@"%f %f ", frame.size.height, frame.size.width);
        
#warning placeholder stuff, replace with card-specific information {
//        information = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 100)];
////        information.text = @"no info given";
//        [information setTextAlignment:NSTextAlignmentCenter];
//        information.textColor = [UIColor blackColor];
//
//        _photoinfo = [[UIImageView alloc] initWithImage :
//                                    [UIImage imageNamed :@"purpleflowers"]];
        
       // _photoinfo = [[UIImageView alloc] imageNamed:@"purpleflowers"];
        
        //[self addSubview:_photoinfo ];
       // photoinfo =
        
        self.backgroundColor = [UIColor whiteColor];
#warning placeholder stuff, replace with card-specific information }
        
        
        
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
        [self addSubview:information];
        //imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noButton"]];
       //
      //  UIImage* image = [UIImage imageName:@"nycme"];
//        UIImage* smallImage2 = [image2 scaleToSize:CGSizeMake(100.0f,100.0f)];
//        
        
//        UIView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nycme"]];
//        [self addSubview:contentView];
       //  [self constructImageView:image];
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}
//
//- (void)constructImageView:(UIImage *)image {
//    CGFloat topPadding = 10.f;
//    CGRect frame = CGRectMake(floorf((CGRectGetWidth(self.bounds) - image.size.width)/2),
//                              topPadding,
//                              image.size.width,
//                              image.size.height);
//    self.imageView = [[UIImageView alloc] initWithFrame:frame];
//    self.imageView.image = image;
//    [self addSubview:self.imageView];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)createContentView
{
    int value = (arc4random() % 8);
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    imageView = [[UIImageView alloc] initWithFrame:contentView.frame];
    
    switch (value) {
        case 0:
            imageView.image = [UIImage imageNamed:@"mama1"];
            break;
        case 1:
            imageView.image = [UIImage imageNamed:@"nycme"];
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"hugh"];
            break;
        case 3:
            imageView.image = [UIImage imageNamed:@"me2"];
            break;
        case 4:
            imageView.image = [UIImage imageNamed:@"demo-bg"];
            break;
        case 5:
            imageView.image = [UIImage imageNamed:@"ws2"];
            break;
        case 6:
            imageView.image = [UIImage imageNamed:@"greenpurple"];
            break;
        default:
            imageView.image = [UIImage imageNamed:@"flowers"];
            break;
    }
    
    [contentView addSubview:imageView];
    
    
    return contentView;
}


//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}



@end
