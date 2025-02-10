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
code:
; Image Thunk Data / Import Address Directory
iatbl:
    dq symbol
    dq 0
iatbl_size equ $-iatbl
    times 1 dw 0
                                                ; [UNUSED] e_cparhdr
                                                ; [UNUSED] e_minalloc
                                                ; [UNUSED] e_maxalloc
                                                ; [UNUSED] e_ss
                                                ; [UNUSED] e_sp
                                                ; [UNUSED] e_csum
                                                ; [UNUSED] e_ip
                                                ; [UNUSED] e_cs
                                                ; [UNUSED] e_lfarlc

dll_name:
    db 'USER32.dll', 0
    db 0
                                                ; [UNUSED] e_ovno
                                                ; [UNUSED] 3 dw of e_res

                                                ; [UNUSED] 1 dw of e_res
                                                ; [UNUSED] e_oemid
; Strings
title:
    db 'H',0,'i',0,0x3d,0xd8,0x4b,0xdc,0,0

                                                ; [UNUSED] e_oeminfo
                                                ; [UNUSED] 4 dw of e_res2

content:
    db 'H',0,'e',0,'l',0,'l',0,'o',0,0,0        ; [UNUSED] 6 dw of e_res2

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
    dd entry_0                     ; AddressOfEntryPoint
    dd code                        ; BaseOfCode

    dq 0x0004_2000_0000            ; ImageBase
    dd 0x10                        ; SectionAlignment
    dd 0x10                        ; FileAlignment
entry_3:                                           ; [UNUSED] MajorOperatingSystemVersion
    lea rdx, [byte r8-(content - title)]           ; [UNUSED] MinorOperatingSystemVersion
    jmp [byte rdx - (title-iatbl)]  ; MessageBoxW  ; [UNUSED] MajorImageVersion
    times 8-($-entry_3) db 0xCC                    ; [UNUSED] MinorImageVersion

    dw 4                           ; MajorSubsystemVersion
    dw 0                           ; MinorSubsystemVersion
    dd 0                           ; Reserved1
    dd file_size                   ; SizeOfImage
    dd hdr_size                    ; SizeOfHeaders
    dd 0                           ; CheckSum
    dw IMAGE_SUBSYSTEM_WINDOWS_GUI ; Subsystem (Windows GUI)
                                   ; DllCharacteristics
    dw IMAGE_DLLCHARACTERISTICS    ; DllCharacteristics

    dq 0x000000                    ; SizeOfStackReserve
    dq 0x0000                      ; SizeOfStackCommit
    dq 0x000000                    ; SizeOfHeapReserve
    dq 0x0000                      ; SizeOfHeapCommit

    dd 0                           ; LoaderFlags
    dd 2                           ; NumberOfRvaAndSizes

; Optional Header, Data Directories
entry_2:                              ; [UNUSED] Export, RVA (dd)
    mov r9d, 0x00240040               ; [UNUSED] Export, Size (dd)
    jmp entry_3
    times 8-($-entry_2) db 0xCC

opt_hdr_size equ $-opt_hdr

; Section Table
    ; collapse import rva onto section table name, note this shrinks SizeOfOptionalHeader

    dd itbl                 ; Import, RVA
    dd itbl_size            ; Import, Size

    dd sect_size            ; VirtualSize
    dd section_start        ; VirtualAddress
    dd code_size            ; SizeOfRawData
    dd section_start        ; PointerToRawData
entry_1:
    lea r8, [rdx - entry_0 + content]
    jmp entry_2
    times 12-($-entry_1) db 0xCC
                                   ; [UNUSED] PointerToRelocations
                                   ; [UNUSED] PointerToLinenumbers
                                   ; [UNUSED] NumberOfRelocations
                                   ; [UNUSED] NumberOfLinenumbers
    dd 0x60000020           ; Characteristics

hdr_size equ $-$$

; Entry

section_start:

symbol: ; 16 bytes
    dw 0                    ; [UNUSED] Function Order
    db 'MessageBoxW', 0     ; Function Name

; Import Directory
itbl:
    dq 0                    ; OriginalFirstThunk

entry_0:                    ; [UNUSED] TimeDateStamp
    xor ecx, ecx ; hWnd
    jmp entry_1
    times 4-($-entry_0) db 0xCC

    dd dll_name             ; ForwarderChain
    dd iatbl                ; Name
    dq 0                    ; FirstThunk
itbl_size equ $-itbl
    ; can't get rid of this :|
    times 6 dq 0

sect_size equ $-section_start

code_size equ align($-section_start, 16)
file_size equ $-$$
