//
//  cplus.c
//  GTKit
//
//  Created by wstt on 13-1-25.
//  Copyright (c) 2013年 wstt. All rights reserved.
//

#include <stdio.h>
#include "cplus.h"

#import <GT/GTInterface.h>

void func_cplusTest()
{
    GT_IN_REGISTER("Double", "Double", "123");
    GT_IN_SET("Double", true, "1");
    GT_IN_SET("Double", true, "2");
    //注册输入参数 string类型
    GT_IN_REGISTER("STRING", "String", "String");
    GT_IN_REGISTER("Float", "Float", "2.3");
    GT_IN_REGISTER("Bool", "Bool", "1");
    GT_IN_REGISTER("Integer", "Integer", "5");

    //注册输入参数 array类型
    char* array[] = {"10051001121021132225400", "10051550121021160734240"};
    GT_IN_REGISTER_ARRAY("Array", "Array", array, 2);
    
//    GT_IN_REGISTER("Double", "Double1", "7.9");
//    GT_IN_REGISTER("STRING", "String1", "String");
//    GT_IN_REGISTER("Float", "Float1", "2.3");
//    GT_IN_REGISTER("Bool", "Bool1", "1");
//    GT_IN_REGISTER("Integer", "Integer1", "5");
    
    GT_OUT_REGISTER("Name", "Name", "HANNAH_LIAO");
    GT_OUT_REGISTER("Device", "DEV", "iPhone yyyy");
    
    //输出参数注册
    GT_OUT_REGISTER("URLInfo", "URLInfo", "");
//    GT_OUT_REGISTER("Name", "名字", "gGGabcdefghigale");
//    GT_OUT_REGISTER("姓名", "姓名", "背景上回将来大家佛汇集及附近诶的金额讴歌");
    
    //默认在AC显示的输入输出参数，最多三个
    GT_IN_DEFAULT_ON_AC("Double", "数组", "Bool");
    
}