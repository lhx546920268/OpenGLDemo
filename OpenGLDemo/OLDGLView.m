//
//  OLDGLView.m
//  OpenGLDemo
//
//  Created by 罗海雄 on 2020/7/2.
//  Copyright © 2020 luohaixiong. All rights reserved.
//

#import "OLDGLView.h"
#import "OLDGLHelper.h"

@interface OLDGLView ()
{
    GLuint _renderbuffer;
    GLuint _framebuffer;
    GLuint _buffer;
    EAGLContext *_context;
}

@end

@implementation OLDGLView

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
    
    if(_buffer){
        glDeleteBuffers(1, &_buffer);
        _buffer = 0;
    }
    
    //清除上下文
    if(EAGLContext.currentContext == _context){
        EAGLContext.currentContext = nil;
    }
}

+ (Class)layerClass
{
    return CAEAGLLayer.class;
}

- (CAEAGLLayer *)glLayer
{
    return (CAEAGLLayer*)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawMode = GL_TRIANGLE_STRIP;
        [self pepareToDraw];
    }
    return self;
}

- (void)pepareToDraw
{
    //初始化上下文
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    EAGLContext.currentContext = _context;
    
    /**
     设置绘制区域 起始坐标是左下角
     */
    glViewport(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    //设置渲染缓冲区
    /**
     创建渲染缓冲区
     @param n 缓冲区数量，如果缓冲区是数组，就传对应数组长度，否则传1
     @param renderbuffers 缓冲区，可以是数组，也可以是一个 GLuint 变量
     */
    glGenRenderbuffers(1, &_renderbuffer);
    
    /**
     绑定渲染缓冲区
     @param target 缓冲区的目标，值必须是 GL_RENDERBUFFER
     @param renderbuffer 要绑定的缓冲区
     */
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer]; //与layer绑定，为渲染缓冲区分配内存
    
    //设置帧缓冲区
    /**
    创建帧缓冲区
    @param n 缓冲区数量，如果缓冲区是数组，就传对应数组长度，否则传1
    @param framebuffers 缓冲区，可以是数组，也可以是一个 GLuint 变量
    */
    glGenFramebuffers(1, &_framebuffer);
    
    /**
    绑定帧缓冲区
    @param target 缓冲区的目标，值必须是 GL_FRAMEBUFFER
    @param framebuffer 要绑定的缓冲区
    */
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    
    /**
     将渲染缓冲区挂载在帧缓冲区
     @param target 指定帧缓冲区的的对象 值必须是
     GL_DRAW_FRAMEBUFFER（写）, GL_READ_FRAMEBUFFER（读）, or GL_FRAMEBUFFER. GL_FRAMEBUFFER和GL_DRAW_FRAMEBUFFER是相等的
     @param attachment 挂载点，值必须是
     GL_COLOR_ATTACHMENTi（颜色，i的范围是 0~GL_MAX_COLOR_ATTACHMENTS-1），GL_DEPTH_ATTACHMENT（深度），GL_STENCIL_ATTACHMENT（模板），GL_DEPTH_STENCIL_ATTACHMENT（深度和模板）
     @param renderbuffertarget 渲染缓冲区的对象，值必须是 GL_RENDERBUFFER
     @param renderbuffer 渲染缓冲区
     */
    glFramebufferRenderbuffer(GL_READ_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);
    
    /**
     创建顶点数据缓冲区
     @param n 缓冲区数量，如果缓冲区是数组，就传对应数组长度，否则传1
     @param buffers 缓冲区，可以是数组，也可以是一个 GLuint 变量
     */
    glGenBuffers(1, &_buffer);
    glBindBuffer(GL_ARRAY_BUFFER, _buffer); //绑定顶点数据缓冲区
}

