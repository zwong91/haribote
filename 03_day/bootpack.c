/* 告诉C编译器，有一个函数在别的文件里 */

void io_hlt(void);
/* 是函数声明却不用{}，而用;，这表示的意思是：
	函数在别的文件中，你自己找一下 */

/* 
bootpack.c 编译链接过程: 生成haribote.sys

1. bootpack.c  cc1.exe--> bootpack.gas  gas2nask.exe---> bootpack.nas
2. bootpack.nas nask.exe --> bootpack.obj obj2bim.exe --> bootpack.bim
3. bootpack.bim bim2hrb.exe --> bootpack.hrb
4. asmhead.bin + bootpack.hrb  copy ---> haribote.sys

*/
// Haribote 哈利波特, 主函数作用为休眠省电功能, 1度电 = 5毛
void HariMain(void)
{
fin:
	io_hlt(); /* 执行naskfunc.nas中的_io_hlt函数 */
	goto fin;

}
