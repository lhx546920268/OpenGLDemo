//
//  OLDGLHelper.m
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import "OLDGLHelper.h"

@implementation OLDGLHelper

+ (void)loadShaderWithCode:(NSString *)code type:(GLenum)type program:(GLuint)program
{
    /**
     创建一个着色器对象
     @param type 着色类型，GL_VERTEX_SHADER（顶点着色器），GL_FRAGMENT_SHADER（片段着色器）
     */
    GLuint shader = glCreateShader(type);
    const GLchar* string = (GLchar*)code.UTF8String;
    
    /**
     填充着色器代码
     @param shader 着色器对象
     @param count 数组长度，如果只有一个字符串，传1
     @param string 代码字符串数组指针
     @param length 代码字符串数组里面每个字符串的长度，传NULL则表示每个字符串都以null结尾
     */
    glShaderSource(shader, 1, &string, NULL);
    
    //编译着色器
    glCompileShader(shader);
    
    GLint success;
    /**
     获取对应的参数值
     @param pname 参数名称
     GL_SHADER_TYPE 着色器类型 GL_VERTEX_SHADER，GL_FRAGMENT_SHADER

     GL_DELETE_STATUS 是否已删除 GL_TRUE或GL_FALSE

     GL_COMPILE_STATUS 是否编译成功 GL_TRUE或GL_FALSE

     GL_INFO_LOG_LENGTH 日志长度

     GL_SHADER_SOURCE_LENGTH 源码长度
     */
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if(!success){
        GLint length;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &length);
        
        GLchar infoLog[length];
        glGetShaderInfoLog(shader, (GLsizei)sizeof(infoLog), 0, &infoLog[0]);
        
        NSLog(@"%@", code);
        NSLog(@"Complie shader error %@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
    }
    
    //关联program和着色器
    glAttachShader(program, shader);
    
    //释放着色器
    glDeleteShader(shader);
}

+ (void)loadShaderWithFileName:(NSString *)fileName type:(GLenum)type program:(GLuint)program
{
    NSURL *URL = [NSBundle.mainBundle URLForResource:fileName withExtension:@"glsl"];
    NSString *code = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
    return [self loadShaderWithCode:code type:type program:program];
}

@end