- (void)drawWithData:(const OLDGLData *)data size:(GLsizeiptr)size backgroundColor:(UIColor *)backgroudColor
{
    EAGLContext.currentContext = _context;
    
    CGFloat red, green, blue, alpha;
    [backgroudColor getRed:&red green:&green blue:&blue alpha:&alpha];
    /**
     预设背景颜色，值是RGBA，范围都是0 ~ 1.0
     */
    glClearColor(red, green, blue, alpha);
    /**
     通过预设值来刷新缓冲区
     @param mask 可选值有 GL_DEPTH_BUFFER_BIT（深度），GL_STENCIL_BUFFER_BIT（模板），GL_COLOR_BUFFER_BIT（颜色），类似OC的Options枚举，可多选
     */
    glClear(GL_COLOR_BUFFER_BIT);
    
    //创建一个 program
    GLuint program = glCreateProgram();
    [OLDGLHelper loadShaderWithFileName:@"vertexShader" type:GL_VERTEX_SHADER program:program];
    [OLDGLHelper loadShaderWithFileName:@"fragmentShader" type:GL_FRAGMENT_SHADER program:program];
    
    //链接 program
    glLinkProgram(program);
    
    GLint success;
    /**
     从program获取对应的参数值
     @param pname 参数名称
     GL_DELETE_STATUS 是否已删除 GL_TRUE或GL_FALSE

     GL_LINK_STATUS 是否链接成功（glLinkProgram），GL_TRUE或GL_FALSE

     GL_VALIDATE_STATUS 最后一次验证是否成功（glValidateProgram） GL_TRUE或GL_FALSE

     GL_INFO_LOG_LENGTH 获取日志长度

     GL_ATTACHED_SHADERS 添加到program（glAttachShader）中着色器的数量

     GL_ACTIVE_ATTRIBUTES 激活的属性数量

     GL_ACTIVE_ATTRIBUTE_MAX_LENGTH 最大属性名称的长度

     GL_ACTIVE_UNIFORMS 激活的统一变量数量

     GL_ACTIVE_UNIFORM_MAX_LENGTH 最大统一变量名称的长度
     
     @param params 参数值
     */
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if(success){
        glUseProgram(program); //链接成功后使用
    }else{
        GLint length;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &length);
        
        GLchar infoLog[length];
        glGetProgramInfoLog(program, (GLsizei)sizeof(infoLog), 0, &infoLog[0]);
        
        NSLog(@"Link program error %@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
    }
    
    //填充数据
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
    
    
    GLuint positionIndex = glGetAttribLocation(program, "position"); //获取着色器的字段索引
    
    /**
     给顶点着色器赋值
     @param index 字段索引
     @param size 数据数量，比如位置 xyz就传3，颜色rgba就传4
     @param type 数据类型 GL_BYTE GL_UNSIGNED_BYTE GL_SHORT GL_UNSIGNED_SHORT GL_FIXED GL_FLOAT
     @param normalized 是否将数据标准化 GL_TRUE GL_FALSE
     @param stride 顶点数据 步数，就像 for循环中  i += n
     @param pointer 同一组数据内的偏移量
     */
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, GL_FALSE, sizeof(OLDGLData), NULL + offsetof(OLDGLData, x));
    
    /**
     启动顶点数据
     @param index 字段索引
     */
    glEnableVertexAttribArray(positionIndex);
    
    GLuint colorIndex = glGetAttribLocation(program, "color");
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, GL_FALSE, sizeof(OLDGLData), NULL + offsetof(OLDGLData, r));
    glEnableVertexAttribArray(colorIndex);
    
    /**
     绘制图元
     @param mode 绘制模式
     GL_POINTS 绘制一个点
     GL_LINE_STRIP 所有按顺序点连接起来
     GL_LINE_LOOP 绘制线
     GL_LINES
     GL_TRIANGLE_STRIP 绘制三角形，每次都取前面2个点和当前点组合
     GL_TRIANGLE_FAN 绘制三角形，每次都取第一点，当前点，前一个点组合
     GL_TRIANGLES 绘制三角形，点不重复使用，如果点不够3个，会丢弃
     @param first 起始位置
     @param count 要绘制的数量
     */
    glDrawArrays(self.drawMode, 0, (GLsizei)(size / sizeof(GLfloat) / 7));
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    glDeleteProgram(program);
}

@end
