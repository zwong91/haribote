; initial program loader 引导器 -> grub
; TAB=4
; 二进制-->16进制语言编辑器(机器语言) ->(汇编器nasm) 汇编语言 ->(obj ld link compiler) C语言 迭代过程
; 电信号on/off 抽象为0/1, 1GB=1024MB，1MB=1024KB，1KB=1024byte，1字节byte=8比特bit（8位0和1)
; 1Byte电信号集合 和文字编码ASCII映射
; DB（define byte） 声明字节：往文件里写入1个字节的指令, 直接输入字符串，汇编编译器自动转换为十六进制编码
; DW（difine word），word是16位bit = 2个byte
; DD（difine double-word）,double-word是32位bit = 4个byte
; RESB（reserve byte）预定字节：从当前行数到指定行数自动填充0x00

		ORG		0x7c00			; 指明程序装载地址, 0x00007c00-0x00007dff

; 标准FAT12格式软盘专用的代码 Stand FAT12 format floppy code

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		; 启动扇区名称（8字节）
		DW		512				; 每个扇区（sector）大小（必须512字节）
		DB		1				; 簇（cluster）大小（必须为1个扇区）
		DW		1				; FAT起始位置（一般为第一个扇区）
		DB		2				; FAT个数（必须为2）
		DW		224				; 根目录大小（一般为224项）
		DW		2880			; 该磁盘大小（必须为2880扇区1440*1024/512）
		DB		0xf0			; 磁盘类型（必须为0xf0）
		DW		9				; FAT的长度（必??9扇区）
		DW		18				; 一个磁道（track）有几个扇区（必须为18）
		DW		2				; 磁头数（必??2）
		DD		0				; 不使用分区，必须是0
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 意义不明（固定）
		DD		0xffffffff		; （可能是）卷标号码
		DB		"HELLO-OS   "	; 磁盘的名称（必须为11字?，不足填空格）
		DB		"FAT12   "		; 磁盘格式名称（必??8字?，不足填空格）
		RESB	18				; 先空出18字节

; 程序主体

entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX

		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; 给SI加1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
fin:
		HLT						; 让CPU待机，毫无意义的空转, 等待指令
		JMP		fin				; 无限循环

msg:
		DB		0x0a, 0x0a		; 换行两次
		DB		"hello, world"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 填写0x00直到0x001fe, $ 当前该行

		DB		0x55, 0xaa		;第510 511 字节必须以0x55 0xaa结尾
