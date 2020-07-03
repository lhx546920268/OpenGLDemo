//
//  OLDGLHelper.h
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

///OpenGL帮助类
@interface OLDGLHelper : NSObject

///加载着色器
+ (void)loadShaderWithCode:(NSString*) code type:(GLenum) type program:(GLuint) program;
+ (void)loadShaderWithFileName:(NSString*) fileName type:(GLenum) type program:(GLuint) program;

@end

NS_ASSUME_NONNULL_END
