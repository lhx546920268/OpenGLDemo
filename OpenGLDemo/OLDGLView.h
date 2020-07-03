//
//  OLDGLView.h
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct{
    GLfloat x, y, z;
    GLfloat r, g, b, a;
} OLDGLData;

///用于显示 OpenGL内容
@interface OLDGLView : UIView

///用于绘制OpenGL内容的图层
@property(nonatomic, readonly) CAEAGLLayer *glLayer;

///绘制模式 默认 GL_TRIANGLE_STRIP
@property(nonatomic, assign) GLenum drawMode;

- (void)drawWithData:(const OLDGLData*) data size:(GLsizeiptr) size backgroundColor:(UIColor*) backgroudColor;

@end

NS_ASSUME_NONNULL_END
