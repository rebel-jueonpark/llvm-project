; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=tahiti -verify-machineinstrs | FileCheck %s --check-prefix=SI
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s --check-prefix=VI
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=gfx1100 -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s --check-prefix=GFX11

define amdgpu_kernel void @madak_f16(
; SI-LABEL: madak_f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0xd
; SI-NEXT:    s_mov_b32 s11, 0xf000
; SI-NEXT:    s_mov_b32 s10, -1
; SI-NEXT:    s_mov_b32 s14, s10
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s12, s6
; SI-NEXT:    s_mov_b32 s13, s7
; SI-NEXT:    s_mov_b32 s15, s11
; SI-NEXT:    s_mov_b32 s2, s10
; SI-NEXT:    s_mov_b32 s3, s11
; SI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0
; SI-NEXT:    buffer_load_ushort v1, off, s[0:3], 0
; SI-NEXT:    s_mov_b32 s8, s4
; SI-NEXT:    s_mov_b32 s9, s5
; SI-NEXT:    s_waitcnt vmcnt(1)
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_madak_f32 v0, v0, v1, 0x41200000
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[8:11], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: madak_f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x34
; VI-NEXT:    s_mov_b32 s11, 0xf000
; VI-NEXT:    s_mov_b32 s10, -1
; VI-NEXT:    s_mov_b32 s14, s10
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s12, s6
; VI-NEXT:    s_mov_b32 s13, s7
; VI-NEXT:    s_mov_b32 s15, s11
; VI-NEXT:    s_mov_b32 s2, s10
; VI-NEXT:    s_mov_b32 s3, s11
; VI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0
; VI-NEXT:    buffer_load_ushort v1, off, s[0:3], 0
; VI-NEXT:    s_mov_b32 s8, s4
; VI-NEXT:    s_mov_b32 s9, s5
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_madak_f16 v0, v0, v1, 0x4900
; VI-NEXT:    buffer_store_short v0, off, s[8:11], 0
; VI-NEXT:    s_endpgm
;
; GFX11-LABEL: madak_f16:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[2:3], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[2:3], 0x34
; GFX11-NEXT:    s_mov_b32 s10, -1
; GFX11-NEXT:    s_mov_b32 s11, 0x31016000
; GFX11-NEXT:    s_mov_b32 s14, s10
; GFX11-NEXT:    s_mov_b32 s15, s11
; GFX11-NEXT:    s_mov_b32 s2, s10
; GFX11-NEXT:    s_mov_b32 s3, s11
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s12, s6
; GFX11-NEXT:    s_mov_b32 s13, s7
; GFX11-NEXT:    buffer_load_u16 v0, off, s[12:15], 0
; GFX11-NEXT:    buffer_load_u16 v1, off, s[0:3], 0
; GFX11-NEXT:    s_mov_b32 s8, s4
; GFX11-NEXT:    s_mov_b32 s9, s5
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_mul_f16_e32 v0, v0, v1
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_1)
; GFX11-NEXT:    v_add_f16_e32 v0, 0x4900, v0
; GFX11-NEXT:    buffer_store_b16 v0, off, s[8:11], 0
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) #0 {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %b.val = load half, ptr addrspace(1) %b

  %t.val = fmul half %a.val, %b.val
  %r.val = fadd half %t.val, 10.0

  store half %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @madak_f16_use_2(
; SI-LABEL: madak_f16_use_2:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx8 s[4:11], s[2:3], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x11
; SI-NEXT:    s_mov_b32 s15, 0xf000
; SI-NEXT:    s_mov_b32 s14, -1
; SI-NEXT:    s_mov_b32 s18, s14
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s16, s8
; SI-NEXT:    s_mov_b32 s17, s9
; SI-NEXT:    s_mov_b32 s19, s15
; SI-NEXT:    s_mov_b32 s8, s10
; SI-NEXT:    s_mov_b32 s9, s11
; SI-NEXT:    s_mov_b32 s10, s14
; SI-NEXT:    s_mov_b32 s11, s15
; SI-NEXT:    s_mov_b32 s2, s14
; SI-NEXT:    s_mov_b32 s3, s15
; SI-NEXT:    buffer_load_ushort v0, off, s[16:19], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v2, off, s[0:3], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v3, 0x41200000
; SI-NEXT:    s_mov_b32 s12, s4
; SI-NEXT:    s_mov_b32 s13, s5
; SI-NEXT:    s_mov_b32 s0, s6
; SI-NEXT:    s_mov_b32 s1, s7
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v2, v2
; SI-NEXT:    v_madak_f32 v1, v0, v1, 0x41200000
; SI-NEXT:    v_mac_f32_e32 v3, v0, v2
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v3
; SI-NEXT:    buffer_store_short v0, off, s[12:15], 0
; SI-NEXT:    buffer_store_short v1, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: madak_f16_use_2:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx8 s[4:11], s[2:3], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x44
; VI-NEXT:    s_mov_b32 s15, 0xf000
; VI-NEXT:    s_mov_b32 s14, -1
; VI-NEXT:    s_mov_b32 s18, s14
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s16, s8
; VI-NEXT:    s_mov_b32 s17, s9
; VI-NEXT:    s_mov_b32 s19, s15
; VI-NEXT:    s_mov_b32 s8, s10
; VI-NEXT:    s_mov_b32 s9, s11
; VI-NEXT:    s_mov_b32 s10, s14
; VI-NEXT:    s_mov_b32 s11, s15
; VI-NEXT:    s_mov_b32 s2, s14
; VI-NEXT:    s_mov_b32 s3, s15
; VI-NEXT:    buffer_load_ushort v0, off, s[16:19], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    buffer_load_ushort v2, off, s[0:3], 0 glc
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v3, 0x4900
; VI-NEXT:    s_mov_b32 s12, s4
; VI-NEXT:    s_mov_b32 s13, s5
; VI-NEXT:    s_mov_b32 s0, s6
; VI-NEXT:    s_mov_b32 s1, s7
; VI-NEXT:    v_madak_f16 v1, v0, v1, 0x4900
; VI-NEXT:    v_mac_f16_e32 v3, v0, v2
; VI-NEXT:    buffer_store_short v1, off, s[12:15], 0
; VI-NEXT:    buffer_store_short v3, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX11-LABEL: madak_f16_use_2:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b256 s[4:11], s[2:3], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[2:3], 0x44
; GFX11-NEXT:    s_mov_b32 s14, -1
; GFX11-NEXT:    s_mov_b32 s15, 0x31016000
; GFX11-NEXT:    s_mov_b32 s18, s14
; GFX11-NEXT:    s_mov_b32 s19, s15
; GFX11-NEXT:    s_mov_b32 s22, s14
; GFX11-NEXT:    s_mov_b32 s23, s15
; GFX11-NEXT:    s_mov_b32 s2, s14
; GFX11-NEXT:    s_mov_b32 s3, s15
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s16, s8
; GFX11-NEXT:    s_mov_b32 s17, s9
; GFX11-NEXT:    s_mov_b32 s20, s10
; GFX11-NEXT:    s_mov_b32 s21, s11
; GFX11-NEXT:    buffer_load_u16 v0, off, s[16:19], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    buffer_load_u16 v1, off, s[20:23], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    buffer_load_u16 v2, off, s[0:3], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_mov_b32 s12, s4
; GFX11-NEXT:    s_mov_b32 s13, s5
; GFX11-NEXT:    s_mov_b32 s0, s6
; GFX11-NEXT:    s_mov_b32 s1, s7
; GFX11-NEXT:    v_mul_f16_e32 v1, v0, v1
; GFX11-NEXT:    v_mul_f16_e32 v0, v0, v2
; GFX11-NEXT:    s_delay_alu instid0(VALU_DEP_2) | instskip(NEXT) | instid1(VALU_DEP_2)
; GFX11-NEXT:    v_add_f16_e32 v1, 0x4900, v1
; GFX11-NEXT:    v_add_f16_e32 v0, 0x4900, v0
; GFX11-NEXT:    buffer_store_b16 v1, off, s[12:15], 0
; GFX11-NEXT:    buffer_store_b16 v0, off, s[0:3], 0
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r0,
    ptr addrspace(1) %r1,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b,
    ptr addrspace(1) %c) #0 {
entry:
  %a.val = load volatile half, ptr addrspace(1) %a
  %b.val = load volatile half, ptr addrspace(1) %b
  %c.val = load volatile half, ptr addrspace(1) %c

  %t0.val = fmul half %a.val, %b.val
  %t1.val = fmul half %a.val, %c.val
  %r0.val = fadd half %t0.val, 10.0
  %r1.val = fadd half %t1.val, 10.0

  store half %r0.val, ptr addrspace(1) %r0
  store half %r1.val, ptr addrspace(1) %r1
  ret void
}

attributes #0 = { "denormal-fp-math"="preserve-sign,preserve-sign" }
