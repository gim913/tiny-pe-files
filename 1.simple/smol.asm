BITS 64

%define align(n,r) (((n+(r-1))/r)*r)

%define IMAGE_FILE_MACHINE_AMD64 0x8664

%define IMAGE_FILE_EXECUTABLE_IMAGE 0x02
%define IMAGE_FILE_LARGE_ADDRESS_AWARE 0x20
%define IMAGE_SUBSYSTEM_WINDOWS_GUI 2

%define IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA 0x20
%define IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE 0x40
%define IMAGE_DLLCHARACTERISTICS_NX_COMPAT 0x100
%define IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE 0x8000

%define IMAGE_DLLCHARACTERISTICS IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA | IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE | IMAGE_DLLCHARACTERISTICS_NX_COMPAT

%define MB_ICONINFORMATION 0x00000040
%define MB_TOPMOST 0x00040000
%define MB_SERVICE_NOTIFICATION 0x00200000

%define MB_TYPE MB_ICONINFORMATION | MB_TOPMOST | MB_SERVICE_NOTIFICATION

; DOS Header
    dw 'MZ'                 ; e_magic
    dw 0                    ; [UNUSED] e_cblp
    dw 0                    ; [UNUSED] c_cp
    dw 0                    ; [UNUSED] e_crlc
    dw 0                    ; [UNUSED] e_cparhdr
    dw 0                    ; [UNUSED] e_minalloc
    dw 0                    ; [UNUSED] e_maxalloc
    dw 0                    ; [UNUSED] e_ss
    dw 0                    ; [UNUSED] e_sp
    dw 0                    ; [UNUSED] e_csum
    dw 0                    ; [UNUSED] e_ip
    dw 0                    ; [UNUSED] e_cs
    dw 0                    ; [UNUSED] e_lfarlc
    dw 0                    ; [UNUSED] e_ovno
    times 4 dw 0            ; [UNUSED] e_res
    dw 0                    ; [UNUSED] e_oemid
    dw 0                    ; [UNUSED] e_oeminfo
    times 10 dw 0           ; [UNUSED] e_res2
    dd pe_hdr               ; e_lfanew

; PE Header
pe_hdr:
    dw 'PE', 0                     ; Signature

; Image File Header
    dw IMAGE_FILE_MACHINE_AMD64 ; Machine
    dw 0x01                     ; NumberOfSections
    dd 0                        ; [UNUSED] TimeDateStamp
    dd 0                        ; PointerToSymbolTable
    dd 0                        ; NumberOfSymbols
    dw opt_hdr_size             ; SizeOfOptionalHeader
                                ; Characteristics
    dw IMAGE_FILE_EXECUTABLE_IMAGE

; Optional Header, COFF Standard Fields
opt_hdr:
    dw 0x020b                      ; Magic (PE32+)
    db 0                           ; MajorLinkerVersion
    db 0                           ; MinorLinkerVersion
    dd code_size                   ; SizeOfCode
    dd 0                           ; SizeOfInitializedData
    dd 0                           ; SizeOfUninitializedData
    dd entry                       ; AddressOfEntryPoint
    dd iatbl                       ; BaseOfCode

    dq 0x0004_2000_0000            ; ImageBase
    dd 0x10                        ; SectionAlignment
    dd 0x10                        ; FileAlignment
    dw 1                           ; MajorOperatingSystemVersion
    dw 0                           ; MinorOperatingSystemVersion
    dw 0                           ; MajorImageVersion
    dw 0                           ; MinorImageVersion
    dw 4                           ; MajorSubsystemVersion
    dw 0                           ; MinorSubsystemVersion
    dd 0                           ; Reserved1
    dd file_size                   ; SizeOfImage
    dd hdr_size                    ; SizeOfHeaders
    dd 0                           ; CheckSum
    dw IMAGE_SUBSYSTEM_WINDOWS_GUI ; Subsystem (Windows GUI)
                                   ; DllCharacteristics
    dw IMAGE_DLLCHARACTERISTICS    ; DllCharacteristics
    dq 0x100000                    ; SizeOfStackReserve
    dq 0x1000                      ; SizeOfStackCommit
    dq 0x100000                    ; SizeOfHeapReserve
    dq 0x1000                      ; SizeOfHeapCommit
    dd 0                           ; LoaderFlags
    dd 0x10                        ; NumberOfRvaAndSizes

