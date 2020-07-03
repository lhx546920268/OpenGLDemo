//
//  OLDGraphicsViewController.m
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import "OLDGraphicsViewController.h"
#import "OLDGLView.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES3/gl.h>
#import "OLDGLHelper.h"

@interface OLDGraphicsViewController ()
{
    GLuint _renderbuffer;
    GLuint _framebuffer;
    EAGLContext *_context;
}

@end

@implementation OLDGraphicsViewController

- (void)dealloc
{
    //释放缓冲区
    if(_renderbuffer){
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = 0;
    }
    
    if(_framebuffer){
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    
    //清除上下文
    if(EAGLContext.currentContext == _context){
        EAGLContext.currentContext = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //三角形
    OLDGLData triangleData[] = {
        {-1, -1, 0, 0, 1, 0, 1},
        {1, -1, 0, 0, 1, 0, 1},
        {0, 1, 0, 0, 1, 0, 1}
    };
    
    OLDGLView *view = [[OLDGLView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 200) / 2, 100, 200, 200)];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawTriangle:)]];
    [view drawWithData:triangleData size:sizeof(triangleData) backgroundColor:UIColor.redColor];
    [self.view addSubview:view];

    //矩形
    OLDGLData rectangleData[] = {
        {-0.8, -0.8, 0, 0, 1, 0, 1},
        {0.8, -0.8, 0, 0, 1, 0, 1},
        {-0.8, 0.8, 0, 0, 1, 0, 1},
        {0.8, 0.8, 0, 0, 1, 0, 1}
    };
    
    view = [[OLDGLView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 200) / 2, 320, 200, 200)];
    [view drawWithData:rectangleData size:sizeof(rectangleData) backgroundColor:UIColor.redColor];
    [self.view addSubview:view];
    
    //圆
    GLfloat radius = 0.8;
    GLsizeiptr numberOfArc = 100; //圆弧数量
    GLfloat arc = M_PI * 2 / numberOfArc; //每份圆弧
    OLDGLData circleData[numberOfArc];

    //计算圆上的点 x,y 半径不一致就变成椭圆了
    for(GLsizeiptr i = 0;i < numberOfArc;i ++){
        GLfloat x = radius * cos(arc * i);
        GLfloat y = radius * sin(arc * i);
        circleData[i] = (OLDGLData){x, y, 0, 0, 1, 0, 1};
    }
    
    view = [[OLDGLView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 200) / 2, 540, 200, 200)];
    view.drawMode = GL_TRIANGLE_FAN;
    [view drawWithData:circleData size:sizeof(circleData) backgroundColor:UIColor.redColor];
    [self.view addSubview:view];
}

- (void)drawTriangle:(UITapGestureRecognizer*) tap
{
    OLDGLView *view = (OLDGLView*)tap.view;
    //三角形
    OLDGLData triangleData[] = {
        {-1, -1, 0, 1, 0, 0, 1},
        {1, -1, 0, 0, 1, 0, 1},
        {0, 1, 0, 0, 0, 1, 1}
    };
    [view drawWithData:triangleData size:sizeof(triangleData) backgroundColor:UIColor.cyanColor];
}

- (void)drawRectangle
{
    
}

- (void)drawCircle
{
    
}


@end
