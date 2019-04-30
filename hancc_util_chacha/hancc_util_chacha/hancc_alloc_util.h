//
//  alloc.h
//  rrrr
//
//  Created by 韩帆 on 2019/4/28.
//  Copyright © 2019 hancc. All rights reserved.
//

#ifndef HANCC_ALLOC_UTIL_H
#define HANCC_ALLOC_UTIL_H

#include <stdio.h>

/**
 申请内存
 @param size 申请的内存块大小
 @return 返回申请的内存的首地址，失败返回NULL
 */
void *hancc_mem_malloc(unsigned size);
/**
 释放指定的内存块

 @param p 要释放的内存块首地址
 */
void hancc_mem_free(void *p);







/**
 打印内存系统中每一个内存块的信息
 */
void hancc_mem_block_print(void);
/**
 打印指定内存块的内容
 @param buf 指定内存块的首地址
 @param len 指定内存块的大小
 */
void hancc_buffer_print(unsigned char *buf,unsigned int len);
/**
 打印整个内存区的内容
 */
void hancc_mem_print(void);
#endif /* alloc_h */
