.data
	matrice:.space 40000
	n:.space 4
	nrleg:.space 400
	indice:.space 4
	citiri:.space 4
	nr:.data 4
	aux_citire: .data 4
	indicel:.space 4
	indicec:.space 4
	left:.space 4
	right:.space 4
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	newLine: .asciz "\n"
	c:.space 4
	
.text

.global main

main:
	#citire cerinta
	pushl $c
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	#citire nr de noduri
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	xorl %ecx,%ecx #reinitializam %ecx-contor
	lea nrleg, %edi #vectorul in care memoram cate legaturi are fiecare nod (nrleg[i]=j <=> nodul i are j leg)

et_for:
	cmp %ecx, n 
	je cont
	
	pushl %ecx
	pushl $aux_citire
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	popl %ecx
	
	movl aux_citire, %ebx
	movl %ebx,(%edi,%ecx,4) 
	
	incl %ecx
	jmp et_for
	
cont:
	movl $0,indice #contor,  reprezinta nodul ot care citim legaturile
	lea nrleg, %edi
	
et_constr: 
	#construim marricea
	movl indice, %ecx 
	cmp %ecx, n
	je et_afis
	
	movl indice, %ebx
	movl %ebx, left #in matrice pe pozitia [left][right] vom pune 1, unde left reprezinta nodul curent iar right nodul cu care are legatura
	movl (%edi,%ecx,4),%ebx
	
	xor %ecx,%ecx
	
	et_for1:
		cmp %ecx,%ebx
		je conti
		
		pushl %ecx
		pushl %ebx
		pushl $right
		pushl $formatScanf
		call scanf
		popl %ebx
		popl %ebx
		popl %ebx
		popl %ecx
		 
		movl left,%eax
		movl $0, %edx
		mull n
		addl right,%eax #eax<-left*n+right
		lea matrice, %edi
		movl $1,(%edi,%eax,4)
		
		incl  %ecx
		jmp et_for1
	conti:
		lea nrleg, %edi
		incl indice
		jmp et_constr
et_afis:
	movl $0, indicel
	for_linii:
		movl indicel, %ecx
		cmp %ecx, n
		je et_exit
		movl $0, indicec
		
		for_coloane:
			movl indicec, %ecx
			cmp %ecx, n
			je cont0
			
			movl indicel, %eax
			movl $0, %edx
			mull n
			addl indicec, %eax
			lea matrice, %edi
			movl (%edi, %eax, 4), %ebx
			
			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			
			pushl $0
			call fflush
			popl %ebx
			
			incl indicec
			jmp for_coloane
			
	cont0:
		
		pushl $newLine
		call printf
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
		
		incl indicel
		jmp for_linii

et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