; Optional Header, Data Directories
    dd 0                    ; Export, RVA
    dd 0                    ; Export, Size
    dd itbl                 ; Import, RVA
    dd itbl_size            ; Import, Size
    dd 0                    ; Resource, RVA
    dd 0                    ; Resource, Size
    dd 0                    ; Exception, RVA
    dd 0                    ; Exception, Size
    dd 0                    ; Certificate, RVA
    dd 0                    ; Certificate, Size
    dd 0                    ; Base Relocation, RVA
    dd 0                    ; Base Relocation, Size
    dd 0                    ; Debug, RVA
    dd 0                    ; Debug, Size
    dd 0                    ; Architecture, RVA
    dd 0                    ; Architecture, Size
    dd 0                    ; Global Ptr, RVA
    dd 0                    ; Global Ptr, Size
    dd 0                    ; TLS, RVA
    dd 0                    ; TLS, Size
    dd 0                    ; Load Config, RVA
    dd 0                    ; Load Config, Size
    dd 0                    ; Bound Import, RVA
    dd 0                    ; Bound Import, Size
    dd iatbl                ; IAT, RVA
    dd iatbl_size           ; IAT, Size
    dd 0                    ; Delay Import Descriptor, RVA
    dd 0                    ; Delay Import Descriptor, Size
    dd 0                    ; CLR Runtime Header, RVA
    dd 0                    ; CLR Runtime Header, Size
    dd 0                    ; Reserved, RVA
    dd 0                    ; Reserved, Size

opt_hdr_size equ $-opt_hdr

; Section Table
    section_name db 'smol_1'     ; Name
    times 8-($-section_name) db 0
    dd sect_size            ; VirtualSize
    dd iatbl                ; VirtualAddress
    dd code_size            ; SizeOfRawData
    dd iatbl                ; PointerToRawData
    dd 0                    ; PointerToRelocations
    dd 0                    ; PointerToLinenumbers
    dw 0                    ; NumberOfRelocations
    dw 0                    ; NumberOfLinenumbers
    dd 0x60000020           ; Characteristics

hdr_size equ $-$$

code:
; Import Address Directory
iatbl:
    dq symbol
    dq 0

iatbl_size equ $-iatbl

; Strings
title:
    db 'H',0,'i',0,0x3d,0xd8,0x4b,0xdc,0,0
content:
    db 'H',0,'e',0,'l',0,'l',0,'o',0,0,0

; Entry
entry:
    mov r9d, MB_TYPE        ; uType
    lea r8, [rel title]     ; lpCaption
    lea rdx, [rel content]  ; lpText
    xor ecx, ecx            ; hWnd
    jmp [rel iatbl]         ; MessageBoxW

    times align($-$$,16)-($-$$) db 0xcc

; Import Directory
itbl:
    dq intbl                ; OriginalFirstThunk
    dd 0                    ; TimeDateStamp
    dd dll_name             ; ForwarderChain
    dd iatbl                ; Name
    dq 0                    ; FirstThunk

    times 3 dd 0

itbl_size equ $-itbl

; Import Name Table
intbl:
    dq symbol
    dq 0

; Symbol
symbol:
    dw 0                    ; [UNUSED] Function Order
    db 'MessageBoxW', 0     ; Function Name
dll_name:
    db 'USER32.dll', 0
    db 0

sect_size equ $-code
    times align($-$$,16)-($-$$) db 0

code_size equ $-code
file_size equ $-$$
